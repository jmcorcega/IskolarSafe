// ignore_for_file: unused_catch_clause

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';

class HealthEntriesAPI {
  static final FirebaseFirestore store = FirebaseFirestore.instance;
  static const String _storeName = "entries";

  // Get all entries from the database
  Stream<QuerySnapshot> getAllEntries(IskolarInfo userInfo) {
    return store
        .collection(_storeName)
        .where('userId', isEqualTo: userInfo.id)
        .orderBy('dateGenerated', descending: true)
        .snapshots();
  }

  // Get all entries with edit/delete requests from the database
  Stream<QuerySnapshot> getEntriesWithRequests() {
    return store
        .collection(_storeName)
        .where(Filter.or(
          Filter('updated', isNull: false),
          Filter('forDeletion', isEqualTo: true),
        ))
        .snapshots();
  }

  Future<HealthEntry?> getEntry(String entryId) async {
    try {
      var info = await store.collection(_storeName).doc(entryId).get();

      Map<String, dynamic>? data = info.data();
      return HealthEntry.fromJson(data!);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // Add entry to the firestore
  Future<bool> uploadEntry(Map<String, dynamic> entry) async {
    try {
      final ref = await store.collection(_storeName).add(entry);
      await store.collection(_storeName).doc(ref.id).update({'id': ref.id});

      return true;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Update entry in the firestore
  Future<bool> updateEntry(Map<String, dynamic> entry) async {
    try {
      await store.collection(_storeName).doc(entry['id']).update(entry);
      await store
          .collection(_storeName)
          .doc(entry['id'])
          .update({"updated": null});

      return true;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Update entry in the firestore
  Future<bool> deleteEntry(Map<String, dynamic> entry) async {
    try {
      await store.collection(_storeName).doc(entry['id']).delete();
      return true;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Reject an entry request in the firestore
  Future<bool> rejectRequest(Map<String, dynamic> entry) async {
    try {
      await store
          .collection(_storeName)
          .doc(entry['id'])
          .update({"updated": null, "forDeletion": false});
      return true;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Edit entry in the firestore
  Future<bool> editEntry(Map<String, dynamic> entry) async {
    try {
      await store
          .collection(_storeName)
          .doc(entry['id'])
          .update({"updated": entry});

      return true;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Edit entry for deletion in the firestore
  Future<bool> requestDeletion(HealthEntry entry) async {
    try {
      await store
          .collection(_storeName)
          .doc(entry.id)
          .update({"forDeletion": true});
      await store
          .collection(_storeName)
          .doc(entry.id)
          .update({"updated": HealthEntry.toJson(entry)});

      return true;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}

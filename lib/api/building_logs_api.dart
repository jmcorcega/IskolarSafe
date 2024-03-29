import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:iskolarsafe/models/user_model.dart';

class BuildingLogsAPI {
  static final FirebaseFirestore store = FirebaseFirestore.instance;
  static const String _storeName = "logs";

  // Get all entries from the database
  Stream<QuerySnapshot> getAllEntries(IskolarInfo userInfo) {
    if (userInfo.type == IskolarType.admin) {
      return store
          .collection(_storeName)
          .orderBy('entryDate', descending: true)
          .snapshots();
    }

    return store
        .collection(_storeName)
        .where('monitorId', isEqualTo: userInfo.id!)
        .orderBy('entryDate', descending: true)
        .snapshots();
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
}

/*
  Based on work by Ms. Claizel Coubeili Cepe
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/api/entries_api.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:provider/provider.dart';

class HealthEntryProvider with ChangeNotifier {
  /// Instance of [HealthEntriesAPI] used to interact with the Firestore database.
  late HealthEntriesAPI api;

  /// Stream of all health entries in the database.
  late Stream<QuerySnapshot> _entryStream;
  late bool _status = false;

  HealthEntryProvider(BuildContext context) {
    api = HealthEntriesAPI();
    fetchEntries(context);
    notifyListeners();
  }

  fetchEntries(BuildContext context) {
    _entryStream =
        api.getAllEntries(context.read<AccountsProvider>().userInfo!);
  }

  // Getters
  Stream<QuerySnapshot> get entries => _entryStream;
  Stream<QuerySnapshot> get requests => api.getEntriesWithRequests();
  Future<HealthEntry?> getEntry(String entryId) => api.getEntry(entryId);
  bool get status => _status;

  /// Adds a new health entry to the database.
  Future<void> addEntry(HealthEntry entry) async {
    _status = await api.uploadEntry(HealthEntry.toJson(entry));
    notifyListeners();
  }

  /// Updates an entry to the database.
  Future<void> updateEntry(HealthEntry entry) async {
    _status = await api.updateEntry(HealthEntry.toJson(entry));
    notifyListeners();
  }

  /// Deletes an entry to the database.
  Future<void> deleteEntry(HealthEntry entry) async {
    _status = await api.deleteEntry(HealthEntry.toJson(entry));
    notifyListeners();
  }

  /// Rejects an entry request in the database.
  Future<void> rejectRequest(HealthEntry entry) async {
    _status = await api.rejectRequest(HealthEntry.toJson(entry));
    notifyListeners();
  }

  /// Edits an entry to the database.
  Future<void> editEntry(HealthEntry entry) async {
    _status = await api.editEntry(HealthEntry.toJson(entry));
    notifyListeners();
  }

  /// Edits an entry to the database.
  Future<void> requestDeletion(HealthEntry entry) async {
    _status = await api.requestDeletion(entry);
    notifyListeners();
  }
}

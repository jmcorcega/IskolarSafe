/*
  Based on work by Ms. Claizel Coubeili Cepe
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/api/entries_api.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';

class HealthEntryProvider with ChangeNotifier {
  /// Instance of [HealthEntriesAPI] used to interact with the Firestore database.
  late HealthEntriesAPI api;

  /// Stream of all health entries in the database.
  late Stream<QuerySnapshot> _entryStream;
  late IskolarInfo? _userInfo;
  late bool _status = false;

  HealthEntryProvider() {
    api = HealthEntriesAPI();
    fetchEntries();
  }

  // Getters
  Stream<QuerySnapshot> get entries => _entryStream;
  bool get status => _status;

  /// Fetches all health entries from the database.
  fetchEntries() async {
    _userInfo = await AccountsProvider().userInfo;
    _entryStream = api.getAllEntries(_userInfo!);
    notifyListeners();
  }

  Future<void> refetchEntries() async {
    await fetchEntries();
    notifyListeners();
  }

  /// Adds a new slam book entry to the database.
  Future<void> addEntry(HealthEntry entry) async {
    _status = await api.uploadEntry(HealthEntry.toJson(entry));
    notifyListeners();
  }
}

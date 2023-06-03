/*
  Based on work by Ms. Claizel Coubeili Cepe
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/api/building_logs_api.dart';
import 'package:iskolarsafe/models/building_log_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:provider/provider.dart';

class BuildingLogsProvider with ChangeNotifier {
  /// Instance of [BuildingLogsAPI] used to interact with the Firestore database.
  late BuildingLogsAPI api;

  /// Stream of all health entries in the database.
  late Stream<QuerySnapshot> _logs;
  late bool _status = false;

  BuildingLogsProvider(BuildContext context) {
    api = BuildingLogsAPI();
    fetchLogs(context);
    notifyListeners();
  }

  fetchLogs(BuildContext context) {
    IskolarInfo user = context.read<AccountsProvider>().userInfo!;

    if (user.type == IskolarType.student) {
      return;
    }

    _logs = api.getAllEntries(user);
  }

  // Getters
  Stream<QuerySnapshot> get entries => _logs;
  bool get status => _status;

  /// Adds a new health entry to the database.
  Future<void> addEntry(BuildingLog log) async {
    _status = await api.uploadEntry(BuildingLog.toJson(log));
    notifyListeners();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iskolarsafe/models/user_model.dart';

class BuildingLog {
  String? id;
  final DateTime entryDate;
  final String monitorId;
  final String entryId;
  final IskolarInfo user;

  BuildingLog({
    this.id,
    required this.entryDate,
    required this.monitorId,
    required this.entryId,
    required this.user,
  });

  // Factory constructor to instantiate object from json format
  factory BuildingLog.fromJson(Map<String, dynamic> json) {
    return BuildingLog(
      id: json['id'],
      entryDate: DateTime.fromMillisecondsSinceEpoch(json['entryDate']),
      monitorId: json['monitorId'],
      entryId: json['entryId'],
      user: IskolarInfo.fromJson(json['user']),
    );
  }

  static Map<String, dynamic> toJson(BuildingLog log) {
    return {
      'id': log.id,
      'entryDate': Timestamp.fromDate(log.entryDate).millisecondsSinceEpoch,
      'monitorId': log.monitorId,
      'entryId': log.entryId,
      'user': IskolarInfo.toJson(log.user),
    };
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum IskolarType {
  student,
  monitor,
  admin;

  static IskolarType fromJson(Map<String, dynamic> json) {
    // Accomodate earlier sign ups from users when we still didn't have a type
    if (json['type'] == null) {
      return IskolarType.student;
    }

    switch (json['type']) {
      case 'administrator':
        return IskolarType.admin;
      case 'building_monitor':
        return IskolarType.monitor;
      default:
        return IskolarType.student;
    }
  }

  static String toJson(IskolarType type) {
    switch (type) {
      case IskolarType.admin:
        return "administrator";
      case IskolarType.monitor:
        return "building_monitor";
      default:
        return "student";
    }
  }

  static String toStr(IskolarType type) {
    switch (type) {
      case IskolarType.admin:
        return "Administrator";
      case IskolarType.monitor:
        return "Building Monitor";
      default:
        return "Student";
    }
  }
}

enum IskolarHealthStatus {
  healthy,
  notWell,
  quarantined,
  monitored;

  static IskolarHealthStatus fromJson(String? json) {
    // Accomodate earlier sign ups from users when we still didn't have a type
    if (json == null) {
      return IskolarHealthStatus.healthy;
    }

    switch (json) {
      case 'monitored':
        return IskolarHealthStatus.monitored;
      case 'quarantined':
        return IskolarHealthStatus.quarantined;
      case 'notWell':
        return IskolarHealthStatus.notWell;
      default:
        return IskolarHealthStatus.healthy;
    }
  }

  static String toJson(IskolarHealthStatus status) {
    switch (status) {
      case IskolarHealthStatus.quarantined:
        return "quarantined";
      case IskolarHealthStatus.monitored:
        return "monitored";
      case IskolarHealthStatus.notWell:
        return "notWell";
      default:
        return "healthy";
    }
  }
}

class IskolarInfo {
  String? id;
  final String firstName;
  final String lastName;
  final String userName;
  final String studentNumber;
  final String course;
  final String college;
  final List<String> condition;
  final List<String> allergies;
  String? photoUrl;
  IskolarType type;
  IskolarHealthStatus status;

  DateTime? dateQuarantined;
  DateTime? dateMonitored;

  IskolarInfo({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.studentNumber,
    required this.course,
    required this.college,
    required this.condition,
    required this.allergies,
    this.type = IskolarType.student,
    this.status = IskolarHealthStatus.healthy,
    this.dateQuarantined,
    this.dateMonitored,
    this.photoUrl,
  });

  // Factory constructor to instantiate object from json format
  factory IskolarInfo.fromJson(Map<String, dynamic> json) {
    return IskolarInfo(
      id: json['id'],
      type: IskolarType.fromJson(json),
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      studentNumber: json['studentNumber'],
      course: json['course'],
      photoUrl: json['photoUrl'],
      college: json['college'],
      condition:
          (json['condition'] as List).map((item) => item as String).toList(),
      allergies:
          (json['allergies'] as List).map((item) => item as String).toList(),
      status: IskolarHealthStatus.fromJson(json['status']),
      dateQuarantined:
          DateTime.fromMillisecondsSinceEpoch(json['dateQuarantined'] ?? 0),
      dateMonitored:
          DateTime.fromMillisecondsSinceEpoch(json['dateMonitored'] ?? 0),
    );
  }

  static List<IskolarInfo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data
        .map<IskolarInfo>((dynamic d) => IskolarInfo.fromJson(d))
        .toList();
  }

  static Map<String, dynamic> toJson(IskolarInfo user) {
    return {
      'id': user.id,
      'type': IskolarType.toJson(user.type),
      'firstName': user.firstName,
      'lastName': user.lastName,
      'userName': user.userName,
      'photoUrl': user.photoUrl,
      'studentNumber': user.studentNumber,
      'course': user.course,
      'college': user.college,
      'condition': user.condition,
      'allergies': user.allergies,
      'status': IskolarHealthStatus.toJson(user.status),
      'dateQuarantined': user.dateQuarantined != null
          ? Timestamp.fromDate(user.dateQuarantined!).millisecondsSinceEpoch
          : null,
      'dateMonitored': user.dateMonitored != null
          ? Timestamp.fromDate(user.dateMonitored!).millisecondsSinceEpoch
          : null,
    };
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iskolarsafe/models/user_model.dart';

enum FluSymptom {
  none,
  feverish,
  musclePains;

  static String getName(FluSymptom type) {
    switch (type) {
      case FluSymptom.none:
        return "None";
      case FluSymptom.feverish:
        return "Feverish";
      case FluSymptom.musclePains:
        return "Muscle or joint pains";
    }
  }

  static List<FluSymptom> fromJson(Map<String, dynamic> json) {
    List<FluSymptom> list = [];
    var js =
        (json['fluSymptoms'] as List).map((item) => item as String).toList();

    for (var i in js) {
      switch (i) {
        case "none":
          list.add(FluSymptom.none);
          break;
        case "feverish":
          list.add(FluSymptom.feverish);
          break;
        case "musclePains":
          list.add(FluSymptom.musclePains);
          break;
      }
    }

    return list;
  }
}

enum RespiratorySymptom {
  none,
  cough,
  colds,
  soreThroat,
  breathingDifficulty;

  static String getName(RespiratorySymptom symptoms) {
    switch (symptoms) {
      case RespiratorySymptom.none:
        return "None";
      case RespiratorySymptom.cough:
        return "Cough";
      case RespiratorySymptom.colds:
        return "Colds";
      case RespiratorySymptom.soreThroat:
        return "Sore throat";
      case RespiratorySymptom.breathingDifficulty:
        return "Difficulty of breathing";
    }
  }

  static List<RespiratorySymptom> fromJson(Map<String, dynamic> json) {
    List<RespiratorySymptom> list = [];
    var js = (json['respiratorySymptoms'] as List)
        .map((item) => item as String)
        .toList();

    for (var i in js) {
      switch (i) {
        case "none":
          list.add(RespiratorySymptom.none);
          break;
        case "cough":
          list.add(RespiratorySymptom.cough);
          break;
        case "colds":
          list.add(RespiratorySymptom.colds);
          break;
        case "soreThroat":
          list.add(RespiratorySymptom.soreThroat);
          break;
        case "breathingDifficulty":
          list.add(RespiratorySymptom.breathingDifficulty);
          break;
      }
    }

    return list;
  }
}

enum OtherSymptom {
  none,
  diarrhea,
  lossOfTaste,
  lossOfSmell;

  static String getName(OtherSymptom other) {
    switch (other) {
      case OtherSymptom.none:
        return "None";
      case OtherSymptom.diarrhea:
        return "Diarrhea";
      case OtherSymptom.lossOfTaste:
        return "Loss of taste";
      case OtherSymptom.lossOfSmell:
        return "Loss of smell";
    }
  }

  static List<OtherSymptom> fromJson(Map<String, dynamic> json) {
    List<OtherSymptom> list = [];
    var js =
        (json['otherSymptoms'] as List).map((item) => item as String).toList();

    for (var i in js) {
      switch (i) {
        case "none":
          list.add(OtherSymptom.none);
          break;
        case "diarrhea":
          list.add(OtherSymptom.diarrhea);
          break;
        case "lossOfTaste":
          list.add(OtherSymptom.lossOfTaste);
          break;
        case "lossOfSmell":
          list.add(OtherSymptom.lossOfSmell);
          break;
      }
    }

    return list;
  }
}

class HealthEntry {
  String? id;
  final String userId;
  final IskolarInfo userInfo;
  final DateTime dateGenerated;

  final List<FluSymptom>? fluSymptoms;
  final List<RespiratorySymptom>? respiratorySymptoms;
  final List<OtherSymptom>? otherSymptoms;

  final bool exposed;
  final bool waitingForRtPcr;
  final bool waitingForRapidAntigen;

  final IskolarHealthStatus verdict;
  final bool forDeletion;
  final HealthEntry? updated;

  HealthEntry({
    this.id,
    required this.userId,
    required this.userInfo,
    required this.dateGenerated,
    required this.fluSymptoms,
    required this.respiratorySymptoms,
    required this.otherSymptoms,
    required this.exposed,
    required this.waitingForRtPcr,
    required this.waitingForRapidAntigen,
    required this.verdict,
    this.forDeletion = false,
    this.updated,
  });

  // Factory constructor to instantiate object from json format
  factory HealthEntry.fromJson(Map<String, dynamic> json) {
    return HealthEntry(
      id: json['id'],
      userId: json['userId'],
      userInfo: IskolarInfo.fromJson(json['userInfo']),
      dateGenerated: DateTime.fromMillisecondsSinceEpoch(json['dateGenerated']),
      fluSymptoms: FluSymptom.fromJson(json),
      respiratorySymptoms: RespiratorySymptom.fromJson(json),
      otherSymptoms: OtherSymptom.fromJson(json),
      exposed: json['exposed'],
      waitingForRtPcr: json['waitingForRtPcr'],
      waitingForRapidAntigen: json['waitingForRapidAntigen'],
      verdict: IskolarHealthStatus.fromJson(json['verdict']),
      forDeletion: json['forDeletion'] ?? false,
      updated: json['updated'] != null
          ? HealthEntry.fromJson(json['updated'])
          : null,
    );
  }

  static Map<String, dynamic> toJson(HealthEntry entry) {
    return {
      'id': entry.id,
      'userId': entry.userInfo.id,
      'userInfo': IskolarInfo.toJson(entry.userInfo),
      'dateGenerated':
          Timestamp.fromDate(entry.dateGenerated).millisecondsSinceEpoch,
      'fluSymptoms': entry.fluSymptoms!.map((e) => e.name).toList(),
      'respiratorySymptoms':
          entry.respiratorySymptoms!.map((e) => e.name).toList(),
      'otherSymptoms': entry.otherSymptoms!.map((e) => e.name).toList(),
      'exposed': entry.exposed,
      'waitingForRtPcr': entry.waitingForRtPcr,
      'waitingForRapidAntigen': entry.waitingForRapidAntigen,
      'verdict': IskolarHealthStatus.toJson(entry.verdict),
      'forDeletion': entry.forDeletion,
      'updated':
          entry.updated != null ? HealthEntry.toJson(entry.updated!) : null,
    };
  }
}

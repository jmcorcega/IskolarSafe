import 'dart:convert';

class Entry {
  // ohms website is down, questions below are from online covid screening questionnaires
  // do you have fever (37.8 C or higher) or are you feeling feverish
  // have you experienced one or more flu like symptoms in the past 14 days
  // have you tested positive for covid 19 in the past 14 days

  // have you been in close contact with someome who tested covid positive in the past 14 days
  // have you traveled internationally or been in an area with a high number of covid 19 cases in the past 14 days

  // are you currently under quarantine or isolation due to potential exposure to covid 19

  /*
  bool hasFever;
  bool hasFluSymptoms;
  bool hasCovid;
  bool hasTravelled;
  bool hasQuarantine;
  */

  final int userId;
  final int transactionId;
  DateTime dateGenerated;
  DateTime validUntil;

  Entry(
      {required this.userId,
      required this.transactionId,
      required this.dateGenerated,
      required this.validUntil});

  // Factory constructor to instantiate object from json format
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      userId: json['userId'],
      transactionId: json['transactionId'],
      dateGenerated: json['dateGenerated'],
      validUntil: json['validUntil'],
    );
  }

  static List<Entry> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Entry>((dynamic d) => Entry.fromJson(d)).toList();
  }

  static Map<String, dynamic> toJson(Entry entry) {
    return {
      'userId': entry.userId,
      'transactionId': entry.transactionId,
      'dateGenerated': entry.dateGenerated,
      'validUntil': entry.validUntil
    };
  }
}

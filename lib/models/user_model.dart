import 'dart:convert';

class AppUserInfo {
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

  AppUserInfo({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.studentNumber,
    required this.course,
    required this.college,
    required this.condition,
    required this.allergies,
    this.photoUrl,
  });

  // Factory constructor to instantiate object from json format
  factory AppUserInfo.fromJson(Map<String, dynamic> json) {
    return AppUserInfo(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      studentNumber: json['studentNumber'],
      course: json['course'],
      college: json['college'],
      condition:
          (json['condition'] as List).map((item) => item as String).toList(),
      allergies:
          (json['allergies'] as List).map((item) => item as String).toList(),
    );
  }

  static List<AppUserInfo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data
        .map<AppUserInfo>((dynamic d) => AppUserInfo.fromJson(d))
        .toList();
  }

  static Map<String, dynamic> toJson(AppUserInfo user) {
    return {
      'id': user.id,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'userName': user.userName,
      'photoUrl': user.photoUrl,
      'studentNumber': user.studentNumber,
      'course': user.course,
      'college': user.college,
      'condition': user.condition,
      'allergies': user.allergies,
    };
  }
}

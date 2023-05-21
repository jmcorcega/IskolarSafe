import 'dart:convert';

class User {
  int? userId;
  final String firstName;
  final String lastName;
  final String userName;
  final String studentNumber;
  final String course;
  final String college;
  final List<String> condition;
  final List<String> allergies;
  String? photoUrl;

  User({
    required this.userId,
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
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      photoUrl: json['photoUrl'],
      studentNumber: json['studentNumber'],
      course: json['course'],
      college: json['college'],
      condition: json['condition'],
      allergies: json['allergies'],
    );
  }

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  static Map<String, dynamic> toJson(User user) {
    return {
      'userId': user.userId,
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

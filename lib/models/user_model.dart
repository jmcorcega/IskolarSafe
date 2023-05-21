import 'dart:convert';

class User {
  final int userId;
  String firstName;
  String lastName;
  String userName;
  String studentNumber;
  String course;
  String college;
  List<String> condition;
  List<String> allergies;
  String? imageUrl;

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
  });

  // Factory constructor to instantiate object from json format
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
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
      'studentNumber': user.studentNumber,
      'course': user.course,
      'college': user.college,
      'condition': user.condition,
      'allergies': user.allergies,
    };
  }
}

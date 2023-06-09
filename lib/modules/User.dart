import 'package:mongo_dart/mongo_dart.dart';

import 'db/dbCon.dart';

class User {
  final String? id;
  final String name;
  final String lastName;
  final DateTime? birth_date;
  final double weight;
  final double height;
  final String username;
  final String email;
  final bool visibility;
  final String password;
  final List<dynamic>? routines;
  final List<dynamic>? posts;
  final List<dynamic>? friends;
  final List<dynamic>? friendRequests;

  User({
    this.id,
    required this.name,
    required this.lastName,
    this.birth_date,
    required this.weight,
    required this.height,
    required this.username,
    required this.email,
    required this.visibility,
    required this.password,
    this.routines,
    this.posts,
    this.friendRequests,
    this.friends
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'lastName': lastName,
      'birth_date': birth_date,
      'weight': weight,
      'height': height,
      'username': username,
      'email': email,
      'visibility': visibility,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['_id'],
        name: map['name'],
        lastName: map['lastName'],
        birth_date: DateTime.parse(map['birth_date']),
        weight: map['weight'],
        height: map['height'],
        username: map['username'],
        email: map['email'],
        visibility: map['visibility'],
        password: map['password'],
        routines: map['routines']);
  }

  @override
  String toString() {
    return 'Usuario: $name';
  }
}

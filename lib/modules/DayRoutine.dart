import 'dart:ffi';

import 'package:lift_share/modules/Exercise.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DayRoutine{
  final ObjectId id = ObjectId();
  final String day_of_week;
  List<Map<String, dynamic>> exercises;

  DayRoutine({required this.day_of_week, required this.exercises});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'day_of_week': day_of_week,
      'exercises': exercises
    };
  }

  factory DayRoutine.fromMap(Map<String, dynamic> map) {
    return DayRoutine(
      day_of_week: map['day_of_week'],
      exercises: map['exercises'],
    );
  }

  @override
  String toString() {
    return 'dia de la semana: $day_of_week';
  }
}
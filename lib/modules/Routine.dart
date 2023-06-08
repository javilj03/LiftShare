import '../modules/Exercise.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Routine {
  final String? id;
  final String name;
  final String desc;
  final List<String>? days;
  final bool visibility;

  Routine({
    this.id,
    required this.name,
    required this.desc,
    this.days,
    required this.visibility,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'desc': desc,
      'days_of_week': days,
      'visibility': visibility,
    };
  }
}

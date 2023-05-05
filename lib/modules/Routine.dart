import 'package:lift_share/modules/Exercise.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Routine {
  final ObjectId id;
  final String name;
  final String desc;
  final List<ObjectId>? days;
  final bool visibility;

  Routine({
    required this.id,
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

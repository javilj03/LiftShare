import 'package:flutter/material.dart';
import 'package:lift_share/modules/db/dbCon.dart';
import 'package:lift_share/widgets/Routines/RoutineCard.dart';
import '../../modules/Routine.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;

class RoutineList extends StatelessWidget {
  final Mongo.ObjectId userId;

  RoutineList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Routine>>(
      future: MongoDb.getRoutinesForUser(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          final routines = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              return RoutineCard(
                routine: routine,
              );
            },
          );
        }
      },
    );
  }
}
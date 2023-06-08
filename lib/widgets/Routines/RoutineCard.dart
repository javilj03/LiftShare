import 'package:flutter/material.dart';
import '../../modules/Routine.dart';
import 'RoutineView.dart';

class RoutineCard extends StatelessWidget {
  final Routine routine;

  RoutineCard({required this.routine});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => RoutineView(id: routine.id!),
        ));
      },
      child: Card(
        margin: EdgeInsets.all(10),
        color: Color(0xFF14213D),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                Icons.sports_gymnastics,
                size: 50,
                color: Colors.white,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    routine.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(routine.desc,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

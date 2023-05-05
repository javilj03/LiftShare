import 'package:flutter/material.dart';

class RoutineCard extends StatelessWidget {
  final routine;

  RoutineCard({required this.routine});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var snackBar = SnackBar(content: Text('pulsado ${routine.name}'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

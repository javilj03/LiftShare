import 'package:flutter/material.dart';
import 'package:lift_share/constants.dart';
import '../../modules/Routine.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

List<Routine> routineList = [
  Routine(
      id: M.ObjectId(),
      name: 'rutina1',
      desc: 'rutina de ...',
      visibility: true),
  Routine(
      id: M.ObjectId(),
      name: 'rutina2',
      desc: 'rutina de ...',
      visibility: true),
  Routine(
      id: M.ObjectId(),
      name: 'rutina3',
      desc: 'rutina de ...',
      visibility: true),
  Routine(
      id: M.ObjectId(),
      name: 'rutina4',
      desc: 'rutina de ...',
      visibility: true),
  Routine(
      id: M.ObjectId(),
      name: 'rutina5',
      desc: 'rutina de ...',
      visibility: true),
  Routine(
      id: M.ObjectId(),
      name: 'rutina6',
      desc: 'rutina de ...',
      visibility: true),
  Routine(
      id: M.ObjectId(),
      name: 'rutina7',
      desc: 'rutina de ...',
      visibility: true),
  Routine(
      id: M.ObjectId(),
      name: 'rutina8',
      desc: 'rutina de ...',
      visibility: true),
  Routine(
      id: M.ObjectId(),
      name: 'rutina9',
      desc: 'rutina de ...',
      visibility: true),
];

class ProfileRoutine extends StatelessWidget {
  final ScrollController scrollController;
  ProfileRoutine({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: routineList.length,
      itemBuilder: (context, index) {
        Routine routine = routineList[index];
        return Column(
          children: [
            _RoutineCardProfile(routine),
          ],
        );
      },
    );
  }

  Widget _RoutineCardProfile(Routine routine) {
    return GestureDetector(
      onTap: () => print('${routine.name}'),
      child: Card(
        elevation: 2,
        color: Color(BLUE),
        margin: EdgeInsets.all(2),
        child: Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          height: 75,
          child: Row(
            children: [
              Text(
                routine.name,
                style: TextStyle(color: Color(WHITE)),
              ),
              Text(
                routine.desc,
                style: TextStyle(color: Color(WHITE)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

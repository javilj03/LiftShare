import 'package:flutter/material.dart';
import 'package:lift_share/constants.dart';
import 'package:lift_share/modules/DayRoutine.dart';
import 'package:lift_share/widgets/Routines/CreateRoutine.dart';
import '../../modules/Routine.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class RoutineView extends StatelessWidget {
  const RoutineView();

  @override
  Widget build(BuildContext context) {
    List<DayRoutine> listRoutineDay = [
      DayRoutine(day_of_week: 'Lunes', exercises: [
        {'name': 'Press banca', 'series': 4, 'reps': 10},
        {'name': 'Press inclinado', 'series': 4, 'reps': 10}
      ]),
      DayRoutine(day_of_week: 'Martes', exercises: [
        {'name': 'Press banca', 'series': 4, 'reps': 10},
        {'name': 'Press inclinado', 'series': 4, 'reps': 10}
      ]),
      DayRoutine(day_of_week: 'Miercoles', exercises: [
        {'name': 'Press banca', 'series': 4, 'reps': 10},
        {'name': 'Press inclinado', 'series': 4, 'reps': 10}
      ]),
      DayRoutine(day_of_week: 'Jueves', exercises: [
        {'name': 'Press banca', 'series': 4, 'reps': 10},
        {'name': 'Press inclinado', 'series': 4, 'reps': 10}
      ]),
    ];
    Routine routine = Routine(
      id: M.ObjectId(),
      name: 'Rutina prediseñada',
      desc: 'Sin desc',
      visibility: true,
    );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tablas por día'),
          backgroundColor: Color(ORANGE),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => CreateRoutine.forEdit(routine),
                ));
              },
              icon: Icon(Icons.edit, size: 40),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: listRoutineDay.length,
          itemBuilder: (context, index) {
            DayRoutine routine = listRoutineDay[index];
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    routine.day_of_week,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey), // Borde de la tabla
                      borderRadius: BorderRadius.circular(
                          8), // Bordes redondeados de la tabla
                      color: Colors.white, // Color de fondo de la tabla
                    ),
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Ejercicio')),
                      DataColumn(label: Text('Series')),
                      DataColumn(label: Text('Repeticiones')),
                    ],
                    rows: routine.exercises.map((exercise) {
                      return DataRow(cells: <DataCell>[
                        DataCell(Text(exercise['name'])),
                        DataCell(Text(exercise['series'].toString())),
                        DataCell(Text(exercise['reps'].toString())),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

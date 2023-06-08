import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../modules/DayRoutine.dart';
import '../../widgets/Routines/CreateRoutine.dart';
import '../../modules/Routine.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RoutineView extends StatelessWidget {
  final String id;
  RoutineView({required this.id});
  @override
  Widget build(BuildContext context) {
    print(id);

    return FutureBuilder<Routine>(
      future: getRoutine(id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          final routine = snapshot.data!;
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: Text(routine.name),
                backgroundColor: Color(ORANGE),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => CreateRoutine.forEdit(routine),
                      ));
                    },
                    icon: Icon(Icons.edit, size: 40),
                  ),
                ],
              ),
              body: FutureBuilder<List<DayRoutine>>(
                  future: getDayRoutines(routine.id!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      final routines = snapshot.data!;
                      return ListView.builder(
                        itemCount: routines.length,
                        itemBuilder: (context, index) {
                          DayRoutine routine = routines[index];
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  routine.day_of_week,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DataTable(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Colors.grey), // Borde de la tabla
                                      borderRadius: BorderRadius.circular(
                                          8), // Bordes redondeados de la tabla
                                      color: Colors
                                          .white, // Color de fondo de la tabla
                                    ),
                                    columns: const <DataColumn>[
                                      DataColumn(label: Text('Ejercicio')),
                                      DataColumn(label: Text('Series')),
                                      DataColumn(label: Text('Repeticiones')),
                                    ],
                                    rows: routine.exercises.map((exercise) {
                                      return DataRow(cells: <DataCell>[
                                        DataCell(Text(exercise['name'])),
                                        DataCell(
                                            Text(exercise['series'].toString())),
                                        DataCell(
                                            Text(exercise['reps'].toString())),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }),
            ),
          );
        }
      },
    );
  }

  Future<Routine> getRoutine(String id) async {
    Routine routine;
    var response = await http.get(Uri.parse('$URL_HEAD/api/getRoutine/$id'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      routine = Routine(
        id: data['_id'],
        name: data['name'],
        desc: data['desc'],
        days: List<String>.from(data['days_of_week']),
        visibility: data['visibility'],
      );
    } else {
      print('Error en la petición HTTP: ${response.statusCode}');
      routine = Routine(name: 'Error', desc: 'desc', visibility: true);
    }
    return routine;
  }

  Future<List<DayRoutine>> getDayRoutines(String id) async {
    List<DayRoutine> dayRoutines = [];
    var response =
        await http.get(Uri.parse('$URL_HEAD/api/getDayRoutines/$id'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      // Recorre cada objeto obtenido y crea un objeto DayRoutine
      for (var item in data) {
        DayRoutine routine = DayRoutine(
          id: item['_id'],
          day_of_week: item['day_of_week'],
          exercises: List<Map<String, dynamic>>.from(item['exercises']),
        );

        dayRoutines.add(routine);
      }
    } else {
      print('Error en la petición HTTP: ${response}');
      dayRoutines = [];
    }
    return dayRoutines;
  }
}

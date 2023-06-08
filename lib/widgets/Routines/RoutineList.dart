import 'package:flutter/material.dart';
import '../../widgets/Routines/RoutineCard.dart';
import '../../modules/Routine.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants.dart';

class RoutineList extends StatelessWidget {
  final String userId;

  RoutineList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Routine>>(
      future: getRoutines(userId),
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

  Future<List<Routine>> getRoutines(String userId) async {
  List<Routine> routines = [];
  try {
    var response = await http.get(Uri.parse('$URL_HEAD/api/getUserRoutines/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      // Recorre cada objeto obtenido y crea un objeto Routine
      for (var item in data) {
        Routine routine = Routine(
          id: item['_id'],
          name: item['name'],
          desc: item['desc'],
          days: List<String>.from(item['days_of_week']),
          visibility: item['visibility'],
        );
        routines.add(routine);
      }
    } else {
      print('Error en la petición HTTP: ${response.statusCode}');
    }
  } catch (err) {
    print('Error al obtener rutinas de usuario: $err');
  }

  return routines;
}
}

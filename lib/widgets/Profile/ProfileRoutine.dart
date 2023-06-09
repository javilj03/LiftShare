import 'package:flutter/material.dart';
import 'package:liftShare/providers/UserProvider.dart';
import 'package:liftShare/widgets/Routines/RoutineView.dart';
import '../../constants.dart';
import '../../modules/Routine.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProfileRoutine extends StatelessWidget {
  final ScrollController scrollController;
  final String? userId;
  ProfileRoutine({required this.scrollController, this.userId});

  @override
  Widget build(BuildContext context) {
    Future<List<Routine>> getRoutinesData() async {
      List<Routine> routines = [];
      try {
        if (userId != null) {
          var res = await http
              .get(Uri.parse('$URL_HEAD/api/getUserRoutines/$userId'));

          if (res.statusCode == 200) {
            List<dynamic> data = jsonDecode(res.body);

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
            return routines;
          }else{
            print('Error de peticion: ${res.body}');
          }
        } else {
          var id =
              Provider.of<UserProvider>(context, listen: false).getUserProvider;
          var res =
              await http.get(Uri.parse('$URL_HEAD/api/getUserRoutines/$id'));
          if (res.statusCode == 200) {
            List<dynamic> data = jsonDecode(res.body);

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
            return routines;
          }else{
            print('Error de peticion: ${res.body}' );
          }
        }
      } catch (err) {
        print(err);
      }
      return [];
    }

    return FutureBuilder<List<Routine>>(
      future: getRoutinesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Mostrar un indicador de carga mientras se espera la respuesta de getUser()
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Manejar errores de obtener la información del usuario
        } else {
          List<Routine> routineList = snapshot.data as List<Routine>;
          return ListView.builder(
            controller: scrollController,
            itemCount: routineList.length,
            itemBuilder: (context, index) {
              Routine routine = routineList[index];
              return Column(
                children: [
                  _RoutineCardProfile(routine, context),
                ],
              );
            },
          );
        }
      },
    );
  }

  Widget _RoutineCardProfile(Routine routine, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => RoutineView(id: routine.id!,)),),
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
                style: TextStyle(color: Color(WHITE), fontWeight: FontWeight.bold),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

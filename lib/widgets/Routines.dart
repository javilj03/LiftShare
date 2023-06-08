import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/Routines/CreateRoutine.dart';
import '../widgets/Routines/RoutineList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;

class Routines extends StatelessWidget {
  Future<String> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              color: Color(0xFFFCA311),
              elevation: 8,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 20, left: 10, bottom: 5, right: 10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Rutinas de LiftShare',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    child: RoutineList(
                      userId: ADMIN_ID,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              color: Color(0xFFFCA311),
              elevation: 8,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 20, left: 10, bottom: 5, right: 10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Mis rutinas',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FutureBuilder<String>(
                    future: getId(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final userIdProvider =
                            Provider.of<UserProvider>(context,
                                listen: false);
                        String userId =
                            userIdProvider.getUserProvider;
                        
                        print('ID user: $userId');
                        return Container(
                          height: 100,
                          child: RoutineList(userId: userId),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => CreateRoutine()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFFCA311),
      ),
    );
  }
}

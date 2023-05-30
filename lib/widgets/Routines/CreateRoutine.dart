import 'package:flutter/material.dart';
import 'package:lift_share/modules/Routine.dart';
import 'package:lift_share/modules/db/dbCon.dart';
import 'package:lift_share/widgets/Routines/CreateDayRoutine.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import '../../constants.dart';
import '../../modules/DayRoutine.dart';
import '../../providers/DayRoutineProvider.dart';
import '../../providers/UserProvider.dart';

class CreateRoutine extends StatefulWidget {
  const CreateRoutine({super.key});
  CreateRoutine.forEdit(Routine routine);

  @override
  State<CreateRoutine> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends State<CreateRoutine> {
  List<String> _selectedDays = [];
  List<DayRoutine> dayRoutineList = [];

  TextEditingController nameController = TextEditingController();
  void _toggleSelectedDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Color(0xFFFE5E5E5),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Text(
                      'Elige los días de tu entrenamiento',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDayButton('L'),
                      _buildDayButton('M'),
                      _buildDayButton('X'),
                      _buildDayButton('J'),
                      _buildDayButton('V'),
                      _buildDayButton('S'),
                      _buildDayButton('D'),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Nombre de la rutina',
                      ),
                    ),
                  ),
                ]),
          ),
          _buildSelectedDaysCards(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(ORANGE),
        onPressed: () {
          saveRoutine();
        },
        label: Text('Guardar'),
        icon: Icon(Icons.save),
      ),
    );
  }

  Widget _buildDayButton(String day) {
    final bool isSelected = _selectedDays.contains(day);
    Color buttonColor = isSelected ? Color(BLUE) : Color(ORANGE);
    Color textColor = isSelected ? Color(WHITE) : Color(BLACK);
    return GestureDetector(
      onTap: () {
        _toggleSelectedDay(day);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(fontSize: 12, color: textColor),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDaysCards() {
    if (_selectedDays.isEmpty) {
      return Container(); // Retorna un contenedor vacío si no hay días seleccionados
    }
    String changeName(String day) {
      switch (day) {
        case 'L':
          return 'Lunes';
        case 'M':
          return 'Martes';
        case 'X':
          return 'Miercoles';
        case 'J':
          return 'Jueves';
        case 'V':
          return 'Viernes';
        case 'S':
          return 'Sabado';
        case 'D':
          return 'Domingo';
        default:
          return '';
      }
    }

    return Column(
      children: _selectedDays
          .map(
            (day) => Card(
              margin: EdgeInsets.all(10),
              color: Color(ORANGE),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                              changeName(day),
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          final dayRoutineProvider =
                              Provider.of<DayRoutineProvider>(context,
                                  listen: false);
                          List<DayRoutine> dayRoutines =
                              dayRoutineProvider.dayRoutines;
                          if (dayRoutines.isEmpty) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    CreateDayRoutine.fromName(changeName(day)),
                              ),
                            );
                          } else {
                            dayRoutines.forEach((e) {
                              if (e.day_of_week == changeName(day)) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        CreateDayRoutine.fromDayRoutine(e),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => CreateDayRoutine.fromName(
                                        changeName(day)),
                                  ),
                                );
                              }
                            });
                          }
                        })
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  void saveRoutine() async {
    final dayRoutineProvider =
        Provider.of<DayRoutineProvider>(context, listen: false);
    List<DayRoutine> dayRoutines = dayRoutineProvider.dayRoutines;
    print(dayRoutines.toList());
    List<Mongo.ObjectId> IdList = [];
    for (var e in dayRoutines) {
      IdList.add(e.id);
      await MongoDb.CreateDayRoutine(e);
    }

    Routine routine = Routine(
      id: Mongo.ObjectId(),
      name: nameController.text,
      desc: 'desc',
      visibility: true,
      days: IdList,
    );
    final userIdProvider = Provider.of<UserProvider>(context, listen: false);
    Mongo.ObjectId userId = userIdProvider.getUserProvider;
    await MongoDb.insertRoutine(routine, userId);
    Navigator.of(context).pop();
  }
}

import 'package:flutter/material.dart';
import '../../widgets/Routines/CreateDayRoutine.dart';
import '../../modules/Routine.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../modules/DayRoutine.dart';
import '../../providers/DayRoutineProvider.dart';
import '../../providers/UserProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateRoutine extends StatefulWidget {
  final Routine? routine;
  const CreateRoutine() : routine = null;
  CreateRoutine.forEdit(this.routine);

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
  void initState() {
    super.initState();
    if (widget.routine != null) {
      initializeRoutineData();
    }
  }

  void initializeRoutineData() async {
    nameController.text = widget.routine!.name;
    _selectedDays.clear(); // Limpiar la lista de días seleccionados

    var response = await http
        .get(Uri.parse('$URL_HEAD/api/getDayRoutines/${widget.routine!.id}'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      dayRoutineList = []; // Limpiar la lista de rutinas diarias

      // Recorre cada objeto obtenido y crea un objeto DayRoutine
      for (var item in data) {
        DayRoutine routine = DayRoutine(
          id: item['_id'],
          day_of_week: item['day_of_week'],
          exercises: List<Map<String, dynamic>>.from(item['exercises']),
        );

        Provider.of<DayRoutineProvider>(context, listen: false)
            .addDayRoutine(routine);

        dayRoutineList.add(routine);
        if (item['day_of_week'] == 'Miercoles') {
          _selectedDays.add('X');
        } else {
          _selectedDays.add(item['day_of_week'][0]);
        }
      }
    } else {
      print('Error en la petición HTTP: ${response}');
      dayRoutineList = [];
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                          bool dayFound = false;
                          for (var e in dayRoutines) {
                            if (e.day_of_week == changeName(day)) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      CreateDayRoutine.fromDayRoutine(e),
                                ),
                              );
                              dayFound = true;
                              break; // Salir del bucle for después de encontrar el día correspondiente
                            }
                          }

                          if (!dayFound) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    CreateDayRoutine.fromName(changeName(day)),
                              ),
                            );
                          }
                        }
                      },
                    )
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
    List<String> idList = [];

    for (var e in dayRoutines) {
      try {
        var response = await http.post(
          Uri.parse('$URL_HEAD/api/createDayRoutine'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'day_of_week': e.day_of_week,
            'exercises': e.exercises,
          }),
        );
        idList.add(response.body.replaceAll("\"", ""));
      } catch (err) {
        print(err);
      }
    }

    final userIdProvider = Provider.of<UserProvider>(context, listen: false);

    if (widget.routine == null) {
      Routine newRoutine = Routine(
        name: nameController.text,
        desc: 'desc',
        visibility: true,
        days: idList,
      );
      var response = await http.put(
        Uri.parse(
            '$URL_HEAD/api/createRoutine/${userIdProvider.getUserProvider.replaceAll("\"", "")}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': newRoutine.name,
          'desc': newRoutine.desc,
          'days_of_week': newRoutine.days
        }),
      );
      if (response.statusCode == 200) {
        Provider.of<DayRoutineProvider>(context, listen: false);
        dayRoutineProvider.clearDayRoutines();
        Navigator.of(context).pop();
      } else {
        print('Ha ocurrido un error');
        print(response.body);
      }
    } else {
      var res = await http.get(
          Uri.parse('$URL_HEAD/api/getUser/${userIdProvider.getUserProvider}'));
      var userData = json.decode(res.body);

      Routine newRoutine = Routine(
        id: widget.routine!.id,
        name: nameController.text,
        desc: 'desc',
        visibility: true,
        days: idList,
      );
      if (checkRoutineExistsInJson(newRoutine.id!, userData)) {
        var response = await http.put(
          Uri.parse('$URL_HEAD/api/updRoutine/${newRoutine.id!}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': newRoutine.name,
            'desc': newRoutine.desc,
            'days_of_week': newRoutine.days,
          }),
        );
        if (response.statusCode == 200) {
          Provider.of<DayRoutineProvider>(context, listen: false);
          dayRoutineProvider.clearDayRoutines();
          Navigator.of(context).pop();
        } else {
          print('Ha ocurrido un error');
          print(response.body);
        }
      } else {
        var response = await http.put(
          Uri.parse(
              '$URL_HEAD/api/createRoutine/${userIdProvider.getUserProvider.replaceAll("\"", "")}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': newRoutine.name,
            'desc': newRoutine.desc,
            'days_of_week': newRoutine.days
          }),
        );
        if (response.statusCode == 200) {
          Provider.of<DayRoutineProvider>(context, listen: false);
          dayRoutineProvider.clearDayRoutines();
          Navigator.of(context).pop();
        } else {
          print('Ha ocurrido un error');
          print(response.body);
        }
      }
    }
  }

  bool checkRoutineExistsInJson(String id, dynamic json) {
    final routines = json['routines'];
    if (routines != null && routines is List<dynamic>) {
      return routines.any((routine) => routine == id);
    }
    return false;
  }
}

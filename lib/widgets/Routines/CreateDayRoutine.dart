import 'package:flutter/material.dart';
import 'package:lift_share/constants.dart';
import 'package:provider/provider.dart';
import '../../modules/db/dbCon.dart';
import '../../modules/DayRoutine.dart';
import '../../modules/Exercise.dart';
import '../../providers/DayRoutineProvider.dart';

class CreateDayRoutine extends StatefulWidget {
  final String day;
  const CreateDayRoutine({required this.day});

  @override
  State<CreateDayRoutine> createState() => _CreateDayRoutineState();
}

class _CreateDayRoutineState extends State<CreateDayRoutine> {
  List<String> _exercises = [];
  List<TextEditingController> _nameController = [];
  List<TextEditingController> _repsController = [];
  List<TextEditingController> _seriesController = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.day),
        backgroundColor: Color(ORANGE),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Color(BLUE),
            padding: EdgeInsets.all(16),
            child: Text(
              'Editar ${widget.day}',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nuevo Ejercicio',
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _addExercise();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                if (index >= _nameController.length) {
                  _nameController.add(TextEditingController());
                  _repsController.add(TextEditingController());
                  _seriesController.add(TextEditingController());
                }
                return Container(
                  height: 75,
                  child: Card(
                    child: Row(children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController[index],
                          decoration:
                              InputDecoration(labelText: 'Nombre Ejercicio'),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          controller: _repsController[index],
                          decoration: InputDecoration(labelText: 'Reps'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          controller: _seriesController[index],
                          decoration: InputDecoration(labelText: 'Series'),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          saveDay();
          Navigator.of(context).pop();
        },
        child: Icon(Icons.save),
        backgroundColor: Color(0xFFFCA311),
      ),
    );
  }

  void saveDay() async {
    List<Exercise> _exercisesList = [];
    for (var index = 0; index < _nameController.length; index++) {
      Exercise e = Exercise(
          name: _nameController[index].text,
          reps: int.parse(_repsController[index].text),
          series: int.parse(_seriesController[index].text));
      _exercisesList.add(e);
    }

    List<Map<String, dynamic>> listToDB = [];
    for (var index = 0; index < _exercisesList.length; index++) {
      listToDB.add({
        'name': _exercisesList[index].name,
        'series': _exercisesList[index].series,
        'reps': _exercisesList[index].reps,
      });
    }
    print(listToDB.toList());

    // Crea un nuevo objeto Day_routine con los ejercicios creados por el usuario
    DayRoutine newDayRoutine = DayRoutine(
      exercises: listToDB,
      day_of_week: widget.day,
    );
    // Obtiene la instancia de DayRoutinesProvider y agrega el nuevo objeto Day_routine a la lista de rutinas diarias
    Provider.of<DayRoutineProvider>(context, listen: false)
        .addDayRoutine(newDayRoutine);
  }

  void _addExercise() {
    setState(() {
      _exercises.add('Exercise ${_exercises.length + 1}');
    });
  }
}

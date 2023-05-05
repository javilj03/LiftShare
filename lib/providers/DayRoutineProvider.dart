import 'package:flutter/material.dart';
import '../modules/DayRoutine.dart';

class DayRoutineProvider with ChangeNotifier{
  List<DayRoutine> _dayRoutineList = [];

  List<DayRoutine> get dayRoutines => _dayRoutineList;

  void addDayRoutine(DayRoutine dayRoutine){
    _dayRoutineList.add(dayRoutine);
    notifyListeners();
  }

  void clearDayRoutines(){
    _dayRoutineList.clear();
    notifyListeners();
  }

}
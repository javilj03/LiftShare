import 'package:flutter/material.dart';
import '../modules/DayRoutine.dart';

class DayRoutineProvider with ChangeNotifier {
  List<DayRoutine> _dayRoutineList = [];

  List<DayRoutine> get dayRoutines => _dayRoutineList;

  void addDayRoutine(DayRoutine dayRoutine) {
    _dayRoutineList.add(dayRoutine);
    notifyListeners();
  }

  void removeDayRoutine(String dayOfWeek) {
    int i = 0;
    _dayRoutineList.map((e) => {
      if(e.day_of_week == dayOfWeek){
        _dayRoutineList.remove(i)
      },
      i++
    });
  }

  void clearDayRoutines() {
    _dayRoutineList.clear();
    notifyListeners();
  }
}

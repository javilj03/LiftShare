import 'package:flutter/material.dart';
import '../modules/DayRoutine.dart';

class DayRoutineProvider with ChangeNotifier {
  List<DayRoutine> _dayRoutineList = [];

  List<DayRoutine> get dayRoutines => _dayRoutineList;

  int _getDayOfWeekIndex(String dayOfWeek) {
    switch (dayOfWeek.toLowerCase()) {
      case 'monday':
        return 0;
      case 'tuesday':
        return 1;
      case 'wednesday':
        return 2;
      case 'thursday':
        return 3;
      case 'friday':
        return 4;
      case 'saturday':
        return 5;
      case 'sunday':
        return 6;
      default:
        return 7; // Otros días de la semana se considerarán al final
    }
  }

  void addDayRoutine(DayRoutine dayRoutine) {
    _dayRoutineList.sort((a, b) =>
        _getDayOfWeekIndex(a.day_of_week) - _getDayOfWeekIndex(b.day_of_week));
    _dayRoutineList.add(dayRoutine);
    notifyListeners();
  }

  void removeDayRoutine(String dayOfWeek) {
    _dayRoutineList.removeWhere((routine) => routine.day_of_week == dayOfWeek);
    notifyListeners();
  }

  void clearDayRoutines() {
    _dayRoutineList.clear();
    notifyListeners();
  }
}

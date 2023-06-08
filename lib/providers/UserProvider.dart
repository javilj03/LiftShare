import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier{
  var userId;

  String get getUserProvider => userId;

  void addUser(String id){
    userId = id.replaceAll("\"", "");
    notifyListeners();
  }

  void clearUserId(){
    userId = '';
    notifyListeners();
  }

}
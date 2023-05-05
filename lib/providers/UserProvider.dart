import 'package:flutter/material.dart';
import '../modules/User.dart';
import 'package:mongo_dart/mongo_dart.dart';


class UserProvider with ChangeNotifier{
  var userId;

  ObjectId get getUserProvider => userId;

  void addUser(ObjectId id){
    userId = id;
    notifyListeners();
  }

  void clearUserId(){
    userId = '';
    notifyListeners();
  }

}
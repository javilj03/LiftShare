import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import '../../modules/User.dart';
import '../../modules/db/dbCon.dart';

class ExtraRegister extends StatelessWidget {
  final nameController;
  final lastNameController;
  final emailController;
  final usernameController;
  final passwordController;
  final birthController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  ExtraRegister({
    required this.nameController,
    required this.lastNameController,
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 8, left: 8, right: 8, top: 50),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Fecha de nacimiento',
                  ),
                  controller: birthController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Peso'),
                  controller: weightController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Altura'),
                  controller: heightController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      _sendData(context);
                    },
                    child: Text('Completar')),
              )
            ],
          ),
        ),
      ),
    );
  }

  _sendData(BuildContext context) {
    User u = User(
      id: Mongo.ObjectId(),
      name: nameController.text,
      lastName: lastNameController.text,
      birth_date: DateTime.now(),
      weight: double.parse(weightController.text),
      height: double.parse(heightController.text),
      username: usernameController.text,
      email: emailController.text,
      visibility: true,
      password: passwordController.text,
    );
    _createUser(u);
  }

  _createUser(User user) async {
    await MongoDb.insertUser(user);
  }
}

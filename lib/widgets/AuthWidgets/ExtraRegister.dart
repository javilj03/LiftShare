import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import '../../modules/User.dart';
import '../../constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../ConstantWidgets/NavBar.dart';
import 'package:provider/provider.dart';
import '../../providers/UserProvider.dart';

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

  _sendData(BuildContext context) async {
    User u = User(
      name: nameController.text,
      lastName: lastNameController.text,
      weight: double.parse(weightController.text),
      height: double.parse(heightController.text),
      username: usernameController.text,
      email: emailController.text,
      visibility: true,
      password: passwordController.text,
    );
    try {
      var response = await http.post(
        Uri.parse('$URL_HEAD/api/createUser'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': u.name,
            'lastName': u.lastName,
            'username': u.username,
            'password': u.password,
            'email': u.email,
            'weight': u.weight,
            'height': u.height,
          },
        ),
      );
      print(response.body);
      if (response.statusCode == 200) {
        Provider.of<UserProvider>(context, listen: false)
            .addUser(response.body);
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => NavBar()),
        );
      } else {
        print('Usuario no valido');
      }
    } catch (err) {
      print(err);
    }
  }
}

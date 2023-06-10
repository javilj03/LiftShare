import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import '../../modules/User.dart';
import '../../constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../ConstantWidgets/NavBar.dart';
import 'package:provider/provider.dart';
import '../../providers/UserProvider.dart';
import 'package:intl/intl.dart';

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
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        locale: const Locale(
                            'es', 'ES'), // Set the locale to Spanish (Spain)
                      );

                      if (selectedDate != null) {
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(selectedDate);
                        birthController.text = formattedDate;
                      }
                    },
                    controller: birthController,
                    readOnly: true,
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Peso'),
                  controller: weightController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(ORANGE)),
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
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        Provider.of<UserProvider>(context, listen: false)
            .addUser(responseData['_id']);
        
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => NavBar()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se ha podido crear el usuario', textAlign: TextAlign.center,),
            duration: Duration(seconds: 4), // Duración del SnackBar
          ),
        );
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ha ocurrido un error', textAlign: TextAlign.center,),
            duration: Duration(seconds: 4), // Duración del SnackBar
          ),
        );
      print(err);
    }
  }
}

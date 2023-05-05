import 'dart:async';

import 'package:flutter/material.dart';
import './ExtraRegister.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import '../../modules/db/dbCon.dart';
import '../../modules/User.dart';

class Register extends StatelessWidget {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(20)),
              Image.asset(
                'assets/img/liftShare.png',
                width: 300,
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 8, right: 8, bottom: 8),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  controller: nameController,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Apellidos',
                    border: OutlineInputBorder(),
                  ),
                  controller: lastNameController,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                  ),
                  controller: emailController,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario',
                    border: OutlineInputBorder(),
                  ),
                  controller: usernameController,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                  controller: passwordController,
                ),
              ),
              ElevatedButton(
                child: Text('Continuar'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExtraRegister(
                              emailController: emailController,
                              lastNameController: lastNameController,
                              nameController: nameController,
                              passwordController: passwordController,
                              usernameController: usernameController,
                            )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:lift_share/modules/User.dart';
import '../../modules/db/dbCon.dart';
import '../ConstantWidgets/NavBar.dart';
import './Register.dart';
import 'package:provider/provider.dart';
import '../../providers/UserProvider.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50, bottom: 8, left: 8, right: 8),
              child: Image.asset(
                'assets/img/liftShare.png',
                width: 300,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10, left: 30, right: 30, top: 10),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre de usuario'),
                    controller: usernameController,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: 10, left: 30, right: 30, top: 10),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contraseña',
                    ),
                    controller: passwordController,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFCA311), // Color FCA311
                    ),
                    child: Text('Iniciar sesión'),
                    onPressed: () {
                      _checkUser(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFCA311), // Color FCA311
                      ),
                      child: Text('Crear cuenta'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => Register()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _checkUser(BuildContext context) async {
    var user = await MongoDb.verifyUser(
        usernameController.text, passwordController.text);
    if (user!=null) {
      Provider.of<UserProvider>(context, listen: false)
            .addUser(user);
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => NavBar()),
      );
    } else {
      print('no eres usuario');
    }
  }
}

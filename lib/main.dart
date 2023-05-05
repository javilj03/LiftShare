import 'package:flutter/material.dart';
import 'package:lift_share/providers/UserProvider.dart';
import './providers/DayRoutineProvider.dart';
import 'package:provider/provider.dart';
import './modules/db/dbCon.dart';
import './widgets/AuthWidgets/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDb.connect();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DayRoutineProvider>(create: (_) => DayRoutineProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      title: 'Lift Share',
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import '/providers/UserProvider.dart';
import './providers/DayRoutineProvider.dart';
import 'package:provider/provider.dart';
import './widgets/AuthWidgets/Login.dart';
import './widgets/ConstantWidgets/NavBar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'), // Add any other locales you need
      ],
    );
  }
}

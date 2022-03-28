import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
            headline3: TextStyle(fontWeight: FontWeight.w600),
            headline4: TextStyle(fontWeight: FontWeight.w700),
        )
      ),
      home: AuthScreen(),
    );
  }
}

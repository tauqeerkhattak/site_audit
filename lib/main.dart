import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';

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
        fontFamily: 'Ubuntu',
        textTheme: TextTheme(
            headline3: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'NanumMyeongjo', color: Constants.primaryColor),
            headline4: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'NanumMyeongjo',
                color: Constants.primaryColor.withOpacity(0.8),
                height: 1.5
            ),
        )
      ),
      home: AuthScreen(),
    );
  }
}

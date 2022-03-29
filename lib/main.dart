import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';

import 'screens/auth_screen.dart';
import 'utils/size_config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => OrientationBuilder(
      builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
         return MaterialApp(
            title: 'Site Audit',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                fontFamily: 'Ubuntu',
                textTheme: TextTheme(
                  headline3: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontFamily: 'NanumMyeongjo',
                      fontSize: SizeConfig.textMultiplier * 6,
                      color: Constants.primaryColor),
                  headline4: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'NanumMyeongjo',
                      fontSize: SizeConfig.textMultiplier * 4.5,
                      color: Constants.primaryColor.withOpacity(0.8),
                      height: 1.5),
                )),
            home: AuthScreen(),
          );
        },
      ),
    );
  }
}

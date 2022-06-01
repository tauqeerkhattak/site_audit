import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/network.dart';
import 'package:site_audit/utils/permssion_util.dart';

import 'routes/pages.dart';
import 'routes/routes.dart';
import 'utils/size_config.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  init() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectionState.active) {
      Network.isAvailable = true;
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => OrientationBuilder(
        builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          PermissionUtil.request();
          return GetMaterialApp(
            title: 'Site Audit',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Ubuntu',
              textTheme: TextTheme(
                headline3: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFamily: 'NanumMyeongjo',
                  fontSize: SizeConfig.textMultiplier * 6,
                  color: Constants.primaryColor,
                ),
                headline4: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'NanumMyeongjo',
                  fontSize: SizeConfig.textMultiplier * 4.5,
                  color: Constants.primaryColor.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ),
            initialRoute: AppRoutes.AUTH,
            getPages: AppPages.list,
          );
        },
      ),
    );
  }
}

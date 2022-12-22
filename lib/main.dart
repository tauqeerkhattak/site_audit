import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:site_audit/offlineDatabase/database.dart';

import 'routes/pages.dart';
import 'routes/routes.dart';
import 'services/image_picker_service.dart';
import 'services/local_storage_service.dart';
import 'utils/constants.dart';
import 'utils/permssion_util.dart';
import 'utils/size_config.dart';

void main() async {
  await GetStorage.init();
  await PermissionUtil.request();
  final llo = Get.put(LocalStorageService());
  await llo.clearAll();
  await DatabaseDb.initDb();
  DatabaseDb db = DatabaseDb();
  await db.deleteAllForms();
  Get.put(ImagePickerService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        SizeConfig.init(orientation);
        return GetMaterialApp(
          title: 'Site Audit',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Roboto',
            textTheme: TextTheme(
              headline3: GoogleFonts.roboto(
                fontWeight: FontWeight.w800,
                fontSize: SizeConfig.textMultiplier * 6,
                color: Constants.primaryColor,
              ),
              headline4: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.textMultiplier * 4.5,
                color: Constants.primaryColor.withOpacity(0.8),
                height: 1.5,
              ),
            ),
          ),
          builder: (context, child) {
            final data = MediaQuery.of(context).copyWith(textScaleFactor: 1);
            return MediaQuery(data: data, child: child!);
          },
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splash,
          getPages: AppPages.list,
        );
      },
    );
  }
}

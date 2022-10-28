import 'package:get/get.dart';
import 'package:site_audit/domain/bindings/auth_bindings.dart';
import 'package:site_audit/domain/bindings/form_bindings.dart';
import 'package:site_audit/domain/bindings/home_bindings.dart';
import 'package:site_audit/domain/bindings/review_bindings.dart';
import 'package:site_audit/domain/bindings/splash_bindings.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/screens/auth/auth_screen.dart';
import 'package:site_audit/screens/form/form_screen.dart';
import 'package:site_audit/screens/form/review_screen.dart';
import 'package:site_audit/screens/home/home_screen.dart';
import 'package:site_audit/screens/splash/splash.dart';

import '../domain/bindings/load_bindings.dart';
import '../screens/auth/add_site_data.dart';
import '../screens/load_data/load_data.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.splash,
      page: () => Splash(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: AppRoutes.auth,
      binding: AuthBindings(),
      page: () => const AuthScreen(),
    ),
    GetPage(
      name: AppRoutes.loadData,
      binding: LoadBindings(),
      page: () => LoadData(),
    ),
    GetPage(
      name: AppRoutes.home,
      binding: HomeBindings(),
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.form,
      binding: FormBindings(),
      page: () => FormScreen(),
    ),
    GetPage(
      name: AppRoutes.review,
      binding: ReviewBindings(),
      page: () => const ReviewScreen(),
    ),
    GetPage(
      name: AppRoutes.addSiteData,
      binding: AuthBindings(),
      page: () => AddSiteData(),
    ),
  ];
}

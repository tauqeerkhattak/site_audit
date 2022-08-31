import 'package:get/get.dart';
import 'package:site_audit/bindings/auth_bindings.dart';
import 'package:site_audit/bindings/form_bindings.dart';
import 'package:site_audit/bindings/home_bindings.dart';
import 'package:site_audit/bindings/splash_bindings.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/screens/auth/auth_screen.dart';
import 'package:site_audit/screens/form_screen/form_screen.dart';
import 'package:site_audit/screens/home/home_screen.dart';
import 'package:site_audit/screens/splash/splash.dart';

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
      name: AppRoutes.home,
      binding: HomeBindings(),
      page: () => HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.form,
      binding: FormBindings(),
      page: () => FormScreen(),
    ),
  ];
}

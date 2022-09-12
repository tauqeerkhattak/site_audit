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
    GetPage(
      name: AppRoutes.review,
      binding: ReviewBindings(),
      page: () => ReviewScreen(),
    ),
  ];
}

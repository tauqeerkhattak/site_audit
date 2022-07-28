import 'package:get/get.dart';
import 'package:site_audit/bindings/auth_bindings.dart';
import 'package:site_audit/bindings/home_bindings.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/screens/auth_screen.dart';
import 'package:site_audit/screens/home_screen.dart';

class AppPages {
  static var list = [
    GetPage(
        name: AppRoutes.AUTH,
        binding: AuthBindings(),
        page: () => AuthScreen()),
    GetPage(
        name: AppRoutes.HOME,
        binding: HomeBindings(),
        page: () => HomeScreen()),
    // GetPage(
    //     name: AppRoutes.HOME,
    //     binding: HomeBindings(),
    //     page: () => HomeScreen()
    // ),
    // GetPage(
    //     name: AppRoutes.INFO,
    //     binding: InfoBinding(),
    //     page: () => InfoScreen()
    // ),
    // GetPage(
    //     name: AppRoutes.FAVORITES,
    //     page: () => FavoritesScreen()
    // ),
  ];
}

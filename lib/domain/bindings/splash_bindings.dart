import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/dashboard_controller.dart';
import 'package:site_audit/domain/controllers/splash_controller.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => DashboardController());
  }
}

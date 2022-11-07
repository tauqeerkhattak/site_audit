import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/auth_controller.dart';
import 'package:site_audit/domain/controllers/dashboard_controller.dart';
import 'package:site_audit/domain/controllers/home_controller.dart';
import 'package:site_audit/domain/controllers/load_controller.dart';

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => HomeController());
  }
}

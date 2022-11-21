import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/dashboard_controller.dart';
import 'package:site_audit/domain/controllers/home_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut(() => DashboardController());
  }
}

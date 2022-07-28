import 'package:get/get.dart';
import 'package:site_audit/controllers/auth_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
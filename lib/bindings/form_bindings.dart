import 'package:get/get.dart';
import 'package:site_audit/controllers/form_controller.dart';

class FormBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FormController());
  }
}

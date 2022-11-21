import 'package:get/get.dart';

import '../controllers/load_controller.dart';

class LoadBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoadController());
  }
}

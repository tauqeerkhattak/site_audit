import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/review_controller.dart';

class ReviewBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReviewController());
  }
}

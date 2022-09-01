import 'package:get/get.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/services/local_storage_service.dart';

class SplashController extends GetxController {
  final storage = Get.find<LocalStorageService>();
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () async {
      if (storage.hasKey(key: 'user')) {
        Get.offAndToNamed(AppRoutes.home);
      } else {
        Get.offAndToNamed(AppRoutes.auth);
      }
    });
  }
}

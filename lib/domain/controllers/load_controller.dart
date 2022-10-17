import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/services/local_storage_service.dart';

import '../../models/module_model.dart';
import '../../models/user_model.dart';
import '../../services/local_storage_keys.dart';
import '../../services/services.dart';

class LoadController extends GetxController {
  final loading = false.obs;
  final storageService = Get.find<LocalStorageService>();
  List<Module>? modules = [];
  RxInt totalForms = 0.obs;
  RxInt currentForm = 1.obs;
  Rxn<User> user = Rxn();

  @override
  void onInit() {
    super.onInit();
    loading.value = true;
    final userData = storageService.get(key: userKey);
    user.value = User.fromJson(jsonDecode(userData));
    if (user.value != null) {
      getData();
    }
  }

  Future<void> getData() async {
    try {
      modules = await AppService.getModules(
        projectId: user.value!.data!.projectId!,
      );
      if (modules != null) {
        for (Module module in modules!) {
          totalForms = totalForms + (module.subModules?.length ?? 0);
        }
        await getForms();
      }
      Get.offAndToNamed(
        AppRoutes.home,
      );
    } catch (e) {
      log('Exception in load_controller.dart: ${e.toString()}');
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        loading.value = false;
      });
    }
  }

  Future<void> getForms() async {
    int projectId = user.value!.data!.projectId!;
    for (Module module in modules!) {
      for (SubModule subModule in module.subModules!) {
        await AppService.getFormBySubModuleId(
          projectId: '$projectId',
          // moduleId: 1,
          moduleId: subModule.subModuleId!,
        );
        currentForm++;
      }
    }
    AppService.getStaticDropdowns('$projectId');
  }
}

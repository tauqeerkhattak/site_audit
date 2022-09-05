import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/models/module_model.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/services/local_storage_keys.dart';
import 'package:site_audit/services/local_storage_service.dart';
import 'package:site_audit/services/services.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  final pageController = PageController(initialPage: 0);
  final storageService = Get.find<LocalStorageService>();
  RxList<Module> modules = RxList([]);
  Rxn<Module> selectedModule = Rxn();
  Rxn<SubModule> selectedSubModule = Rxn();

  @override
  void onInit() {
    super.onInit();
    getModules();
  }

  Future<void> getModules() async {
    try {
      final data = storageService.get(key: userKey);
      User user = User.fromJson(jsonDecode(data));
      loading.value = true;
      final temp =
          await AppService.getModules(projectId: user.data!.projectId!);
      if (temp != null) {
        modules.value = temp;
        modules.removeWhere((element) {
          return element.moduleName!.toLowerCase() == 'site details';
        });
        loading.value = false;
      }
    } catch (e) {
      log('Error: $e');
      loading.value = false;
      Get.rawSnackbar(
        backgroundColor: Colors.red,
        message: 'Error: $e',
      );
    }
  }

  void animateBack() async {
    int currentPage = pageController.page!.toInt();
    if (currentPage > 0) {
      await pageController.animateToPage(
        (currentPage - 1),
        duration: const Duration(milliseconds: 400),
        curve: Curves.linear,
      );
    }
  }

  void animateForward(Module module) async {
    selectedModule.value = module;
    await pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.linear,
    );
  }
}

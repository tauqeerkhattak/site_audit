import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/models/module_model.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/service/local_storage_service.dart';
import 'package:site_audit/service/services.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  final storageService = Get.find<LocalStorageService>();
  RxList<Module> modules = RxList([]);

  @override
  void onInit() {
    super.onInit();
    getModules();
  }

  Future<void> getModules() async {
    try {
      final data = storageService.get(key: 'user');
      User user = User.fromJson(jsonDecode(data));
      log('data: $data');
      loading.value = true;
      final temp =
          await AppService.getModules(projectId: user.data!.projectId!);
      if (temp != null) {
        modules.value = temp;
      }
    } catch (e) {
      print('Error: $e');
      Get.rawSnackbar(
        backgroundColor: Colors.red,
        message: 'Error: $e',
      );
    } finally {
      loading.value = false;
    }
  }
}

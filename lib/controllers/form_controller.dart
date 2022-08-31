import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/service/local_storage_service.dart';
import 'package:site_audit/service/services.dart';

class FormController extends GetxController {
  final loading = RxBool(false);
  final storageService = Get.find<LocalStorageService>();
  RxString projectId = RxString('Loading...');
  Rxn<FormModel> form = Rxn();
  User? user;
  final data = <String, dynamic>{};
  var textController = TextEditingController(text: 'Hello');

  @override
  void onInit() {
    super.onInit();
    data.assign('textController', textController);
    final userData = storageService.get(key: 'user');
    user = User.fromJson(jsonDecode(userData));
    projectId.value = '${user!.data!.projectId}';
    getForms();
  }

  Future<void> getForms() async {
    final arguments = Get.arguments;
    loading.value = true;
    final temp = await AppService.getFormBySubModuleId(
      projectId: projectId.value,
      moduleId: arguments['module_id'],
    );
    if (temp != null) {
      form.value = temp;
    }
    try {} catch (e) {
      log('Error: $e');
      Get.rawSnackbar(
        backgroundColor: Colors.red,
        message: 'Error: $e',
      );
    } finally {
      loading.value = false;
    }
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/services/image_picker_service.dart';
import 'package:site_audit/services/local_storage_service.dart';
import 'package:site_audit/services/services.dart';
import 'package:site_audit/utils/enums/enum_helper.dart';
import 'package:site_audit/utils/enums/input_type.dart';

class FormController extends GetxController {
  final loading = RxBool(false);
  final storageService = Get.find<LocalStorageService>();
  final imagePickerService = Get.find<ImagePickerService>();
  String? projectId;
  Rxn<FormModel> form = Rxn();
  User? user;
  Map<String, Rx<dynamic>> data = <String, Rx<dynamic>>{};

  @override
  void onInit() {
    super.onInit();
    final userData = storageService.get(key: 'user');
    user = User.fromJson(jsonDecode(userData));
    projectId = '${user!.data!.projectId}';
    getForms();
  }

  Future<void> getForms() async {
    try {
      final arguments = Get.arguments;
      loading.value = true;
      final temp = await AppService.getFormBySubModuleId(
        projectId: projectId!,
        moduleId: arguments['module_id'],
      );
      if (temp != null) {
        form.value = temp;
        assignControllersToFields();
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

  void assignControllersToFields() {
    final fields = form.value!.items!;
    for (int i = 0; i < fields.length; i++) {
      final item = fields[i];
      InputType type = EnumHelper.inputTypeFromString(item.inputType);
      switch (type) {
        case InputType.DROPDOWN:
          data['DROPDOWN$i'] = item.inputOption!.inputOptions!.first.obs;
          break;
        case InputType.AUTO_FILLED:
          data['AUTOFILLED$i'] = TextEditingController().obs;
          break;
        case InputType.TEXTBOX:
          data['TEXTBOX$i'] = TextEditingController().obs;
          break;
        case InputType.INTEGER:
          data['INTEGER$i'] = TextEditingController().obs;
          break;
        case InputType.PHOTO:
          data['PHOTO$i'] = ''.obs;
          break;
        case InputType.RADIAL:
          data['RADIAL$i'] = item.inputOption!.inputOptions!.first.obs;
          break;
        case InputType.FLOAT:
          data['FLOAT$i'] = TextEditingController().obs;
          break;
      }
    }
  }
}

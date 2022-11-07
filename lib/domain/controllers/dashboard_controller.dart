import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/models/static_values.dart';
import 'package:site_audit/services/local_storage_keys.dart';
import 'package:site_audit/services/local_storage_service.dart';

class DashboardController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    fetchData();
  }

  final storageService = Get.put(LocalStorageService());

  RxList<StaticValues> forms = <StaticValues>[].obs;

  Future<void> fetchData() async {
    final keys = await storageService.getAllKeys();

    for (final key in keys) {
      if (key.contains("site_name")) {
        final value = await storageService.get(key: key);

        log("${key} valuesss");

        forms.value.add(StaticValues.fromJson(value.first));
      }
    }
  }
}

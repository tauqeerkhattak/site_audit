import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/models/static_values.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/screens/dashboard/dashboard_screen.dart';
import 'package:site_audit/services/local_storage_keys.dart';
import 'package:site_audit/services/local_storage_service.dart';
import 'package:site_audit/services/services.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/network.dart';

class DashboardController extends GetxController {
  var audits ;
  RxBool loading = false.obs;
  StreamSubscription? sub;
  final storageService = Get.put(LocalStorageService());

  RxList<StaticValues> forms = <StaticValues>[].obs;


  @override
  void onInit() {
    super.onInit();
    // TODO: implement onInit
    initNetwork();
    fetchData();
  }

  void initNetwork() async {
    if (await hasNetwork()) {
      Network.isNetworkAvailable.value = true;
    } else {
      Network.isNetworkAvailable.value = false;
    }
    sub = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        log('No network!');
        Network.isNetworkAvailable.value = false;
      } else {
        if (await hasNetwork()) {
          Network.isNetworkAvailable.value = true;
          await sendSavedData();
          log('Network available!');
        } else {
          Network.isNetworkAvailable.value = false;
          log('No network!');
        }
      }
    });
  }

  Future<bool> hasNetwork() async {
    try {
      var res = await get(Uri.parse('https://www.example.com/'));
      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      log('Exception: ${_.message}');
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    sub?.cancel();
  }



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

  Future<void> sendSavedData() async {
    loading.value = true;
    if (storageService.hasKey(key: offlineSavedDataKey)) {
      final List<dynamic> list = storageService.get(key: offlineSavedDataKey);
      final userData = storageService.get(key: userKey);
      final User user = User.fromJson(jsonDecode(userData));
      int length = list.length;
      final temp = List.of(list);
      for (int i = 0; i < length; i++) {
        var element = temp[i];
        //File file = await saveJsonFileLocally(element);
        final String? response = await AppService.sendJson(
          moduleId: element['sub_module_id'],
          projectId: user.data!.projectId!,
          engineerId: user.data!.id!,
          json: jsonEncode(element),
        );
        if (response != null) {
          final res = jsonDecode(response);
          if (res['status'] == 200) {
            list.remove(element);
          }
        }
      }
      if (list.isEmpty) {
        storageService.remove(key: offlineSavedDataKey);
        itemCount = 1;
        audits = null;
        auditNumber = [];
        storageService.remove(key: 'audit');
        loading.value = false;
        Get.rawSnackbar(
          backgroundColor: Constants.successColor,
          icon: const Icon(
            Icons.save,
            color: Colors.white,
          ),
          message: 'All locally saved audits have been uploaded to server',
        );

      }
    }
    //dashController.loading.value = false;
    loading.value = false;
  }
}

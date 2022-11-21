import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/screens/dashboard/dashboard_screen.dart';
import 'package:site_audit/services/local_storage_keys.dart';
import 'package:site_audit/services/local_storage_service.dart';
import 'package:site_audit/services/services.dart';
import 'package:site_audit/utils/network.dart';
import '../../utils/constants.dart';
import 'dashboard_controller.dart';

class SplashController extends GetxController {
  final storage = Get.find<LocalStorageService>();
  final dashController = Get.put(DashboardController());
  RxBool loading = false.obs;
  StreamSubscription? sub;

  @override
  void onInit() {
    super.onInit();
    //initNetwork();
    Future.delayed(const Duration(seconds: 5), () async {
      var data = storage.get(key: "sitesData");
      if(data == null){
        if (storage.hasKey(key: userKey)) {
          // Get.offAndToNamed(AppRoutes.addSiteData);
          Get.offAndToNamed(AppRoutes.dashboard);
        } else {
          Get.offAndToNamed(AppRoutes.auth);
        }
      }else{
        Get.offAndToNamed(AppRoutes.home);
      }



    });
  }

  @override
  void dispose() {
    super.dispose();
    //sub?.cancel();
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

  Future<void> sendSavedData() async {
    loading.value = true;
    if (storage.hasKey(key: offlineSavedDataKey)) {
      final List<dynamic> list = storage.get(key: offlineSavedDataKey);
      final userData = storage.get(key: userKey);
      final User user = User.fromJson(jsonDecode(userData));
      int length = list.length;
      final temp = List.of(list);
      for (int i = 0; i < length; i++) {
        var element = temp[i];

        File file = await saveJsonFileLocally(element);
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
        storage.remove(key: offlineSavedDataKey);
        itemCount = 1;
        dashController.audits = null;
        auditNumber = [];
        storage.remove(key: 'audit');
        print("==================>hamza");
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

  Future<File> saveJsonFileLocally(Map<String, dynamic> model) async {
    final directory = await getExternalStorageDirectory();
    final path = directory?.path;
    File file = File('$path/data.json');
    await file.writeAsString(jsonEncode(model)).then((value) {
      log('File saved at: $path/data.json');
    });
    return file;
  }
}

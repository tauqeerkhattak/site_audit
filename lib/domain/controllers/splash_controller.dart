import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/services/local_storage_keys.dart';
import 'package:site_audit/services/local_storage_service.dart';
import 'package:site_audit/utils/network.dart';

class SplashController extends GetxController {
  final storage = Get.find<LocalStorageService>();
  StreamSubscription? sub;

  @override
  void onInit() {
    super.onInit();
    initNetwork();
    Future.delayed(const Duration(seconds: 5), () async {
      if (storage.hasKey(key: userKey)) {
        Get.offAndToNamed(AppRoutes.home);
      } else {
        Get.offAndToNamed(AppRoutes.auth);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    sub?.cancel();
  }

  void initNetwork() {
    sub = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        log('No network!');
        Network.isNetworkAvailable.value = false;
      } else {
        if (await hasNetwork()) {
          Network.isNetworkAvailable.value = true;
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
}

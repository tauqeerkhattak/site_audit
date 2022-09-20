import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:site_audit/models/module_model.dart';
import 'package:site_audit/models/review_model.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/services/local_storage_keys.dart';
import 'package:site_audit/services/local_storage_service.dart';
import 'package:site_audit/services/services.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/network.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  RxBool auditLoading = false.obs;
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
      }
    } catch (e) {
      log('Error: $e');

      Get.rawSnackbar(
        backgroundColor: Colors.red,
        message: 'Error: $e',
      );
    } finally {
      loading.value = false;
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

  Future<void> submitAudits() async {
    final data = await storageService.getAllKeys();
    List<String> keysToSend = [];
    for (String key in data) {
      if (key.contains('>>')) {
        log('Key: $key');
        keysToSend.add(key);
      }
    }
    if (Network.isNetworkAvailable) {
      // for (String key in keysToSend) {
      //   final data = storageService.ge
      // }
      List<dynamic> listOfItems = storageService.get(key: keysToSend.first);
      for (var item in listOfItems) {
        await sendJsonFile(item);
      }
    } else {
      loading.value = false;
      await storageService.save(key: offlineSavedData, value: keysToSend);
      Get.rawSnackbar(
        title: "No Internet!",
        message:
            "Data will be uploaded when you have a stable internet connection!",
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
        backgroundColor: Constants.primaryColor,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
      );
    }
    // AppService.sendJsonFile(moduleId: 1);
  }

  Future<void> sendJsonFile(dynamic data) async {
    try {
      ReviewModel model = ReviewModel.fromJson(data);
      File file = await saveJsonFileLocally(model);
      AppService.sendJsonFile(
        moduleId: model.subModuleId!,
        file: file,
      );
    } catch (e) {
      log('Exception in sendJsonFile=>HomeController: $e');
    }
  }

  Future<File> saveJsonFileLocally(ReviewModel model) async {
    // final directory = await getApplicationDocumentsDirectory();
    final directory = await getExternalStorageDirectory();
    final path = directory?.path;
    File file = File('$path/data.json');
    await file.writeAsString(jsonEncode(model.toJson())).then((value) {
      log('File saved at: $path/data.json');
    });
    return file;
  }
}

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
  final pageController = PageController(initialPage: 0);
  Rxn<User> user = Rxn();
  final storageService = Get.find<LocalStorageService>();
  RxList<Module> modules = RxList([]);

  Rxn<Module> selectedModule = Rxn();
  Rxn<SubModule> selectedSubModule = Rxn();

  @override
  void onInit() {
    super.onInit();
    final userData = storageService.get(key: userKey);
    getModules();
    user.value = User.fromJson(jsonDecode(userData));
  }

  Future<void> getModules() async {
    final data = storageService.get(key: modulesKey);
    List<dynamic> jsonList = jsonDecode(data);
    for (var item in jsonList) {
      modules.add(Module.fromJson(item));
    }
    modules.removeWhere((element) {
      return element.moduleName?.toLowerCase() == 'site details';
    });
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
    loading.value = true;
    final data = await storageService.getAllKeys();
    List<String> keysToSend = [];
    for (String key in data) {
      if (key.contains('>>')) {
        log('Key: $key');
        keysToSend.add(key);
      }
    }
    if (Network.isNetworkAvailable.value) {
      for (String key in keysToSend) {
        List<dynamic> listOfItems = storageService.get(key: key);
        for (var item in listOfItems) {
          int code = await sendJsonFile(item);
          if (code == 200) {
            storageService.remove(key: key);
          }
        }
      }
      loading.value = false;
    } else {
      if (storageService.hasKey(key: offlineSavedData)) {
        final List<String> list = await storageService.get(
          key: offlineSavedData,
        );
        list.addAll(keysToSend);
        await storageService.save(key: offlineSavedData, value: list);
      }
      await storageService.save(key: offlineSavedData, value: keysToSend);
      loading.value = false;
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

  Future<int> sendJsonFile(dynamic data) async {
    try {
      ReviewModel model = ReviewModel.fromJson(data);
      final jsonData = model.toJson();
      final staticValues = model.staticValues;
      jsonData['static_values'] = {
        'operator': {
          'value': staticValues?.operator?.value?.operator,
        },
        'region': {
          'value': staticValues?.region?.value?.name,
        },
        'sub_region': {
          'value': staticValues?.subRegion?.value?.name,
        },
        'cluster': {
          'value': staticValues?.cluster?.value?.id,
        },
        'site_id': {
          'value': staticValues?.siteId?.value?.id,
        },
        'site_name': {
          'value': staticValues?.siteId?.value?.name,
        }
      };
      File file = await saveJsonFileLocally(jsonData);
      String? response = await AppService.sendJsonFile(
        moduleId: model.subModuleId!,
        projectId: user.value!.data!.projectId!,
        engineerId: user.value!.data!.id!,
        file: file,
      );
      if (response != null) {
        final data = jsonDecode(response);
        if (data['status'] == 200) {
          int moduleCount = storageService.get(
                key: model.moduleName!,
              ) ??
              0;
          int subModuleCount = storageService.get(
                key: model.subModuleName!,
              ) ??
              0;
          if (moduleCount != 0) {
            storageService.save(
              key: model.moduleName!,
              value: --moduleCount,
            );
          }
          if (subModuleCount != 0) {
            storageService.save(
              key: model.subModuleName!,
              value: --subModuleCount,
            );
          }
        }
        return data['status'];
      } else {
        return 0;
      }
    } catch (e) {
      log('Exception in sendJsonFile=>HomeController: $e');
      return 0;
    }
  }

  Future<File> saveJsonFileLocally(Map<String, dynamic> model) async {
    // final directory = await getApplicationDocumentsDirectory();
    final directory = await getExternalStorageDirectory();
    final path = directory?.path;
    File file = File('$path/data.json');
    await file.writeAsString(jsonEncode(model)).then((value) {
      log('File saved at: $path/data.json');
    });
    return file;
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:site_audit/domain/controllers/dashboard_controller.dart';
import 'package:site_audit/models/module_model.dart';
import 'package:site_audit/models/static_values.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/screens/dashboard/dashboard_screen.dart';
import 'package:site_audit/services/local_storage_keys.dart';
import 'package:site_audit/services/local_storage_service.dart';
import 'package:site_audit/services/services.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/network.dart';
import 'package:site_audit/utils/ui_utils.dart';

import '../../models/form_model.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  bool isLocallySaved = false;
  RxInt currentPage = 0.obs;
  final pageController = PageController(initialPage: 0);
  Rxn<User> user = Rxn();
  final storageService = Get.find<LocalStorageService>();
  final dashController = Get.find<DashboardController>();
  RxList<Module> modules = RxList([]);
  Rxn<Module> selectedModule = Rxn();
  Rxn<SubModule> selectedSubModule = Rxn();
  GetStorage g = GetStorage('MyStorage');

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

  Future<void> submitAudits(BuildContext context) async {
    final data = await storageService.getAllKeys();
    try{
      List<String> keysToSend = [];
      for (String key in data) {
        if (key.contains('>>')) {
          log('Key: $key');
          keysToSend.add(key);
        }
      }
      if (keysToSend.isEmpty) {
        UiUtils.showSimpleDialog(
          context: context,
          title: 'Info',
          content:
          'No forms found, to complete audit, you have to fill some forms first!',
        );
        return;
      }else{
        loading.value = true;
        for (String key in keysToSend) {
          List<dynamic> listOfItems = storageService.get(key: key);
          for (var item in listOfItems) {
            /// TO-DO
            int code = await sendJsonFile(item, key);
            if (code == 200) {
              storageService.remove(key: key);

            }
          }
        }
        if(isLocallySaved) {
          isLocallySaved = false;
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

        var data = storageService.get(key: 'audit');
        if(data != null){
          storageService.save(key: "audit", value: data + 1 );
        }else{
          storageService.save(key: "audit", value: itemCount++);
        }

        if(Network.isNetworkAvailable.value == true){
          itemCount = 1;
          dashController.audits = [];
          auditNumber = [];
          storageService.remove(key: 'audit');
          Get.rawSnackbar(
            title: "SYNCED",
            message: "Forms synced successfully",
            backgroundColor: Constants.primaryColor,
          );
        }else{
          Get.rawSnackbar(
            title: "Connection Failed",
            message: "No internet found try to save data locally.",
            backgroundColor: Constants.primaryColor,
          );
        }
        loading.value = false;
        storageService.save(key: "sitesData", value: "submit");
        storageService.remove(key: "sitesData");
        Get.offAndToNamed(AppRoutes.dashboard);
      }
    }catch(e){
      Get.rawSnackbar(
        title: "Connection Failed",
        message: "No internet found try to save data locally.",
        backgroundColor: Constants.primaryColor,
      );
    }
    loading.value = false;

  }

  Future<int> sendJsonFile(dynamic data, String key) async {
    // try {
    FormModel model = FormModel.fromJson(data);
    final moduleName = key.split(' >> ').first;
    final jsonData = model.toFormJson();
    final jsonStaticValues = model.staticValues;
    final staticValues = StaticValues.fromJson(jsonStaticValues!);
    jsonData['static_values'] = [
      {
        "key": "operator",
        "value": staticValues.operator?.value?.operator,
      },
      {
        "key": "region",
        "value": staticValues.region?.value?.name,
      },
      {
        "key": "sub_region",
        "value": staticValues.subRegion?.value?.name,
      },
      {
        "key": "cluster",
        "value": staticValues.cluster?.value?.id,
      },
      {
        "key": "site_id",
        "value": staticValues.siteId?.value?.id,
      },
      {
        "key": "site_name",
        "value": staticValues.siteId?.value?.name,
      }
    ];
    //File file = await saveJsonFileLocally(jsonData);
    if (Network.isNetworkAvailable.value) {
      String? response = await AppService.sendJson(
        moduleId: model.subModuleId!,
        engineerId: user.value!.data!.id!,
        projectId: user.value!.data!.projectId!,
        json: jsonEncode(jsonData),
      );
      /*String? response = await AppService.sendJsonFile(
        moduleId: model.subModuleId!,
        projectId: user.value!.data!.projectId!,
        engineerId: user.value!.data!.id!,
        file: file,
      );*/
      if (response != null) {
        final data = jsonDecode(response);
        if (data['status'] == 200) {
          removeFromLocalStorage(
            data: null,
            moduleName: moduleName,
            subModuleName: model.subModuleName!,
          );
        } else {
          Get.rawSnackbar(
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.error,
              color: Colors.white,
            ),
            message:
                'Form with Module: ${model.subModuleName} could not be uploaded!',
          );
        }
        return data['status'];
      } else {
        return 0;
      }
    } else {
      isLocallySaved = true;
      removeFromLocalStorage(
        data: jsonData,
        moduleName: moduleName,
        subModuleName: model.subModuleName!,
      );
      return 200;
    }
    // } catch (e) {
    //   log('Exception in sendJsonFile=>HomeController: $e');
    //   return 0;
    // }
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

  Future<void> removeFromLocalStorage({
    Map<String, dynamic>? data,
    required String moduleName,
    required String subModuleName,
  }) async {
    if (data != null) {
      if (storageService.hasKey(key: offlineSavedDataKey)) {
        final List<dynamic> list = await storageService.get(
          key: offlineSavedDataKey,
        );
        list.add(data);
        //storageService.save(key: "audit", value: list.length);
        await storageService.save(
          key: offlineSavedDataKey,
          value: list,
        );
      } else {
        await storageService.save(key: offlineSavedDataKey, value: [data]);
      }
    }
    int moduleCount = storageService.get(
          key: moduleName,
        ) ??
        0;
    int subModuleCount = storageService.get(
          key: subModuleName,
        ) ??
        0;
    if (moduleCount != 0) {
      storageService.save(
        key: moduleName,
        value: --moduleCount,
      );
    }
    if (subModuleCount != 0) {
      storageService.save(
        key: subModuleName,
        value: --subModuleCount,
      );
    }
  }

}

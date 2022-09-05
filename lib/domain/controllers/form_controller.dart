import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/models/static_drop_model.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/services/image_picker_service.dart';
import 'package:site_audit/services/local_storage_keys.dart';
import 'package:site_audit/services/local_storage_service.dart';
import 'package:site_audit/services/services.dart';
import 'package:site_audit/utils/enums/enum_helper.dart';
import 'package:site_audit/utils/enums/input_type.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/utils/validator.dart';

class FormController extends GetxController {
  final loading = RxBool(false);
  final storageService = Get.find<LocalStorageService>();
  final imagePickerService = Get.find<ImagePickerService>();
  final formKey = GlobalKey<FormState>();
  String? projectId;
  Rxn<FormModel> form = Rxn();
  Rxn<StaticDropModel> staticDrops = Rxn<StaticDropModel>();
  User? user;
  Map<String, Rx<dynamic>> data = <String, Rx<dynamic>>{};
  TextEditingController siteName = TextEditingController();

  //STATIC DROPDOWNS
  List<Datum> operators = <Datum>[].obs;
  List<Region> regions = <Region>[].obs;
  List<SubRegion> subRegions = <SubRegion>[].obs;
  List<ClusterId> clusters = <ClusterId>[].obs;
  List<SiteReference> siteIDs = <SiteReference>[].obs;

  //STATIC DROPDOWNS CURRENT VALUES
  Rxn<Datum?> currentOperator = Rxn<Datum?>();
  Rxn<Region?> currentRegion = Rxn<Region?>();
  Rxn<SubRegion?> currentSubRegion = Rxn<SubRegion?>();
  Rxn<ClusterId?> currentCluster = Rxn<ClusterId?>();
  Rxn<SiteReference?> currentSite = Rxn<SiteReference?>();

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    loading.value = true;
    final userData = storageService.get(key: userKey);
    user = User.fromJson(jsonDecode(userData));
    projectId = '${user!.data!.projectId}';
    await getForms();
    await getStaticDropdowns(projectId!);
    loading.value = false;
  }

  Future<void> getForms() async {
    try {
      final arguments = Get.arguments;
      final temp = await AppService.getFormBySubModuleId(
        projectId: projectId!,
        // moduleId: 1,
        moduleId: arguments['module_id'],
      );
      if (temp != null) {
        form.value = temp;
        assignControllersToFields();
      }
    } catch (e) {
      log('Error in Forms: $e');
      Get.rawSnackbar(
        backgroundColor: Colors.red,
        message: 'Error: $e',
      );
    }
  }

  Future<void> getStaticDropdowns(String projectId) async {
    try {
      final temp = await AppService.getStaticDropdowns(projectId);
      if (temp != null) {
        staticDrops.value = temp;
        operators = staticDrops.value!.data!;
        loading.value = false;
      }
    } catch (e) {
      log('Error in Static Dropdown: $e');
      Get.rawSnackbar(
        backgroundColor: Colors.red,
        message: 'Cant get data, please check your connection',
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
          data['DROPDOWN$i'] = Rxn<dynamic>();
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

  void submit() {
    loading.value = true;
    bool validate = formKey.currentState!.validate();
    List<Items> items = form.value!.items!;
    if (validate) {
      final keys = data.keys.toList();
      for (int i = 0; i < keys.length; i++) {
        if (items[i].mandatory ?? false) {
          validate = Validator.validateField(
            data[keys[i]]!.value,
            EnumHelper.inputTypeFromString(items[i].inputType),
          );
          if (!validate) {
            break;
          }
        }
      }
    }
    if (validate) {
      log('Validated!');
      final items = form.value!.items!;
      final keys = data.keys.toList();
      for (int i = 0; i < items.length; i++) {
        final type = EnumHelper.inputTypeFromString(items[i].inputType);
        if (isTextController(type)) {
          items[i].answer = data[keys[i]]!.value.text;
        } else if (type == InputType.PHOTO) {
          final imagePath = data[keys[i]]!.value;
          if (imagePath != null && imagePath != '') {
            String base64 = covertToBase64(imagePath);
            items[i].answer = base64;
          } else {
            items[i].answer = data[keys[i]]!.value;
          }
        } else {
          items[i].answer = data[keys[i]]!.value;
        }
      }
      Map<String, String> staticValues = {
        'operator': currentOperator.value?.operator ?? '',
        'region': currentRegion.value?.name ?? '',
        'sub_region': currentSubRegion.value?.name ?? '',
        'cluster': currentCluster.value?.id ?? '',
        'site_id': currentSite.value?.id ?? '',
        'site_name': siteName.text,
      };
      form.value!.items = items;
      form.value!.staticValues = staticValues;
      // saveJsonFileLocally();
      UiUtils.showSnackBar(
        message: 'All data is validated!',
      );
      goToReviewPage();
    } else {
      log('NOT VALIDATED');
      UiUtils.showSnackBar(message: 'Please fill all the fields');
    }
    loading.value = false;
  }

  bool isTextController(InputType type) {
    if (type == InputType.TEXTBOX) {
      return true;
    } else if (type == InputType.AUTO_FILLED) {
      return true;
    } else if (type == InputType.FLOAT) {
      return true;
    } else if (type == InputType.INTEGER) {
      return true;
    } else {
      return false;
    }
  }

  String covertToBase64(String imagePath) {
    log('Hello kitty $imagePath');
    File imageFile = File(imagePath);
    List<int> bytes = imageFile.readAsBytesSync();
    final ext = imagePath.split('.').last;
    String base64 = 'data:image/$ext;base64,${base64Encode(bytes)}';
    return base64;
  }

  void goToReviewPage() {
    Future.delayed(
      const Duration(
        seconds: 2,
      ),
      () {
        Get.toNamed(AppRoutes.reviewForm);
      },
    );
    log('UPDATED: ${form.value?.toJson()}');
  }

  Future<void> saveJsonFileLocally() async {
    // final directory = await getApplicationDocumentsDirectory();
    final directory = await getExternalStorageDirectory();
    final path = directory?.path;
    File file = File('$path/data.json');
    await file.writeAsString('${form.value?.toJson()}').then((value) {
      log('File saved at: $path/data.json');
    });
  }
}

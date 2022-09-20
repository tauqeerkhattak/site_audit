import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/models/module_model.dart';
import 'package:site_audit/models/review_model.dart' as rm;
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
import 'package:site_audit/utils/widget_utils.dart';

class FormController extends GetxController {
  final loading = RxBool(false);
  final storageService = Get.find<LocalStorageService>();
  final imagePickerService = Get.find<ImagePickerService>();
  final formKey = GlobalKey<FormState>();
  final location = Location();
  LocationData? locationData;
  String? projectId;
  Rxn<FormModel> form = Rxn();
  Module? module;
  SubModule? subModule;
  Rxn<StaticDropModel> staticDrops = Rxn<StaticDropModel>();
  User? user;
  Map<String, Rx<dynamic>> data = <String, Rx<dynamic>>{};
  TextEditingController siteName = TextEditingController();
  ScreenshotController controller = ScreenshotController();

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
    locationData = await location.getLocation();
    await getForms();
    await getStaticDropdowns(projectId!);
    fillForm();
    loading.value = false;
  }

  Future<void> getForms() async {
    try {
      final arguments = Get.arguments;
      subModule = arguments['subModule'];
      module = arguments['module'];
      final temp = await AppService.getFormBySubModuleId(
        projectId: projectId!,
        // moduleId: 1,
        moduleId: subModule!.subModuleId!,
      );
      if (temp != null) {
        form.value = temp;
        assignControllersToFields();
      }
    } catch (e) {
      log('Error in Forms: $e');
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

  Future<void> submit() async {
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
            if (imagePath.contains('base64')) {
              items[i].answer = imagePath;
            } else {
              saveImageToGallery(File(imagePath));
              String base64 = covertToBase64(imagePath);
              items[i].answer = base64;
            }
          } else {
            items[i].answer = data[keys[i]]!.value;
          }
        } else {
          items[i].answer = data[keys[i]]!.value;
        }
      }
      Map<String, dynamic> staticValues = {
        'operator': {
          'value': currentOperator.value,
          'items': operators,
        },
        'region': {
          'value': currentRegion.value,
          'items': regions,
        },
        'sub_region': {
          'value': currentSubRegion.value,
          'items': subRegions,
        },
        'cluster': {
          'value': currentCluster.value,
          'items': clusters,
        },
        'site_id': {
          'value': currentSite.value,
          'items': siteIDs,
        },
        'site_name': siteName.text,
      };
      form.value!.items = items;
      form.value!.staticValues = jsonEncode(staticValues);
      // saveJsonFileLocally();
      UiUtils.showSnackBar(
        message: 'All data is validated!',
      );
      await saveDataToLocalStorage();
      Get.offNamedUntil(AppRoutes.home, (route) => false);
    } else {
      log('NOT VALIDATED');
      UiUtils.showSnackBar(message: 'Please fill all the fields');
    }
    loading.value = false;
  }

  String getImageName(DateTime now) {
    DateFormat format = DateFormat('yyyy-MM-dd_hh-mm-ss');
    final projectId = user?.data?.projectId;
    final siteId = currentSite.value?.id;
    final engineerId = user?.data?.auditTeamId;
    final fieldId = form.value?.items?.first.designRef;
    final date = format.format(now);
    final name = '${projectId}_${siteId}_${engineerId}_${fieldId}_$date';
    log('Date: $name');
    return name;
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
    File imageFile = File(imagePath);
    List<int> bytes = imageFile.readAsBytesSync();
    final ext = imagePath.split('.').last;
    String base64 = 'data:image/$ext;base64,${base64Encode(bytes)}';
    return base64;
  }

  Future<void> goToReviewPage() async {
    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
      () {
        Get.toNamed(
          AppRoutes.review,
          arguments: {
            'form_name': form.value!.items!.first.modules!.description,
            'form': form.value!.toJson(),
          },
        );
      },
    );
  }

  Future<void> saveDataToLocalStorage() async {
    final moduleName = module!.moduleName!;
    final subModuleName = subModule!.subModuleName!;
    final key = '$moduleName >> $subModuleName';
    form.value!.moduleName = moduleName;
    if (storageService.hasKey(key: key)) {
      List<dynamic> formData = storageService.get(key: key);
      final moduleCount = storageService.get(key: moduleName);
      final subModuleCount = storageService.get(key: subModuleName);
      if (Get.arguments['reviewForm'] != null) {
        formData = [form.value!.toJson()];
        await storageService.save(key: moduleName, value: moduleCount);
        await storageService.save(key: subModuleName, value: subModuleCount);
      } else {
        formData.add(form.value!.toJson());
        await storageService.save(key: moduleName, value: moduleCount + 1);
        await storageService.save(
            key: subModuleName, value: subModuleCount + 1);
      }
      await storageService.save(key: key, value: formData);
    } else {
      await storageService
          .save(key: key, value: <dynamic>[form.value!.toJson()]);
      if (storageService.hasKey(key: moduleName)) {
        final moduleCount = storageService.get(key: moduleName);
        await storageService.save(key: moduleName, value: moduleCount + 1);
      } else {
        await storageService.save(key: moduleName, value: 1);
      }
      await storageService.save(key: subModuleName, value: 1);
    }
  }

  Future<void> saveImageToGallery(File image) async {
    final time = DateTime.now();

    Uint8List imageData = await controller.captureFromWidget(
      WidgetUtils.imageWidget(
        image: image,
        lat: locationData!.latitude!,
        long: locationData!.longitude!,
        dateTime: time,
      ),
      context: Get.context,
      delay: const Duration(
        seconds: 3,
      ),
    );
    final directory = await getTemporaryDirectory();
    final ext = image.path.split('.').last;
    File file = await File(
      '${directory.path}/${getImageName(time)}.$ext',
    ).create();
    file.writeAsBytesSync(imageData);

    await GallerySaver.saveImage(
      file.path,
      albumName: 'SiteAudit',
    );
    try {} catch (e) {
      UiUtils.showSnackBar(message: 'EXCEPTION IN SAVING IMAGE: $e');
    }
  }

  Future<void> fillForm() async {
    final arguments = Get.arguments;
    if (arguments['reviewForm'] != null) {
      final rm.ReviewModel model = arguments['reviewForm'];

      // Static Dropdowns
      currentOperator.value = model.staticValues?.operator?.value;
      currentRegion.value = model.staticValues?.region?.value;
      regions = model.staticValues?.region?.items ?? [];
      currentSubRegion.value = model.staticValues?.subRegion?.value;
      subRegions = model.staticValues?.subRegion?.items ?? [];
      currentCluster.value = model.staticValues?.cluster?.value;
      clusters = model.staticValues?.cluster?.items ?? [];
      currentSite.value = model.staticValues?.siteId?.value;
      siteIDs = model.staticValues?.siteId?.items ?? [];
      siteName.text = currentSite.value?.name ?? '';

      //Dynamic Data
      List<Items> items = form.value!.items!;
      for (int i = 0; i < items.length; i++) {
        Items item = items[i];
        final type = EnumHelper.inputTypeFromString(item.inputType!);
        switch (type) {
          case InputType.DROPDOWN:
            data['DROPDOWN$i']!.value = model.items?[i].answer;
            break;
          case InputType.AUTO_FILLED:
            data['AUTOFILLED$i']!.value = TextEditingController(
              text: model.items?[i].answer,
            );
            break;
          case InputType.TEXTBOX:
            data['TEXTBOX$i']!.value = TextEditingController(
              text: model.items?[i].answer,
            );
            break;
          case InputType.INTEGER:
            data['INTEGER$i']!.value = TextEditingController(
              text: model.items?[i].answer,
            );
            break;
          case InputType.PHOTO:
            String? answer = model.items?[i].answer;
            if (answer != null) {
              data['PHOTO$i']!.value = answer;
              break;
            } else {
              break;
            }
          case InputType.RADIAL:
            data['RADIAL$i']!.value = model.items?[i].answer;
            break;
          case InputType.FLOAT:
            data['FLOAT$i']!.value = TextEditingController(
              text: model.items?[i].answer,
            );
            break;
        }
      }
    } else {
      log('No forms to review!');
    }
  }
}

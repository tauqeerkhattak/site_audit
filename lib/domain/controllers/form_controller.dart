import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/models/module_model.dart';
import 'package:site_audit/models/static_drop_model.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/services/image_picker_service.dart';
import 'package:site_audit/services/local_storage_keys.dart';
import 'package:site_audit/services/local_storage_service.dart';
import 'package:site_audit/utils/enums/enum_helper.dart';
import 'package:site_audit/utils/enums/input_type.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/utils/validator.dart';
import 'package:site_audit/utils/widget_utils.dart';

import '../../models/static_values.dart';

class FormController extends GetxController {
  final loading = RxBool(false);
  final storageService = Get.find<LocalStorageService>();
  final imagePickerService = Get.find<ImagePickerService>();
  final formDataKey = GlobalKey<FormState>();
  final location = Location();
  Rxn<String> formName = Rxn<String>();
  LocationData? locationData;
  String? projectId;
  Rxn<FormModel> form = Rxn();
  Module? module;
  SubModule? subModule;
  Rxn<StaticDropModel> staticDrops = Rxn<StaticDropModel>();
  User? user;
  Map<String, dynamic> data = <String, dynamic>{};
  TextEditingController siteName = TextEditingController();
  ScreenshotController controller = ScreenshotController();

  List<Items> multiLevels = [];
  List<Rxn<int>> optionIndex = [];

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

    loading.value = false;
  }

  Future<void> getForms() async {
    try {
      final arguments = Get.arguments;
      subModule = arguments['subModule'];
      module = arguments['module'];
      formName.value = arguments['formName'];
      final key0 = '$formKey$projectId${subModule?.subModuleId}';
      final storedData = storageService.get(key: key0);
      final forms = jsonDecode(storedData);
      FormModel temp = FormModel.fromJson(forms[0]);
      processMultiLevel(temp);
      temp.items?.removeWhere((element) {
        return element.inputType == 'MULTILEVEL';
      });
      form.value = temp;
      await assignControllersToFields();
      fillForm();
    } catch (e) {
      log('Error in Forms: $e');
      return;
    }
  }

  void processMultiLevel(FormModel model) {
    for (final item in model.items!) {
      InputType type = InputType.values.byName(item.inputType!);
      if (type == InputType.MULTILEVEL) {
        multiLevels.add(item);
      }
    }
    data['MULTILEVEL'] = List.generate(
      multiLevels.length,
      (index) {
        return Rxn<String>();
      },
    );
    optionIndex = List.generate(multiLevels.length, (index) {
      return Rxn(index == 0 ? 0 : null);
    });
  }

  Future<void> getStaticDropdowns(String projectId) async {
    try {
      final data = storageService.get(key: staticValueKey);
      final temp = StaticDropModel.fromJson(jsonDecode(data));
      staticDrops.value = temp;
      operators = staticDrops.value!.data!;
      loading.value = false;
    } catch (e) {
      log('Error in Static Dropdown: $e');
    }
  }

  ///
  /// Assigns controllers to each type of fields.
  ///
  Future<void> assignControllersToFields() async {
    final fields = form.value!.items!;
    final now = DateTime.now();
    for (int i = 0; i < fields.length; i++) {
      final item = fields[i];
      InputType type = EnumHelper.inputTypeFromString(item.inputType);
      switch (type) {
        case InputType.DROPDOWN:
          data['DROPDOWN$i'] = Rxn<dynamic>();
          break;
        case InputType.INTEGER:
          data['INTEGER$i'] = TextEditingController().obs;
          break;
        case InputType.PHOTO:
          data['PHOTO$i'] = ''.obs;
          break;
        case InputType.RADIAL:
          data['RADIAL$i'] = item.inputOption!.first.inputOptions!.first.obs;
          break;
        case InputType.FLOAT:
          data['FLOAT$i'] = TextEditingController().obs;
          break;
        case InputType.LOCATION:
          final lat = locationData?.latitude;
          final long = locationData?.longitude;
          data['LOCATION$i'] = Rx(
            [
              TextEditingController(
                text: '$lat',
              ),
              TextEditingController(
                text: '$long',
              ),
            ],
          );
          break;
        case InputType.DATE_TIME:
          data['DATETIME$i'] = now.toString().obs;
          break;
        case InputType.DATE:
          data['DATE$i'] = now.toString().obs;
          break;
        case InputType.TIME:
          data['TIME$i'] = TimeOfDay.now().obs;
          break;
        case InputType.TEXT:
          data['TEXT$i'] = TextEditingController().obs;
          break;
        case InputType.TEXTBOX:
          data['TEXTBOX$i'] = TextEditingController().obs;
          break;
        case InputType.TEXT_AREA:
          data['TEXTAREA$i'] = TextEditingController().obs;
          break;
        case InputType.MULTILEVEL:
          break;
      }
    }
  }

  ///
  /// For testing use this method
  ///
  // Future<void> assignControllersToFields() async {
  //   final fields = form.value!.items!;
  //   for (int i = 0; i < fields.length; i++) {
  //     final item = fields[i];
  //     InputType type = EnumHelper.inputTypeFromString(item.inputType);
  //     switch (type) {
  //       case InputType.DROPDOWN:
  //         data['DROPDOWN$i'] = Rxn<dynamic>();
  //         break;
  //       case InputType.AUTO_FILLED:
  //         data['AUTOFILLED$i'] = TextEditingController(text: 'AUTO-FILLED').obs;
  //         break;
  //       case InputType.TEXTBOX:
  //         data['TEXTBOX$i'] = TextEditingController(text: 'TEXTBOX').obs;
  //         break;
  //       case InputType.INTEGER:
  //         data['INTEGER$i'] = TextEditingController(text: '123456').obs;
  //         break;
  //       case InputType.PHOTO:
  //         final photo = await rootBundle
  //             .load('assets/images/istockphoto-1184778656-612x612.jpg');
  //         final byteData = photo.buffer.asUint8List();
  //         final dir = await getApplicationDocumentsDirectory();
  //         final file = await File('${dir.path}/image.jpg').create();
  //         await file.writeAsBytes(byteData);
  //         data['PHOTO$i'] = file.path.obs;
  //         break;
  //       case InputType.RADIAL:
  //         data['RADIAL$i'] = item.inputOption!.inputOptions!.first.obs;
  //         break;
  //       case InputType.FLOAT:
  //         data['FLOAT$i'] = TextEditingController(text: '1234.567').obs;
  //         break;
  //     }
  //   }
  // }

  Future<void> submit(BuildContext context) async {
    loading.value = true;
    bool validate = formDataKey.currentState!.validate();
    List<Items> items = form.value!.items!;
    if (validate) {
      final keys = data.keys.toList();
      for (int i = 0; i < items.length; i++) {
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
      List<Items> items = form.value!.items!;
      final keys = data.keys.toList();
      for (int i = 0; i < items.length; i++) {
        final type = EnumHelper.inputTypeFromString(items[i].inputType);
        if (isTextController(type)) {
          final controller = data[keys[i]]!.value;
          items[i].answer = controller.text;
        } else if (type == InputType.PHOTO) {
          final imagePath = data[keys[i]]!.value;
          if (imagePath != null && imagePath != '') {
            if (imagePath.contains('base64')) {
              items[i].answer = imagePath;
            } else {
              // saveImageToGallery(File(imagePath));
              String base64 = covertToBase64(imagePath);
              items[i].answer = base64;
            }
          } else {
            items[i].answer = data[keys[i]]!.value;
          }
        } else if (type == InputType.LOCATION) {
          String answer = '';
          final controllers = data[keys[i]]!.value;
          for (final controller in controllers) {
            answer += '${controller.text} ';
          }
          items[i].answer = answer;
        } else if (type == InputType.TIME) {
          final timeOfDay = data[keys[i]]!.value as TimeOfDay;
          items[i].answer = timeOfDay.format(Get.context!);
        } else {
          items[i].answer = data[keys[i]]!.value.toString();
        }
      }
      Map<String, dynamic> staticValues = {
        'operator': {
          'value': currentOperator.value?.toJson(),
          'items': operators.map((e) => e.toJson()).toList(),
        },
        'region': {
          'value': currentRegion.value?.toJson(),
          'items': regions.map((e) => e.toJson()).toList(),
        },
        'sub_region': {
          'value': currentSubRegion.value?.toJson(),
          'items': subRegions.map((e) => e.toJson()).toList(),
        },
        'cluster': {
          'value': currentCluster.value?.toJson(),
          'items': clusters.map((e) => e.toJson()).toList(),
        },
        'site_id': {
          'value': currentSite.value?.toJson(),
          'items': siteIDs.map((e) => e.toJson()).toList(),
        },
        'site_name': siteName.text,
      };
      for (int i = 0; i < multiLevels.length; i++) {
        multiLevels[i].answer = data['MULTILEVEL'][i];
        form.value!.items!.add(multiLevels[i]);
      }
      form.value!.items = items;
      form.value!.staticValues = staticValues;
      log("SATANIC: $staticValues");
      // saveJsonFileLocally();
      await saveDataToLocalStorage().then((value) {
        UiUtils.showSnackBar(
          message: 'Data is submitted successfully!',
        );
        Navigator.pop(context, 'popped');
      });
      // Get.offNamedUntil(
      //   AppRoutes.home,
      //   (route) => false,
      // );
      // Get.back(closeOverlays: true);
      // Get.offNamedUntil(AppRoutes.home, (route) => false);
    } else {
      log('NOT VALIDATED');
      UiUtils.showSnackBar(
        message: 'Please fill all the fields',
        color: Theme.of(Get.context!).errorColor,
      );
    }
    loading.value = false;
  }

  String getImageName(DateTime now) {
    DateFormat format = DateFormat('yyyy-MM-dd_hh-mm-ss');
    final projectId = user?.data?.projectId;
    final siteId = currentSite.value?.id;
    final engineerId = user?.data?.auditTeamId;
    final fieldId = form.value?.items?.first.id;
    final date = format.format(now);
    final name = '${projectId}_${siteId}_${engineerId}_${fieldId}_$date';
    return name;
  }

  bool isTextController(InputType type) {
    if (type == InputType.TEXT) {
      return true;
    } else if (type == InputType.TEXT_AREA) {
      return true;
    } else if (type == InputType.TEXTBOX) {
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
    final filename = getImageName(DateTime.now());
    String base64 =
        'data:image/filename:$filename.$ext;base64,${base64Encode(bytes)}';
    return base64;
  }

  Future<void> goToReviewPage() async {
    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
      () {
        final moduleName = module!.moduleName!;
        final subModuleName = subModule!.subModuleName!;
        Get.toNamed(
          AppRoutes.review,
          arguments: {
            'form_name': '$moduleName >> $subModuleName',
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
        final deleteIndex = Get.arguments['reviewFormIndex'];
        formData.removeAt(deleteIndex);
        formData.add(form.value!.toJson());
        // await storageService.save(key: moduleName, value: moduleCount);
        // await storageService.save(key: subModuleName, value: subModuleCount);
      } else {
        formData.add(form.value!.toJson());
        await storageService.save(
          key: moduleName,
          value: moduleCount + 1,
        );
        await storageService.save(
          key: subModuleName,
          value: subModuleCount + 1,
        );
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
    try {
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
    } catch (e) {
      UiUtils.showSnackBar(message: 'EXCEPTION IN SAVING IMAGE: $e');
    }
  }

  Future<void> fillForm() async {
    final arguments = Get.arguments;
    if (arguments['reviewForm'] != null) {
      final FormModel model = arguments['reviewForm'];

      StaticValues staticValues = StaticValues.fromJson(model.staticValues!);

      // Static Dropdowns
      currentOperator.value = staticValues.operator?.value;
      currentRegion.value = staticValues.region?.value;
      regions = staticValues.region?.items ?? [];
      currentSubRegion.value = staticValues.subRegion?.value;
      subRegions = staticValues.subRegion?.items ?? [];
      currentCluster.value = staticValues.cluster?.value;
      clusters = staticValues.cluster?.items ?? [];
      currentSite.value = staticValues.siteId?.value;
      siteIDs = staticValues.siteId?.items ?? [];
      siteName.text = currentSite.value?.name ?? '';

      //Dynamic Data
      List<Items> items = model.items!;
      for (int i = 0; i < items.length; i++) {
        Items item = items[i];
        final type = EnumHelper.inputTypeFromString(item.inputType!);
        switch (type) {
          case InputType.DROPDOWN:
            data['DROPDOWN$i']!.value = item.answer;
            break;
          case InputType.TEXT:
            data['TEXT$i']!.value = TextEditingController(
              text: model.items?[i].answer,
            );
            break;
          case InputType.TEXT_AREA:
            data['TEXTAREA$i']!.value = TextEditingController(
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
          case InputType.LOCATION:
            final answer = model.items?[i].answer?.split(' ');
            data['LOCATION$i']!.value = List.generate(
              answer?.length ?? 0,
              (index) {
                return TextEditingController(text: answer?[index]);
              },
            );
            break;
          case InputType.DATE_TIME:
            data['DATETIME$i']!.value = model.items?[i].answer ?? '';
            break;
          case InputType.DATE:
            data['DATE$i']!.value = model.items?[i].answer;
            break;
          case InputType.TIME:
            final time = model.items?[i].answer;
            final list = time!.split(':');
            data['TIME$i']!.value = TimeOfDay(
              hour: int.tryParse(list[0]) ?? 0,
              minute: int.tryParse(list[1]) ?? 0,
            );
            break;
          case InputType.TEXTBOX:
            data['TEXTBOX$i']?.value = TextEditingController(
              text: model.items?[i].answer,
            );
            break;
        }
      }
    } else {
      log('No form to review');
    }
  }
}

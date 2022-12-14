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
import 'package:site_audit/models/DataBaseModel.dart';
import 'package:site_audit/models/photos.dart';
import 'package:site_audit/offlineDatabase/database.dart';
import '../../models/form_model.dart';
import '../../models/module_model.dart';
import '../../models/user_model.dart';
import '../../routes/routes.dart';
import '../../services/image_picker_service.dart';
import '../../services/local_storage_keys.dart';
import '../../services/local_storage_service.dart';
import '../../utils/enums/enum_helper.dart';
import '../../utils/enums/input_type.dart';
import '../../utils/ui_utils.dart';
import '../../utils/validator.dart';
import '../../utils/widget_utils.dart';

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
  User? user;
  Map<String, dynamic> data = <String, dynamic>{};
  ScreenshotController controller = ScreenshotController();

  // List<Items> multiLevels = [];
  Map<int, List<Items>> multiLevels = <int, List<Items>>{};
  Map<int, List<Rxn<int>>> optionIndex = <int, List<Rxn<int>>>{};

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
    loading.value = false;
  }

  Future<void> getForms() async {
    final arguments = Get.arguments;
    subModule = arguments['subModule'];
    module = arguments['module'];
    formName.value = arguments['formName'];
    final key0 = '$formKey$projectId${subModule?.subModuleId}';
    final storedData = storageService.get(key: key0);
    print('$key0 key0');
    List<String> keys = await storageService.getAllKeys();
    print('$keys keys');
    final forms = jsonDecode(storedData);
    form.value = FormModel.fromJson(forms[0]);
    processMultiLevel(form.value!);
    await assignControllersToFields();
    fillForm();
  }
  // catch (e) {
  //   log('Error in Forms: $e');
  //   return;
  // }

  void processMultiLevel(FormModel model) {
    List<Items> temp = model.items!.where((element) {
      return element.inputType == 'MULTILEVEL';
    }).toList();
    for (int i = 0; i < temp.length; i++) {
      List<Items> items = <Items>[];
      final item = temp[i];
      InputType type = InputType.values.byName(item.inputType!);
      if (type == InputType.MULTILEVEL) {
        if (item.parentInputId == 0) {
          int thisID = item.id!;
          // int thisPID = item.parentInputId!;
          items.add(item);
          while (true) {
            final nextItem = model.items!.firstWhereOrNull(
              (element) {
                return element.parentInputId == thisID;
              },
            );
            if (nextItem != null) {
              items.add(nextItem);
              thisID = nextItem.id!;
            } else {
              break;
            }
          }
        }
        multiLevels[i] = items;
        for (final item in items) {
          form.value!.items!.remove(item);
        }
      }
    }
    int length = multiLevels.keys.length;
    Map<int, List<Rxn<String>>> values = <int, List<Rxn<String>>>{};
    Map<int, List<Rxn<int>>> optionValues = <int, List<Rxn<int>>>{};
    for (int i = 0; i < length; i++) {
      values[i] = List.generate(
        multiLevels[i]?.length ?? 0,
        (index) {
          return Rxn<String>();
        },
      );
    }
    for (int i = 0; i < length; i++) {
      optionValues[i] = List.generate(
        multiLevels[i]?.length ?? 0,
        (index) {
          return Rxn<int>(index == 0 ? 0 : null);
        },
      );
    }
    data['MULTILEVEL'] = values;
    optionIndex = optionValues;
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
          data['DROPDOWN$i'] = Rxn<String?>();
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

  Future<void> submit(BuildContext context) async {
    String? path;
    loading.value = true;
    bool validate = formDataKey.currentState!.validate();
    List<Items> items = form.value!.items!;
    final keys = data.keys.where((element) {
      return element != 'MULTILEVEL';
    }).toList();
    if (validate) {
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
      for (int i = 0; i < items.length; i++) {
        final type = EnumHelper.inputTypeFromString(items[i].inputType);
        if (isTextController(type)) {
          final controller = data[keys[i]]!.value;
          items[i].answer = controller.text;
        } else if (type == InputType.PHOTO) {
          //path = data[keys[i]]!.value;
          final imagePath = data[keys[i]]!.value;
          if (imagePath != null && imagePath != '') {
            if (imagePath.contains('base64')) {
              items[i].answer = imagePath;
            } else {
              File? file = await saveImageToGallery(imagePath);
              //File? file = File(imagePath);
              if (file != null) {
                /// TODO
                String base64 = covertToBase64(file.path);
                //String base64 = file.path;
                items[i].filename = getFileName(file.path);
                items[i].answer = base64;
              } else {
                ///TODO
                String base64 = covertToBase64(imagePath);
                //String base64 = imagePath;
                items[i].filename = getFileName(imagePath);
                items[i].answer = base64;
              }
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
          if (keys[i] != InputType.MULTILEVEL.name) {
            items[i].answer = data[keys[i]]!.value.toString();
          }
        }
      }
      Map<String, dynamic> staticValues = storageService.get(
        key: siteDataStorageKey,
      );
      for (int cIndex = 0; cIndex < multiLevels.keys.length; cIndex++) {
        final List<Items> multiLevelItems = multiLevels[cIndex] ?? [];
        for (int gIndex = 0; gIndex < multiLevelItems.length; gIndex++) {
          final Items item = multiLevelItems[gIndex];
          item.answer = data['MULTILEVEL'][cIndex][gIndex].value;
          form.value!.items!.add(item);
        }
      }
      // for (int i = 0; i < multiLevels.length; i++) {
      // multiLevels[i].answer = data['MULTILEVEL'][i].value;
      // form.value!.items!.add(multiLevels[i]);
      // }
      form.value!.items = items;
      form.value!.staticValues = staticValues;
      List<DataBaseItem> dataBaseItem1 = [];
      DatabaseDb databaseDb = DatabaseDb();
      DataBaseModel dataBaseModel = DataBaseModel(
        1,
        form.value!.subModuleId,
        form.value!.subModuleName,
        form.value!.moduleName,
        form.value!.projectId,
        dataBaseItem1,
      );

      // DataBaseItem? dataBaseItem;
      // DataBaseInputOption? dataBaseInputOption;
      // if(form.value!.items!.isNotEmpty){
      //   for (var element in form.value!.items!) {
      //      dataBaseItem = DataBaseItem(
      //       1,
      //       //element.mandatory,
      //       element.inputDescription,
      //       element.answer,
      //       element.inputType,
      //       element.inputParameter,
      //       element.inputLength,
      //       element.inputHint,
      //       element.parentInputId,
      //       element.filename,
      //       element.inputLabel,
      //      // dataBaseInputOption,
      //     ) ;
      //      dataBaseItem1.add(dataBaseItem);
      //     if(element.inputOption != null){
      //       for (var element in element.inputOption!) {
      //          dataBaseInputOption = DataBaseInputOption(
      //           element.inputItemParentId,
      //           element.inputParentLevel,
      //           element.inputOptions,
      //         );
      //       }

      //     }

      //   }
      // }
      // databaseDb.save(dataBaseModel, dataBaseItem1, dataBaseInputOption!);

      int counter = 1;
      int value = storageService.get(key: "FormIndex") ?? 0;
      if (value == 0) {
        storageService.save(key: "FormIndex", value: counter++);
      } else {
        int newValue = value + 1;
        storageService.save(key: "FormIndex", value: newValue);
      }

      Navigator.pop(context, 'popped');

      // saveJsonFileLocally();
      await saveDataToLocalStorage().then((value) {
        UiUtils.showSnackBar(
          message: 'Data is submitted successfully!',
        );
        Navigator.pop(context, 'popped');
      });
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
    const siteId = 01;
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

  String getFileName(String imagePath) {
    File imageFile = File(imagePath);
    List<int> bytes = imageFile.readAsBytesSync();
    final ext = imagePath.split('.').last;
    final filename = getImageName(DateTime.now());
    return '$filename.$ext';
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

    //  TODO: remaining work
    final siteNameKey = form.value!.staticValues!['site_name'];

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

  Future<File?> saveImageToGallery(String imagePath) async {
    try {
      final time = DateTime.now();
      File image = File(imagePath);
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
      return file;
    } catch (e) {
      UiUtils.showSnackBar(message: 'EXCEPTION IN SAVING IMAGE: $e');
      print(e);
      return null;
    }
  }

  Future<void> fillForm() async {
    final arguments = Get.arguments;
    if (arguments['reviewForm'] != null) {
      form.value = arguments['reviewForm'];
      List<Items> temp = [];

      //Dynamic Data
      List<Items> items = form.value!.items!;
      processMultiLevel(form.value!);

      for (int i = 0; i < items.length; i++) {
        Items item = items[i];
        final type = EnumHelper.inputTypeFromString(item.inputType!);
        switch (type) {
          case InputType.DROPDOWN:
            data['DROPDOWN$i']!.value = item.answer;
            break;
          case InputType.TEXT:
            data['TEXT$i']!.value = TextEditingController(
              text: form.value!.items?[i].answer,
            );
            break;
          case InputType.TEXT_AREA:
            data['TEXTAREA$i']!.value = TextEditingController(
              text: form.value!.items?[i].answer,
            );
            break;
          case InputType.INTEGER:
            data['INTEGER$i']!.value = TextEditingController(
              text: form.value!.items?[i].answer,
            );
            break;
          case InputType.PHOTO:
            String? answer = form.value!.items?[i].answer;
            if (answer != null) {
              data['PHOTO$i']!.value = answer;
              break;
            } else {
              break;
            }
          case InputType.RADIAL:
            data['RADIAL$i']!.value = form.value!.items?[i].answer;
            break;
          case InputType.FLOAT:
            data['FLOAT$i']!.value = TextEditingController(
              text: form.value!.items?[i].answer,
            );
            break;
          case InputType.LOCATION:
            final answer = form.value!.items?[i].answer?.split(' ');
            data['LOCATION$i']!.value = List.generate(
              answer?.length ?? 0,
              (index) {
                return TextEditingController(text: answer?[index]);
              },
            );
            break;
          case InputType.DATE_TIME:
            data['DATETIME$i']!.value = form.value!.items?[i].answer ?? '';
            break;
          case InputType.DATE:
            data['DATE$i']!.value = form.value!.items?[i].answer;
            break;
          case InputType.TIME:
            final time = form.value!.items?[i].answer;
            final list = time!.split(':');
            data['TIME$i']!.value = TimeOfDay(
              hour: int.tryParse(list[0]) ?? 0,
              minute: int.tryParse(list[1]) ?? 0,
            );
            break;
          case InputType.TEXTBOX:
            data['TEXTBOX$i']?.value = TextEditingController(
              text: form.value!.items?[i].answer,
            );
            break;
          case InputType.MULTILEVEL:
            temp.add(item);
            break;
        }
      }

      for (int c = 0; c < multiLevels.keys.length; c++) {
        List<Items> items = multiLevels[c]!;
        log('LENGTH: ${items.length} ${multiLevels.keys.length}');
        for (int g = 0; g < items.length; g++) {
          final answer = items[g].answer;
          data['MULTILEVEL'][c][g].value = answer;
          for (int j = 0; j < items[g].inputOption!.length; j++) {
            try {
              InputOption ip = items[g].inputOption![j];
              if (ip.inputOptions!.contains(answer)) {
                final answerIndex = ip.inputOptions!.indexOf(answer!);
                optionIndex[c]?[g + 1].value = answerIndex;
                break;
              }
            } catch (e) {
              log('Error: $e');
            }
          }
        }
      }
      // for (int i = 0; i < temp.length; i++) {
      //   // final multiLevelItem = multiLevels[i];
      //   final answer = temp[i].answer;
      //   // multiLevels[i].answer = answer;
      //   data['MULTILEVEL'][i].value = answer;
      //   for (int j = 0; j < multiLevels[i].inputOption!.length; j++) {
      //     InputOption ip = multiLevels[i].inputOption![j];
      //     if (ip.inputOptions!.contains(answer)) {
      //       final answerIndex = ip.inputOptions!.indexOf(answer!);
      //       log('YES ANSWER EXIST $answerIndex');
      //       optionIndex[i + 1].value = answerIndex;
      //       break;
      //     }
      //   }
      // }
    } else {
      log('No form to review');
    }
  }
}

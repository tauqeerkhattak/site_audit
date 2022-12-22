import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/models/static_drop_model.dart';
import 'package:site_audit/offlineDatabase/database.dart';
import 'package:site_audit/services/local_storage_service.dart';

import '../../models/module_model.dart';
import '../../models/static_values.dart';
import '../../routes/routes.dart';

class ReviewController extends GetxController {
  RxBool loading = true.obs;
  final storageService = Get.find<LocalStorageService>();
  RxString formName = RxString('');
  FormModel? formItem;
  Module? module;
  SubModule? subModule;
  int subModuleId = 0;
  Rxn<List<dynamic>> formItems = Rxn(<dynamic>[]);
  int? index = 0;

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
  TextEditingController siteNameController = TextEditingController();
  DatabaseDb? dbHelper;
  @override
  void onInit() {
    super.onInit();
    dbHelper = DatabaseDb();
    // loadsqfData();
    setData();
    //index = storageService.get(key: "FormIndex");
  }

  Future<void> onCardTap(int item) async {
    log('ITEM: $item');
    final rows = await dbHelper!.getFormByFormId(
      formId: item,
    );
    if (rows.isNotEmpty) {
      FormModel temp = FormModel();
      List<Items> items = [];
      for (final row in rows) {
        Items singleItem = Items.fromJson(row);
        if (singleItem.inputOptionId != null) {
          final inputOption = await dbHelper!.getInputOptionsFromId(
            singleItem.inputOptionId!,
          );
          String options = inputOption['input_option'];
          final splitted =
              options.replaceAll('[', '').replaceAll(']', '').split(',');
          singleItem.inputOption = [
            InputOption(
              inputItemParentId: inputOption['input_item_parent_id'],
              inputParentLevel: inputOption['input_parent_level'],
              inputOptions: splitted,
            ),
          ];
        }
        if (singleItem.inputOption?.isNotEmpty ?? false) {
          log('ANSWER: ${singleItem.answer} ${singleItem.inputOption!.first.inputOptions.toString()}');
        }
        items.add(singleItem);
      }
      temp.items = items;
      temp.subModuleId = rows.first['sub_module_id'];
      temp.projectId = rows.first['project_id'];
      temp.subModuleName = subModule?.subModuleName;
      temp.moduleName = module?.moduleName;
      Get.toNamed(
        AppRoutes.form,
        arguments: {
          'module': module,
          'subModule': subModule,
          'reviewFormIndex': index,
          'reviewForm': temp,
          // 'formName': controller.formName.value,
        },
      );
      refreshPage();
      setData();
    }
  }

  // Future<Map<String, List<dynamic>>> getData() async {
  //   Map<String, List<dynamic>> forms = {};
  //   List<dynamic> temp = await sqfLiteData!;
  //   List<dynamic> list = List.of(temp);
  //   int i = 0;
  //
  //   while (list.isNotEmpty) {
  //     final formId = list[i]['form_id'];
  //
  //     final items = list.where((item) {
  //       return item['form_id'] == formId;
  //     }).toList();
  //
  //     if (items.isNotEmpty) {
  //       forms.addAll({'formNumber$i': items});
  //       i++;
  //     }
  //     list.removeWhere((element) {
  //       return element['formID'] == formId;
  //     });
  //   }
  //   log('LENGTH: ${forms.values.length}');
  //
  //   return forms;
  // }

  void refreshPage() {
    final arguments = Get.arguments;
    module = arguments['module'];
    subModule = arguments['subModule'];
    formItems.value = storageService.get(
      key: '${module!.moduleName} >> ${subModule!.subModuleName}',
    );
    refresh();
  }

  void setData() {
    final arguments = Get.arguments;
    module = arguments['module'];
    subModule = arguments['subModule'];
    formName.value = '${module!.moduleName} >> ${subModule!.subModuleName}';
    subModuleId = subModule!.subModuleId!;
    formItems.value = storageService.get(key: formName.value);
    StaticValues? value = formItem?.staticValues != null
        ? StaticValues.fromJson(formItem!.staticValues!)
        : null;

    //Set Dropdowns
    currentOperator.value = value?.operator?.value;
    operators = value?.operator?.items ?? [];

    currentRegion.value = value?.region?.value;
    regions = value?.region?.items ?? [];

    currentSubRegion.value = value?.subRegion?.value;
    subRegions = value?.subRegion?.items ?? [];

    currentCluster.value = value?.cluster?.value;
    clusters = value?.cluster?.items ?? [];

    currentSite.value = value?.siteId?.value;
    siteIDs = value?.siteId?.items ?? [];

    siteNameController = TextEditingController(text: currentSite.value?.name);

    loading.value = false;
  }
}

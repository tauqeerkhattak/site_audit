import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/models/static_drop_model.dart';
import 'package:site_audit/services/local_storage_service.dart';

import '../../models/module_model.dart';
import '../../models/static_values.dart';

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

  @override
  void onInit() {
    super.onInit();
    setData();
    //index = storageService.get(key: "FormIndex");
  }

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

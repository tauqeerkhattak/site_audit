import 'package:get/get.dart';
import 'package:site_audit/models/module_model.dart';
import 'package:site_audit/models/review_model.dart';
import 'package:site_audit/models/static_drop_model.dart';
import 'package:site_audit/services/local_storage_service.dart';

class ReviewController extends GetxController {
  RxBool loading = true.obs;
  final storageService = Get.find<LocalStorageService>();
  RxString formName = RxString('');
  ReviewModel? formItem;
  Module? module;
  SubModule? subModule;
  int subModuleId = 0;
  List<dynamic>? formItems = [];

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
    setData();
  }

  void setData() {
    final arguments = Get.arguments;
    module = arguments['module'];
    subModule = arguments['subModule'];
    formName.value = '${module!.moduleName} >> ${subModule!.subModuleName}';
    subModuleId = subModule!.subModuleId!;
    formItems = storageService.get(key: formName.value);
    StaticValues? value = formItem?.staticValues!;

    //Set Dropdowns
    currentOperator.value = value?.operator?.value;
    operators = value?.operator!.items! ?? [];

    currentRegion.value = value?.region?.value;
    regions = value?.region!.items! ?? [];

    currentSubRegion.value = value?.subRegion?.value;
    subRegions = value?.subRegion!.items! ?? [];

    currentCluster.value = value?.cluster?.value;
    clusters = value?.cluster!.items ?? [];

    currentSite.value = value?.siteId!.value;
    siteIDs = value?.siteId!.items ?? [];

    loading.value = false;
  }
}

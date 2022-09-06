import 'package:get/get.dart';
import 'package:site_audit/models/module_model.dart';
import 'package:site_audit/services/local_storage_service.dart';

class ReviewController extends GetxController {
  RxBool loading = true.obs;
  final storageService = Get.find<LocalStorageService>();
  RxString formName = RxString('');
  Module? module;
  SubModule? subModule;
  int subModuleId = 0;
  List<dynamic>? formItems = [];

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
    loading.value = false;
  }
}

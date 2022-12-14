import 'dart:convert';

class Module {
  int? moduleId;
  String? moduleName;
  List<SubModule>? subModules;

  Module({
    this.moduleId,
    this.moduleName,
    this.subModules,
  });

  Module.fromJson(Map<String, dynamic> json) {
    moduleId = json['module_id'];
    moduleName = json['module_name'];
    if (json['sub_modules'] != null) {
      subModules = <SubModule>[];
      json['sub_modules'].forEach((v) {
        subModules!.add(SubModule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson(Module module) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['module_id'] = module.moduleId;
    data['module_name'] = module.moduleName;
    data['sub_modules'] = jsonEncode(module.subModules);
    return data;
  }
}

class SubModule {
  int? subModuleId;
  String? subModuleName;

  SubModule({
    this.subModuleId,
    this.subModuleName,
  });

  SubModule.fromJson(Map<String, dynamic> json) {
    subModuleId = json['sub_module_id'];
    subModuleName = json['sub_module_name'];
  }
}

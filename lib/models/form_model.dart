import 'package:site_audit/models/static_values.dart';

class FormModel {
  int? subModuleId;
  String? subModuleName;
  List<Items>? items;
  StaticValues? staticValues;
  String? moduleName;

  FormModel({
    this.subModuleId,
    this.subModuleName,
    this.moduleName,
    this.items,
    this.staticValues,
  });

  FormModel.fromJson(Map<String, dynamic> json) {
    subModuleId = json['sub_module_id'];
    subModuleName = json['sub_module_name'];
    moduleName = json['module_name'];
    staticValues = json['static_values'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_module_id'] = subModuleId;
    data['sub_module_name'] = subModuleName;
    data['static_values'] = staticValues;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? projectId;
  String? designRef;
  bool? mandatory;
  String? inputDescription;
  String? inputType;
  String? inputParameter;
  String? answer;
  int? inputLength;
  String? inputLabel;
  int? status;
  Modules? modules;
  InputOption? inputOption;

  Items(
      {this.projectId,
      this.designRef,
      this.mandatory,
      this.inputDescription,
      this.inputType,
      this.inputParameter,
      this.answer,
      this.inputLength,
      this.inputLabel,
      this.status,
      this.modules,
      this.inputOption});

  Items.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    designRef = json['design_ref'];
    mandatory = json['mandatory'] == 1 ? true : false;
    inputDescription = json['input_description'];
    inputType = json['input_type'];
    inputParameter = json['input_parameter'];
    inputLength = json['input_length'];
    inputLabel = json['input_label'];
    status = json['status'];
    modules =
        json['modules'] != null ? Modules.fromJson(json['modules']) : null;
    inputOption = json['input_option'] != null
        ? InputOption.fromJson(json['input_option'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['project_id'] = projectId;
    data['design_ref'] = designRef;
    data['mandatory'] = mandatory;
    data['input_description'] = inputDescription;
    data['input_type'] = inputType;
    data['input_parameter'] = inputParameter;
    data['input_length'] = inputLength;
    data['input_label'] = inputLabel;
    data['status'] = status;
    if (modules != null) {
      data['modules'] = modules!.toJson();
    }
    if (inputOption != null) {
      data['input_option'] = inputOption!.toJson();
    }
    return data;
  }
}

class Modules {
  int? id;
  int? projectId;
  int? moduleId;
  int? status;
  int? parentId;
  int? menuLevel;
  String? description;
  String? designRef;
  String? createdAt;
  String? updatedAt;

  Modules(
      {this.id,
      this.projectId,
      this.moduleId,
      this.status,
      this.parentId,
      this.menuLevel,
      this.description,
      this.designRef,
      this.createdAt,
      this.updatedAt});

  Modules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    moduleId = json['module_id'];
    status = json['status'];
    parentId = json['parent_id'];
    menuLevel = json['menu_level'];
    description = json['description'];
    designRef = json['design_ref'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['project_id'] = projectId;
    data['module_id'] = moduleId;
    data['status'] = status;
    data['parent_id'] = parentId;
    data['menu_level'] = menuLevel;
    data['description'] = description;
    data['design_ref'] = designRef;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class InputOption {
  int? status;
  List<String>? inputOptions;

  InputOption({this.status, this.inputOptions});

  InputOption.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    inputOptions = json['input_options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['input_options'] = inputOptions;
    return data;
  }
}

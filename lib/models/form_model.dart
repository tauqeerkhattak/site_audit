class FormModel {
  int? subModuleId;
  String? subModuleName;
  String? moduleName;
  String? staticValues;
  List<Items>? items;

  FormModel({this.subModuleId, this.subModuleName, this.items});

  FormModel.fromJson(Map<String, dynamic> json) {
    subModuleId = json['sub_module_id'];
    subModuleName = json['sub_module_name'];
    moduleName = json['module_name'];
    staticValues = json['staticValues'];
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
    data['module_name'] = moduleName;
    data['static_values'] = staticValues.toString();
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
  String? inputLabel;
  String? answer;
  int? status;
  InputOption? inputOption;
  Modules? modules;

  Items(
      {this.projectId,
      this.designRef,
      this.mandatory,
      this.inputDescription,
      this.inputType,
      this.inputLabel,
      this.answer,
      this.status,
      this.inputOption,
      this.modules});

  Items.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    designRef = json['design_ref'];
    mandatory = json['mandatory'] == 1 ? true : false;
    inputDescription = json['input_description'];
    inputType = json['input_type'];
    inputLabel = json['input_label'];
    answer = json['answer'];
    status = json['status'];
    inputOption = json['input_option'] != null
        ? InputOption.fromJson(json['input_option'])
        : null;
    modules =
        json['modules'] != null ? Modules.fromJson(json['modules']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['project_id'] = projectId;
    data['design_ref'] = designRef;
    data['mandatory'] = mandatory;
    data['input_description'] = inputDescription;
    data['input_type'] = inputType;
    data['input_label'] = inputLabel;
    data['answer'] = answer;
    data['status'] = status;
    if (inputOption != null) {
      data['input_option'] = inputOption!.toJson();
    }
    if (modules != null) {
      data['modules'] = modules!.toJson();
    }
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

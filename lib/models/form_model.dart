import 'package:equatable/equatable.dart';

class FormModel {
  int? subModuleId;
  String? subModuleName;
  String? moduleName;
  String? projectId;
  Map<String, dynamic>? staticValues;
  List<Items>? items;

  FormModel({
    this.subModuleId,
    this.subModuleName,
    this.staticValues,
    this.moduleName,
    this.projectId,
    this.items,
  });

  FormModel.fromJson(Map<String, dynamic> json) {
    subModuleId = int.tryParse('${json['sub_module_id']}');
    subModuleName = json['sub_module_name'];
    moduleName = json['module_name'];
    projectId = json['project_id'];
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
    data['module_name'] = moduleName;
    data['static_values'] = staticValues;
    data['project_id'] = projectId;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items extends Equatable {
  int? id;
  bool? mandatory;
  String? inputDescription;
  String? answer;
  String? inputType;
  String? inputParameter;
  int? inputLength;
  String? inputHint;
  int? parentInputId;
  String? inputLabel;
  List<InputOption>? inputOption;

  Items(
      {this.id,
      this.mandatory,
      this.inputDescription,
      this.answer,
      this.inputType,
      this.inputParameter,
      this.inputLength,
      this.inputHint,
      this.parentInputId,
      this.inputLabel,
      this.inputOption});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mandatory = json['mandatory'] == 1;
    inputDescription = json['input_description'];
    answer = json['answer'];
    inputType = json['input_type'];
    inputParameter = json['input_parameter'];
    inputLength = json['input_length'];
    inputHint = json['input_hint'];
    parentInputId = json['parent_input_id'];
    inputLabel = json['input_label'];
    if (json['input_option'] != null) {
      inputOption = <InputOption>[];
      json['input_option'].forEach((v) {
        inputOption!.add(InputOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mandatory'] = mandatory;
    data['input_description'] = inputDescription;
    data['answer'] = answer;
    data['input_type'] = inputType;
    data['input_parameter'] = inputParameter;
    data['input_length'] = inputLength;
    data['input_hint'] = inputHint;
    data['parent_input_id'] = parentInputId;
    data['input_label'] = inputLabel;
    if (inputOption != null) {
      data['input_option'] = inputOption!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object?> get props => [id];
}

class InputOption {
  int? inputItemParentId;
  int? inputParentLevel;
  List<String>? inputOptions;

  InputOption(
      {this.inputItemParentId, this.inputParentLevel, this.inputOptions});

  InputOption.fromJson(Map<String, dynamic> json) {
    inputItemParentId = json['input_item_parent_id'];
    inputParentLevel = json['input_parent_level'];
    inputOptions = json['input_options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['input_item_parent_id'] = inputItemParentId;
    data['input_parent_level'] = inputParentLevel;
    data['input_options'] = inputOptions;
    return data;
  }
}

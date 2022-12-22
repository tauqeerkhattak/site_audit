import 'dart:developer';

import 'package:equatable/equatable.dart';

class FormModel {
  int? id;
  int? subModuleId;
  String? subModuleName;
  String? moduleName;
  int? projectId;
  Map<String, dynamic>? staticValues;
  List<Items>? items;

  FormModel({
    this.id,
    this.subModuleId,
    this.subModuleName,
    this.staticValues,
    this.moduleName,
    this.projectId,
    this.items,
  });

  FormModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subModuleId = int.tryParse('${json['sub_module_id']}');
    subModuleName = json['sub_module_name'];
    moduleName = json['module_name'];
    projectId = int.tryParse(json['project_id'].toString());
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
    data['id'] = id;
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

  Map<String, dynamic> toFormJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_module_id'] = subModuleId;
    data['sub_module_name'] = subModuleName;
    data['module_name'] = moduleName;
    data['static_values'] = staticValues;
    data['project_id'] = projectId;
    if (items != null) {
      data['items'] = items!.map((v) => v.toPostJson()).toList();
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
  String? filename;
  String? inputLabel;
  int? inputOptionId;
  List<InputOption>? inputOption;

  Items({
    this.id,
    this.mandatory,
    this.inputDescription,
    this.answer,
    this.inputType,
    this.inputParameter,
    this.inputLength,
    this.inputHint,
    this.parentInputId,
    this.inputLabel,
    this.filename,
    this.inputOption,
  });

  Map<String, dynamic> toSqfFormatData({
    required String projectId,
    required String subModuleId,
    int? inputOptionId,
  }) {
    return <String, dynamic>{
      'input_id': id,
      'project_id': projectId,
      'sub_module_id': subModuleId,
      'mandatory': mandatory ?? false ? 1 : 0,
      'input_description': inputDescription,
      'input_type': inputType,
      'input_parameter': inputParameter,
      'input_length': inputLength,
      'input_hint': inputHint,
      'parent_input_id': parentInputId,
      'input_label': inputLabel,
      'input_option_id': inputOptionId,
    };
  }

  Map<String, dynamic> toAnswerData({
    required String projectId,
    required String subModuleId,
    required int formId,
    int? inputOptionId,
  }) {
    return <String, dynamic>{
      'input_id': id,
      'form_id': formId,
      'project_id': projectId,
      'sub_module_id': subModuleId,
      'mandatory': mandatory ?? false ? 1 : 0,
      'input_description': inputDescription,
      'answer': answer,
      'input_type': inputType,
      'input_parameter': inputParameter,
      'input_length': inputLength,
      'input_hint': inputHint,
      'parent_input_id': parentInputId,
      'input_label': inputLabel,
      'input_option_id': inputOptionId,
    };
  }

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['input_id'];
    mandatory = json['mandatory'] == 1;
    inputDescription = json['input_description'];
    answer = json['answer'];
    filename = json['filename'];
    inputType = json['input_type'];
    inputParameter = json['input_parameter'];
    inputLength = int.tryParse(json['input_length'].toString());
    inputHint = json['input_hint'];
    parentInputId = json['parent_input_id'];
    inputLabel = json['input_label'];
    inputOptionId = json['input_option_id'];
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
    data['filename'] = filename;
    data['input_hint'] = inputHint;
    data['parent_input_id'] = parentInputId;
    data['input_label'] = inputLabel;
    if (inputOption != null) {
      data['input_option'] = inputOption!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toPostJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['answer'] = answer;
    data['input_type'] = inputType;
    data['input_label'] = inputLabel;
    data['filename'] = filename;
    return data;
  }

  @override
  List<Object?> get props => [id];
}

class InputOption {
  int? inputItemParentId;
  int? inputParentLevel;
  List<String>? inputOptions;

  InputOption({
    this.inputItemParentId,
    this.inputParentLevel,
    this.inputOptions,
  });

  String inputOptionsToString() {
    String result = '[';
    for (String inputData in inputOptions ?? []) {
      if (inputOptions!.indexOf(inputData) == inputOptions!.length - 1) {
        result += '$inputData]';
      } else {
        result += '$inputData,';
      }
    }
    return result;
  }

  Map<String, dynamic> toSqfFormatData() {
    for (String inn in inputOptions ?? []) {
      log('INPUT OPTION LENGTH: ${inn.length}');
    }
    return <String, dynamic>{
      'input_item_parent_id': inputItemParentId,
      'input_parent_level': inputParentLevel,
      'input_option': inputOptionsToString(),
    };
  }

  InputOption.fromJson(Map<String, dynamic> json) {
    inputItemParentId = int.tryParse(json['input_item_parent_id'].toString());
    inputParentLevel = int.tryParse(json['input_parent_level'].toString());
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

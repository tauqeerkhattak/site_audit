import 'dart:convert';

import 'package:site_audit/models/form_model.dart';

class DataBaseModel {
  int? id;
  int? sub_module_id;
  String? sub_module_name;
  String? module_name;
  int? project_id;
  List<DataBaseItem>? items;

  DataBaseModel(
    this.id,
    this.sub_module_id,
    this.sub_module_name,
    //this.static_values,
    this.module_name,
    this.project_id,
    this.items,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'sub_module_id': sub_module_id,
      'sub_module_name': sub_module_name,
      'module_name': module_name,
      'project_id': project_id,
      //items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
      "items": List<dynamic>.from(items!.map((x) => x.toMap())),
      //'static_values': static_values,
      //'items': items,
    };
    return map;
  }

  DataBaseModel.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    sub_module_id = map['sub_module_id'];
    sub_module_name = map['sub_module_name'];
    module_name = map['module_name'];
    project_id = map['project_id'];
    items = List<DataBaseItem>.from(
        map["items"].map((x) => DataBaseItem.fromMap(x)));
    //static_values = map['static_values'];
    //items = map['items'];
  }
}

class DataBaseItem {
  int? id;
  //bool? mandatory;
  String? inputDescription;
  String? answer;
  String? inputType;
  String? inputParameter;
  int? inputLength;
  String? inputHint;
  int? parentInputId;
  String? filename;
  String? inputLabel;
  //List<DataBaseItem>? inputOption;

  DataBaseItem(
    this.id,
    //this.mandatory,
    this.inputDescription,
    this.answer,
    this.inputType,
    this.inputParameter,
    this.inputLength,
    this.inputHint,
    this.parentInputId,
    this.inputLabel,
    this.filename,
    //this.inputOption
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      //'mandatory' : mandatory,
      'inputDescription': inputDescription,
      'answer': answer,
      'filename': filename,
      'inputType': inputType,
      'inputParameter': inputParameter,
      'inputLength': inputLength,
      'inputHint': inputHint,
      'parentInputId': parentInputId,
      'inputLabel': inputLabel,
      //'inputOption' : inputOption,
    };
    return map;
  }

  DataBaseItem.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    //mandatory = map['mandatory'];
    inputDescription = map['inputDescription'];
    answer = map['answer'];
    filename = map['filename'];
    inputType = map['inputType'];
    inputParameter = map['inputParameter'];
    inputLength = map['inputLength'];
    inputHint = map['inputHint'];
    parentInputId = map['parentInputId'];
    inputLabel = map['inputLabel'];
    //inputOption = map['inputOption'];
  }
}

class DataBaseInputOption {
  int? inputItemParentId;
  int? inputParentLevel;
  List<String>? inputOptions;

  DataBaseInputOption(
    this.inputItemParentId,
    this.inputParentLevel,
    this.inputOptions,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'inputItemParentId': inputItemParentId,
      'inputParentLevel': inputParentLevel,
      'inputOptions': inputOptions,
    };
    return map;
  }

  DataBaseInputOption.fromMap(Map<dynamic, dynamic> map) {
    inputItemParentId = map['inputItemParentId'];
    inputParentLevel = map['inputParentLevel'];
    inputParentLevel = map['inputParentLevel'];
  }
}

import 'dart:convert';

import 'package:site_audit/models/static_drop_model.dart';

class ReviewModel {
  int? subModuleId;
  String? subModuleName;
  StaticValues? staticValues;
  List<Items>? items;

  ReviewModel(
      {this.subModuleId, this.subModuleName, this.staticValues, this.items});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    subModuleId = json['sub_module_id'];
    subModuleName = json['sub_module_name'];
    staticValues = json['static_values'] != null
        ? StaticValues.fromJson(jsonDecode(json['static_values']))
        : null;
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
    if (staticValues != null) {
      data['static_values'] = staticValues!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaticValues {
  OperatorData? operator;
  RegionData? region;
  SubRegionData? subRegion;
  ClusterData? cluster;
  SiteData? siteId;
  String? siteName;

  StaticValues(
      {this.operator,
      this.region,
      this.subRegion,
      this.cluster,
      this.siteId,
      this.siteName});

  StaticValues.fromJson(Map<String, dynamic> json) {
    operator = json['operator'] != null
        ? OperatorData.fromJson(json['operator'])
        : null;
    region =
        json['region'] != null ? RegionData.fromJson(json['region']) : null;
    subRegion = json['sub_region'] != null
        ? SubRegionData.fromJson(json['sub_region'])
        : null;
    cluster =
        json['cluster'] != null ? ClusterData.fromJson(json['cluster']) : null;
    siteId =
        json['site_id'] != null ? SiteData.fromJson(json['site_id']) : null;
    siteName = json['site_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['operator'] = operator;
    data['region'] = region;
    data['sub_region'] = subRegion;
    data['cluster'] = cluster;
    data['site_id'] = siteId;
    data['site_name'] = siteName;
    return data;
  }
}

class OperatorData {
  Datum? value;
  List<Datum>? items;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['items'] = items;
    return data;
  }

  OperatorData.fromJson(Map<String, dynamic> data) {
    value = Datum.fromJson(data['value']);
    if (data['items'] != null) {
      items = <Datum>[];
      data['items'].forEach((value) {
        items!.add(Datum.fromJson(value));
      });
    }
  }
}

class RegionData {
  Region? value;
  List<Region>? items;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['items'] = items;
    return data;
  }

  RegionData.fromJson(Map<String, dynamic> data) {
    value = Region.fromJson(data['value']);
    if (data['items'] != null) {
      items = <Region>[];
      data['items'].forEach((value) {
        items!.add(Region.fromJson(value));
      });
    }
  }
}

class SubRegionData {
  SubRegion? value;
  List<SubRegion>? items;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['items'] = items;
    return data;
  }

  SubRegionData.fromJson(Map<String, dynamic> data) {
    value = SubRegion.fromJson(data['value']);
    if (data['items'] != null) {
      items = <SubRegion>[];
      data['items'].forEach((value) {
        items!.add(SubRegion.fromJson(value));
      });
    }
  }
}

class ClusterData {
  ClusterId? value;
  List<ClusterId>? items;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['items'] = items;
    return data;
  }

  ClusterData.fromJson(Map<String, dynamic> data) {
    value = ClusterId.fromJson(data['value']);
    if (data['items'] != null) {
      items = <ClusterId>[];
      data['items'].forEach((value) {
        items!.add(ClusterId.fromJson(value));
      });
    }
  }
}

class SiteData {
  SiteReference? value;
  List<SiteReference>? items;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['items'] = items;
    return data;
  }

  SiteData.fromJson(Map<String, dynamic> data) {
    value = SiteReference.fromJson(data['value']);
    if (data['items'] != null) {
      items = <SiteReference>[];
      data['items'].forEach((value) {
        items!.add(SiteReference.fromJson(value));
      });
    }
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
    mandatory = json['mandatory'];
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

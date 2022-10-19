import 'package:site_audit/models/static_drop_model.dart';

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
    data['operator'] = operator?.toJson();
    data['region'] = region?.toJson();
    data['sub_region'] = subRegion?.toJson();
    data['cluster'] = cluster?.toJson();
    data['site_id'] = siteId?.toJson();
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
    value = data['value'];
    if (data['items'] != null) {
      items = <Datum>[];
      data['items'].forEach((value) {
        items!.add(value);
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
    value = data['value'];
    if (data['items'] != null) {
      items = <Region>[];
      data['items'].forEach((value) {
        items!.add(value);
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
    value = data['value'];
    if (data['items'] != null) {
      items = <SubRegion>[];
      data['items'].forEach((value) {
        items!.add(value);
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
    value = data['value'];
    if (data['items'] != null) {
      items = <ClusterId>[];
      data['items'].forEach((value) {
        items!.add(value);
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
    value = data['value'];
    if (data['items'] != null) {
      items = <SiteReference>[];
      data['items'].forEach((value) {
        items!.add(value);
      });
    }
  }
}

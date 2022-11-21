import 'dart:developer';

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
    operator = getOperator(json['operator']);
    region = getRegionData(json['region']);
    subRegion = getSubRegionData(json['sub_region']);
    cluster = getClusterData(json['cluster']);
    siteId = getSiteData(json['site_id']);
    siteName = json['site_name'];
  }

  OperatorData? getOperator(dynamic data) {
    if (data != null) {
      if (data.runtimeType == OperatorData) {
        return data;
      } else {
        log("OPERATOR: ${data['operator']}");
        return OperatorData.fromJson(data);
      }
    }
    return null;
  }

  RegionData? getRegionData(dynamic data) {
    if (data != null) {
      if (data.runtimeType == RegionData) {
        return data;
      } else {
        return RegionData.fromJson(data);
      }
    }
    return null;
  }

  SubRegionData? getSubRegionData(dynamic data) {
    if (data != null) {
      if (data.runtimeType == SubRegionData) {
        return data;
      } else {
        return SubRegionData.fromJson(data);
      }
    }
    return null;
  }

  ClusterData? getClusterData(dynamic data) {
    if (data != null) {
      if (data.runtimeType == ClusterData) {
        return data;
      } else {
        return ClusterData.fromJson(data);
      }
    }
    return null;
  }

  SiteData? getSiteData(dynamic data) {
    if (data != null) {
      if (data.runtimeType == SiteData) {
        return data;
      } else {
        return SiteData.fromJson(data);
      }
    }
    return null;
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
    value = data['value'] != null ? Datum.fromJson(data['value']) : null;
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
    value = data['value'] != null ? Region.fromJson(data['value']) : null;
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
    value = data['value'] != null ? SubRegion.fromJson(data['value']) : null;
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
    value = data['value'] != null ? ClusterId.fromJson(data['value']) : null;
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
    value =
        data['value'] != null ? SiteReference.fromJson(data['value']) : null;
    if (data['items'] != null) {
      items = <SiteReference>[];
      data['items'].forEach((value) {
        items!.add(SiteReference.fromJson(value));
      });
    }
  }
}

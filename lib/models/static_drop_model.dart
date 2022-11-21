import 'package:equatable/equatable.dart';

class StaticDropModel {
  int? status;
  List<Datum>? data;

  StaticDropModel({this.status, this.data});

  StaticDropModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Datum>[];
      json['data'].forEach((v) {
        data!.add(Datum.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Datum extends Equatable {
  String? operator;
  List<Region>? region;

  Datum({this.operator, this.region});

  Datum.fromJson(Map<String, dynamic> json) {
    operator = json['operator'];
    if (json['region'] != null) {
      region = <Region>[];
      json['region'].forEach((v) {
        region!.add(Region.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['operator'] = operator;
    if (region != null) {
      data['region'] = region!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object?> get props => [operator];
}

class Region extends Equatable {
  String? name;
  List<SubRegion>? subRegion;

  Region({this.name, this.subRegion});

  Region.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['sub-region'] != null) {
      subRegion = <SubRegion>[];
      json['sub-region'].forEach((v) {
        subRegion!.add(SubRegion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (subRegion != null) {
      data['sub-region'] = subRegion!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object?> get props => [name];
}

class SubRegion extends Equatable {
  String? name;
  List<ClusterId>? clusterId;

  SubRegion({this.name, this.clusterId});

  SubRegion.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['cluster_id'] != null) {
      clusterId = <ClusterId>[];
      json['cluster_id'].forEach((v) {
        clusterId!.add(ClusterId.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (clusterId != null) {
      data['cluster_id'] = clusterId!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object?> get props => [name];
}

class ClusterId extends Equatable {
  String? id;
  List<SiteReference>? siteReference;

  ClusterId({this.id, this.siteReference});

  ClusterId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['site_reference'] != null) {
      siteReference = <SiteReference>[];
      json['site_reference'].forEach((v) {
        siteReference!.add(SiteReference.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (siteReference != null) {
      data['site_reference'] = siteReference!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object?> get props => [id];
}

class SiteReference extends Equatable {
  String? id;
  String? name;
  SiteReference({this.id, this.name});
  SiteReference.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  @override
  List<Object?> get props => [id];
}

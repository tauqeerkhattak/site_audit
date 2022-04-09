// To parse this JSON data, do
//
//     final siteDetailModel = siteDetailModelFromJson(jsonString);

import 'dart:convert';

SiteDetailModel siteDetailModelFromJson(String str) => SiteDetailModel.fromJson(json.decode(str));

String siteDetailModelToJson(SiteDetailModel data) => json.encode(data.toJson());

class SiteDetailModel {
  SiteDetailModel({
    this.status,
    this.data,
  });

  int? status;
  List<Datum>? data;

  factory SiteDetailModel.fromJson(Map<String, dynamic> json) => SiteDetailModel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.datumOperator,
    this.region,
  });

  String? datumOperator;
  List<Region>? region;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    datumOperator: json["operator"],
    region: List<Region>.from(json["region"].map((x) => Region.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "operator": datumOperator,
    "region": List<dynamic>.from(region!.map((x) => x.toJson())),
  };
}

class Region {
  Region({
    this.name,
    this.subRegion,
  });

  String? name;
  List<SubRegion>? subRegion;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    name: json["name"],
    subRegion: List<SubRegion>.from(json["sub-region"].map((x) => SubRegion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "sub-region": List<dynamic>.from(subRegion!.map((x) => x.toJson())),
  };
}

class SubRegion {
  SubRegion({
    this.name,
    this.clusterId,
  });

  String? name;
  List<ClusterId>? clusterId;

  factory SubRegion.fromJson(Map<String, dynamic> json) => SubRegion(
    name: json["name"],
    clusterId: List<ClusterId>.from(json["cluster_id"].map((x) => ClusterId.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "cluster_id": List<dynamic>.from(clusterId!.map((x) => x.toJson())),
  };
}

class ClusterId {
  ClusterId({
    this.id,
    this.siteReference,
  });

  String? id;
  List<SiteReference>? siteReference;

  factory ClusterId.fromJson(Map<String, dynamic> json) => ClusterId(
    id: json["id"],
    siteReference: List<SiteReference>.from(json["site_reference"].map((x) => SiteReference.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "site_reference": List<dynamic>.from(siteReference!.map((x) => x.toJson())),
  };
}

class SiteReference {
  SiteReference({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory SiteReference.fromJson(Map<String, dynamic> json) => SiteReference(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

// To parse this JSON data, do
//
//     final localSiteModel = localSiteModelFromMap(jsonString);

import 'dart:convert';

class LocalSiteModel {
  LocalSiteModel({
    this.localSiteModelOperator,
    this.region,
    this.subRegion,
    this.cluster,
    this.siteId,
    this.siteName,
    this.siteKeeperName,
    this.siteKeeperPhone,
    this.siteType,
    this.survey,
    this.latitude,
    this.longitude,
    this.weather,
    this.temperature,
    this.imagePath,
  });

  String? localSiteModelOperator;
  String? region;
  String? subRegion;
  String? cluster;
  String? siteId;
  String? siteName;
  String? siteKeeperName;
  String? siteKeeperPhone;
  String? siteType;
  String? survey;
  String? latitude;
  String? longitude;
  String? weather;
  String? temperature;
  String? imagePath;

  factory LocalSiteModel.fromJson(String str) =>
      LocalSiteModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LocalSiteModel.fromMap(Map<String, dynamic> json) => LocalSiteModel(
        localSiteModelOperator:
            json["operator"] == null ? null : json["operator"],
        region: json["region"] == null ? null : json["region"],
        subRegion: json["subRegion"] == null ? null : json["subRegion"],
        cluster: json["cluster"] == null ? null : json["cluster"],
        siteId: json["siteID"] == null ? null : json["siteID"],
        siteName: json["siteName"] == null ? null : json["siteName"],
        siteKeeperName:
            json["siteKeeperName"] == null ? null : json["siteKeeperName"],
        siteKeeperPhone:
            json["siteKeeperPhone"] == null ? null : json["siteKeeperPhone"],
        siteType: json["siteType"] == null ? null : json["siteType"],
        survey: json["survey"] == null ? null : json["survey"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        weather: json["weather"] == null ? null : json["weather"],
        temperature: json["temperature"] == null ? null : json["temperature"],
        imagePath: json["imagePath"] == null ? null : json["imagePath"],
      );

  Map<String, dynamic> toMap() => {
        "operator":
            localSiteModelOperator == null ? null : localSiteModelOperator,
        "region": region == null ? null : region,
        "subRegion": subRegion == null ? null : subRegion,
        "cluster": cluster == null ? null : cluster,
        "siteID": siteId == null ? null : siteId,
        "siteName": siteName == null ? null : siteName,
        "siteKeeperName": siteKeeperName == null ? null : siteKeeperName,
        "siteKeeperPhone": siteKeeperPhone == null ? null : siteKeeperPhone,
        "siteType": siteType == null ? null : siteType,
        "survey": survey == null ? null : survey,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "weather": weather == null ? null : weather,
        "temperature": temperature == null ? null : temperature,
        "imagePath": imagePath == null ? null : imagePath,
      };
}

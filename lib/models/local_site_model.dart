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
    this.imagePath1,
    this.imagePath2,
    this.imagePath3,
    this.image1description,
    this.image2description,
    this.image3description
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
  String? imagePath1;
  String? imagePath2;
  String? imagePath3;
  String? image1description;
  String? image2description;
  String? image3description;

  factory LocalSiteModel.fromJson(String str) =>
      LocalSiteModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LocalSiteModel.fromMap(Map<String, dynamic> json) => LocalSiteModel(
        localSiteModelOperator: json["operator"] == null ? null : json["operator"],
        region: json["region"] == null ? null : json["region"],
        subRegion: json["subRegion"] == null ? null : json["subRegion"],
        cluster: json["cluster"] == null ? null : json["cluster"],
        siteId: json["siteID"] == null ? null : json["siteID"],
        siteName: json["siteName"] == null ? null : json["siteName"],
        siteKeeperName: json["siteKeeperName"] == null ? null : json["siteKeeperName"],
        siteKeeperPhone: json["siteKeeperPhone"] == null ? null : json["siteKeeperPhone"],
        siteType: json["siteType"] == null ? null : json["siteType"],
        survey: json["survey"] == null ? null : json["survey"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        weather: json["weather"] == null ? null : json["weather"],
        temperature: json["temperature"] == null ? null : json["temperature"],
        imagePath: json["imagePath"] == null ? null : json["imagePath"],
        imagePath1: json["imagePath1"] == null ? null : json["imagePath1"],
        imagePath2: json["imagePath2"] == null ? null : json["imagePath2"],
        imagePath3: json["imagePath3"] == null ? null : json["imagePath3"],
        image1description: json["image1description"] == null ? null : json["image1description"],
        image2description: json["image2description"] == null ? null : json["image2description"],
        image3description: json["image3description"] == null ? null : json["image3description"],
      );

  Map<String, dynamic> toMap() => {
        "operator": localSiteModelOperator == null ? null : localSiteModelOperator,
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
        "imagePath1": imagePath1 == null ? null : imagePath1,
        "imagePath2": imagePath2 == null ? null : imagePath2,
        "imagePath3": imagePath3 == null ? null : imagePath3,
        "image1description": image1description == null ? null : image1description,
        "image2description": image2description == null ? null : image2description,
        "image3description": image3description == null ? null : image3description,
      };
}

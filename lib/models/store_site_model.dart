class StoreSiteModel {
  int? status;
  String? message;
  Data? data;

  StoreSiteModel({this.status, this.message, this.data});

  StoreSiteModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? systemDatetimeOfInsert;
  String? internalProjectId;
  String? siteReferenceId;
  String? siteReferenceName;
  String? siteOperator;
  String? siteLocationRegion;
  String? siteLocationSubRegion;
  String? siteBelongsToCluster;
  String? siteKeeperName;
  String? siteKeeperPhoneNumber;
  String? sitePhysicalType;
  String? siteLongitude;
  String? siteLatitude;
  String? siteAltitudeAboveSeaLevel;
  String? siteLocalDatetimeSurveyStart;
  String? siteExternalTemperature;
  String? siteAuditWeatherConditions;
  String? rowIdOfAuditTeam;
  String? siteAdditionalNotes1;
  String? siteAdditionalNotes2;
  String? siteAdditionalNotes3;
  int? id;

  Data(
      {this.systemDatetimeOfInsert,
      this.internalProjectId,
      this.siteReferenceId,
      this.siteReferenceName,
      this.siteOperator,
      this.siteLocationRegion,
      this.siteLocationSubRegion,
      this.siteBelongsToCluster,
      this.siteKeeperName,
      this.siteKeeperPhoneNumber,
      this.sitePhysicalType,
      this.siteLongitude,
      this.siteLatitude,
      this.siteAltitudeAboveSeaLevel,
      this.siteLocalDatetimeSurveyStart,
      this.siteExternalTemperature,
      this.siteAuditWeatherConditions,
      this.rowIdOfAuditTeam,
      this.siteAdditionalNotes1,
      this.siteAdditionalNotes2,
      this.siteAdditionalNotes3,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    systemDatetimeOfInsert = json['system_datetime_of_insert'];
    internalProjectId = json['internal_project_id'];
    siteReferenceId = json['site_reference_id'];
    siteReferenceName = json['site_reference_name'];
    siteOperator = json['site_operator'];
    siteLocationRegion = json['site_location_region'];
    siteLocationSubRegion = json['site_location_sub_region'];
    siteBelongsToCluster = json['site_belongs_to_cluster'];
    siteKeeperName = json['site_keeper_name'];
    siteKeeperPhoneNumber = json['site_keeper_phone_number'];
    sitePhysicalType = json['site_physical_type'];
    siteLongitude = json['site_longitude'];
    siteLatitude = json['site_latitude'];
    siteAltitudeAboveSeaLevel = json['site_altitude_above_sea_level'];
    siteLocalDatetimeSurveyStart = json['site_local_datetime_survey_start'];
    siteExternalTemperature = json['site_external_temperature'];
    siteAuditWeatherConditions = json['site_audit_weather_conditions'];
    rowIdOfAuditTeam = json['row_id_of_audit_team'];
    siteAdditionalNotes1 = json['site_additional_notes_1'];
    siteAdditionalNotes2 = json['site_additional_notes_2'];
    siteAdditionalNotes3 = json['site_additional_notes_3'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['system_datetime_of_insert'] = this.systemDatetimeOfInsert;
    data['internal_project_id'] = this.internalProjectId;
    data['site_reference_id'] = this.siteReferenceId;
    data['site_reference_name'] = this.siteReferenceName;
    data['site_operator'] = this.siteOperator;
    data['site_location_region'] = this.siteLocationRegion;
    data['site_location_sub_region'] = this.siteLocationSubRegion;
    data['site_belongs_to_cluster'] = this.siteBelongsToCluster;
    data['site_keeper_name'] = this.siteKeeperName;
    data['site_keeper_phone_number'] = this.siteKeeperPhoneNumber;
    data['site_physical_type'] = this.sitePhysicalType;
    data['site_longitude'] = this.siteLongitude;
    data['site_latitude'] = this.siteLatitude;
    data['site_altitude_above_sea_level'] = this.siteAltitudeAboveSeaLevel;
    data['site_local_datetime_survey_start'] =
        this.siteLocalDatetimeSurveyStart;
    data['site_external_temperature'] = this.siteExternalTemperature;
    data['site_audit_weather_conditions'] = this.siteAuditWeatherConditions;
    data['row_id_of_audit_team'] = this.rowIdOfAuditTeam;
    data['site_additional_notes_1'] = this.siteAdditionalNotes1;
    data['site_additional_notes_2'] = this.siteAdditionalNotes2;
    data['site_additional_notes_3'] = this.siteAdditionalNotes3;
    data['id'] = this.id;
    return data;
  }
}

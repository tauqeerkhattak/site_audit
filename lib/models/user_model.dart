// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'dart:convert';

User userFromMap(String str) => User.fromMap(json.decode(str));

String userToMap(User data) => json.encode(data.toMap());

class User {
  User({
    this.id,
    this.systemDatetimeOfLastChange,
    this.lastChangedBy,
    this.assignedToAuditCompany,
    this.assignedToProjectId,
    this.engineerStatus,
    this.worksForCompanyPrefix,
    this.engineeringTeamNumber,
    this.engineeringAuditTeamId,
    this.engineerName,
    this.engineerMobileNumber,
    this.engineerEmailAddress,
    this.locationManagedFrom,
    this.engineerSkills,
    this.engineerCertifications,
    this.engineerToolsCarried,
    this.password,
    this.engineerIdCopy,
  });

  int? id;
  DateTime? systemDatetimeOfLastChange;
  String? lastChangedBy;
  int? assignedToAuditCompany;
  int? assignedToProjectId;
  String? engineerStatus;
  String? worksForCompanyPrefix;
  String? engineeringTeamNumber;
  String? engineeringAuditTeamId;
  String? engineerName;
  String? engineerMobileNumber;
  String? engineerEmailAddress;
  String? locationManagedFrom;
  String? engineerSkills;
  String? engineerCertifications;
  String? engineerToolsCarried;
  String? password;
  String? engineerIdCopy;

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    systemDatetimeOfLastChange: json["system_datetime_of_last_change"] == null ? null : DateTime.parse(json["system_datetime_of_last_change"]),
    lastChangedBy: json["last_changed_by"] == null ? null : json["last_changed_by"],
    assignedToAuditCompany: json["assigned_to_audit_company"] == null ? null : json["assigned_to_audit_company"],
    assignedToProjectId: json["assigned_to_project_id"] == null ? null : json["assigned_to_project_id"],
    engineerStatus: json["engineer_status"] == null ? null : json["engineer_status"],
    worksForCompanyPrefix: json["works_for_company_prefix"] == null ? null : json["works_for_company_prefix"],
    engineeringTeamNumber: json["engineering_team_number"] == null ? null : json["engineering_team_number"],
    engineeringAuditTeamId: json["engineering_audit_team_id"] == null ? null : json["engineering_audit_team_id"],
    engineerName: json["engineer_name"] == null ? null : json["engineer_name"],
    engineerMobileNumber: json["engineer_mobile_number"] == null ? null : json["engineer_mobile_number"],
    engineerEmailAddress: json["engineer_email_address"] == null ? null : json["engineer_email_address"],
    locationManagedFrom: json["location_managed_from"] == null ? null : json["location_managed_from"],
    engineerSkills: json["engineer_skills"] == null ? null : json["engineer_skills"],
    engineerCertifications: json["engineer_certifications"] == null ? null : json["engineer_certifications"],
    engineerToolsCarried: json["engineer_tools_carried"] == null ? null : json["engineer_tools_carried"],
    password: json["password"] == null ? null : json["password"],
    engineerIdCopy: json["engineer_id_copy"] == null ? null : json["engineer_id_copy"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "system_datetime_of_last_change": systemDatetimeOfLastChange == null ? null : systemDatetimeOfLastChange!.toIso8601String(),
    "last_changed_by": lastChangedBy == null ? null : lastChangedBy,
    "assigned_to_audit_company": assignedToAuditCompany == null ? null : assignedToAuditCompany,
    "assigned_to_project_id": assignedToProjectId == null ? null : assignedToProjectId,
    "engineer_status": engineerStatus == null ? null : engineerStatus,
    "works_for_company_prefix": worksForCompanyPrefix == null ? null : worksForCompanyPrefix,
    "engineering_team_number": engineeringTeamNumber == null ? null : engineeringTeamNumber,
    "engineering_audit_team_id": engineeringAuditTeamId == null ? null : engineeringAuditTeamId,
    "engineer_name": engineerName == null ? null : engineerName,
    "engineer_mobile_number": engineerMobileNumber == null ? null : engineerMobileNumber,
    "engineer_email_address": engineerEmailAddress == null ? null : engineerEmailAddress,
    "location_managed_from": locationManagedFrom == null ? null : locationManagedFrom,
    "engineer_skills": engineerSkills == null ? null : engineerSkills,
    "engineer_certifications": engineerCertifications == null ? null : engineerCertifications,
    "engineer_tools_carried": engineerToolsCarried == null ? null : engineerToolsCarried,
    "password": password == null ? null : password,
    "engineer_id_copy": engineerIdCopy == null ? null : engineerIdCopy,
  };
}
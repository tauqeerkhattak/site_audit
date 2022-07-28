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
    this.status,
    this.worksForCompanyPrefix,
    this.teamNumber,
    this.auditTeamId,
    this.name,
    this.phone,
    this.email,
    this.locationManagedFrom,
    this.skills,
    this.certifications,
    this.toolsCarried,
    // this.password,
    this.engineerIdCopy,
  });

  int? id;
  DateTime? systemDatetimeOfLastChange;
  String? lastChangedBy;
  int? assignedToAuditCompany;
  int? assignedToProjectId;
  String? status;
  String? worksForCompanyPrefix;
  String? teamNumber;
  String? auditTeamId;
  String? name;
  String? phone;
  String? email;
  String? locationManagedFrom;
  String? skills;
  String? certifications;
  String? toolsCarried;
  // String? password;
  String? engineerIdCopy;

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    systemDatetimeOfLastChange: json["system_datetime_of_last_change"] == null ? null : DateTime.parse(json["system_datetime_of_last_change"]),
    lastChangedBy: json["last_changed_by"] == null ? null : json["last_changed_by"],
    assignedToAuditCompany: json["assigned_to_audit_company"] == null ? null : json["assigned_to_audit_company"],
    assignedToProjectId: json["assigned_to_project_id"] == null ? null : json["assigned_to_project_id"],
    status: json["engineer_status"] == null ? null : json["engineer_status"],
    worksForCompanyPrefix: json["works_for_company_prefix"] == null ? null : json["works_for_company_prefix"],
    teamNumber: json["engineering_team_number"] == null ? null : json["engineering_team_number"],
    auditTeamId: json["engineering_audit_team_id"] == null ? null : json["engineering_audit_team_id"],
    name: json["engineer_name"] == null ? null : json["engineer_name"],
    phone: json["engineer_mobile_number"] == null ? null : json["engineer_mobile_number"],
    email: json["engineer_email_address"] == null ? null : json["engineer_email_address"],
    locationManagedFrom: json["location_managed_from"] == null ? null : json["location_managed_from"],
    skills: json["engineer_skills"] == null ? null : json["engineer_skills"],
    certifications: json["engineer_certifications"] == null ? null : json["engineer_certifications"],
    toolsCarried: json["engineer_tools_carried"] == null ? null : json["engineer_tools_carried"],
    // password: json["password"] == null ? null : json["password"],
    engineerIdCopy: json["engineer_id_copy"] == null ? null : json["engineer_id_copy"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "system_datetime_of_last_change": systemDatetimeOfLastChange == null ? null : systemDatetimeOfLastChange!.toIso8601String(),
    "last_changed_by": lastChangedBy == null ? null : lastChangedBy,
    "assigned_to_audit_company": assignedToAuditCompany == null ? null : assignedToAuditCompany,
    "assigned_to_project_id": assignedToProjectId == null ? null : assignedToProjectId,
    "engineer_status": status == null ? null : status,
    "works_for_company_prefix": worksForCompanyPrefix == null ? null : worksForCompanyPrefix,
    "engineering_team_number": teamNumber == null ? null : teamNumber,
    "engineering_audit_team_id": auditTeamId == null ? null : auditTeamId,
    "engineer_name": name == null ? null : name,
    "engineer_mobile_number": phone == null ? null : phone,
    "engineer_email_address": email == null ? null : email,
    "location_managed_from": locationManagedFrom == null ? null : locationManagedFrom,
    "engineer_skills": skills == null ? null : skills,
    "engineer_certifications": certifications == null ? null : certifications,
    "engineer_tools_carried": toolsCarried == null ? null : toolsCarried,
    // "password": password == null ? null : password,
    "engineer_id_copy": engineerIdCopy == null ? null : engineerIdCopy,
  };
}
class User {
  String? status;
  String? token;
  Data? data;

  User({this.status, this.token, this.data});

  User.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? auditCompanyId;
  int? projectId;
  String? status;
  String? auditTeamId;
  String? password;
  String? engineerNameFull;
  String? engineerMobileNumber;
  String? engineerEmailAddress;
  String? locationManagedFrom;
  String? engineerSkills;
  String? engineerCertifications;
  String? engineerToolsCarried;
  String? engineerIdCopy;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.auditCompanyId,
      this.projectId,
      this.status,
      this.auditTeamId,
      this.password,
      this.engineerNameFull,
      this.engineerMobileNumber,
      this.engineerEmailAddress,
      this.locationManagedFrom,
      this.engineerSkills,
      this.engineerCertifications,
      this.engineerToolsCarried,
      this.engineerIdCopy,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    auditCompanyId = int.tryParse(json['audit_company_id']);
    projectId = int.tryParse(json['project_id']);
    status = json['status'];
    auditTeamId = json['audit_team_id'];
    password = json['password'];
    engineerNameFull = json['engineer_name_full'];
    engineerMobileNumber = json['engineer_mobile_number'];
    engineerEmailAddress = json['engineer_email_address'];
    locationManagedFrom = json['location_managed_from'];
    engineerSkills = json['engineer_skills'];
    engineerCertifications = json['engineer_certifications'];
    engineerToolsCarried = json['engineer_tools_carried'];
    engineerIdCopy = json['engineer_id_copy'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['audit_company_id'] = auditCompanyId;
    data['project_id'] = projectId;
    data['status'] = status;
    data['audit_team_id'] = auditTeamId;
    data['password'] = password;
    data['engineer_name_full'] = engineerNameFull;
    data['engineer_mobile_number'] = engineerMobileNumber;
    data['engineer_email_address'] = engineerEmailAddress;
    data['location_managed_from'] = locationManagedFrom;
    data['engineer_skills'] = engineerSkills;
    data['engineer_certifications'] = engineerCertifications;
    data['engineer_tools_carried'] = engineerToolsCarried;
    data['engineer_id_copy'] = engineerIdCopy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

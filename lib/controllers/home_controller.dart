import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:site_audit/models/local_site_model.dart';
import 'package:site_audit/models/store_site_model.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/service/services.dart';

class HomeController extends GetxController {
  Rx<bool> isLoading = false.obs;
  final GetStorage _box = GetStorage();

  Future<void> storeSiteDetail() async {
    isLoading.value = true;
    var data = _box.read('user');
    User user = User.fromMap(data);
    var siteData = await _box.read(user.id.toString());
    LocalSiteModel model = LocalSiteModel.fromJson(siteData);
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    // ),
    String date = format.parse(now.toString()).toString();
    var payload = {
      'system_datetime_of_insert': date.split('.').first,
      'internal_project_id': user.assignedToProjectId.toString(),
      'site_reference_id': model.siteId!,
      'site_reference_name': model.siteName!,
      'site_operator': model.localSiteModelOperator!,
      'site_location_region': model.region!,
      'site_location_sub_region': model.subRegion!,
      'site_belongs_to_cluster': model.cluster!,
      'site_keeper_name': model.siteKeeperName!,
      'site_keeper_phone_number': model.siteKeeperPhone!,
      'site_physical_type': model.siteType!,
      'site_longitude': model.longitude!,
      'site_latitude': model.latitude!,
      'site_altitude_above_sea_level': '4.6',
      'site_local_datetime_survey_start': model.survey!,
      'site_external_temperature': model.temperature!,
      'site_audit_weather_conditions': model.weather!,
      'row_id_of_audit_team': 1.toString(),
      // 'site_additional_notes_1': 'Image Name: ${basename(model.imagePath!)}',
      // 'site_additional_notes_2': '',
      // 'site_additional_notes_3': ''
    };
    List<http.MultipartFile> files = [
      await http.MultipartFile.fromPath(
        'site_photo_from_main_entrance',
        model.imagePath!,
      ),
    ];
    var res = await AppService.storeSiteDetails(payload: payload, files: files);
    if (res != null) {
      StoreSiteModel model = StoreSiteModel.fromJson(jsonDecode(res));
      Get.dialog(
        AlertDialog(
          title: Text(model.message!),
        ),
      );
    }
    isLoading.value = false;
    try {} on Exception catch (e) {
      print("Something $e");
      throw Exception(e);
    }
  }
}

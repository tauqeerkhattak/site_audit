import 'dart:convert';

import 'package:get/get.dart' hide MultipartFile;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:site_audit/models/local_site_model.dart';
import 'package:site_audit/models/store_site_model.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/service/encryption_service.dart';
import 'package:site_audit/service/services.dart';
import 'package:site_audit/utils/network.dart';
import 'package:site_audit/widgets/custom_dialog.dart';

class HomeController extends GetxController {
  Rx<bool> isLoading = false.obs;
  final GetStorage _box = GetStorage();

  Future<void> storeSiteDetail() async {
    try {
      if (Network.isNetworkAvailable) {
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
          'system_datetime_of_insert':
              await EncryptionService.encrypt(date.split('.').first),
          'internal_project_id': await EncryptionService.encrypt(
              user.assignedToProjectId.toString()),
          'site_reference_id': await EncryptionService.encrypt(model.siteId!),
          'site_reference_name':
              await EncryptionService.encrypt(model.siteName!),
          'site_operator':
              await EncryptionService.encrypt(model.localSiteModelOperator!),
          'site_location_region':
              await EncryptionService.encrypt(model.region!),
          'site_location_sub_region':
              await EncryptionService.encrypt(model.subRegion!),
          'site_belongs_to_cluster':
              await EncryptionService.encrypt(model.cluster!),
          'site_keeper_name':
              await EncryptionService.encrypt(model.siteKeeperName!),
          'site_keeper_phone_number':
              await EncryptionService.encrypt(model.siteKeeperPhone!),
          'site_physical_type':
              await EncryptionService.encrypt(model.siteType!),
          'site_longitude': await EncryptionService.encrypt(model.longitude!),
          'site_latitude': await EncryptionService.encrypt(model.latitude!),
          'site_altitude_above_sea_level':
              await EncryptionService.encrypt('4.6'),
          'site_local_datetime_survey_start':
              await EncryptionService.encrypt(model.survey!),
          'site_external_temperature':
              await EncryptionService.encrypt(model.temperature!),
          'site_audit_weather_conditions':
              await EncryptionService.encrypt(model.weather!),
          'row_id_of_audit_team': await EncryptionService.encrypt(1.toString()),
          // 'site_additional_notes_1': 'Image Name: ${basename(model.imagePath!)}',
          // 'site_additional_notes_2': '',
          // 'site_additional_notes_3': ''
        };
        List<MultipartFile> files = [
          await MultipartFile.fromPath(
            'site_photo_from_main_entrance',
            model.imagePath!,
          ),
        ];
        var res =
            await AppService.storeSiteDetails(payload: payload, files: files);
        if (res != null) {
          StoreSiteModel model = StoreSiteModel.fromJson(jsonDecode(res));
          _box.remove(user.id.toString());
          CustomDialog.showCustomDialog(
            title: 'Success',
            content: model.message!,
          );
        }
        isLoading.value = false;
      } else {
        Network.sendDataToNetwork = true;
        CustomDialog.showCustomDialog(
          title: 'No network available',
          content:
              'Waiting for network connection to send data automatically...',
        );
      }
    } on Exception catch (e) {
      isLoading.value = false;
      print("Something $e");
      CustomDialog.showCustomDialog(title: 'Error', content: e.toString());
      throw Exception(e);
    }
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
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
  RxBool isLoading = false.obs;
  RxBool confirmClose = false.obs;
  RxBool auditComplete = false.obs;
  RxBool savingData = false.obs;
  RxDouble savingPercent = 0.0.obs;
  RxBool dataSaved = false.obs;
  final GetStorage _box = GetStorage();

  Future<void> storeSiteDetail() async {
    try {
      if (Network.isAvailable) {
        isLoading.value = true;
        Timer.periodic(Duration(milliseconds: 200), (Timer t) {
          if(savingPercent.value < 0.9) {
            // print(savingPercent.value);
            savingPercent.value = savingPercent.value + 0.1;
          } else {
            t.cancel();
          }
        },);
        var data = _box.read('user');
        User user = User.fromMap(data);
        var siteData = await _box.read(user.id.toString());
        LocalSiteModel model = LocalSiteModel.fromJson(siteData);
        DateTime now = DateTime.now();
        DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
        // ),
        String date = format.parse(now.toString()).toString();
        var payload = {
          'system_datetime_of_insert': await EncryptionService.encrypt(date.split('.').first),
          'internal_project_id': await EncryptionService.encrypt(user.assignedToProjectId.toString()),
          'site_reference_id': await EncryptionService.encrypt(model.siteId!),
          'site_reference_name': await EncryptionService.encrypt(model.siteName!),
          'site_operator': await EncryptionService.encrypt(model.localSiteModelOperator!),
          'site_location_region': await EncryptionService.encrypt(model.region!),
          'site_location_sub_region': await EncryptionService.encrypt(model.subRegion!),
          'site_belongs_to_cluster': await EncryptionService.encrypt(model.cluster!),
          'site_keeper_name': await EncryptionService.encrypt(model.siteKeeperName!),
          'site_keeper_phone_number': await EncryptionService.encrypt(model.siteKeeperPhone!),
          'site_physical_type': await EncryptionService.encrypt(model.siteType!),
          'site_longitude': await EncryptionService.encrypt(model.longitude!),
          'site_latitude': await EncryptionService.encrypt(model.latitude!),
          'site_altitude_above_sea_level': await EncryptionService.encrypt('4.6'),
          'site_local_datetime_survey_start': await EncryptionService.encrypt(model.survey!),
          'site_external_temperature': await EncryptionService.encrypt(model.temperature!),
          'site_audit_weather_conditions': await EncryptionService.encrypt(model.weather!),
          'row_id_of_audit_team': await EncryptionService.encrypt(user.id.toString()),
        };
        if(model.image1description != null && model.image1description!.isNotEmpty){
          payload.addAll({'site_additional_notes_1': await EncryptionService.encrypt(model.image1description.toString()),});
        }
        if(model.image2description != null && model.image2description!.isNotEmpty){
          payload.addAll({'site_additional_notes_2': await EncryptionService.encrypt(model.image2description.toString())});
        }
        if(model.image3description != null && model.image3description!.isNotEmpty){
          print({'site_additional_notes_3': await EncryptionService.encrypt(model.image3description.toString())});
        }
        List<MultipartFile> files = [
          await MultipartFile.fromPath('site_photo_from_main_entrance', model.imagePath!,),
          if(model.imagePath1 != null)
            await MultipartFile.fromPath('site_additional_photo_1_name', model.imagePath1!,),
          if(model.imagePath1 != null)
            await MultipartFile.fromPath('site_additional_photo_2_name', model.imagePath2!,),
          if(model.imagePath1 != null)
            await MultipartFile.fromPath('site_additional_photo_3_name', model.imagePath3!,),
        ];
        var res = await AppService.storeSiteDetails(payload: payload, files: files);
        if (res != null) {
          StoreSiteModel model = StoreSiteModel.fromJson(jsonDecode(res));
          _box.remove(user.id.toString());
          savingPercent.value = savingPercent.value + 1.0;
          dataSaved.value = true;
          savingData.value = false;
          confirmClose.value = false;
          auditComplete.value = true;
          Future.delayed(Duration(milliseconds: 200), () => Get.back());
          // CustomDialog.showCustomDialog(
          //   title: 'Success',
          //   content: model.message!,
          // );
        }
        isLoading.value = false;
      }
      else {
        Network.sendDataToNetwork = true;
        savingData.value = true;
        confirmClose.value = false;
        Timer.periodic(Duration(milliseconds: 200), (Timer t) {
          if(savingPercent.value < 0.9) {
            print(savingPercent.value);
            savingPercent.value = savingPercent.value + 0.1;
          } else {
            dataSaved.value = true;
            savingData.value = false;
            confirmClose.value = false;
            auditComplete.value = true;
            t.cancel();
            Future.delayed(Duration(milliseconds: 200), () => Get.back());
            // Future.delayed(Duration(milliseconds: 200), () => SystemNavigator.pop());
          }
        },);
        // CustomDialog.showCustomDialog(
        //   title: 'No network available',
        //   content:
        //       'Waiting for network connection to send data automatically...',
        // );
      }
    } on Exception catch (e) {
      isLoading.value = false;
      print("Something $e");
      CustomDialog.showCustomDialog(title: 'Error', content: e.toString());
      throw Exception(e);
    }
  }

  void handleCancel() {
    confirmClose.value = false;
    savingData.value = false;
    dataSaved.value = false;
  }

  Future<void> handleCloseApp() async {
    if(savingData()){
      dataSaved.value = true;
      savingData.value = false;
      confirmClose.value = false;
    }
    else if(confirmClose()){
      storeSiteDetail();
      // savingData.value = true;
      // confirmClose.value = false;
      // Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      //   if(savingPercent.value < 0.9) {
      //     print(savingPercent.value);
      //     savingPercent.value = savingPercent.value + 0.1;
      //   } else {
      //     dataSaved.value = true;
      //     savingData.value = false;
      //     confirmClose.value = false;
      //     t.cancel();
      //     Future.delayed(Duration(milliseconds: 200), () => SystemNavigator.pop());
      //   }
      // },);
    }
    else {
      confirmClose.value = true;
    }
  }
}

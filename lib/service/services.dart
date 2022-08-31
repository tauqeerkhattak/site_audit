import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/models/module_model.dart';
import 'package:site_audit/service/local_storage_service.dart';
import 'package:site_audit/utils/network.dart';

import 'apis.dart';

class AppService {
  static final _storageService = Get.find<LocalStorageService>();

  // LOGIN ENGINEER
  static Future<Map<String, dynamic>?> login({payload}) async {
    try {
      var res = await Network.post(url: Api.login, payload: payload);
      // dev.log(res);
      if (res != null) {
        var user = jsonDecode(res);
        _storageService.save(
          key: 'user',
          value: res,
        );
        _storageService.save(
          key: "token",
          value: user['token'],
        );
        return user;
      } else {
        Get.rawSnackbar(
            title: "Unable to login",
            message: "Please contact app admin",
            backgroundColor: Colors.redAccent);
        return null;
      }
    } catch (e) {
      dev.log("ERROR LOGIN: $e");
      Get.rawSnackbar(
        message: "Error in login request!",
        backgroundColor: Colors.redAccent,
      );
      return throw Exception(e);
    }
  }

  // POST DETAILS
  static updateDetails({payload}) async {
    try {
      var header = {
        "Authorization": "Bearer ${_storageService.get(
          key: 'token',
        )}"
      };
      var res = await Network.post(
        url: Api.updateDetails,
        payload: payload,
        headers: header,
      );
      if (res != null) {
        var data = jsonDecode(res);
        _storageService.save(
          key: 'user',
          value: res,
        );
        Get.snackbar(
          "Updated!",
          data['message'],
          borderRadius: 50,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          maxWidth: 300,
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 20,
          ),
        );
        return data;
      } else {
        Get.rawSnackbar(
          title: "Unable to login",
          message: "Please contact app admin",
          backgroundColor: Colors.redAccent,
        );
        return null;
      }
    } catch (e) {
      dev.log("ERROR LOGIN: $e");
      Get.rawSnackbar(
          message: "Error in login request!",
          backgroundColor: Colors.redAccent);
      return throw Exception(e);
    }
  }

  // POST SITE DETAILS
  static Future<String> storeSiteDetails(
      {required Map<String, String> payload,
      List<http.MultipartFile>? files}) async {
    try {
      // dev.log(payload);
      var header = {
        "Authorization": "Bearer ${_storageService.get(
          key: 'token',
        )}"
      };
      var response = await Network.multiPartRequest(
        url: Api.postDetails,
        payload: payload,
        headers: header,
        files: files,
      );
      dev.log('POST SITE DETAIL: $response');
      if (response != null) {
        return response;
      } else {
        return '';
      }
    } on Exception catch (e) {
      dev.log("ERROR STORING DETAILS: $e");
      Get.rawSnackbar(
        message: "Error in Storing site details!",
        backgroundColor: Colors.redAccent,
      );
      return throw Exception(e);
    }
  }

  //SITE DETAILS
  static getSiteDetails() async {
    try {
      var header = {
        "Authorization": "Bearer ${_storageService.get(
          key: 'token',
        )}"
      };
      var data = _storageService.get(
        key: 'user',
      );
      data = jsonDecode(data);
      String? response = await Network.get(
          url: '${Api.siteDetails}${data['assigned_to_project_id']}',
          headers: header);
      if (response != null) {
        final data = jsonDecode(response);
        await _storageService.save(
          key: 'site_details',
          value: data,
        );
        return data;
      } else {
        Get.rawSnackbar(
            title: 'Unable to get site details',
            backgroundColor: Colors.redAccent);
        return null;
      }
    } on Exception catch (e) {
      dev.log("ERROR Getting Details: $e");
      Get.rawSnackbar(
          message: "Error getting site details",
          backgroundColor: Colors.redAccent);
      return throw Exception(e);
    }
  }

  //Physical Site types
  static Future<List<String>> getPhysicalSiteTypes() async {
    try {
      var header = {
        "Authorization": "Bearer ${_storageService.get(
          key: 'token',
        )}"
      };
      var data = _storageService.get(
        key: 'user',
      );
      var response = await Network.get(
        url: '${Api.physicalType}${data['assigned_to_project_id']}',
        headers: header,
      );
      var map = jsonDecode(response);
      List<String> types = List.castFrom(map['data']);
      return types;
    } on Exception catch (e) {
      dev.log('Error in Physical Data: $e');
      Get.rawSnackbar(
          message: "Error getting physical site types",
          backgroundColor: Colors.redAccent);
      return throw Exception(e);
    }
  }

  //Get Image Size
  static String getFileSizeString({required int bytes, int decimals = 0}) {
    if (bytes <= 0) return "0 Bytes";
    const suffixes = [" Bytes", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  //Weather Types
  static Future<List<String>> getWeatherTypes() async {
    try {
      var header = {
        "Authorization": "Bearer ${_storageService.get(
          key: 'token',
        )}"
      };
      var data = _storageService.get(
        key: 'user',
      );
      var response = await Network.get(
        url: '${Api.weatherType}${data['assigned_to_project_id']}',
        headers: header,
      );
      var map = jsonDecode(response);
      dev.log('Weather data: $response');
      List<String> types = List.castFrom(map['data']);
      return types;
    } on Exception catch (e) {
      dev.log('Error in Weather Data: $e');
      Get.rawSnackbar(
          message: "Error getting weather types",
          backgroundColor: Colors.redAccent);
      return throw Exception(e);
    }
  }

  static Future<List<Module>?> getModules({required int projectId}) async {
    try {
      var header = {
        "Authorization": "Bearer ${_storageService.get(
          key: 'token',
        )}"
      };
      final response = await Network.get(
        url: '${Api.getModules}$projectId',
        headers: header,
      );
      if (response != null) {
        List<dynamic> jsonList = jsonDecode(response);
        List<Module> modules = [];
        for (var element in jsonList) {
          modules.add(Module.fromJson(element));
        }
        dev.log('Modules data: $response');
        return modules;
      } else {
        return null;
      }
    } on Exception catch (e) {
      dev.log('Error in Modules Data: $e');
      Get.rawSnackbar(
        message: "Error getting Modules",
        backgroundColor: Colors.redAccent,
      );
      throw Exception(e);
    }
  }

  static Future<FormModel?> getFormBySubModuleId(
      {required String projectId, required int moduleId}) async {
    try {
      var header = {
        "Authorization": "Bearer ${_storageService.get(
          key: 'token',
        )}"
      };
      final response = await Network.get(
        url: '${Api.getForms}$projectId/$moduleId',
        headers: header,
      );
      if (response != null) {
        List<dynamic> jsonList = jsonDecode(response);
        FormModel? form;
        form = FormModel.fromJson(jsonList[0]);
        dev.log('Form: $response');
        return form;
      } else {
        return null;
      }
    } on Exception catch (e) {
      dev.log('Error in Forms Data: $e');
      Get.rawSnackbar(
        message: "Error getting Forms",
        backgroundColor: Colors.redAccent,
      );
      throw Exception(e);
    }
  }
}

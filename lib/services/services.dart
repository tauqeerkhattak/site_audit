import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/models/module_model.dart';
import 'package:site_audit/models/static_drop_model.dart';
import 'package:site_audit/services/local_storage_keys.dart';
import 'package:site_audit/services/local_storage_service.dart';
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
          key: userKey,
          value: res,
        );
        _storageService.save(
          key: tokenKey,
          value: user['token'],
        );
        return user;
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
          key: tokenKey,
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
          key: userKey,
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

  //STATIC DROPDOWNS
  static Future<StaticDropModel?> getStaticDropdowns(String projectId) async {
    try {
      if (Network.isNetworkAvailable.value) {
        dev.log('DATA IS COMING INTERNET');
        var header = {
          "Authorization": "Bearer ${_storageService.get(
            key: tokenKey,
          )}"
        };
        String? response = await Network.get(
          url: '${Api.siteDetails}$projectId',
          headers: header,
        );
        if (response != null) {
          await _storageService.save(
            key: staticValueKey,
            value: response,
          );
          final data = jsonDecode(response);
          return StaticDropModel.fromJson(data);
        } else {
          Get.rawSnackbar(
              title: 'Unable to get site details',
              backgroundColor: Colors.redAccent);
          return null;
        }
      } else {
        dev.log('DATA IS COMING LOCAL STORAGE');
        if (_storageService.hasKey(key: staticValueKey)) {
          final response = _storageService.get(key: staticValueKey);
          final data = jsonDecode(response);
          return StaticDropModel.fromJson(data);
        }
      }
    } on Exception catch (e) {
      dev.log("ERROR Getting Details: $e");
      Get.rawSnackbar(
          message: "Error getting site details",
          backgroundColor: Colors.redAccent);
      return throw Exception(e);
    }
    return null;
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
        key: userKey,
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
          key: tokenKey,
        )}"
      };
      var data = _storageService.get(
        key: userKey,
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
      if (Network.isNetworkAvailable.value) {
        dev.log('DATA IS COMING INTERNET');
        var header = {
          "Authorization": "Bearer ${_storageService.get(
            key: tokenKey,
          )}"
        };
        final response = await Network.get(
          url: '${Api.getModules}$projectId',
          headers: header,
        );
        if (response != null) {
          await _storageService.save(key: modulesKey, value: response);
          List<dynamic> jsonList = jsonDecode(response);
          List<Module> modules = [];
          for (var element in jsonList) {
            modules.add(Module.fromJson(element));
          }
          return modules;
        }
      } else {
        dev.log('DATA IS COMING LOCAL STORAGE');
        if (_storageService.hasKey(key: modulesKey)) {
          final response = _storageService.get(key: modulesKey);
          List<dynamic> jsonList = jsonDecode(response);
          List<Module> modules = [];
          for (var element in jsonList) {
            modules.add(Module.fromJson(element));
          }
          return modules;
        }
      }
    } on Exception catch (e) {
      dev.log('Error in Modules Data: $e');
      throw Exception(e);
    }
    return null;
  }

  static Future<FormModel?> getFormBySubModuleId(
      {required String projectId, required int moduleId}) async {
    try {
      final key = '$formKey$projectId$moduleId';
      if (Network.isNetworkAvailable.value) {
        dev.log('DATA IS COMING INTERNET');
        var header = {
          "Authorization": "Bearer ${_storageService.get(
            key: tokenKey,
          )}"
        };
        final response = await Network.get(
          url: '${Api.getForms}$projectId/$moduleId',
          headers: header,
        );
        if (response != null) {
          await _storageService.save(key: key, value: response);
          List<dynamic> jsonList = jsonDecode(response);
          FormModel? form;
          form = FormModel.fromJson(jsonList[0]);
          return form;
        } else {
          return null;
        }
      } else {
        dev.log('DATA IS COMING LOCAL STORAGE');
        if (_storageService.hasKey(key: key)) {
          final response = _storageService.get(key: key);
          List<dynamic> jsonList = jsonDecode(response);
          FormModel? form;
          form = FormModel.fromJson(jsonList[0]);
          return form;
        }
      }
    } on Exception catch (e) {
      dev.log('Error in Forms Data: $e');
      throw Exception(e);
    }
    return null;
  }

  static Future<String?> sendJson({
    required int moduleId,
    required int engineerId,
    required int projectId,
    dynamic json,
  }) async {
    var header = {
      "Authorization": "Bearer ${_storageService.get(
        key: tokenKey,
      )}"
    };
    final payload = {
      "module_id": moduleId,
      "engineer_id": engineerId,
      "project_id": projectId,
      "json": json.toString(),
    };
    final response = await Network.post(
      url: Api.postJson,
      payload: payload,
      headers: header,
    );
    if (response != null) {
      return response;
      /*final res = jsonDecode(response);
      print("=========>Response$res");
      if (res['status'] == 200) {
        dev.log('GONE $res');
        return res['message'];
      } else {
        dev.log('NOT GONE');
        return null;
      }*/
    } else {
      return null;
    }
  }

  static Future<String?> sendJsonFile({
    required int moduleId,
    required int projectId,
    required int engineerId,
    required File file,
  }) async {
    try {
      var header = {
        "Authorization": "Bearer ${_storageService.get(
          key: tokenKey,
        )}"
      };
      MultipartFile httpFile = await MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('text', 'json'),
      );
      final response = await Network.multiPartRequest(
        url: Api.postFile,
        headers: header,
        payload: {
          'module_id': '$moduleId',
          'project_id': '$projectId',
          'engineer_id': '$engineerId',
        },
        files: [
          httpFile,
        ],
      );
      return response;
    } on Exception catch (e) {
      dev.log('Error in sending json file: $e');
      throw Exception(e);
    }
  }
}

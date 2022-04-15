import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:site_audit/utils/network.dart';

import 'apis.dart';

class AppService {
  static GetStorage _box = GetStorage();

  // LOGIN ENGINEER
  static login({payload}) async {
    try {
      var res = await Network.post(url: Api.login, payload: payload);
      // print(res);
      if (res != null) {
        var user = jsonDecode(res);
        _box.write("user", user['user']);
        _box.write("token", user['token']);
        return user;
      } else {
        Get.rawSnackbar(
            title: "Unable to login",
            message: "Please contact app admin",
            backgroundColor: Colors.redAccent);
        return null;
      }
    } catch (e) {
      print("ERROR LOGIN: $e");
      Get.rawSnackbar(
          message: "Error in login request!",
          backgroundColor: Colors.redAccent);
      return throw Exception(e);
    }
  }

  // POST DETAILS
  static updateDetails({payload}) async {
    try {
      var header = {"Authorization": "Bearer ${_box.read('token')}"};
      var res = await Network.post(
          url: Api.updateDetails, payload: payload, headers: header);
      if (res != null) {
        var data = jsonDecode(res);
        _box.write("user", data['data']);
        Get.snackbar("Updated!", data['message'],
            borderRadius: 50,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            maxWidth: 300,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20));
        return data;
      } else {
        Get.rawSnackbar(
            title: "Unable to login",
            message: "Please contact app admin",
            backgroundColor: Colors.redAccent);
        return null;
      }
    } catch (e) {
      print("ERROR LOGIN: $e");
      Get.rawSnackbar(
          message: "Error in login request!",
          backgroundColor: Colors.redAccent);
      return throw Exception(e);
    }
  }

  // POST SITE DETAILS
  static Future<String> storeSiteDetails(
      {payload, List<http.MultipartFile>? files}) async {
    try {
      var header = {"Authorization": "Bearer ${_box.read('token')}"};
      var response = await Network.multiPartRequest(
        url: Api.postDetails,
        payload: payload,
        headers: header,
        files: files,
      );
      print('POST SITE DETAIL: $response');
      if (response != null) {
        return response;
      } else {
        return '';
      }
    } on Exception catch (e) {
      print("ERROR STORING DETAILS: $e");
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
      var header = {"Authorization": "Bearer ${_box.read('token')}"};
      var data = _box.read('user');
      String response = await Network.get(
          url: Api.siteDetails + '${data['assigned_to_project_id']}',
          headers: header);
      if (response != null) {
        final data = jsonDecode(response);
        await _box.write('site_details', data);
        return data;
      } else {
        Get.rawSnackbar(
            title: 'Unable to get site details',
            backgroundColor: Colors.redAccent);
        return null;
      }
    } on Exception catch (e) {
      print("ERROR Getting Details: $e");
      Get.rawSnackbar(
          message: "Error getting site details",
          backgroundColor: Colors.redAccent);
      return throw Exception(e);
    }
  }

  //Physical Site types
  static Future<List<String>> getPhysicalSiteTypes() async {
    try {
      var header = {"Authorization": "Bearer ${_box.read('token')}"};
      var data = _box.read('user');
      var response = await Network.get(
        url: Api.physicalType + '${data['assigned_to_project_id']}',
        headers: header,
      );
      var map = jsonDecode(response);
      print('Physical Site data: $response');
      List<String> types = List.castFrom(map['data']);
      return types;
    } on Exception catch (e) {
      print('Error in Physical Data: ' + e.toString());
      Get.rawSnackbar(
          message: "Error getting physical site types",
          backgroundColor: Colors.redAccent);
      return throw Exception(e);
    }
  }

  //Weather Types
  static Future<List<String>> getWeatherTypes() async {
    try {
      var header = {"Authorization": "Bearer ${_box.read('token')}"};
      var data = _box.read('user');
      var response = await Network.get(
        url: Api.weatherType + '${data['assigned_to_project_id']}',
        headers: header,
      );
      var map = jsonDecode(response);
      print('Weather data: $response');
      List<String> types = List.castFrom(map['data']);
      return types;
    } on Exception catch (e) {
      print('Error in Weather Data: ' + e.toString());
      Get.rawSnackbar(
          message: "Error getting weather types",
          backgroundColor: Colors.redAccent);
      return throw Exception(e);
    }
  }
}

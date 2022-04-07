import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:site_audit/utils/network.dart';

import 'apis.dart';

class AppService {
  static GetStorage _box = GetStorage();

  // LOGIN ENGINEER
  static login({payload}) async {
    try{
      var res = await Network.post(url: Api.login, payload: payload);
      // print(res);
      if(res != null) {
        var user = jsonDecode(res);
        _box.write("user", user['user']);
        _box.write("token", user['token']);
        return user;
      }
      else {
        Get.rawSnackbar(title: "Unable to login", message: "Please contact app admin", backgroundColor: Colors.redAccent);
        return null;
      }
    } catch(e){
      print("ERROR LOGIN: $e");
      Get.rawSnackbar(message: "Error in login request!", backgroundColor: Colors.redAccent);
      return throw Exception(e);
    }
  }

  // POST DETAILS
  static updateDetails({payload}) async {
    try{
      var header = {"Authorization" : "Bearer ${_box.read('token')}"};
      var res = await Network.post(url: Api.updateDetails, payload: payload, headers: header);
      if(res != null) {
        var data = jsonDecode(res);
        _box.write("user", data['data']);
        Get.snackbar("Updated!", data['message'],
          borderRadius: 50,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          maxWidth: 300,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20)
        );
        return data;
      }
      else {
        Get.rawSnackbar(title: "Unable to login", message: "Please contact app admin", backgroundColor: Colors.redAccent);
        return null;
      }
    } catch(e){
      print("ERROR LOGIN: $e");
      Get.rawSnackbar(message: "Error in login request!", backgroundColor: Colors.redAccent);
      return throw Exception(e);
    }
  }
}
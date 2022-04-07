import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:site_audit/utils/network.dart';

import 'apis.dart';

class AppService {
  static GetStorage _box = GetStorage();

  // SPOT DETAIL
  // static spotDetail({int? spotId}) async {
  //   try{
  //     var res = await Network.get(url: Api.spotDetail + spotId.toString());
  //     if(res != null)
  //       return Spot.fromMap(jsonDecode(res));
  //     return null;
  //   } catch(e){
  //     print("ERROR SPOT DETAIL: $e");
  //     Get.rawSnackbar(title: "Error in spot detail request!");
  //     return throw Exception(e);
  //   }
  // }

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
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/service/services.dart';

class AuthController extends GetxController {
  RxBool loading = false.obs;
  Rx<User> _user = User().obs;

  // TEXT EDITING CONTROLLERS
  TextEditingController loginId = TextEditingController();
  TextEditingController password = TextEditingController();

  User get user => _user.value;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loginId.text = "NEJ001";
    password.text = "PAS001NEX";
  }

  String? validator(String? value) {
    if (value!.isEmpty) {
      return 'Please this field must be filled';
    }
    else if (value.length < 3) {
      return 'Length is too short';
    }
    return null;
  }

  void handleLogin() async {
    if (formKey.currentState!.validate()) {
      try{
        FocusManager.instance.primaryFocus?.unfocus();
        loading.value = true;
        var payload = {
          "engineer_id": loginId.text,
          "password": password.text,
        };
        var res = await AppService.login(payload: payload);
        if(res != null) {
          _user.value = userFromMap(jsonEncode(res['user']));
          loading.value = false;
        }
        else {
          loading.value = false;
        }
      }
      catch (e) {
        print(e);
      }
      finally {
        loading.value = false;
      }
    }
  }
}
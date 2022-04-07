import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/service/services.dart';

class AuthController extends GetxController {
  RxBool loading = false.obs;
  Rx<User> _user = User().obs;
  PageController pageController = PageController();
  int index = 0;

  // TEXT EDITING CONTROLLERS
  TextEditingController loginId = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  User? get user => _user.value;

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

  Future handleLogin() async {
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
          setUpdateDetails();
          pageController.animateToPage(
            1,
            duration: Duration(milliseconds: 500),
            curve: Curves.linear,
          );
          // loading.value = false;
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

  void setUpdateDetails() {
   name.text = user!.name!;
   email.text = user!.email!;
   phone.text = user!.phone!;
  }

  Future submitDetails() async {
    if (formKey.currentState!.validate()) {
      try{
        FocusManager.instance.primaryFocus?.unfocus();
        loading.value = true;
        var payload = {
          "engineer_id": user!.id,
          "engineer_name": name.text,
          "engineer_email": email.text,
          "engineer_contact": phone.text,
        };
        var res = await AppService.updateDetails(payload: payload);
        if(res != null) {
          _user.value = userFromMap(jsonEncode(res['data']));
          pageController.animateToPage(
            2,
            duration: Duration(milliseconds: 500),
            curve: Curves.linear,
          );
          // loading.value = false;
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
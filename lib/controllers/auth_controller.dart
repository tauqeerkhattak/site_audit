import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/models/site_detail_model.dart';
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
  var siteDetails = SiteDetailModel().obs;
  User? get user => _user.value;

  //Dropdown Lists
  List <Datum> operators = <Datum>[].obs;
  List <Region> regions = <Region>[].obs;
  List <SubRegion> subRegions = <SubRegion>[].obs;
  List <ClusterId> clusters = <ClusterId>[].obs;
  List <SiteReference> siteIDs = <SiteReference>[].obs;

  //Current Dropdown values
  Rx<Datum> currentOperator = Datum().obs;
  Rx<Region> currentRegion = Region().obs;
  Rx<SubRegion> currentSubRegion = SubRegion().obs;
  Rx<ClusterId> currentCluster = ClusterId().obs;
  Rx<SiteReference> currentSite = SiteReference(id: '',name: '').obs;

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

  Future getSiteDetails () async {
    var response = await AppService.getSiteDetails();
    print('Response: ${response}');
    if (response != null) {
      siteDetails.value = SiteDetailModel.fromJson(response);
      operators = siteDetails.value.data!;
    }
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
          getSiteDetails();
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
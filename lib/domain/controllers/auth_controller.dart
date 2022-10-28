import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/services/local_storage_service.dart';
import 'package:site_audit/services/services.dart';
import 'package:site_audit/utils/ui_utils.dart';

import '../../models/static_drop_model.dart';
import '../../services/local_storage_keys.dart';
import '../../utils/constants.dart';

class AuthController extends GetxController {
  RxBool loading = false.obs;
  final Rx<User> _user = User().obs;
  PageController pageController = PageController(initialPage: 0);
  int index = 0;
  final storageService = Get.find<LocalStorageService>();

  // TEXT EDITING CONTROLLERS
  TextEditingController loginId = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController siteName = TextEditingController();

  User? get user => _user.value;

  final loginFormKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  final siteDataKey = GlobalKey<FormState>();

  //STATIC DROPDOWNS
  List<Datum> operators = <Datum>[].obs;
  List<Region> regions = <Region>[].obs;
  List<SubRegion> subRegions = <SubRegion>[].obs;
  List<ClusterId> clusters = <ClusterId>[].obs;
  List<SiteReference> siteIDs = <SiteReference>[].obs;

  //STATIC DROPDOWNS CURRENT VALUES
  Rxn<Datum?> currentOperator = Rxn<Datum?>();
  Rxn<Region?> currentRegion = Rxn<Region?>();
  Rxn<SubRegion?> currentSubRegion = Rxn<SubRegion?>();
  Rxn<ClusterId?> currentCluster = Rxn<ClusterId?>();
  Rxn<SiteReference?> currentSite = Rxn<SiteReference?>();

  Rxn<StaticDropModel> staticDrops = Rxn<StaticDropModel>();

  @override
  void onInit() {
    super.onInit();
    // TODO Uncomment this
    loginId.text = "NEXJAV001";
    password.text = "PASS001NEXJAV";
    getData();
  }

  Future<void> getData() async {
    try {
      loading.value = true;
      String? userData = storageService.get(key: userKey);
      if (userData != null) {
        final user = User.fromJson(jsonDecode(userData));
        final projectId = user.data?.projectId;
        await getStaticDropdowns(projectId!.toString());
        loading.value = false;
      } else {
        loading.value = false;
      }
    } catch (e) {
      log('Exception in authcontroller: $e');
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }

  Future<void> handleLogin() async {
    if (loginFormKey.currentState!.validate()) {
      try {
        FocusManager.instance.primaryFocus?.unfocus();
        loading.value = true;
        var payload = {
          "engineer_id": loginId.text,
          "password": password.text,
        };
        var res = await AppService.login(payload: payload);
        if (res != null) {
          _user.value = User.fromJson(res);
          setUpdateDetails();
          getData();
          loading.value = false;
          //TODO: Uncomment this to call Site Detail API
          pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
          );
          // loading.value = false;
        }
      } catch (e) {
        log('Error: $e');
        loading.value = false;
        UiUtils.showSnackBar(message: 'Error logging in, please try again!');
      }
    }
  }

  void setUpdateDetails() {
    name.text = user!.data!.engineerNameFull!;
    email.text = user!.data!.engineerEmailAddress!;
    phone.text = user!.data!.engineerMobileNumber!;
  }

  Future<void> updateEngineerDetails() async {
    try {
      loading.value = true;
      var payload = {
        'engineer_id': loginId.text,
        'engineer_name': name.text,
        'engineer_email': email.text,
        'engineer_contact': phone.text
      };
      final res = await AppService.updateDetails(payload: payload);
      if (res != null) {
        _user.value = User.fromJson(res);
        loading.value = false;
        Get.toNamed(AppRoutes.loadData);
      }
    } catch (e) {
      log('Error: $e');
      loading.value = false;
      Get.rawSnackbar(
        backgroundColor: Colors.red,
        message: 'Error: $e',
      );
    }
  }

  Future<void> getStaticDropdowns(String projectId) async {
    try {
      final data = await AppService.getStaticDropdowns(projectId);
      log("STATIC: $data");
      staticDrops.value = data;
      operators = staticDrops.value!.data!;
      loading.value = false;
    } catch (e) {
      log('Error in Static Dropdown: $e');
    }
  }

  void onSubmit() {
    if (siteDataKey.currentState!.validate()) {
      log('Hello');
      Map<String, dynamic> staticValues = {
        'operator': {
          'value': currentOperator.value?.toJson(),
          'items': operators.map((e) => e.toJson()).toList(),
        },
        'region': {
          'value': currentRegion.value?.toJson(),
          'items': regions.map((e) => e.toJson()).toList(),
        },
        'sub_region': {
          'value': currentSubRegion.value?.toJson(),
          'items': subRegions.map((e) => e.toJson()).toList(),
        },
        'cluster': {
          'value': currentCluster.value?.toJson(),
          'items': clusters.map((e) => e.toJson()).toList(),
        },
        'site_id': {
          'value': currentSite.value?.toJson(),
          'items': siteIDs.map((e) => e.toJson()).toList(),
        },
        'site_name': siteName.text,
      };
      storageService
          .save(key: siteDataStorageKey, value: staticValues)
          .then((value) {
        Get.offAllNamed(AppRoutes.home);
      }).catchError((error) {
        UiUtils.showSnackBar(
          message: 'Error: $error',
          color: Constants.errorColor,
        );
      });
    }
    // StaticValues staticValues = StaticValues.fromJson(model.staticValues!);
    //
    // // Static Dropdowns
    // currentOperator.value = staticValues.operator?.value;
    // currentRegion.value = staticValues.region?.value;
    // regions = staticValues.region?.items ?? [];
    // currentSubRegion.value = staticValues.subRegion?.value;
    // subRegions = staticValues.subRegion?.items ?? [];
    // currentCluster.value = staticValues.cluster?.value;
    // clusters = staticValues.cluster?.items ?? [];
    // currentSite.value = staticValues.siteId?.value;
    // siteIDs = staticValues.siteId?.items ?? [];
    // siteName.text = currentSite.value?.name ?? '';
  }
}

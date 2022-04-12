import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:site_audit/models/local_site_model.dart';
import 'package:site_audit/models/site_detail_model.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/screens/home_screen.dart';
import 'package:site_audit/service/services.dart';

class AuthController extends GetxController {
  RxBool loading = false.obs;
  Rx<User> _user = User().obs;
  PageController pageController = PageController();
  int index = 0;

  //IMAGE PICKER
  final ImagePicker _picker = ImagePicker();

  // TEXT EDITING CONTROLLERS
  TextEditingController loginId = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  TextEditingController siteName = TextEditingController();
  TextEditingController siteKeeper = TextEditingController();
  TextEditingController siteKeeperPhone = TextEditingController();
  TextEditingController surveyStart = TextEditingController();
  TextEditingController longitude = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController temperature = TextEditingController();

  var siteDetails = SiteDetailModel().obs;
  Rx<String> imagePath = ''.obs;
  Rx<File> image = File('').obs;
  User? get user => _user.value;

  //Dropdown Lists
  List<Datum> operators = <Datum>[].obs;
  List<Region> regions = <Region>[].obs;
  List<SubRegion> subRegions = <SubRegion>[].obs;
  List<ClusterId> clusters = <ClusterId>[].obs;
  List<SiteReference> siteIDs = <SiteReference>[].obs;
  List<String> physicalSiteTypes = <String>[].obs;
  List<String> weatherType = <String>[].obs;

  //Current Dropdown values
  Rx<Datum> currentOperator = Datum().obs;
  Rx<Region?> currentRegion = Region().obs;
  Rx<SubRegion> currentSubRegion = SubRegion().obs;
  Rx<ClusterId> currentCluster = ClusterId().obs;
  Rx<SiteReference> currentSite = SiteReference(id: '', name: '').obs;
  Rx<String> currentSiteTypes = ''.obs;
  Rx<String> currentWeather = ''.obs;

  //Dropdown Flags
  bool isRegionSelected = false;
  bool isSubRegionSelected = false;
  bool isClusterSelected = false;
  bool isSiteIDSelected = false;

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
    } else if (value.length < 3) {
      return 'Length is too short';
    }
    return null;
  }

  Future getSiteDetails() async {
    var response = await AppService.getSiteDetails();
    print('Response: $response');
    if (response != null) {
      siteDetails.value = SiteDetailModel.fromJson(response);
      operators = siteDetails.value.data!;
      physicalSiteTypes = await AppService.getPhysicalSiteTypes();
      weatherType = await AppService.getWeatherTypes();
    }
  }

  Future handleLogin() async {
    if (formKey.currentState!.validate()) {
      try {
        FocusManager.instance.primaryFocus?.unfocus();
        loading.value = true;
        var payload = {
          "engineer_id": loginId.text,
          "password": password.text,
        };
        var res = await AppService.login(payload: payload);
        if (res != null) {
          _user.value = userFromMap(jsonEncode(res['user']));
          setUpdateDetails();
          //TODO: Uncomment this to call Site Detail API
          getSiteDetails();
          pageController.animateToPage(
            1,
            duration: Duration(milliseconds: 500),
            curve: Curves.linear,
          );
          // loading.value = false;
        }
      } catch (e) {
        print(e);
      } finally {
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
      try {
        FocusManager.instance.primaryFocus?.unfocus();
        loading.value = true;
        var payload = {
          "engineer_id": user!.id,
          "engineer_name": name.text,
          "engineer_email": email.text,
          "engineer_contact": phone.text,
        };
        var res = await AppService.updateDetails(payload: payload);
        if (res != null) {
          _user.value = userFromMap(jsonEncode(res['data']));
          pageController.animateToPage(
            2,
            duration: Duration(milliseconds: 500),
            curve: Curves.linear,
          );
          // loading.value = false;
        }
      } catch (e) {
        print(e);
      } finally {
        loading.value = false;
      }
    }
  }

  Future<void> pickImage(ImageSource source) async {
    XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      print(imagePath.value);
      imagePath.value = file.path;
      image.value = File(file.path);
    }
  }

  Future<void> submitSiteDetails() async {
    PermissionStatus status = await Permission.storage.request();
    final GetStorage _box = GetStorage();
    if (status.isGranted) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;
      final String fileName = basename(imagePath.value);
      print(path + fileName);
      final File localImage = await image.value.copy(path + '/$fileName');
      print(localImage.path);
      LocalSite site = LocalSite(
        operator: currentOperator.value.datumOperator,
        region: currentRegion.value!.name,
        subRegion: currentSubRegion.value.name,
        cluster: currentCluster.value.id,
        siteID: currentSite.value.id,
        siteName: siteName.text,
        siteKeeperName: siteKeeper.text,
        siteKeeperPhone: siteKeeperPhone.text,
        siteType: currentSiteTypes.value,
        survey: surveyStart.text,
        latitude: latitude.text,
        longitude: longitude.text,
        weather: currentWeather.value,
        temperature: temperature.text,
        imagePath: localImage.path,
      );
      var data = site.toJson();
      _box.write(user!.id.toString(), data).then((value) {
        Get.to(() => HomeScreen());
      });
    }
  }
}

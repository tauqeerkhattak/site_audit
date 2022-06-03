import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' hide PermissionStatus;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:site_audit/models/local_site_model.dart';
import 'package:site_audit/models/site_detail_model.dart';
import 'package:site_audit/models/store_site_model.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/screens/home_screen.dart';
import 'package:site_audit/service/services.dart';
import 'package:site_audit/utils/network.dart';
import 'package:site_audit/widgets/custom_dialog.dart';

class AuthController extends GetxController {
  RxBool loading = false.obs;
  Rx<User> _user = User().obs;
  RxBool validated = true.obs;
  late PageController pageController;
  int index = 0;
  final key = GlobalKey<FormState>();

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
  Rx<File> image = File('').obs;
  User? get user => _user.value;
  StreamSubscription? sub;
  final GetStorage _box = GetStorage();

  //Dropdown Lists
  final RxList<Datum> operators = <Datum>[].obs;
  final RxList<Region> regions = <Region>[].obs;
  final RxList<SubRegion> subRegions = <SubRegion>[].obs;
  final RxList<ClusterId> clusters = <ClusterId>[].obs;
  final RxList<SiteReference> siteIDs = <SiteReference>[].obs;
  final RxList<String> physicalSiteTypes = <String>[].obs;
  final RxList<String> weatherType = <String>[].obs;

  //Current Dropdown values
  Rxn<Datum?> currentOperator = Rxn<Datum?>();
  Rxn<Region?> currentRegion = Rxn<Region?>();
  Rxn<SubRegion?> currentSubRegion = Rxn<SubRegion?>();
  Rxn<ClusterId?> currentCluster = Rxn<ClusterId?>();
  Rxn<SiteReference?> currentSite = Rxn<SiteReference?>();
  Rx<String> currentSiteTypes = ''.obs;
  Rx<String> currentWeather = ''.obs;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() async {
    initNetwork();
    if (_box.hasData('user')) {
      pageController = PageController(initialPage: 2);
    } else {
      pageController = PageController(initialPage: 0);
    }
    if (_box.hasData('site_details')) {
      if (Network.isAvailable) {
        await getSiteDetails();
      } else {
        print('Not Available');
        siteDetails.value =
            SiteDetailModel.fromJson(jsonDecode(_box.read('site_details')));
        operators.value = siteDetails.value.data!;
        print(siteDetails.value.data!.first.datumOperator);
        physicalSiteTypes.value =
            List.castFrom(_box.read('physical_site_type'));
        weatherType.value = List.castFrom(_box.read('weather_type'));
      }
    }
    setDataTime();
    super.onInit();
    // TODO Uncomment this
    // loginId.text = "NEJ001";
    // password.text = "PAS001NEX";
  }

  Future<void> setLocation() async {
    print('Set Location!');
    Location location = Location();
    LocationData locationData;
    if (await location.serviceEnabled()) {
      locationData = await location.getLocation();
      print('Location: ${locationData.time}');
      latitude.text = locationData.latitude.toString();
      longitude.text = locationData.longitude.toString();
    } else {
      bool serviceEnable = await location.requestService();
      if (serviceEnable) {
        locationData = await location.getLocation();
        print('Lat: ${locationData.latitude}');
        latitude.text = locationData.latitude.toString();
        longitude.text = locationData.longitude.toString();
      } else {
        print('Location service not enabled');
        CustomDialog.showCustomDialog(
          title: 'Error',
          content:
              'Location must be turned on to automatically get your location',
        );
      }
    }
  }

  initNetwork() {
    sub = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        log('No wifi or mobile');
        Network.isAvailable = false;
      } else {
        if (await hasNetwork()) {
          log('Internet available');
          Network.isAvailable = true;
          await submitSiteData();
        } else {
          log('Internet not available');
          Network.isAvailable = false;
        }
      }
    });
  }

  Future<bool> hasNetwork() async {
    try {
      var res = await get(Uri.parse('https://www.example.com/'));
      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      print('Exception: ${_.message}');
      return false;
    }
  }

  Future<void> submitSiteData() async {
    if (_box.hasData('user')) {
      var data = _box.read('user');
      User user = User.fromMap(data);
      if (_box.hasData(user.id.toString())) {
        print('Data exists!');
        var siteData = await _box.read(user.id.toString());
        LocalSiteModel model = LocalSiteModel.fromJson(siteData);
        DateTime now = DateTime.now();
        DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
        String date = format.parse(now.toString()).toString();
        var payload = {
          'system_datetime_of_insert': date.split('.').first,
          'internal_project_id': user.assignedToProjectId.toString(),
          'site_reference_id': model.siteId!,
          'site_reference_name': model.siteName!,
          'site_operator': model.localSiteModelOperator!,
          'site_location_region': model.region!,
          'site_location_sub_region': model.subRegion!,
          'site_belongs_to_cluster': model.cluster!,
          'site_keeper_name': model.siteKeeperName!,
          'site_keeper_phone_number': model.siteKeeperPhone!,
          'site_physical_type': model.siteType!,
          'site_longitude': model.longitude!,
          'site_latitude': model.latitude!,
          'site_altitude_above_sea_level': '4.6',
          'site_local_datetime_survey_start': model.survey!,
          'site_external_temperature': model.temperature!,
          'site_audit_weather_conditions': model.weather!,
          'row_id_of_audit_team': user.id.toString(),
          // 'site_additional_notes_1': 'Image Name: ${basename(model.imagePath!)}',
          // 'site_additional_notes_2': '',
          // 'site_additional_notes_3': ''
        };
        List<http.MultipartFile> files = [
          await http.MultipartFile.fromPath(
            'site_photo_from_main_entrance',
            model.imagePath!,
          ),
        ];
        var res =
            await AppService.storeSiteDetails(payload: payload, files: files);
        if (res != null) {
          StoreSiteModel model = StoreSiteModel.fromJson(jsonDecode(res));
          _box.remove(user.id.toString());
          Get.rawSnackbar(
            title: "Site Data submitted",
            message:
                "Locally saved data has been send to server automatically!",
            backgroundColor: Colors.green,
          );
        }
      } else {
        print('No data!');
      }
    } else {
      log('User not logged in');
    }
  }

  @override
  void dispose() {
    super.dispose();
    sub?.cancel();
  }

  String? stringValidator(String? value) {
    if (value == null) {
      return 'Please fill this field';
    } else if (value.isEmpty) {
      return 'Please fill this field';
    } else if (value.length < 2) {
      return 'Length is too short';
    }
    return null;
  }

  String? dynamicValidator(dynamic value) {
    if (value == null) {
      return 'Select a value!';
    }
    return null;
  }

  Future<void> getSiteDetails() async {
    _box.remove('site_details');
    var response =
        await AppService.getSiteDetails().timeout(const Duration(seconds: 25));
    log('Response: $response');
    if (response != null) {
      siteDetails.value = SiteDetailModel.fromJson(response);
      operators.value = siteDetails.value.data!;
      physicalSiteTypes.value = await AppService.getPhysicalSiteTypes();
      weatherType.value = await AppService.getWeatherTypes();
      _box.write('site_details', jsonEncode(siteDetails.value));
      _box.write('physical_site_type', physicalSiteTypes);
      _box.write('weather_type', weatherType);
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
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      XFile? file = await _picker.pickImage(source: source);
      if (file != null) {
        print(file.path);
        final bytes = File(file.path).lengthSync();
        final kb = bytes / 1024;
        final mb = kb / 1024;
        print('Size in MB: $mb');
        if (mb > 10) {
          CustomDialog.showCustomDialog(
            title: 'Error',
            content: 'Image size cannot be greater than 10 mb!',
          );
        } else {
          image.value = File(file.path);
        }
      }
    } else {
      CustomDialog.showCustomDialog(
        title: 'Permission required',
        content: 'Permission to Camera required to capture site images.',
      );
    }
  }

  void setDataTime() {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    String date = format.parse(now.toString()).toString();
    surveyStart.text = date.split('.').first;
  }

  Future<void> submitSiteDetails() async {
    var data = _box.read('user');
    User user = User.fromMap(data);
    if (image.value.path != '') {
      PermissionStatus status = await Permission.storage.request();
      final GetStorage _box = GetStorage();
      if (status.isGranted) {
        final Directory directory = await getApplicationDocumentsDirectory();
        final String path = directory.path;
        final String fileName = basename(image.value.path);
        print(path + fileName);
        final File localImage = await image.value.copy(path + '/$fileName');
        LocalSiteModel site = LocalSiteModel(
          localSiteModelOperator: currentOperator.value!.datumOperator,
          region: currentRegion.value!.name,
          subRegion: currentSubRegion.value!.name,
          cluster: currentCluster.value!.id,
          siteId: currentSite.value!.id,
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
        print('User: ${user.id}');
        _box.write(user.id.toString(), data).then(
          (value) {
            print('Go to next page');
            Get.to(() => HomeScreen());
          },
        );
      }
    } else {
      CustomDialog.showCustomDialog(
        title: 'Image missing',
        content: 'Please select an image first!',
      );
    }
  }
}

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

import '../service/encryption_service.dart';

class AuthController extends GetxController {
  RxBool loading = false.obs;
  Rx<User> _user = User().obs;
  late PageController pageController;
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
  TextEditingController altitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController temperature = TextEditingController();

  TextEditingController description1 = TextEditingController();
  TextEditingController description2 = TextEditingController();
  TextEditingController description3 = TextEditingController();

  var siteDetails = SiteDetailModel().obs;
  Rx<File> image = File('').obs;
  Rx<File> image1 = File('').obs;
  Rx<File> image2 = File('').obs;
  Rx<File> image3 = File('').obs;
  User? get user => _user.value;
  StreamSubscription? sub;
  final GetStorage _box = GetStorage();

  //Dropdown Lists
  List<Datum> operators = <Datum>[].obs;
  List<Region> regions = <Region>[].obs;
  List<SubRegion> subRegions = <SubRegion>[].obs;
  List<ClusterId> clusters = <ClusterId>[].obs;
  List<SiteReference> siteIDs = <SiteReference>[].obs;
  List<String> physicalSiteTypes = <String>[].obs;
  List<String> weatherType = <String>[].obs;

  //Current Dropdown values
  Rxn<Datum?> currentOperator = Rxn<Datum?>();
  Rxn<Region?> currentRegion = Rxn<Region?>();
  Rxn<SubRegion?> currentSubRegion = Rxn<SubRegion?>();
  Rxn<ClusterId?> currentCluster = Rxn<ClusterId?>();
  Rxn<SiteReference?> currentSite = Rxn<SiteReference?>();
  Rx<String> currentSiteTypes = ''.obs;
  Rx<String> currentWeather = ''.obs;

  final loginFormKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  final key = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initNetwork();
    if (_box.hasData('user')) {
      pageController = PageController(initialPage: 2);
    } else {
      pageController = PageController(initialPage: 0);
    }
    if (_box.hasData('site_details')) {
      print('Start');
      siteDetails.value =
          SiteDetailModel.fromJson(jsonDecode(_box.read('site_details')));
      operators = siteDetails.value.data!;
      print(siteDetails.value.data!.first.datumOperator);
      physicalSiteTypes = List.castFrom(_box.read('physical_site_type'));
      weatherType = List.castFrom(_box.read('weather_type'));
    }
    setDataTime();
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

  void initNetwork() {
    sub = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        print('No network!');
        Network.isNetworkAvailable = false;
      } else {
        if (await hasNetwork()) {
          Network.isNetworkAvailable = true;
          await submitSiteData();
          print('Network available!');
        } else {
          Network.isNetworkAvailable = false;
          print('No network!');
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
        Map<String, String> payload = {
          'system_datetime_of_insert': await EncryptionService.encrypt(date.split('.').first),
          'internal_project_id': await EncryptionService.encrypt(user.assignedToProjectId.toString()),
          'site_reference_id': await EncryptionService.encrypt(model.siteId!),
          'site_reference_name': await EncryptionService.encrypt(model.siteName!),
          'site_operator': await EncryptionService.encrypt(model.localSiteModelOperator!),
          'site_location_region': await EncryptionService.encrypt(model.region!),
          'site_location_sub_region': await EncryptionService.encrypt(model.subRegion!),
          'site_belongs_to_cluster': await EncryptionService.encrypt(model.cluster!),
          'site_keeper_name': await EncryptionService.encrypt(model.siteKeeperName!),
          'site_keeper_phone_number': await EncryptionService.encrypt(model.siteKeeperPhone!),
          'site_physical_type': await EncryptionService.encrypt(model.siteType!),
          'site_longitude': await EncryptionService.encrypt(model.longitude!),
          'site_latitude': await EncryptionService.encrypt(model.latitude!),
          'site_altitude_above_sea_level': await EncryptionService.encrypt('4.6'),
          'site_local_datetime_survey_start': await EncryptionService.encrypt(model.survey!),
          'site_external_temperature': await EncryptionService.encrypt(model.temperature!),
          'site_audit_weather_conditions': await EncryptionService.encrypt(model.weather!),
          'row_id_of_audit_team': await EncryptionService.encrypt(user.id.toString()),
        };
        if(model.image1description != null && model.image1description!.isNotEmpty){
          payload.addAll({'site_additional_notes_1': await EncryptionService.encrypt(model.image1description.toString()),});
        }
        if(model.image2description != null && model.image2description!.isNotEmpty){
          payload.addAll({'site_additional_notes_2': await EncryptionService.encrypt(model.image2description.toString())});
        }
        if(model.image3description != null && model.image3description!.isNotEmpty){
          print({'site_additional_notes_3': await EncryptionService.encrypt(model.image3description.toString())});
        }
        // Map<String, String> payload = {
        //   'system_datetime_of_insert': date.split('.').first,
        //   'internal_project_id': user.assignedToProjectId.toString(),
        //   'site_reference_id': model.siteId!,
        //   'site_reference_name': model.siteName!,
        //   'site_operator': model.localSiteModelOperator!,
        //   'site_location_region': model.region!,
        //   'site_location_sub_region': model.subRegion!,
        //   'site_belongs_to_cluster': model.cluster!,
        //   'site_keeper_name': model.siteKeeperName!,
        //   'site_keeper_phone_number': model.siteKeeperPhone!,
        //   'site_physical_type': model.siteType!,
        //   'site_longitude': model.longitude!,
        //   'site_latitude': model.latitude!,
        //   'site_altitude_above_sea_level': '4.6',
        //   'site_local_datetime_survey_start': model.survey!,
        //   'site_external_temperature': model.temperature!,
        //   'site_audit_weather_conditions': model.weather!,
        //   'row_id_of_audit_team': user.id.toString(),
        //   // 'site_additional_notes_1': model.image1description ?? "",
        //   // 'site_additional_notes_2': model.image2description ?? "",
        //   // 'site_additional_notes_3': model.image3description ?? "",
        // };
        // if(model.image1description != null && model.image1description!.isNotEmpty){
        //   payload.addAll({'site_additional_notes_1': model.image1description!});
        // }
        // if(model.image2description != null && model.image2description!.isNotEmpty){
        //   payload.addAll({'site_additional_notes_2': model.image3description!});
        // }
        // if(model.image3description != null && model.image3description!.isNotEmpty){
        //   print({'site_additional_notes_3': model.image3description!});
        // }
        List<http.MultipartFile> files = [
          await http.MultipartFile.fromPath('site_photo_from_main_entrance', model.imagePath!,),
          if(model.imagePath1 != null)
            await http.MultipartFile.fromPath('site_additional_photo_1_name', model.imagePath1!,),
          if(model.imagePath1 != null)
            await http.MultipartFile.fromPath('site_additional_photo_2_name', model.imagePath2!,),
          if(model.imagePath1 != null)
            await http.MultipartFile.fromPath('site_additional_photo_3_name', model.imagePath3!,),
        ];
        // print("TYPE::: ${payload.runtimeType}");
        var res = await AppService.storeSiteDetails(payload: payload, files: files);
        if (res != null) {
          StoreSiteModel model = StoreSiteModel.fromJson(jsonDecode(res));
          _box.remove(user.id.toString());
          Get.rawSnackbar(
            title: "Site Data submitted",
            message: "Locally saved data has been send to server automatically!",
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

  Future getSiteDetails() async {
    var response = await AppService.getSiteDetails();
    print('Response: $response');
    if (response != null) {
      siteDetails.value = SiteDetailModel.fromJson(response);
      operators = siteDetails.value.data!;
      physicalSiteTypes = await AppService.getPhysicalSiteTypes();
      weatherType = await AppService.getWeatherTypes();
      _box.write('site_details', jsonEncode(siteDetails.value));
      _box.write('physical_site_type', physicalSiteTypes);
      _box.write('weather_type', weatherType);
    }
  }

  Future handleLogin() async {
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

  Future handleMainEntrancePhoto() async {
    File? _img = await _pickImage(ImageSource.camera);
    if(_img != null)
      image.value = _img;
  }

  Future handleAdditionalPhoto1() async {
    File? _img = await _pickImage(ImageSource.camera);
    if(_img != null)
      image1.value = _img;
  }

  Future handleAdditionalPhoto2() async {
    File? _img = await _pickImage(ImageSource.camera);
    if(_img != null)
      image2.value = _img;
  }

  Future handleAdditionalPhoto3() async {
    File? _img = await _pickImage(ImageSource.camera);
    if(_img != null)
      image3.value = _img;
  }

  Future<File?> _pickImage(ImageSource source) async {
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
          return File(file.path);
          // image.value = File(file.path);
        }
      }
    } else {
      CustomDialog.showCustomDialog(
        title: 'Permission required',
        content: 'Permission to Camera required to capture site images.',
      );
    }
    return null;
  }

  void setDataTime() {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    String date = format.parse(now.toString()).toString();
    surveyStart.text = date.split('.').first;
  }

  Future<void> submitSiteDetails() async {
    if (key.currentState!.validate()) {
      var data = _box.read('user');
      User user = User.fromMap(data);
      if (image.value.path != '') {
        PermissionStatus status = await Permission.storage.request();
        // final GetStorage _box = GetStorage();
        if (status.isGranted) {
          final Directory directory = await getApplicationDocumentsDirectory();
          final String path = directory.path;
          final String fileName = basename(image.value.path);
          final String fileName1 = basename(image1.value.path);
          final String fileName2 = basename(image2.value.path);
          final String fileName3 = basename(image3.value.path);
          File? localImage1;
          File? localImage2;
          File? localImage3;
          // print(path + fileName);

          final File localImage = await image.value.copy(path + '/$fileName');
          if(fileName1.isNotEmpty)
            localImage1 = await image1.value.copy(path + '/$fileName1');
          if(fileName2.isNotEmpty)
            localImage2 = await image2.value.copy(path + '/$fileName2');
          if(fileName3.isNotEmpty)
            localImage3 = await image3.value.copy(path + '/$fileName3');


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
            image1description: description1.text,
            image2description: description2.text,
            image3description: description3.text,
            imagePath1: localImage1?.path ?? null,
            imagePath2: localImage2?.path ?? null,
            imagePath3: localImage3?.path ?? null,
          );
          var data = site.toJson();
          // print('JSON: $data');
          print('User: ${user.id}');
          await _box.write(user.id.toString(), data);
          print('Go to next page');
          Get.to(() => HomeScreen());
        }
      } else {
        CustomDialog.showCustomDialog(
          title: 'Image missing',
          content: 'Please select an image first!',
        );
      }
    }
  }
}

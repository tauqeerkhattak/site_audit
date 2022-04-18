import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
    super.onInit();
    initNetwork();
    if (_box.hasData('user')) {
      pageController = PageController(initialPage: 2);
    } else {
      pageController = PageController(initialPage: 0);
    }
    if (_box.hasData('site_details')) {
      // _box.write('site_details', siteDetails.value.toJson().toString());
      // _box.write('physical_site_type', physicalSiteTypes.toString());
      // _box.write('weather_type', weatherType.toString());
      print('Start');
      siteDetails.value =
          SiteDetailModel.fromJson(jsonDecode(_box.read('site_details')));
      operators = siteDetails.value.data!;
      print(siteDetails.value.data!.first.datumOperator);
      physicalSiteTypes = List.castFrom(_box.read('physical_site_type'));
      weatherType = List.castFrom(_box.read('weather_type'));
    }
    loginId.text = "NEJ001";
    password.text = "PAS001NEX";
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
    var data = _box.read('user');
    User user = User.fromMap(data);
    if (_box.hasData(user.id.toString())) {
      print('Data exists!');
      var siteData = await _box.read(user.id.toString());
      LocalSiteModel model = LocalSiteModel.fromJson(siteData);
      DateTime now = DateTime.now();
      DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
      // ),
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
        'row_id_of_audit_team': 1.toString(),
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
          message: "Locally saved data has been send to server automatically!",
          backgroundColor: Colors.green,
        );
      }
    } else {
      print('No data!');
    }
  }

  @override
  void dispose() {
    super.dispose();
    sub?.cancel();
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
    XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      print(file.path);
      image.value = File(file.path);
    }
  }

  void selectDateTime(TextEditingController textController) async {
    int seconds = DateTime.now().second;
    DateTime? surveyDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        Duration(
          days: 1000,
        ),
      ),
      lastDate: DateTime.now(),
    );
    TimeOfDay? surveyTime = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    //2022-03-31 18:24:23
    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    String date = format
        .parse(
            '${surveyDate.toString().split(' ').first} ${surveyTime?.hour}:${surveyTime?.minute}:${seconds.toString()}')
        .toString();
    textController.text = date.split('.').first;
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
          localSiteModelOperator: currentOperator.value.datumOperator,
          region: currentRegion.value!.name,
          subRegion: currentSubRegion.value.name,
          cluster: currentCluster.value.id,
          siteId: currentSite.value.id,
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

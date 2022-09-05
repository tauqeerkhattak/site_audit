import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/models/user_model.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/services/services.dart';
import 'package:site_audit/utils/ui_utils.dart';

class AuthController extends GetxController {
  RxBool loading = false.obs;
  final Rx<User> _user = User().obs;
  PageController pageController = PageController(initialPage: 0);
  int index = 0;

  //IMAGE PICKER
  // final ImagePicker _picker = ImagePicker();

  // TEXT EDITING CONTROLLERS
  TextEditingController loginId = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  User? get user => _user.value;

  final loginFormKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  final key = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // TODO Uncomment this
    loginId.text = "NEXJAV001";
    password.text = "PASS001NEXJAV";
  }

  Future<void> handleLogin() async {
    if (loginFormKey.currentState!.validate()) {
      try {
        log('Login pressed!');
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
        Get.offAndToNamed(AppRoutes.home);
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

  // Future handleMainEntrancePhoto() async {
  //   File? _img = await _pickImage(ImageSource.camera);
  //   if (_img != null) image.value = _img;
  // }
  //
  // Future handleAdditionalPhoto1() async {
  //   File? _img = await _pickImage(ImageSource.camera);
  //   if (_img != null) image1.value = _img;
  // }
  //
  // Future handleAdditionalPhoto2() async {
  //   File? _img = await _pickImage(ImageSource.camera);
  //   if (_img != null) image2.value = _img;
  // }
  //
  // Future handleAdditionalPhoto3() async {
  //   File? _img = await _pickImage(ImageSource.camera);
  //   if (_img != null) image3.value = _img;
  // }
  //
  // Future<File?> _pickImage(ImageSource source) async {
  //   PermissionStatus status = await Permission.camera.request();
  //   if (status.isGranted) {
  //     XFile? file = await _picker.pickImage(source: source);
  //     if (file != null) {
  //       print(file.path);
  //       final bytes = File(file.path).lengthSync();
  //       final kb = bytes / 1024;
  //       final mb = kb / 1024;
  //       print('Size in MB: $mb');
  //       if (mb > 10) {
  //         CustomDialog.showCustomDialog(
  //           title: 'Error',
  //           content: 'Image size cannot be greater than 10 mb!',
  //         );
  //       } else {
  //         return File(file.path);
  //         // image.value = File(file.path);
  //       }
  //     }
  //   } else {
  //     CustomDialog.showCustomDialog(
  //       title: 'Permission required',
  //       content: 'Permission to Camera required to capture site images.',
  //     );
  //   }
  //   return null;
  // }

  // void setDataTime() {
  //   DateTime now = DateTime.now();
  //   DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
  //   String date = format.parse(now.toString()).toString();
  //   surveyStart.text = date.split('.').first;
  // }

  // void saveImageToGallery(BuildContext context, File image) async {
  //   ScreenshotController controller = ScreenshotController();
  //   Uint8List imageData = await controller.captureFromWidget(
  //     _imageWidget(image),
  //     delay: Duration(
  //       seconds: 3,
  //     ),
  //   );
  //   final time = DateTime.now();
  //   DateFormat format = DateFormat("MMM-dd-yyyy_H_m_s");
  //   final directory = await getTemporaryDirectory();
  //   File file =
  //       await File('${directory.path}/${format.format(time)}.png').create();
  //   file.writeAsBytesSync(imageData);
  //   log('${file.path}');
  //   log('FOrmat: ${format.format(time)}');
  //   GallerySaver.saveImage(
  //     file.path,
  //     albumName: 'SiteAudit',
  //   ).then((value) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Image saved to gallery!"),
  //       ),
  //     );
  //   });
  // }
  //
  // Widget _imageWidget(File image) {
  //   return Container(
  //     clipBehavior: Clip.antiAlias,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8.0),
  //     ),
  //     child: Stack(
  //       children: [
  //         Image.file(
  //           image,
  //           fit: BoxFit.fill,
  //           // height: Get.height * 0.8,
  //           // width: Get.width,
  //         ),
  //         Positioned(
  //           bottom: 60,
  //           left: 20,
  //           child: Text(
  //             'Lat: ${latitude.text}',
  //             style: TextStyle(
  //               color: Colors.pink,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 12,
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           bottom: 40,
  //           left: 20,
  //           child: Text(
  //             'Long: ${longitude.text}',
  //             style: TextStyle(
  //               color: Colors.pink,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 12,
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           bottom: 20,
  //           left: 20,
  //           child: Text(
  //             'Dated: ${surveyStart.text}',
  //             style: TextStyle(
  //               color: Colors.pink,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 12,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

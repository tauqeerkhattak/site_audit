import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/controllers/splash_controller.dart';
import 'package:site_audit/utils/constants.dart';

class Splash extends StatelessWidget {
  final controller = Get.find<SplashController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/op_co_services.png',
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Constants.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

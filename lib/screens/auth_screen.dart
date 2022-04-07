import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:site_audit/controllers/auth_controller.dart';
import 'package:site_audit/screens/auth/confirm_detail.dart';
import 'package:site_audit/screens/auth/login.dart';
import 'package:site_audit/screens/auth/site_detail.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          children: [
            LoginScreen(controller: controller,),
            ConfirmDetail(controller: controller,),
            SiteDetail(controller: controller,)
          ],
        ),
      ),
    );
  }
}

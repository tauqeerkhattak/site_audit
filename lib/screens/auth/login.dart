import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/controllers/auth_controller.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class LoginScreen extends StatelessWidget {
  final AuthController controller;
  const LoginScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Stack(
      children: [
        Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/hand-drawn-5g.jpg",
              height: 300,
            )),
        SingleChildScrollView(
          // height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 30),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  "assets/images/op_co_services.png",
                  scale: 3.0,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'iServAudit',
                  style: _theme.textTheme.headline3,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Site Audit\nApp\nLogin:',
                  style: _theme.textTheme.headline4,
                ),
                SizedBox(
                  height: 10,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                      'Please enter the Engineer ID and Password that were supplied to you....',
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2.8,
                        // fontWeight: FontWeight.w400
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  placeHolder: "Engineer ID",
                  lines: 1,
                  controller: controller.loginId,
                  validator: controller.validator,
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                    placeHolder: "Password",
                    lines: 1,
                    controller: controller.password,
                    validator: controller.validator),
                SizedBox(
                  height: 30,
                ),
                Obx(
                  () => RoundedButton(
                    text: 'Login',
                    onPressed: controller.handleLogin,
                    loading: controller.loading(),
                    // width: controller.loading() ? 100 : Get.width,
                    width: Get.width,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

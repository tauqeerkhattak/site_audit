import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/auth_controller.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/utils/validator.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class LoginScreen extends StatelessWidget {
  final controller = Get.find<AuthController>();
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          child: Image.asset(
            "assets/images/hand-drawn-5g.jpg",
            height: 300,
          ),
        ),
        SingleChildScrollView(
          // height: MediaQuery.of(context).size.height,
          padding:
              const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 30),
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  "assets/images/op_co_services.png",
                  scale: 3.0,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'iServAudit',
                  style: theme.textTheme.headline3,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Site Audit\nApp\nLogin:',
                  style: theme.textTheme.headline4,
                ),
                const SizedBox(
                  height: 10,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Please enter the Engineer ID and Password that were supplied to you....',
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 2.8,
                      // fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InputField(
                  placeHolder: "Engineer ID",
                  lines: 1,
                  controller: controller.loginId,
                  validator: Validator.stringValidator,
                ),
                const SizedBox(
                  height: 20,
                ),
                InputField(
                  placeHolder: "Password",
                  lines: 1,
                  controller: controller.password,
                  validator: Validator.stringValidator,
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(
                  () => RoundedButton(
                    text: 'Login',
                    onPressed: controller.handleLogin,
                    loading: controller.loading(),
                    width: controller.loading() ? 1 : 1,
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/controllers/auth_controller.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class ConfirmDetail extends StatelessWidget {
  final AuthController controller;
  const ConfirmDetail({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Stack(
      children: [
        Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/images/33810963.jpg", height: 300,)
        ),

        SingleChildScrollView(
          padding: EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 30),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Confirm\nEngineer\nDetails:', style: _theme.textTheme.headline4,),
                SizedBox(height: 10,),
                InputField(placeHolder: "Name", controller: controller.name, validator: controller.validator,),
                SizedBox(height: 10,),
                InputField(placeHolder: "Email", controller: controller.email, validator: controller.validator,),
                SizedBox(height: 10,),
                InputField(placeHolder: "Phone", controller: controller.phone, validator: controller.validator,),
                SizedBox(height: 30,),
                Obx(() => RoundedButton(
                  text: 'Next',
                  onPressed: controller.submitDetails,
                  loading: controller.loading(),
                  width: controller.loading() ? 100 : Get.width,
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
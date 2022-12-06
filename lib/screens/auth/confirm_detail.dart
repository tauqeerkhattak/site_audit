import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/auth_controller.dart';
import 'package:site_audit/utils/validator.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class ConfirmDetail extends StatelessWidget {
  final controller = Get.find<AuthController>();
  ConfirmDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          child: Image.asset(
            "assets/images/33810963.jpg",
            height: 300,
          ),
        ),
        SingleChildScrollView(
          padding:
          const EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 30),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Confirm\nEngineer\nDetails:',
                  style: theme.textTheme.headline4,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  placeHolder: "Name",
                  controller: controller.name,
                  validator: Validator.stringValidator,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  placeHolder: "Email",
                  controller: controller.email,
                  validator: Validator.stringValidator,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  placeHolder: "Phone",
                  controller: controller.phone,
                  validator: Validator.stringValidator,
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(
                      () => RoundedButton(
                    text: 'Next',
                    onPressed: controller.updateEngineerDetails,
                    loading: controller.loading(),
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

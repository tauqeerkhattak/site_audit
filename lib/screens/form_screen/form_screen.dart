import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/controllers/form_controller.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/enums/enum_helper.dart';
import 'package:site_audit/utils/enums/input_type.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/widgets/custom_dropdown.dart';
import 'package:site_audit/widgets/custom_radio_button.dart';
import 'package:site_audit/widgets/default_layout.dart';
import 'package:site_audit/widgets/image_input.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class FormScreen extends StatelessWidget {
  final controller = Get.find<FormController>();
  FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundImage: 'assets/images/hand-drawn-5g.jpg',
      child: Padding(
        padding: UiUtils.allInsets10,
        child: _bodyWidget(),
      ),
    );
  }

  Widget _bodyWidget() {
    return Obx(
      () {
        if (controller.loading.value) {
          return Center(
            child: UiUtils.loadingIndicator,
          );
        } else {
          FormModel form = controller.form.value!;
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    '${form.subModuleName}',
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  itemBuilder: (context, index) {
                    Items item = form.items![index];
                    InputType type =
                        EnumHelper.inputTypeFromString(item.inputType);
                    return _inputWidget(type, item, index);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: form.items!.length,
                ),
              ),
              Expanded(
                flex: 1,
                child: RoundedButton(
                  text: 'Submit',
                  onPressed: () {
                    log('FINAL JSON: ${controller.data}');
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _inputWidget(InputType type, Items item, int index) {
    switch (type) {
      case InputType.DROPDOWN:
        List<String> options = item.inputOption!.inputOptions!;
        return Obx(
          () => CustomDropdown(
            items: options,
            label: item.inputLabel,
            value: controller.data['DROPDOWN$index']!.value,
            onChanged: (String? value) {
              controller.data['DROPDOWN$index']!.value = value!;
              log('OnChanged: $value ${controller.data['DROPDOWN$index']!.value}');
            },
          ),
        );
      case InputType.AUTO_FILLED:
        return InputField(
          controller: controller.data['AUTOFILLED$index']!.value,
          label: item.inputLabel,
          placeHolder: 'Tap to Enter Text',
          readOnly: true,
        );
      case InputType.TEXTBOX:
        return InputField(
          controller: controller.data['TEXTBOX$index']!.value,
          label: item.inputLabel,
          placeHolder: 'Tap to Enter Text',
        );
      case InputType.INTEGER:
        return InputField(
          controller: controller.data['INTEGER$index']!.value,
          label: item.inputLabel,
          placeHolder: 'Tap to Enter Text',
          inputType: TextInputType.number,
        );
      case InputType.PHOTO:
        return Obx(
          () => ImageInput(
            onTap: () async {
              final path = await controller.imagePickerService.pickImage();
              controller.data['PHOTO$index']!.value = path;
              log('Photo upload tapped!');
            },
            imagePath: controller.data['PHOTO$index']!.value,
            label: item.inputLabel,
            hint: 'Upload a picture',
          ),
        );
      case InputType.RADIAL:
        String? label = item.inputLabel;
        List<String> options = item.inputOption!.inputOptions!;
        return Obx(
          () => CustomRadioButton(
            label: label,
            options: options,
            value: controller.data['RADIAL$index']!.value,
            onChanged: (value) {
              controller.data['RADIAL$index']!.value = value;
            },
          ),
        );
      case InputType.FLOAT:
        return InputField(
          controller: controller.data['FLOAT$index']!.value,
          label: item.inputLabel,
          placeHolder: 'Tap to Enter Text',
          inputType: TextInputType.number,
        );
    }
  }
}

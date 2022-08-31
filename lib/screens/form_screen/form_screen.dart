import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/controllers/form_controller.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/enums/enum_helper.dart';
import 'package:site_audit/utils/enums/input_type.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/widgets/custom_dropdown.dart';
import 'package:site_audit/widgets/default_layout.dart';
import 'package:site_audit/widgets/image_input.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class FormScreen extends StatelessWidget {
  final controller = Get.find<FormController>();
  FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('Data from: ${controller.data['textController'].text}');
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
                    return _inputWidget(type, item);
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
                  onPressed: () {},
                ),
              ),
            ],
          );
          // return SingleChildScrollView(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.stretch,
          //     children: List.generate(
          //       form.items!.length,
          //       (index) {
          //       },
          //     ),
          //   ),
          // );
        }
      },
    );
  }

  Widget _inputWidget(InputType type, Items item) {
    switch (type) {
      case InputType.DROPDOWN:
        List<String> items = item.inputOption!.inputOptions!;
        String currentValue = items.first;
        return CustomDropdown(
          items: items,
          label: item.inputLabel,
          value: currentValue,
          onChanged: (String? value) {
            currentValue = value!;
          },
        );

      case InputType.AUTO_FILLED:
        return InputField(
          label: item.inputLabel,
          placeHolder: 'Tap to Enter Text',
          readOnly: true,
        );
      case InputType.TEXTBOX:
        return InputField(
          label: item.inputLabel,
          placeHolder: 'Tap to Enter Text',
        );
      case InputType.INTEGER:
        return InputField(
          label: item.inputLabel,
          placeHolder: 'Tap to Enter Text',
          inputType: TextInputType.number,
        );
      case InputType.PHOTO:
        return ImageInput(
          onTap: () {
            log('Photo upload tapped!');
          },
          label: item.inputLabel,
          hint: 'Upload a picture',
        );
      case InputType.RADIAL:
        String? label = item.inputLabel;
        List<String> options = item.inputOption!.inputOptions!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null)
              Text(
                label,
                style: TextStyle(
                  color: Constants.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (label != null) UiUtils.spaceVrt10,
            GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: SizeConfig.screenHeight * 0.06,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(options.length, (index) {
                return RadioListTile(
                  value: index.isEven,
                  title: Text(
                    options[index],
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  groupValue: 1,
                  onChanged: (value) {},
                );
              }),
            ),
          ],
        );
      case InputType.FLOAT:
        return InputField(
          label: item.inputLabel,
          placeHolder: 'Tap to Enter Text',
          inputType: TextInputType.number,
        );
    }
  }
}

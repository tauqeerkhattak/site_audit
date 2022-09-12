import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/review_controller.dart';
import 'package:site_audit/models/review_model.dart';
import 'package:site_audit/utils/enums/enum_helper.dart';
import 'package:site_audit/utils/enums/input_type.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/utils/widget_utils.dart';
import 'package:site_audit/widgets/custom_app_bar.dart';
import 'package:site_audit/widgets/custom_dropdown.dart';
import 'package:site_audit/widgets/default_layout.dart';
import 'package:site_audit/widgets/image_input.dart';
import 'package:site_audit/widgets/input_field.dart';

class FormReview extends StatelessWidget {
  final controller = Get.find<ReviewController>();

  FormReview({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CustomAppBar(
        titleText: '${controller.formName}',
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: UiUtils.allInsets8,
          child: Column(
            children: [
              ...staticDropdowns(),
              for (int i = 0; i < controller.formItem!.items!.length; i++)
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: getItem(controller.formItem!.items![i]),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getItem(Items item) {
    final type = EnumHelper.inputTypeFromString(item.inputType);
    final textInput = InputField(
      label: item.inputDescription,
      readOnly: true,
      controller: TextEditingController(
        text: item.answer != '' ? item.answer : 'No value entered!',
      ),
    );
    switch (type) {
      case InputType.DROPDOWN:
        return textInput;
      case InputType.AUTO_FILLED:
        return textInput;
      case InputType.TEXTBOX:
        return textInput;
      case InputType.INTEGER:
        return textInput;
      case InputType.PHOTO:
        return ImageInput(
          imagePath: null,
          hint: 'No picture uploaded!',
          base64: item.answer?.split(',').last,
          label: item.inputDescription,
          onTap: () {},
          isMandatory: false,
        );
      case InputType.RADIAL:
        return textInput;
      case InputType.FLOAT:
        return textInput;
    }
  }

  List<Widget> staticDropdowns() {
    return [
      Row(
        children: [
          operatorDrop(),
          WidgetUtils.spaceHrz10,
          subRegionDrop(),
        ],
      ),
      WidgetUtils.spaceVrt10,
      Row(
        children: [
          Expanded(
            child: InputField(
              label: 'Site Sub Region',
              readOnly: true,
              controller: TextEditingController(
                  // text: formItem.staticValues?.subRegion?.value,
                  ),
            ),
          ),
          WidgetUtils.spaceHrz10,
          Expanded(
            child: InputField(
              label: 'Site Cluster',
              readOnly: true,
              controller: TextEditingController(
                  // text: formItem.staticValues?.cluster?.value,
                  ),
            ),
          ),
        ],
      ),
      WidgetUtils.spaceVrt10,
      Row(
        children: [
          Expanded(
            child: InputField(
              label: 'Site ID',
              readOnly: true,
              controller: TextEditingController(
                  // text: formItem.staticValues?.siteId?.value,
                  ),
            ),
          ),
          WidgetUtils.spaceHrz10,
          Expanded(
            child: InputField(
              label: 'Site Name',
              readOnly: true,
              controller: TextEditingController(
                  // text: controller.formItem!.staticValues?.siteName,
                  ),
            ),
          ),
        ],
      ),
    ];
  }

  Widget operatorDrop() {
    return Expanded(
      child: CustomDropdown(
        label: 'Site Operator',
        onChanged: (value) {},
        hint: 'Select',
        items: controller.operators,
        value: controller.currentOperator.value,
      ),
    );
  }

  Widget subRegionDrop() {
    return Expanded(
      child: CustomDropdown(
        label: 'Site Region',
        onChanged: (value) {},
        hint: 'Select',
        items: controller.regions,
        value: controller.currentRegion.value,
      ),
    );
  }
}

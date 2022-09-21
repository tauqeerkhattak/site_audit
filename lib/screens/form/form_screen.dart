import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/form_controller.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/models/static_drop_model.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/enums/enum_helper.dart';
import 'package:site_audit/utils/enums/input_type.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/utils/validator.dart';
import 'package:site_audit/utils/widget_utils.dart';
import 'package:site_audit/widgets/custom_app_bar.dart';
import 'package:site_audit/widgets/custom_dropdown.dart';
import 'package:site_audit/widgets/custom_radio_button.dart';
import 'package:site_audit/widgets/default_layout.dart';
import 'package:site_audit/widgets/error_widget.dart';
import 'package:site_audit/widgets/image_input.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class FormScreen extends StatelessWidget {
  final controller = Get.find<FormController>();
  FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CustomAppBar(
        titleText: getTitleText(),
        backButton: GestureDetector(
          onTap: () {
            log('Go back');
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              CupertinoIcons.back,
              color: Constants.primaryColor,
              size: 30,
            ),
          ),
        ),
      ),
      backgroundImage: 'assets/images/hand-drawn-5g.jpg',
      child: Padding(
        padding: UiUtils.allInsets10,
        child: _bodyWidget(),
      ),
    );
  }

  String getTitleText() {
    String? title = controller.form.value?.items?.first.modules?.description;
    if (title != null) {
      return 'ADD $title';
    }
    final args = Get.arguments;
    title =
        '${args['module'].moduleName} >> ${args['subModule'].subModuleName}';
    return 'ADD $title';
  }

  Widget _bodyWidget() {
    return Obx(
      () {
        if (controller.loading.value) {
          return Center(
            child: UiUtils.loadingIndicator,
          );
        } else {
          if (controller.form.value == null) {
            return const CustomErrorWidget(
              errorText: 'Error getting forms.',
            );
          }
          FormModel form = controller.form.value!;
          return Column(
            children: [
              Expanded(
                flex: 11,
                child: Form(
                  key: controller.formDataKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: UiUtils.vertInsets8,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: operatorDrop(
                                  'Site Operator',
                                  controller.operators,
                                ),
                              ),
                              UiUtils.spaceHzt20,
                              Expanded(
                                child: regionDrop(
                                  'Site Region',
                                  controller.regions,
                                ),
                              ),
                            ],
                          ),
                          WidgetUtils.spaceVrt10,
                          Row(
                            children: [
                              Expanded(
                                child: subRegionDrop(
                                  'Site Sub-Region',
                                  controller.subRegions,
                                ),
                              ),
                              UiUtils.spaceHzt20,
                              Expanded(
                                child: clusterDrop(
                                  'Site Cluster',
                                  controller.clusters,
                                ),
                              ),
                            ],
                          ),
                          WidgetUtils.spaceVrt10,
                          Row(
                            children: [
                              Expanded(
                                child: siteIdDrop(
                                  'Site ID',
                                  controller.siteIDs,
                                ),
                              ),
                              UiUtils.spaceHzt20,
                              Expanded(
                                child: InputField(
                                  label: 'Site Name',
                                  placeHolder: 'Site Name',
                                  validator: Validator.stringValidator,
                                  controller: controller.siteName,
                                ),
                              ),
                            ],
                          ),
                          ...List.generate(form.items!.length, (index) {
                            Items item = form.items![index];
                            InputType type =
                                EnumHelper.inputTypeFromString(item.inputType);
                            return Column(
                              children: [
                                UiUtils.spaceVrt10,
                                _inputWidget(
                                  type,
                                  item,
                                  index,
                                ),
                                UiUtils.spaceVrt10,
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              RoundedButton(
                text: 'Submit',
                onPressed: controller.submit,
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
          () => CustomDropdown<String>(
            items: options,
            label: item.inputLabel,
            value: controller.data['DROPDOWN$index']!.value,
            validator:
                item.mandatory ?? true ? Validator.stringValidator : null,
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
          validator: item.mandatory ?? true ? Validator.stringValidator : null,
          readOnly: true,
        );
      case InputType.TEXTBOX:
        return InputField(
          controller: controller.data['TEXTBOX$index']!.value,
          label: item.inputLabel,
          placeHolder: 'Tap to Enter Text',
          validator: item.mandatory ?? true ? Validator.stringValidator : null,
        );
      case InputType.INTEGER:
        return InputField(
          controller: controller.data['INTEGER$index']!.value,
          label: item.inputLabel,
          placeHolder: 'Tap to Enter Text',
          inputType: TextInputType.number,
          validator: item.mandatory ?? true ? Validator.stringValidator : null,
        );
      case InputType.PHOTO:
        return Obx(
          () => ImageInput(
            onTap: () async {
              final path = await controller.imagePickerService.pickImage();
              log('PHOTO AT INDEX: $index');
              controller.data['PHOTO$index']!.value = path;
              log('Photo upload tapped!');
            },
            isMandatory: item.mandatory ?? false,
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
          validator: item.mandatory ?? true ? Validator.stringValidator : null,
        );
    }
  }

  Widget operatorDrop(label, List<Datum> items) {
    items = items.toSet().toList();
    return CustomDropdown<Datum?>(
      items: items,
      hint: 'Select',
      label: 'Site Operator',
      validator: Validator.dynamicValidator,
      value: controller.currentOperator.value,
      onChanged: (value) {
        controller.currentOperator.value = value!;
        controller.regions.clear();
        controller.regions.assignAll(controller.currentOperator.value!.region!);
        controller.currentRegion.value = null;
        controller.subRegions.clear();
        controller.currentSubRegion.value = null;
        controller.clusters.clear();
        controller.currentCluster.value = null;
        controller.siteIDs.clear();
        controller.currentSite.value = null;
        controller.siteName.text = '';
      },
    );
  }

  Widget regionDrop(label, List<Region> items) {
    items = items.toSet().toList();
    return CustomDropdown<Region>(
      items: items,
      label: 'Site Region',
      hint: 'Select',
      validator: Validator.dynamicValidator,
      value: controller.currentRegion.value,
      onChanged: (value) {
        controller.currentRegion.value = value!;
        controller.subRegions.assignAll(value.subRegion!);
        controller.currentSubRegion.value = null;
        controller.clusters.clear();
        controller.currentCluster.value = null;
        controller.siteIDs.clear();
        controller.currentSite.value = null;
        controller.siteName.text = '';
        log('VALUE: ${value.subRegion} LIST: ${controller.subRegions}');
      },
    );
  }

  Widget subRegionDrop(label, List<SubRegion> items) {
    items = items.toSet().toList();
    return CustomDropdown<SubRegion>(
      label: 'Site Sub-Region',
      hint: 'Select',
      validator: Validator.dynamicValidator,
      value: controller.currentSubRegion.value,
      items: items,
      onChanged: (value) {
        controller.currentSubRegion.value = value!;
        controller.clusters
            .assignAll(controller.currentSubRegion.value!.clusterId!);
        controller.currentCluster.value = null;
        controller.siteIDs.clear();
        controller.currentSite.value = null;
        controller.siteName.text = '';
      },
    );
  }

  Widget clusterDrop(label, List<ClusterId> items) {
    items = items.toSet().toList();
    return CustomDropdown<ClusterId>(
      label: 'Site Cluster',
      hint: 'Select',
      value: controller.currentCluster.value,
      validator: Validator.dynamicValidator,
      items: items,
      onChanged: (value) {
        controller.currentCluster.value = value!;
        controller.siteIDs
            .assignAll(controller.currentCluster.value!.siteReference!);
        controller.currentSite.value = null;
        controller.siteName.text = '';
      },
    );
  }

  Widget siteIdDrop(label, List<SiteReference> items) {
    items = items.toSet().toList();
    return CustomDropdown<SiteReference>(
      items: items,
      label: 'Site ID',
      hint: 'Select',
      value: controller.currentSite.value,
      validator: Validator.dynamicValidator,
      onChanged: (value) {
        controller.currentSite.value = value;
        controller.siteName.text = controller.currentSite.value!.name!;
      },
    );
  }
}

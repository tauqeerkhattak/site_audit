import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
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
import 'package:site_audit/widgets/custom_dropdown.dart';
import 'package:site_audit/widgets/custom_radio_button.dart';
import 'package:site_audit/widgets/default_layout.dart';
import 'package:site_audit/widgets/error_widget.dart';
import 'package:site_audit/widgets/image_input.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

import '../../utils/enums/input_parameter.dart';
import '../../widgets/custom_date_time.dart';

class FormScreen extends StatelessWidget {
  final controller = Get.find<FormController>();
  FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      // title: getTitleText(),
      titleWidget: Obx(() => getTitleText()),
      backgroundImage: 'assets/images/hand-drawn-5g.jpg',
      child: Padding(
        padding: UiUtils.allInsets10,
        child: _bodyWidget(context),
      ),
    );
  }

  Widget getTitleText() {
    return Text(
      controller.formName.value != null
          ? controller.formName.value!
          : 'ADD FORM DATA',
      overflow: TextOverflow.visible,
      style: const TextStyle(
        color: Constants.primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Obx(
      () {
        if (controller.loading.value) {
          return const Center(
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
                                  mandatory: true,
                                  mandatoryText: '*',
                                  validator: Validator.stringValidator,
                                  controller: controller.siteName,
                                ),
                              ),
                            ],
                          ),
                          _getMultiLevels(),
                          ...List.generate(
                            form.items!.length,
                            (index) {
                              Items item = form.items![index];
                              InputType type = EnumHelper.inputTypeFromString(
                                item.inputType,
                              );
                              InputParameter parameter =
                                  EnumHelper.inputParameterFromString(
                                item.inputParameter,
                              );
                              return Column(
                                children: [
                                  UiUtils.spaceVrt10,
                                  _inputWidget(
                                    context: context,
                                    type: type,
                                    item: item,
                                    index: index,
                                    parameter: parameter,
                                  ),
                                  UiUtils.spaceVrt10,
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              RoundedButton(
                text: 'Submit',
                onPressed: () async {
                  await controller.submit(context);
                },
              ),
            ],
          );
        }
      },
    );
  }

  Widget _inputWidget({
    required BuildContext context,
    required InputType type,
    required Items item,
    required int index,
    required InputParameter parameter,
  }) {
    final isEditable = parameter == InputParameter.EDITABLE;
    switch (type) {
      case InputType.DROPDOWN:
        List<String> options = item.inputOption?.first.inputOptions ?? [];
        return Obx(
          () => CustomDropdown<String>(
            items: options,
            label: item.inputLabel,
            hint: item.inputHint ?? 'Select Option',
            mandatory: item.mandatory ?? false,
            value: controller.data['DROPDOWN$index']!.value,
            validator:
                item.mandatory ?? true ? Validator.stringValidator : null,
            onChanged: (String? value) {
              controller.data['DROPDOWN$index']!.value = value!;
            },
            enabled: isEditable,
          ),
        );
      case InputType.TEXT:
        return InputField(
          controller: controller.data['TEXTBOX$index']!.value,
          label: item.inputLabel,
          mandatory: item.mandatory ?? false,
          placeHolder: item.inputHint ?? 'Tap to Enter Text',
          validator: item.mandatory ?? true ? Validator.stringValidator : null,
          readOnly: !isEditable,
        );
      case InputType.INTEGER:
        return InputField(
          controller: controller.data['INTEGER$index']!.value,
          label: item.inputLabel,
          mandatory: item.mandatory ?? false,
          placeHolder: item.inputHint ?? 'Tap to Enter Text',
          inputType: TextInputType.number,
          validator: item.mandatory ?? true ? Validator.stringValidator : null,
          readOnly: !isEditable,
        );
      case InputType.PHOTO:
        return Obx(
          () => ImageInput(
            onTap: () async {
              final path = await controller.imagePickerService.pickImage();
              controller.data['PHOTO$index']!.value = path;
            },
            isMandatory: item.mandatory ?? false,
            imagePath: controller.data['PHOTO$index']!.value,
            label: item.inputLabel,
            hint: item.inputHint ?? 'Upload a picture',
          ),
        );
      case InputType.RADIAL:
        String? label = item.inputLabel;
        List<String> options = item.inputOption!.first.inputOptions!;
        return Obx(
          () => CustomRadioButton(
            label: label,
            options: options,
            mandatory: item.mandatory ?? false,
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
          mandatory: item.mandatory ?? false,
          placeHolder: item.inputHint ?? 'Tap to Enter Text',
          inputType: TextInputType.number,
          validator: item.mandatory ?? true ? Validator.stringValidator : null,
          readOnly: !isEditable,
        );
      case InputType.LOCATION:
        List<TextEditingController> controllers =
            controller.data['LOCATION$index']!.value;
        return Row(
          children: [
            Expanded(
              child: InputField(
                controller: controllers[0],
                label: 'Latitude',
                mandatory: item.mandatory ?? false,
                placeHolder: item.inputHint ?? 'Tap to Enter Text',
                validator:
                    item.mandatory ?? true ? Validator.stringValidator : null,
                readOnly: !isEditable,
              ),
            ),
            UiUtils.spaceHzt20,
            Expanded(
              child: InputField(
                controller: controllers[1],
                label: 'Longitude',
                mandatory: item.mandatory ?? false,
                placeHolder: item.inputHint ?? 'Tap to Enter Text',
                validator:
                    item.mandatory ?? true ? Validator.stringValidator : null,
                readOnly: !isEditable,
              ),
            ),
          ],
        );
      case InputType.DATE_TIME:
        final dateTime = controller.data['DATETIME$index']!.value;
        return CustomDateTime(
          controller: TextEditingController(text: dateTime.toString()),
          type: DateTimePickerType.dateTime,
          label: item.inputLabel,
          mandatory: item.mandatory ?? false,
          dateMask: 'dd-M-yyyy hh:mm a',
          suffixIcon: isEditable
              ? const Icon(
                  Icons.calendar_month,
                  color: Constants.primaryColor,
                )
              : null,
          onSaved: (value) {
            if (value != null) {
              controller.data['DATETIME$index']!.value = value;
            }
          },
          placeHolder: item.inputHint ?? 'Tap to select date and time',
          validator: item.mandatory ?? true ? Validator.stringValidator : null,
          readOnly: !isEditable,
        );
      case InputType.DATE:
        final dateTime = controller.data['DATE$index']!.value;
        return CustomDateTime(
          controller: TextEditingController(text: dateTime.toString()),
          type: DateTimePickerType.date,
          mandatory: item.mandatory ?? false,
          label: item.inputLabel,
          dateMask: 'dd-M-yyyy',
          onSaved: (value) {
            if (value != null) {
              controller.data['DATE$index']!.value = value;
            }
          },
          suffixIcon: isEditable
              ? const Icon(
                  Icons.calendar_month,
                  color: Constants.primaryColor,
                )
              : null,
          placeHolder: item.inputHint ?? 'Tap to select date and time',
          validator: item.mandatory ?? true ? Validator.stringValidator : null,
          readOnly: !isEditable,
        );
      case InputType.TIME:
        TimeOfDay timeOfDay = controller.data['TIME$index']!.value;
        // timeOfDay = timeOfDay.get12HoursTime();
        return CustomDateTime(
          // controller: TextEditingController(
          //   text: timeOfDay.format(context),
          // ),
          timeOfDay: timeOfDay,
          type: DateTimePickerType.time,
          mandatory: item.mandatory ?? false,
          label: item.inputLabel,
          dateMask: 'hh:mm a',
          onSaved: (value) {
            log('CHANGED: $value');
            if (value != null) {
              final list = value.split(':');
              final hour = int.tryParse(list[0]);
              final minutes = int.tryParse(list[1]);
              if (hour != null && minutes != null) {
                controller.data['TIME$index']!.value = TimeOfDay(
                  hour: hour,
                  minute: minutes,
                );
              }
            }
          },
          suffixIcon: isEditable
              ? const Icon(
                  Icons.calendar_month,
                  color: Constants.primaryColor,
                )
              : null,
          placeHolder: item.inputHint ?? 'Tap to select date and time',
          validator: item.mandatory ?? true ? Validator.stringValidator : null,
          readOnly: !isEditable,
        );
      case InputType.TEXT_AREA:
        return InputField(
          controller: controller.data['TEXTAREA$index']!.value,
          label: item.inputLabel,
          placeHolder: 'Tap to Enter Text',
          lines: 3,
          validator: item.mandatory ?? true ? Validator.stringValidator : null,
          readOnly: !isEditable,
        );
      case InputType.TEXTBOX:
        return InputField(
          controller: controller.data['TEXTBOX$index']!.value,
          label: item.inputLabel,
          placeHolder: item.inputHint ?? 'Tap to Enter Text',
          validator: item.mandatory ?? true ? Validator.stringValidator : null,
          readOnly: !isEditable,
        );
      case InputType.MULTILEVEL:
        return const SizedBox.shrink();
    }
  }

  Widget _getMultiLevels() {
    int length = controller.multiLevels.length;
    List<Rxn<int>> optionIndex = List.generate(length, (index) {
      return Rxn(index == 0 ? 0 : null);
    });
    List<Rxn<String>> selectedValues = List.generate(length, (index) {
      return Rxn();
    });
    return Column(
      children: List.generate(
        length,
        (index) {
          final item = controller.multiLevels[index];
          return Obx(
            () {
              final currentIndex = optionIndex[index].value;
              return CustomDropdown<String?>(
                label: item.inputLabel,
                mandatory: item.mandatory ?? false,
                value: selectedValues[index].value,
                items: getItems(
                  item,
                  optionIndex[index].value,
                ),
                onChanged: (newValue) {
                  if (currentIndex != null) {
                    int valueIndex = item
                        .inputOption![currentIndex].inputOptions!
                        .indexOf(newValue!);
                    int thisID = item.id!;
                    Items? childItem =
                        controller.multiLevels.firstWhereOrNull((element) {
                      return element.parentInputId == thisID;
                    });
                    if (childItem != null) {
                      selectedValues[index].value = newValue;
                      for (int i = 0; i < length; i++) {
                        if (i == 0) {
                          optionIndex[i].value = 0;
                        } else {
                          optionIndex[i].value = null;
                        }
                      }
                      for (int i = 0; i < length; i++) {
                        if (i != index) {
                          selectedValues[i].value = null;
                        }
                      }
                      int childIndex =
                          controller.multiLevels.indexOf(childItem);
                      optionIndex[childIndex].value = valueIndex;
                    } else {
                      selectedValues[index].value = newValue;
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  List<String> getItems(Items item, int? index) {
    if (index != null) {
      final options = item.inputOption?[index].inputOptions;
      log('OPTION LENGTH: ${options?.length}');
      return options ?? [];
    } else {
      return [];
    }
  }

  Widget operatorDrop(label, List<Datum> items) {
    items = items.toSet().toList();
    return CustomDropdown<Datum?>(
      items: items,
      hint: 'Select',
      label: 'Site Operator',
      mandatory: true,
      mandatoryText: '*',
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

  Widget regionDrop(String label, List<Region> items) {
    items = items.toSet().toList();
    return CustomDropdown<Region>(
      items: items,
      label: label,
      hint: 'Select',
      validator: Validator.dynamicValidator,
      value: controller.currentRegion.value,
      mandatory: true,
      mandatoryText: '*',
      onChanged: (value) {
        controller.currentRegion.value = value!;
        controller.subRegions.assignAll(value.subRegion!);
        controller.currentSubRegion.value = null;
        controller.clusters.clear();
        controller.currentCluster.value = null;
        controller.siteIDs.clear();
        controller.currentSite.value = null;
        controller.siteName.text = '';
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
      mandatory: true,
      mandatoryText: '*',
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
      mandatory: true,
      mandatoryText: '*',
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
      mandatory: true,
      mandatoryText: '*',
      validator: Validator.dynamicValidator,
      onChanged: (value) {
        controller.currentSite.value = value;
        controller.siteName.text = controller.currentSite.value!.name!;
      },
    );
  }
}

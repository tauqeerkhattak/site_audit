import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/form_controller.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/enums/enum_helper.dart';
import 'package:site_audit/utils/enums/input_type.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/utils/validator.dart';
import 'package:site_audit/widgets/custom_dropdown.dart';
import 'package:site_audit/widgets/custom_grid_view.dart';
import 'package:site_audit/widgets/custom_radio_button.dart';
import 'package:site_audit/widgets/default_layout.dart';
import 'package:site_audit/widgets/error_widget.dart';
import 'package:site_audit/widgets/image_input.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

import '../../utils/enums/input_parameter.dart';
import '../../utils/widget_utils.dart';
import '../../widgets/custom_date_time.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  Rxn<FormModel> form = Rxn();
  final controller = Get.find<FormController>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
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

          return form.items!.isNotEmpty
              ? Column(
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
                                _getMultiLevels(),
                                ...List.generate(
                                  form.items!.length,
                                  (index) {
                                    Items item = form.items![index];
                                    InputType type =
                                        EnumHelper.inputTypeFromString(
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
                    WidgetUtils.spaceVrt10,
                    RoundedButton(
                      color: Colors.green,
                      text: _getButtonText(),
                      onPressed: () async {
                        await controller.submit(context);
                      },
                    ),
                  ],
                )
              : const Center(
                  child: Text(
                    "No Data Found",
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
        }
      },
    );
  }

  String _getButtonText() {
    final args = Get.arguments;
    if (args != null) {
      if (args['reviewForm'] != null) {
        return 'Update';
      } else {
        return 'Submit';
      }
    } else {
      return 'Submit';
    }
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
        String? value = controller.data['DROPDOWN$index']?.value;
        value = value == 'null' ? null : value;
        return CustomDropdown<String?>(
          items: options,
          label: item.inputLabel,
          hint: item.inputHint ?? 'Select Option',
          mandatory: item.mandatory ?? false,
          value: value,
          validator: item.mandatory ?? true ? Validator.stringValidator : null,
          onChanged: (String? value) {
            controller.data['DROPDOWN$index']!.value = value!;
          },
          enabled: isEditable,
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
              try {
                final path = await controller.imagePickerService.pickImage();
                controller.data['PHOTO$index']!.value = path;
              } catch (e) {
                print("=========>>>>>>>>Errror: $e");
              }
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
                readOnly: true,
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
                readOnly: true,
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
    // List<Rxn<String>> selectedValues = controller.data['MULTILEVEL']!;
    final keys = controller.multiLevels.keys.toList();
    return Column(
      children: List.generate(
        keys.length,
        (itemIndex) {
          List<Items> multiLevels = controller.multiLevels[itemIndex]!;
          List<Rxn<int>> optionList = controller.optionIndex[itemIndex]!;
          return CustomGridView(
            length: multiLevels.length,
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 5,
            ),
            scrollPhysics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, gridIndex) {
              final item = multiLevels[gridIndex];
              return Obx(
                () {
                  final currentIndex = optionList[gridIndex].value;
                  return CustomDropdown<String?>(
                    label: item.inputLabel,
                    mandatory: item.mandatory ?? false,
                    value: controller
                        .data['MULTILEVEL'][itemIndex][gridIndex].value,
                    hint: item.inputHint ?? 'Select a value',
                    validator: Validator.stringValidator,
                    mandatoryText: "*",
                    items: getItems(
                      item,
                      optionList[gridIndex].value,
                    ),
                    onChanged: (newValue) => onMultilevelChanged(
                      value: newValue,
                      currentOptionIndex: currentIndex,
                      columnIndex: itemIndex,
                      gridIndex: gridIndex,
                      currentItem: item,
                      items: multiLevels,
                      optionList: optionList,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void onMultilevelChanged({
    required Items currentItem,
    required List<Items> items,
    required int columnIndex,
    required int gridIndex,
    required List<Rxn<int>> optionList,
    String? value,
    int? currentOptionIndex,
  }) {
    if (currentOptionIndex != null) {
      int valueIndex = currentItem
          .inputOption![currentOptionIndex].inputOptions!
          .indexOf(value!);
      int thisID = currentItem.id!;
      Items? childItem = items.firstWhereOrNull((element) {
        return element.parentInputId == thisID;
      });
      if (childItem != null) {
        controller.data['MULTILEVEL'][columnIndex][gridIndex].value = value;
        for (int i = 0; i < items.length; i++) {
          if (i > gridIndex) {
            optionList[i].value = null;
          }
        }
        for (int i = 0; i < items.length; i++) {
          if (i > gridIndex) {
            controller.data['MULTILEVEL'][columnIndex][i].value = null;
          }
        }
        int childIndex = items.indexOf(childItem);
        optionList[childIndex].value = valueIndex;
        // controller.optionIndex[childIndex].value = valueIndex;
      } else {
        controller.data['MULTILEVEL'][columnIndex][gridIndex].value = value;
      }
    }
  }

  List<String> getItems(Items item, int? index) {
    try {
      if (index != null) {
        final options = item.inputOption![index].inputOptions;
        return options ?? [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

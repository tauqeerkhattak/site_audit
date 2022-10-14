import 'package:site_audit/utils/enums/input_type.dart';
import 'package:site_audit/utils/ui_utils.dart';

class Validator {
  static String? stringValidator(String? value) {
    if (value == null) {
      return 'Please fill this field';
    } else if (value.isEmpty) {
      return 'Please fill this field';
    } else if (value.length < 2) {
      return 'Length is too short';
    }
    return null;
  }

  static String? dynamicValidator(dynamic value) {
    if (value == null) {
      return 'Select a value!';
    }
    return null;
  }

  static bool validateField(dynamic fieldValue, InputType type) {
    switch (type) {
      case InputType.DROPDOWN:
        return (fieldValue != null && fieldValue != '');
      case InputType.INTEGER:
        return true;
      case InputType.PHOTO:
        bool value = (fieldValue != null && fieldValue != '');
        if (!value) {
          UiUtils.showSnackBar(
            message: 'Please upload all required photos!',
          );
        }
        return value;
      case InputType.RADIAL:
        return (fieldValue != null && fieldValue != '');
      case InputType.FLOAT:
        return true;
      case InputType.LOCATION:
        return true;
      case InputType.DATE_TIME:
        return (fieldValue != null && fieldValue != '');
      case InputType.DATE:
        return (fieldValue != null && fieldValue != '');
      case InputType.TIME:
        return (fieldValue != null && fieldValue != '');
      case InputType.TEXT:
        return true;
      case InputType.TEXT_AREA:
        return true;
      case InputType.TEXTBOX:
        return true;
    }
  }
}

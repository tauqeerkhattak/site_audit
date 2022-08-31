import 'package:site_audit/utils/enums/input_type.dart';

class EnumHelper {
  static InputType inputTypeFromString(String? value) {
    return InputType.values.byName(value!);
  }
}

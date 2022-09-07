import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/ui_utils.dart';

import '../models/static_drop_model.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String? label, hint;
  final String? Function(T?)? validator;
  final Function(T?) onChanged;
  final bool enabled;
  const CustomDropdown({
    Key? key,
    required this.items,
    this.label,
    this.hint,
    required this.onChanged,
    this.value,
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            '$label',
            style: TextStyle(
              color: Constants.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (label != null) UiUtils.spaceVrt10,
        Center(
          child: DropdownButtonFormField<T>(
            hint: Text(
              hint ?? 'Please select a value!',
              style: TextStyle(
                fontFamily: 'Ubuntu',
                color: Colors.grey.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            decoration: InputDecoration(
              enabled: enabled,
              filled: true,
              fillColor: Colors.white,
              // constraints: const BoxConstraints(
              //   minHeight: 60,
              //   maxHeight: 60,
              // ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(
                  color: Constants.primaryColor,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(
                  color: Constants.primaryColor.withOpacity(0.4),
                  width: 2.0,
                ),
                // borderSide: BorderSide(color: Colors.white),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(
                  color: Colors.redAccent.withOpacity(0.4),
                  width: 2.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(
                  color: Constants.primaryColor.withOpacity(0.4),
                  width: 2.0,
                ),
                // borderSide: BorderSide(color: Colors.white),
              ),
            ),
            validator: validator,
            value: value,
            borderRadius: BorderRadius.circular(20),
            items: items.map((T newValue) {
              return DropdownMenuItem<T>(
                value: newValue,
                child: Text(getString(newValue)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  String getString(dynamic value) {
    switch (value.runtimeType) {
      case String:
        return value.toString();
      case Datum:
        return value!.operator;
      case Region:
        return value!.name;
      case SubRegion:
        return value!.name;
      case ClusterId:
        return value!.id;
      case SiteReference:
        return value!.id;
      default:
        return value.toString();
    }
  }
}

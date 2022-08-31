import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/ui_utils.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String value;
  final String? label;
  final Function(String?) onChanged;
  const CustomDropdown({
    Key? key,
    required this.items,
    this.label,
    required this.onChanged,
    required this.value,
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
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Constants.primaryColor.withOpacity(0.4),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: DropdownButton<String>(
              value: value,
              underline: const SizedBox(),
              items: items.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

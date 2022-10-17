import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/widgets/custom_grid_view.dart';

class CustomRadioButton extends StatelessWidget {
  final List<String> options;
  final String value;
  final String? label;
  final Function(dynamic value) onChanged;

  const CustomRadioButton({
    Key? key,
    required this.options,
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
            label!,
            style: const TextStyle(
              color: Constants.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (label != null) UiUtils.spaceVrt10,
        CustomGridView(
          scrollPhysics: const NeverScrollableScrollPhysics(),
          length: options.length,
          crossAxisCount: 2,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: options[index],
              title: Text(
                options[index],
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Constants.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              activeColor: Constants.primaryColor,
              contentPadding: EdgeInsets.zero,
              dense: true,
              groupValue: value,
              onChanged: onChanged,
            );
          },
        ),
        // GridView(
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 2,
        //     mainAxisExtent: SizeConfig.screenHeight * 0.06,
        //   ),
        //   physics: const NeverScrollableScrollPhysics(),
        //   shrinkWrap: true,
        //   children: List.generate(options.length, (index) {
        //     return RadioListTile(
        //       value: options[index],
        //       title: Text(
        //         index == 2
        //             ? "fsafbvkjcbdsvbdvjkkdsnvdsknvdsjkvjk"
        //             : options[index],
        //         textAlign: TextAlign.justify,
        //         style: const TextStyle(
        //           color: Constants.primaryColor,
        //           fontWeight: FontWeight.bold,
        //           fontSize: 14,
        //         ),
        //       ),
        //       activeColor: Constants.primaryColor,
        //       contentPadding: EdgeInsets.zero,
        //       dense: true,
        //       groupValue: value,
        //       onChanged: onChanged,
        //     );
        //   }),
        // ),
      ],
    );
  }
}

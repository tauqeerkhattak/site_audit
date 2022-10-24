import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../utils/constants.dart';
import '../utils/size_config.dart';
import '../utils/ui_utils.dart';

class CustomDateTime extends StatefulWidget {
  const CustomDateTime({
    Key? key,
    required this.type,
    this.onTap,
    this.placeHolder,
    this.readOnly,
    this.timeOfDay,
    this.icon,
    this.suffixIcon,
    this.initialDate,
    this.vertical,
    this.horizontal,
    this.lines,
    this.controller,
    this.validator,
    this.inputType,
    this.label,
    this.dateMask,
    this.onSaved,
    this.mandatoryText,
    this.mandatory = false,
  }) : super(key: key);

  final DateTimePickerType type;
  final String? placeHolder;
  final DateTime? initialDate;
  final String? label, mandatoryText;
  final String? dateMask;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool? readOnly;
  final bool mandatory;
  final TimeOfDay? timeOfDay;
  final double? vertical, horizontal;
  final VoidCallback? onTap;
  final int? lines;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;

  @override
  State<CustomDateTime> createState() => _CustomDateTimeState();
}

class _CustomDateTimeState extends State<CustomDateTime> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: widget.vertical ?? 1.0,
        horizontal: widget.horizontal ?? 1.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Row(
              mainAxisAlignment: widget.mandatoryText != null
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.label}',
                  style: const TextStyle(
                    color: Constants.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.mandatory)
                  Text(
                    widget.mandatoryText ?? '* Required',
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          if (widget.label != null) UiUtils.spaceVrt10,
          DateTimePicker(
            type: widget.type,
            initialTime: widget.timeOfDay,
            controller: widget.controller,
            dateMask: widget.dateMask,
            use24HourFormat: false,
            locale: Localizations.localeOf(context),
            // onSaved:,
            initialValue: widget.timeOfDay?.format(context),
            validator: widget.validator,
            initialDate: widget.initialDate,
            firstDate: DateTime(1800),
            lastDate: DateTime(3000),
            readOnly: widget.readOnly ?? false,
            maxLines: widget.lines ?? 1,
            style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.4),
            onChanged: widget.onSaved,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: widget.placeHolder.toString(),
              prefixIcon: widget.icon,
              suffixIcon: widget.suffixIcon,
              hintStyle: GoogleFonts.roboto(
                color: Colors.grey.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: const BorderSide(
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
            ),
          ),
        ],
      ),
    );
  }
}

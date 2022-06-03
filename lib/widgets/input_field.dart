import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/size_config.dart';

class InputField extends StatelessWidget {
  const InputField({Key? key, this.onTap, this.placeHolder, this.readOnly, this.icon, this.vertical, this.horizontal, this.lines, this.controller, this.validator, this.inputType}) : super(key: key);

  final String? placeHolder;
  final Widget? icon;
  final bool? readOnly;
  final double? vertical, horizontal;
  final VoidCallback? onTap;
  final int? lines;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
          // color: Colors.white,
          borderRadius: new BorderRadius.circular(18.0),
          // boxShadow: [
          //   BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 2.0, spreadRadius: 0.2, offset: Offset(0.0, 0.0))
          // ]
          ),
      clipBehavior: Clip.antiAlias,
      child: TextFormField(
        controller: controller,
        validator: validator,
        readOnly: readOnly ?? false,
        onTap: onTap,
        keyboardType: inputType,
        maxLines: lines ?? 1,
        style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.4),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: placeHolder.toString(),
          prefixIcon: icon,
          hintStyle: TextStyle(fontFamily: 'Ubuntu', color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.w500),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: Constants.primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: Constants.primaryColor.withOpacity(0.4)),
            // borderSide: BorderSide(color: Colors.white),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

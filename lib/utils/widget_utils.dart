import 'package:flutter/material.dart';

class WidgetUtils {
  static SizedBox spaceVrt10 = SizedBox(height: 10.0,);
  static SizedBox spaceVrt20 = SizedBox(height: 20.0,);
  static SizedBox spaceVrt30 = SizedBox(height: 30.0,);
  static SizedBox spaceVrt40 = SizedBox(height: 40.0,);
  static SizedBox spaceHrz20 = SizedBox(width: 20.0,);

  static InputDecoration decoration({String? hint}) {
    return InputDecoration(
      isDense: true,
      filled: true,
      hintText: hint,
      fillColor: Colors.white,
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        gapPadding: 0.0,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        borderSide: BorderSide(color: Color(0xffBDBDBD).withOpacity(0.5)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        gapPadding: 0.0,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }
}
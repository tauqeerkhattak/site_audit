import 'package:flutter/material.dart';

class Constants {
  // static String baseUrl = "eusopht.com";
  static String baseUrl = 'securesiteauditbe01.com';
  static Color primaryColor = Color(0xff0E4A86);

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

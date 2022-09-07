import 'package:flutter/material.dart';

class WidgetUtils {
  static SizedBox spaceVrt10 = const SizedBox(
    height: 10.0,
  );
  static SizedBox spaceVrt20 = const SizedBox(
    height: 20.0,
  );
  static SizedBox spaceVrt30 = const SizedBox(
    height: 30.0,
  );
  static SizedBox spaceVrt40 = const SizedBox(
    height: 40.0,
  );
  static SizedBox spaceHrz10 = const SizedBox(
    width: 10.0,
  );
  static SizedBox spaceHrz20 = const SizedBox(
    width: 20.0,
  );

  static InputDecoration decoration({String? hint}) {
    return InputDecoration(
      isDense: true,
      filled: true,
      hintText: hint,
      fillColor: Colors.white,
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide.none,
        gapPadding: 0.0,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        borderSide: BorderSide(color: const Color(0xffBDBDBD).withOpacity(0.5)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide.none,
        gapPadding: 0.0,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }
}

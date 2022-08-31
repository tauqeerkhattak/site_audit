import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';

class UiUtils {
  static const allInsets8 = EdgeInsets.all(8.0);
  static const allInsets10 = EdgeInsets.all(10.0);

  static const spaceVrt10 = SizedBox(
    height: 10,
  );

  static final loadingIndicator = CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(
      Constants.primaryColor,
    ),
  );
}

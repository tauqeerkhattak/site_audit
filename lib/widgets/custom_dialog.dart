import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/utils/constants.dart';

class CustomDialog {
  static showCustomDialog({
    required String title,
    required String content,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Constants.primaryColor,
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          content,
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(18.0),
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'Okay',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

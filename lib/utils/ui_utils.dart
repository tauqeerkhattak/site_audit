import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/utils/constants.dart';

class UiUtils {
  static const allInsets8 = EdgeInsets.all(8.0);
  static const allInsets10 = EdgeInsets.all(10.0);
  static const vertInsets8 = EdgeInsets.symmetric(
    vertical: 8,
  );

  static const spaceVrt10 = SizedBox(
    height: 10,
  );

  static const spaceVrt20 = SizedBox(
    height: 20,
  );

  static const spaceHzt20 = SizedBox(
    width: 20,
  );

  static const loadingIndicator = CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(
      Constants.primaryColor,
    ),
  );

  static final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(18.0),
    borderSide: const BorderSide(
      color: Colors.red,
      width: 2.0,
    ),
  );

  static void showSnackBar({required String message, Color? color}) {
    Get.rawSnackbar(
      message: message,
      backgroundColor: color ?? Colors.black,
      icon: const Icon(
        Icons.info,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP,
    );
  }

  static void showSimpleDialog(
      {required context, required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              color: Constants.primaryColor,
            ),
          ),
          content: Text(
            content,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                'Okay',
                style: TextStyle(
                  color: Constants.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showErrorDialog(
      {required context, required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          content: Text(
            content,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                'Okay',
                style: TextStyle(
                  color: Constants.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

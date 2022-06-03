import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/widgets/rounded_button.dart';

import '../controllers/home_controller.dart';

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
      barrierDismissible: false,
    );
  }
}

class ConfirmDialog extends StatelessWidget {
  final VoidCallback action;
  const ConfirmDialog({Key? key, required this.action}) : super(key: key);

  HomeController get _controller => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Container(
        // decoration: BoxDecoration(
        //     color: Colors.white,
        // ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _controller.confirmClose() ?
              "Please confirm again – Audit Completed" :
              _controller.savingData() ?
              "Saving Data for later Transmission" :
              _controller.dataSaved() ?
              "Data Saved\nAPP Closing" :
              "Confirm you wish to close the Audit",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: Get.height * 0.035,
                  fontWeight: FontWeight.w500
              ),
            ),

            SizedBox(height: Get.height * 0.080,),

            // if(_controller.isLoading() && !_controller.savingData())
            //   Center(child: CircularProgressIndicator(color: Constants.primaryColor,))
            if(_controller.isLoading() || _controller.savingData())
              LinearPercentIndicator(
                width: Get.width * 0.70,
                lineHeight: 14.0,
                percent: _controller.savingPercent.value,
                backgroundColor: Colors.grey,
                progressColor: Constants.primaryColor,
                barRadius: Radius.circular(30),
              ),

            if(!_controller.isLoading() && !_controller.savingData() && !_controller.dataSaved())
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedButton(
                  text: 'Cancel',
                  onPressed: () => Get.back(),
                  width: 0.35,
                ),
                RoundedButton(
                  text: 'Close Audit',
                  onPressed: _controller.isLoading() ? null : _controller.handleCloseApp,
                  color: Colors.green,
                  width: 0.35,
                  loading: false,
                ),
              ],
            ),
          ],
        ),),
      ),
    );
  }
}


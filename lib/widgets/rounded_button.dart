import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/ui_utils.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color? color;
  final bool? loading;
  final bool disabled;
  final double? width;
  final VoidCallback? onPressed;
  final double? fontScaleFactor;
  const RoundedButton({
    Key? key,
    required this.text,
    this.width,
    this.onPressed,
    this.color,
    this.disabled = false,
    this.loading = false,
    this.fontScaleFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: disabled
            ? () {
                UiUtils.showErrorDialog(
                  context: context,
                  title: 'No connections',
                  content: 'Please connect to a mobile network or wifi!',
                );
              }
            : onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            color: disabled ? Colors.red : (color ?? Constants.primaryColor),
            borderRadius: loading!
                ? BorderRadius.circular(100.0)
                : BorderRadius.circular(18.0),
            // shape: loading! ? BoxShape.circle : BoxShape.rectangle,
          ),
          // width: !loading! ? 100 : double.infinity,
          width: Get.width * (width ?? 1),
          // width: width ?? 500,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
          child: loading!
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Get.textScaleFactor * (fontScaleFactor ?? 20.0),
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}

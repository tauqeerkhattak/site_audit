import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/utils/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color? color;
  final bool? loading;
  final bool disabled;
  final double? width;
  final VoidCallback? onPressed;
  const RoundedButton(
      {Key? key,
      required this.text,
      this.width,
      this.onPressed,
      this.color,
      this.disabled = false,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: disabled ? null : onPressed,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          decoration: BoxDecoration(
            color: disabled ? Colors.grey : (color ?? Constants.primaryColor),
            borderRadius: loading!
                ? BorderRadius.circular(100.0)
                : BorderRadius.circular(18.0),
            // shape: loading! ? BoxShape.circle : BoxShape.rectangle,
          ),
          // width: !loading! ? 100 : double.infinity,
          // height: 60,
          width: Get.width * (width ?? 1),
          // width: width ?? 500,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
          child: loading!
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Get.textScaleFactor * 20.0,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/size_config.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color? color;
  final VoidCallback? onPressed;
  const RoundedButton({Key? key, required this.text, this.onPressed, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        primary: color ?? Constants.primaryColor,
        textStyle: TextStyle(fontSize: SizeConfig.textMultiplier * 2.8, fontFamily: 'Ubuntu', fontWeight: FontWeight.w500)
      ),
    );
  }
}

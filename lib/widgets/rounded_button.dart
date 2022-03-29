import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const RoundedButton({Key? key, required this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 30),
        primary: Constants.primaryColor,
        textStyle: TextStyle(fontSize: 20, fontFamily: 'Ubuntu', fontWeight: FontWeight.w500)
      ),
    );
  }
}

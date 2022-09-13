import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';

class CustomAppBar extends StatelessWidget {
  final String titleText;
  final Widget? backButton;
  const CustomAppBar({
    Key? key,
    required this.titleText,
    this.backButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: backButton,
      title: Text(
        titleText,
        style: const TextStyle(
          color: Constants.primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }
}

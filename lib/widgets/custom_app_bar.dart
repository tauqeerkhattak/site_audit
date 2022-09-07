import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';

class CustomAppBar extends StatelessWidget {
  final String titleText;
  const CustomAppBar({Key? key, required this.titleText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titleText,
        style: TextStyle(
          color: Constants.primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leadingWidth: 0.0,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }
}

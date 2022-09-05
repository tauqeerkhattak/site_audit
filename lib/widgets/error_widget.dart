import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/utils/ui_utils.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorText;

  const CustomErrorWidget({
    Key? key,
    required this.errorText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: SizeConfig.screenWidth * 0.4,
            height: SizeConfig.screenWidth * 0.4,
            child: Image.asset(
              'assets/images/cloud.png',
            ),
          ),
          UiUtils.spaceVrt20,
          Text(
            errorText,
            style: TextStyle(
              color: Constants.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

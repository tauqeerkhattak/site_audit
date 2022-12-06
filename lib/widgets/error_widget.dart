import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/utils/ui_utils.dart';

enum ErrorType { nullData, emptyList }

class CustomErrorWidget extends StatelessWidget {
  final String errorText;
  final ErrorType? type;

  const CustomErrorWidget({
    Key? key,
    required this.errorText,
    this.type = ErrorType.nullData,
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
              getAsset(),
            ),
          ),
          UiUtils.spaceVrt20,
          Text(
            errorText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Constants.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  String getAsset() {
    switch (type) {
      case ErrorType.nullData:
        return 'assets/images/cloud.png';
      case ErrorType.emptyList:
        return 'assets/images/empty-box.png';
      case null:
        return 'assets/images/cloud.png';
    }
  }
}

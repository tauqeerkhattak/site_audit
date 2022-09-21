import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/utils/network.dart';
import 'package:site_audit/utils/size_config.dart';

import '../utils/constants.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;
  final Widget? appBar;
  const DefaultLayout({
    Key? key,
    required this.child,
    this.backgroundImage,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar != null
          ? PreferredSize(
              preferredSize: Size(
                SizeConfig.screenWidth,
                kToolbarHeight,
              ),
              child: appBar!,
            )
          : null,
      backgroundColor: Colors.white,
      body: SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                child: SizedBox(
                  width: SizeConfig.screenWidth * 0.4,
                  height: SizeConfig.screenHeight * 0.4,
                  child: Image.asset(
                    backgroundImage ?? 'assets/images/round_tower.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              child,
              Positioned(
                top: 10,
                right: 10,
                child: Obx(
                  () => PhysicalModel(
                    color: Colors.white,
                    elevation: 8.0,
                    shape: BoxShape.circle,
                    child: Container(
                      width: SizeConfig.screenWidth * 0.05,
                      height: SizeConfig.screenWidth * 0.05,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Network.isNetworkAvailable.value
                            ? Constants.successColor
                            : Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

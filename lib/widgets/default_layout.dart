import 'package:flutter/material.dart';
import 'package:site_audit/utils/size_config.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}

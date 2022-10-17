import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/utils/size_config.dart';

import '../utils/constants.dart';
import '../utils/network.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;
  final String? title;
  final Widget? titleWidget;
  final bool? showBackButton;
  const DefaultLayout({
    Key? key,
    required this.child,
    this.title,
    this.titleWidget,
    this.backgroundImage,
    this.showBackButton = true,
  })  : assert(title != null || titleWidget != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: title != null
            ? Text(
                title!,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  color: Constants.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            : titleWidget,
        elevation: 0.0,
        centerTitle: true,
        leading: showBackButton!
            ? IconButton(
                icon: const Icon(
                  CupertinoIcons.back,
                  color: Constants.primaryColor,
                ),
                onPressed: () => Get.back(),
              )
            : null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: Obx(
              () => Center(
                child: PhysicalModel(
                  color: Colors.white,
                  elevation: 8.0,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    height: SizeConfig.screenWidth * 0.05,
                    decoration: BoxDecoration(
                      color: Network.isNetworkAvailable.value
                          ? Constants.successColor
                          : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        Network.isNetworkAvailable.value ? 'Online' : 'Offline',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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

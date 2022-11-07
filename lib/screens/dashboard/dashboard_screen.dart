import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/auth_controller.dart';
import 'package:site_audit/domain/controllers/dashboard_controller.dart';
import 'package:site_audit/domain/controllers/home_controller.dart';
import 'package:site_audit/domain/controllers/load_controller.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/services/local_storage_service.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/widgets/default_layout.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);
  final authController = Get.find<AuthController>();
  final homeController = Get.put(HomeController());
  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: "Secure  Site Audit",
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              titleText(
                text: "Secure Site Audit App",
                size: 30.0,
              ),
              UiUtils.spaceVrt20,
              titleText(
                text: "Project ID",
                size: 20.0,
              ),
              UiUtils.spaceVrt10,
              Obx(
                () => titleText(
                  text: "${authController.user.value.data?.projectId}",
                ),
              ),
              UiUtils.spaceVrt20,
              Obx(
                () {
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return UiUtils.spaceVrt5;
                    },
                    shrinkWrap: true,
                    itemCount: dashboardController.forms.value.length,
                    itemBuilder: (context, index) {
                      log("${dashboardController.forms.value.length}   zzzz");
                      return ListTile(
                        minVerticalPadding: 0,
                        minLeadingWidth: 0,
                        title: titleText(
                          text:
                              dashboardController.forms.value[index].siteName ??
                                  "No Data",
                        ),
                      );
                    },
                  );
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoundedButton(
                      text: "Sync Forms",
                      width: 0.4,
                      fontScaleFactor: 16.0,
                      onPressed: () => homeController.submitAudits(context),
                    ),
                    RoundedButton(
                      text: "Start New Audit",
                      width: 0.5,
                      fontScaleFactor: 16.0,
                      onPressed: () => Get.toNamed(AppRoutes.addSiteData),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget titleText({required String? text, wight, size}) {
    return Text(
      text!,
      style:
          TextStyle(fontSize: size ?? 14, fontWeight: wight ?? FontWeight.w500),
    );
  }
}

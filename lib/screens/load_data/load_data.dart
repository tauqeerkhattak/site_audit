import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/utils/widget_utils.dart';
import 'package:site_audit/widgets/default_layout.dart';

import '../../domain/controllers/load_controller.dart';
import '../../utils/constants.dart';

class LoadData extends StatelessWidget {
  final controller = Get.find<LoadController>();
  LoadData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SizedBox(
        width: SizeConfig.screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              if (controller.totalForms.value == 0) {
                return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Constants.primaryColor,
                  ),
                );
              } else {
                return CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation(
                    Constants.primaryColor,
                  ),
                  value: controller.currentForm.value /
                      controller.totalForms.value,
                );
              }
            }),
            WidgetUtils.spaceVrt40,
            const Text(
              'Loading all forms and modules',
              style: TextStyle(
                color: Constants.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

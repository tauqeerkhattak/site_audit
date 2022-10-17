import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/review_controller.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/widgets/custom_card.dart';
import 'package:site_audit/widgets/default_layout.dart';
import 'package:site_audit/widgets/error_widget.dart';
import 'package:site_audit/widgets/rounded_button.dart';

import '../../models/form_model.dart';

class ReviewScreen extends StatelessWidget {
  final controller = Get.find<ReviewController>();
  ReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      // appBar: CustomAppBar(
      //   titleText: controller.formName.value,
      //   backButton:
      // ),
      child: Obx(() {
        if (controller.loading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Constants.primaryColor,
              ),
            ),
          );
        } else {
          return Padding(
            padding: UiUtils.allInsets8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            CupertinoIcons.back,
                            color: Constants.primaryColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Center(
                        child: Text(
                          controller.formName.value,
                          style: const TextStyle(
                            color: Constants.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ..._headingText(),
                UiUtils.spaceVrt20,
                getSubmittedFormsList(),
                UiUtils.spaceVrt20,
                _footerText(),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget getSubmittedFormsList() {
    if (controller.formItems == null || controller.formItems!.isEmpty) {
      return const Expanded(
        child: CustomErrorWidget(
          errorText: 'No Forms submitted yet!',
          type: ErrorType.emptyList,
        ),
      );
    } else {
      return Expanded(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return CustomCard(
              title:
                  '${controller.module?.moduleName} >> ${controller.subModule?.subModuleName} ${index + 1}',
              onTap: () {
                controller.formItem = FormModel.fromJson(
                  controller.formItems![index],
                );
                // for (final item in controller.formItem!.items!) {
                //   log('ITEM: ${item.inputType} ${item.answer}');
                // }
                controller.setData();
                Get.toNamed(
                  AppRoutes.form,
                  arguments: {
                    'module': controller.module,
                    'subModule': controller.subModule,
                    'reviewForm': controller.formItem,
                  },
                );
              },
              buttonText: 'Review Audit',
            );
          },
          separatorBuilder: (context, index) {
            return UiUtils.spaceVrt20;
          },
          itemCount: controller.formItems!.length,
        ),
      );
    }
  }

  List<Widget> _headingText() {
    return [
      const Text(
        'Audit Review',
        style: TextStyle(
          // color: Constants.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      UiUtils.spaceVrt10,
      const Text(
        'Select an existing Audit item to view previously collected data',
      ),
    ];
  }

  Widget _footerText() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Audit New Item',
            style: TextStyle(
              // color: Constants.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          UiUtils.spaceVrt10,
          RoundedButton(
            text: 'Start Audit on New Item',
            onPressed: () {
              Get.toNamed(AppRoutes.form, arguments: {
                'module': controller.module,
                'subModule': controller.subModule,
              });
            },
          ),
        ],
      ),
    );
  }
}

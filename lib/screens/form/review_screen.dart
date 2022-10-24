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

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final controller = Get.find<ReviewController>();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: controller.formName.value,
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
    if (controller.formItems.value == null) {
      return const Expanded(
        child: CustomErrorWidget(
          errorText: 'No Forms submitted yet!',
          type: ErrorType.emptyList,
        ),
      );
    } else {
      return Expanded(
        child: Obx(
          () => ListView.separated(
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              return CustomCard(
                title:
                    '${controller.module?.moduleName} >> ${controller.subModule?.subModuleName} ${index + 1}',
                onTap: () async {
                  controller.formItem = FormModel.fromJson(
                    controller.formItems.value![index],
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
                      'reviewFormIndex': index,
                      'reviewForm': controller.formItem,
                    },
                  );
                  //   controller.refreshPage();
                  // });
                },
                buttonText: 'Review Audit',
              );
            },
            separatorBuilder: (context, index) {
              return UiUtils.spaceVrt20;
            },
            itemCount: controller.formItems.value!.length,
          ),
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
                'formName': controller.formName.value,
              })?.whenComplete(() {
                controller.refreshPage();
                setState(() {});
              });
            },
          ),
        ],
      ),
    );
  }
}

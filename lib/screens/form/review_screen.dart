import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/review_controller.dart';
import 'package:site_audit/models/review_model.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/widgets/custom_app_bar.dart';
import 'package:site_audit/widgets/custom_card.dart';
import 'package:site_audit/widgets/default_layout.dart';
import 'package:site_audit/widgets/error_widget.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class ReviewScreen extends StatelessWidget {
  final controller = Get.find<ReviewController>();
  ReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CustomAppBar(
        titleText: controller.formName.value,
      ),
      child: Obx(() {
        if (controller.loading.value) {
          return Center(
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
    if (controller.formItems == null || controller.formItems!.isEmpty) {
      return const Expanded(
        child: CustomErrorWidget(
          errorText: 'No Forms submitted yet!',
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
                ReviewModel model = ReviewModel.fromJson(
                  controller.formItems![index],
                );
                Get.toNamed(
                  AppRoutes.formReview,
                  arguments: {
                    'form_item': model,
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

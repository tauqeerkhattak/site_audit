import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/review_controller.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/widgets/custom_card.dart';
import 'package:site_audit/widgets/default_layout.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int? index = 0;
  final controller = Get.find<ReviewController>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                //UiUtils.spaceVrt20,
                const Spacer(),
                _footerText(),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget getSubmittedFormsList() {
    return Expanded(
      child: FutureBuilder<List<dynamic>>(
        future: controller.dbHelper!.getDistinctByFormId(
          moduleID: controller.subModule?.subModuleId,
        ),
        builder: (context, snapshot) {
          return ListView.separated(
            separatorBuilder: (context, index) {
              return UiUtils.spaceVrt20;
            },
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final formId = snapshot.data![index];
              return CustomCard(
                title:
                    "${controller.module?.moduleName} >> ${controller.subModule?.subModuleName} ${index + 1}",
                onTap: () => controller.onCardTap(formId['form_id']),
                buttonText: 'Review Audit',
              );
            },
          );
        },
      ),
    );
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
            width: 0.8,
            color: Colors.green,
            text: 'Start Audit on New Item',
            onPressed: () {
              Get.toNamed(AppRoutes.form, arguments: {
                'module': controller.module,
                'subModule': controller.subModule,
                'formName': controller.formName.value,
              })?.whenComplete(() {
                setState(() {});
              });
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/review_controller.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/widgets/custom_card.dart';
import 'package:site_audit/widgets/default_layout.dart';
import 'package:site_audit/widgets/error_widget.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
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
    index = controller.storageService.get(key: 'FormIndex') ?? 0;
    if (index! < 1) {
      return const Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: CustomErrorWidget(
            errorText: 'No Audits for this Technology completed yet!',
            type: ErrorType.emptyList,
          ),
        ),
      );
    } else {
      // return Center(
      //     child: Text(
      //   "$index form is submitted",
      //   style: const TextStyle(color: Colors.black, fontSize: 18),
      // ));
      return controller.index == 0
          ? Column(
              children: [
                // Container(
                //   height: MediaQuery.of(context).size.height * 0.32,
                //   child: Obx(
                //     () => ListView.separated(
                //       padding: const EdgeInsets.all(10),
                //       itemBuilder: (context, index) {
                //         return CustomCard(
                //           title:
                //               '${controller.module?.moduleName} >> ${controller.subModule?.subModuleName} ${index + 1}',
                //           onTap: () async {
                //             controller.formItem = FormModel.fromJson(
                //               controller.formItems.value![index],
                //             );
                //             // for (final item in controller.formItem!.items!) {
                //             //   log('ITEM: ${item.inputType} ${item.answer}');
                //             // }
                //             controller.setData();
                //             Get.toNamed(
                //               AppRoutes.form,
                //               arguments: {
                //                 'module': controller.module,
                //                 'subModule': controller.subModule,
                //                 'reviewFormIndex': index,
                //                 'reviewForm': controller.formItem,
                //                 'formName': controller.formName.value,
                //               },
                //             );
                //             //   controller.refreshPage();
                //             // });
                //           },
                //           buttonText: 'Review Audit',
                //         );
                //       },
                //       separatorBuilder: (context, index) {
                //         return UiUtils.spaceVrt20;
                //       },
                //       itemCount: controller.formItems.value?.length ?? 0,
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: Get.height * 0.68,
                  child: FutureBuilder<Map<String, List<dynamic>>>(
                    future: controller.getData(),
                    builder: (context, snapshot) {
                      return ListView.separated(
                        separatorBuilder: (context, index) {
                          return UiUtils.spaceVrt20;
                        },
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final items = snapshot.data!['formNumber$index'];
                          return CustomCard(
                              title:
                                  "${controller.module?.moduleName} >> ${controller.subModule?.subModuleName} ${index + 1}",
                              onTap: () async {
                                final form = FormModel(
                                  id: 34,
                                  projectId: 2,
                                  moduleName: controller.module?.moduleName,
                                  subModuleId:
                                      controller.subModule?.subModuleId,
                                  subModuleName:
                                      controller.subModule?.subModuleName,
                                  items: items?.map((e) {
                                    return Items.fromJson(e);
                                  }).toList(),
                                );
                                // Get.to(
                                //   () => ViewFormScreen(
                                //     list: items,
                                //   ),
                                // );

                                // for (final item in items ?? []) {
                                //   log("$item iteeem");
                                // }

                                Get.toNamed(
                                  AppRoutes.form,
                                  arguments: {
                                    'module': controller.module,
                                    'subModule': controller.subModule,

                                    //
                                    // 'form': controller.formItem?.toJson(),
                                    'reviewFormIndex': index,
                                    'reviewForm': form,
                                    // 'formName': controller.formName.value,
                                  },
                                );
                                controller.refreshPage();
                                // controller.setData();
                                // Get.toNamed(
                                //   AppRoutes.form,
                                //   arguments: {
                                //     'module':
                                //         snapshot.data![index].module_name,
                                //     'subModule':
                                //         snapshot.data![index].sub_module_name,
                                //     'reviewFormIndex': index,
                                //     'reviewForm':
                                //         snapshot.data![index].sub_module_name,
                                //     'formName': '555',
                                //   },
                                // );
                                // controller.refreshPage();
                              },
                              buttonText: 'Review Audit');
                        },
                      );
                    },
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${controller.index} for is submited",
                style: TextStyle(color: Colors.black, fontSize: 16),
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
            width: 0.8,
            color: Colors.green,
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

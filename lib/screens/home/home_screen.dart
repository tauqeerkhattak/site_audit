import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/home_controller.dart';
import 'package:site_audit/domain/controllers/load_controller.dart';
import 'package:site_audit/models/module_model.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/screens/dashboard/dashboard_screen.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/network.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/widgets/custom_grid_view.dart';
import 'package:site_audit/widgets/default_layout.dart';
import 'package:site_audit/widgets/error_widget.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.animateBack();
        return true;
      },
      child: DefaultLayout(
        showBackButton: true,
        backButton: Obx(
          () {
            if (controller.currentPage.value > 0) {
              return IconButton(
                icon: const Icon(
                  CupertinoIcons.back,
                  color: Constants.primaryColor,
                ),
                onPressed: () {
                  controller.animateBack();
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        titleWidget: Obx(
          () => Text(
            getTitle(),
            style: const TextStyle(
              color: Constants.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        child: _bodyWidget(context),
      ),
    );
  }

  String getTitle() {
    if (controller.currentPage.value == 0) {
      return 'Site Audit Home Screen';
    } else {
      return '${controller.selectedModule.value?.moduleName} Sub Menu';
    }
  }

  Widget _bodyWidget(BuildContext context) {
    return Obx(
      () {
        if (controller.loading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Constants.primaryColor,
              ),
            ),
          );
        } else {
          if (controller.modules.isEmpty) {
            return const CustomErrorWidget(
              errorText: 'Cannot get Modules!',
            );
          }
          return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.pageController,
            onPageChanged: (int page) {
              controller.currentPage.value = page;
            },
            children: [
              getModulesUi(context),
              getSubModulesUi(
                controller.selectedModule.value,
              ),
            ],
          );
        }
      },
    );
  }

  Widget tileCard(text, length) {
    List<bool> checks = List.generate(length, (index) {
      return true;
    });
    return customCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.textMultiplier * 2.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          UiUtils.spaceVrt10,
          Container(
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.3),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: IgnorePointer(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 5,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  length,
                  (index) {
                    return Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all(
                        Constants.primaryColor,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: checks[index],
                      onChanged: (bool? value) {
                        checks[index] = value ?? checks[index];
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customCard({required Widget child, double? height, String? image}) {
    return PhysicalModel(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18.0),
      elevation: 8.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.0),
        ),
        clipBehavior: Clip.antiAlias,
        height: height,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        child: child,
      ),
    );
  }

  Widget getModulesUi(BuildContext context) {
    List<Module> modules = controller.modules;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: CustomGridView(
              length: modules.length,
              itemBuilder: (context, index) {
                Module module = modules[index];
                int? moduleCount = controller.storageService.get(
                  key: module.moduleName!,
                );
                return InkWell(
                  onTap: () async {
                    controller.animateForward(module);
                  },
                  child: tileCard(
                    '${module.moduleName}',
                    moduleCount ?? 0,
                    // index == 1 ? 6 : 12,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              bottom: 8,
              right: 8,
            ),
            child: Row(
              children: [
                RoundedButton(
                  text: 'Help',
                  color: Constants.primaryColor,
                  width: 0.2,
                  fontScaleFactor: 15,
                  onPressed: () {},
                ),
                const Spacer(),
                RoundedButton(
                  text: 'Audit Completed Send Data',
                  color: Constants.successColor,
                  width: 0.63,
                  fontScaleFactor: 15,
                  disabled: !Network.isNetworkAvailable.value,
                  loading: controller.loading.value,
                  // onPressed: () => controller.submitAudits(context),
                  onPressed: () => Get.offAndToNamed(AppRoutes.dashboard),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSubModulesUi(Module? module) {
    if (module == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (module.subModules == null || module.subModules!.isEmpty) {
      return Center(
        child: Text(
          'No submodules available for ${module.moduleName}',
        ),
      );
    }
    List<SubModule> subModules = module.subModules!;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: CustomGridView(
              length: subModules.length,
              itemBuilder: (context, index) {
                SubModule subModule = subModules[index];
                int? subModuleCount = controller.storageService.get(
                  key: subModule.subModuleName!,
                );
                return InkWell(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.review,
                      arguments: {
                        'module': module,
                        'subModule': subModule,
                      },
                    )?.whenComplete(() {
                      setState(() {});
                    });
                  },
                  child: tileCard(
                    '${module.moduleName} >> ${subModule.subModuleName}',
                    subModuleCount ?? 0,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              bottom: 8,
              right: 8,
            ),
            child: Row(
              children: [
                RoundedButton(
                  text: 'Help',
                  color: Constants.primaryColor,
                  width: 0.2,
                  fontScaleFactor: 16,
                  onPressed: () {},
                ),
                const Spacer(),
                RoundedButton(
                  text: 'Back',
                  color: Constants.primaryColor,
                  width: 0.2,
                  fontScaleFactor: 16,
                  onPressed: () {
                    controller.animateBack();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

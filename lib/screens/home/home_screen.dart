import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/controllers/home_controller.dart';
import 'package:site_audit/models/module_model.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/widgets/default_layout.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.animateBack();
        return false;
      },
      child: DefaultLayout(
        child: _bodyWidget(),
      ),
    );
  }

  Widget _bodyWidget() {
    return SafeArea(
      child: Obx(
        () {
          if (controller.loading.value) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  Constants.primaryColor,
                ),
              ),
            );
          } else {
            return PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller.pageController,
              children: [
                getModulesUi(),
                getSubModulesUi(
                  controller.selectedModule.value,
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget tileCard(text, length) {
    List<bool> checks = List.generate(length, (index) {
      return true;
    }).obs;
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
              child: Wrap(
                children: [
                  ...List.generate(
                    length,
                    (index) => Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all(
                        Constants.primaryColor,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: checks[index],
                      onChanged: (bool? value) {
                        checks[index] = value ?? checks[index];
                      },
                    ),
                    // (index) => Obx(
                    //   () => ,
                    // ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customCard({required Widget child, double? height, String? image}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10.0,
            spreadRadius: 0.4,
            offset: const Offset(0, 0.0),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      height: height,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10.0),
      child: child,
    );
  }

  Widget getModulesUi() {
    List<Module> modules = controller.modules;
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              'Modules',
              style: TextStyle(
                color: Constants.primaryColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 11,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: SizeConfig.screenWidth * 0.5,
              mainAxisExtent: 120,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: modules.length,
            padding: UiUtils.allInsets8,
            itemBuilder: (context, index) {
              Module module = modules[index];
              return InkWell(
                onTap: () async {
                  controller.animateForward(module);
                },
                child: tileCard(
                  '${module.moduleName}',
                  module.subModules!.length,
                ),
              );
            },
          ),
        ),
      ],
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
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              'SubModules',
              style: TextStyle(
                color: Constants.primaryColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 11,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: SizeConfig.screenWidth * 0.5,
              mainAxisExtent: 120,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: subModules.length,
            padding: UiUtils.allInsets8,
            itemBuilder: (context, index) {
              SubModule subModule = subModules[index];
              return InkWell(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.form,
                    arguments: {
                      'module_id': subModule.subModuleId,
                    },
                  );
                },
                child: tileCard(
                  '${subModule.subModuleName}',
                  2,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

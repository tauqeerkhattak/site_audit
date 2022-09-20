import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/home_controller.dart';
import 'package:site_audit/models/module_model.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/utils/ui_utils.dart';
import 'package:site_audit/widgets/custom_grid_view.dart';
import 'package:site_audit/widgets/default_layout.dart';
import 'package:site_audit/widgets/error_widget.dart';
import 'package:site_audit/widgets/rounded_button.dart';

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
            children: [
              getModulesUi(),
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
                crossAxisCount: 3,
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
        const Expanded(
          flex: 1,
          child: Center(
            child: Text(
              'Site Audit Home Screen',
              style: TextStyle(
                color: Constants.primaryColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
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
                width: 0.7,
                fontScaleFactor: 15,
                onPressed: controller.submitAudits,
              ),
            ],
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
              '${module.moduleName} Sub Menu',
              style: const TextStyle(
                color: Constants.primaryColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
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
                  );
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
    );
  }
}

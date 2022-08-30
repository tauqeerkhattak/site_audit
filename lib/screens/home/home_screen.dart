import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/controllers/home_controller.dart';
import 'package:site_audit/models/module_model.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/size_config.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: SizeConfig.screenWidth * 0.4,
                height: SizeConfig.screenHeight * 0.4,
                child: Image.asset(
                  'assets/images/istockphoto-1184778656-612x612.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _bodyWidget(),
          ],
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return SafeArea(
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
          List<Module> modules = controller.modules;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 120,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: modules.length,
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 8,
              top: 40,
            ),
            itemBuilder: (context, index) {
              Module module = modules[index];
              return tileCard(
                '${module.moduleName}',
                module.subModules!.length,
              );
            },
          );
        }
      }),
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
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.3),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: List.generate(
                length,
                (index) => Obx(
                  () => Checkbox(
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
        borderRadius: new BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10.0,
            spreadRadius: 0.4,
            offset: Offset(0, 0.0),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      height: height ?? null,
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.0),
      child: child,
    );
  }

  Widget progress() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Services',
            style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.8),
          ),
          Text(
            '128m/300m',
            style: TextStyle(color: Colors.grey),
          ),
          Container(
            height: 3,
            width: 100,
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(20)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                height: 3,
                width: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

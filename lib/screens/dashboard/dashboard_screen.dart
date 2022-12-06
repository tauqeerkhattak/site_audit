import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/auth_controller.dart';
import 'package:site_audit/domain/controllers/dashboard_controller.dart';
import 'package:site_audit/domain/controllers/home_controller.dart';
import 'package:site_audit/routes/routes.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/network.dart';
import 'package:site_audit/widgets/default_layout.dart';
import 'package:site_audit/widgets/error_widget.dart';
import 'package:site_audit/widgets/rounded_button.dart';

List auditNumber = [];
int itemCount = 1;

class Audit{
  int number;
  String status;

  Audit(this.number, this.status);
}
class DashboardScreen extends StatelessWidget {
   DashboardScreen({Key? key}) : super(key: key);

  final authController = Get.find<AuthController>();

  final homeController = Get.find<HomeController>();

  final dashboardController = Get.put(DashboardController());


  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: "Secure Site Audit",
        child:SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //const Spacer(),
              Obx(() {
                Network.isNetworkAvailable.value ? dashboardController.audits = null : dashboardController.audits;
                dashboardController.audits = dashboardController.storageService.get(key: 'audit');
                if(dashboardController.loading.value){
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Constants.primaryColor,
                        ),
                      ),
                    ),
                  );
                }else{
                  return
                    dashboardController.audits == null ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CustomErrorWidget(
                          errorText: 'No Audits available!',
                          type: ErrorType.emptyList,
                        ),
                      ],
                    ):Network.isNetworkAvailable.value
                        ?Column(
                          children: const [
                          Icon(Icons.check_circle,color: Colors.blue,size: 50,),
                          Text("Audit Succesfully Submited"),
                      ],
                    ):
                    Obx(() => Column(
                      children: [
                        titleText(
                          text: "No Internet Connection",
                          size: 20.0,
                        ),
                        const SizedBox(height: 5,),
                        titleText(
                          text: "${dashboardController.audits} Audit ready to sync!",
                          size: 16.0,
                        ),
                        /*SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: ListView.separated(
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              return PhysicalModel(
                                elevation: 10.0,
                                color: Colors.white.withRed(250),
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${dashboardController.audits[index]} Audit is Submited',
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Obx(() =>Text(
                                              Network.isNetworkAvailable.value
                                                  ? 'Online'
                                                  :'Offline',textAlign: TextAlign.start,))
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: ElevatedButton(
                                          onPressed: Network.isNetworkAvailable.value
                                              ? (){}:(){
                                            Get.rawSnackbar(
                                              title: "No Internet!",
                                              message:
                                              "Data will be uploaded when you have a stable internet connection!",
                                              icon: const Icon(
                                                Icons.info,
                                                color: Colors.white,
                                              ),
                                              backgroundColor: Constants.primaryColor,
                                              borderRadius: 10,
                                              margin: const EdgeInsets.all(10),
                                            );
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(
                                              Constants.primaryColor,
                                            ),
                                            padding: MaterialStateProperty.all(
                                              const EdgeInsets.all(10.0),
                                            ),
                                          ),
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children:  [
                                              Obx(() =>Text(
                                                Network.isNetworkAvailable.value
                                                    ? "Successfully" : "Sync",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 12
                                                ),
                                              ),),
                                              Icon(Network.isNetworkAvailable.value
                                                  ? Icons.check_circle : Icons.rotate_left,color: Colors.white,size: 18,)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return UiUtils.spaceVrt20;
                            },
                            itemCount: dashboardController.audits.length,
                          ),
                        ),*/
                        /// TO-DO
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PhysicalModel(
                            elevation: 10.0,
                            color: Colors.white.withRed(250),
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${dashboardController.audits} Audit is Submited',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Obx(() =>Text(
                                          Network.isNetworkAvailable.value
                                              ? 'Online'
                                              :'Offline',textAlign: TextAlign.start,))
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: ElevatedButton(
                                      onPressed: Network.isNetworkAvailable.value
                                          ? (){}:(){
                                        Get.rawSnackbar(
                                          title: "No Internet!",
                                          message:
                                          "Data will be uploaded when you have a stable internet connection!",
                                          icon: const Icon(
                                            Icons.info,
                                            color: Colors.white,
                                          ),
                                          backgroundColor: Constants.primaryColor,
                                          borderRadius: 10,
                                          margin: const EdgeInsets.all(10),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                          Constants.primaryColor,
                                        ),
                                        padding: MaterialStateProperty.all(
                                          const EdgeInsets.all(10.0),
                                        ),
                                      ),
                                      child:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children:  [
                                          Obx(() =>Text(
                                            Network.isNetworkAvailable.value
                                                ? "Successfully" : "Sync",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 12
                                            ),
                                          ),),
                                          Icon(Network.isNetworkAvailable.value
                                              ? Icons.check_circle : Icons.rotate_left,color: Colors.white,size: 18,)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ));
                }
              }),

              /*ListView.separated(
                separatorBuilder: (context, index) {
                  return UiUtils.spaceVrt5;
                },
                shrinkWrap: true,
                itemCount: dashboardController.forms.value.length,
                itemBuilder: (context, index) {
                  log("${dashboardController.forms.value.length}   zzzz");
                  return ListTile(
                    minVerticalPadding: 0,
                    minLeadingWidth: 0,
                    title: titleText(
                      text:
                      dashboardController.forms.value[index].siteName ??
                          "No Data",
                    ),
                  );
                },
              ),*/
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: RoundedButton(
                    color: Colors.green,
                      text: "Start New Audit",
                      width: 0.8,
                      fontScaleFactor: 16.0,
                      onPressed: () {
                        if(Network.isNetworkAvailable.value == true){
                          itemCount = 1;
                          auditNumber = [];
                          dashboardController.audits = [];
                          dashboardController.storageService.remove(key: 'audit');
                        }
                        Get.toNamed(AppRoutes.addSiteData);
                      }

                  ),
                ),
              ),
            ],
          ),
        )


    );
  }

  Widget titleText({required String? text, wight, size}) {
    return Text(
      text!,
      style:
      TextStyle(fontSize: size ?? 14, fontWeight: wight ?? FontWeight.w500),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_audit/controllers/auth_controller.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

import '../../models/site_detail_model.dart';

class SiteDetail extends StatelessWidget {
  final AuthController controller;
  static GetStorage _box = GetStorage();
  SiteDetail({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Comment this
    // setData();
    ThemeData _theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 30),
      child: Form(
        key: controller.key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add\nSite\nDetails:',
              style: _theme.textTheme.headline4,
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: operatorDrop(
                      'Site Operator',
                      controller.operators,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: regionDrop(
                      'Site Region',
                      controller.regions,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: subRegionDrop(
                      'Site Sub-Region',
                      controller.subRegions,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: clusterDrop(
                      'Site Cluster',
                      controller.clusters,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: siteIdDrop(
                      'Site ID',
                      controller.siteIDs,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: input(
                      'Site Name',
                      controller: controller.siteName,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            input(
              'Name of Site Keeper',
              controller: controller.siteKeeper,
            ),
            SizedBox(
              height: 10,
            ),
            input(
              'Phone Number of Site Keeper',
              controller: controller.siteKeeperPhone,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: simpleDrop(
                    label: 'Physical Site Type',
                    items: controller.physicalSiteTypes,
                    onChanged: (String? type) {
                      controller.currentSiteTypes.value = type ?? 'Outdoor';
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      controller.selectDateTime(controller.surveyStart);
                    },
                    child: IgnorePointer(
                      child: input(
                        'Survey Start',
                        readOnly: true,
                        controller: controller.surveyStart,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: input(
                    'Longitude',
                    controller: controller.longitude,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: input(
                    'Latitude',
                    controller: controller.latitude,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: simpleDrop(
                    label: 'Weather',
                    items: controller.weatherType,
                    onChanged: (String? weather) {
                      controller.currentWeather.value = weather ?? "Sunny";
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: input(
                    'Temperature',
                    controller: controller.temperature,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            imageInput('Site Photo from main entrance'),
            SizedBox(
              height: 20,
            ),
            Obx(
              () => RoundedButton(
                text: 'Submit',
                onPressed: () async {
                  await controller.submitSiteDetails();
                  // Get.to(() => TempScreen());
                },
                loading: controller.loading(),
                width: controller.loading() ? 100 : Get.width,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // RoundedButton(
            //   text: 'Go To Temp',
            //   onPressed: () {
            //     Get.to(() => HomeScreen());
            //   },
            //   width: Get.width,
            // ),
          ],
        ),
      ),
    );
  }

  Widget imageInput(label) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            label + "\t\t",
            textAlign: TextAlign.start,
            style: TextStyle(
              // color: Colors.white,
              fontSize: SizeConfig.textMultiplier * 2.2,
            ),
          ),
        ),
        Obx(
          () => controller.images.isEmpty
              ? InkWell(
                  onTap: () {
                    controller.pickImage(ImageSource.gallery);
                  },
                  child: Container(
                    height: SizeConfig.screenHeight * 0.2,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Constants.primaryColor,
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Constants.primaryColor,
                          size: 30,
                        ),
                        Text(
                          'Select a picture',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: SizeConfig.textMultiplier * 2.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Row(
                  children: [
                    ...List.generate(controller.images.length, (index) {
                      return Image.file(controller.images[index]);
                    }),
                    InkWell(
                      onTap: () {
                        controller.pickImage(ImageSource.gallery);
                      },
                      child: Container(
                        child: Icon(
                          Icons.camera_alt,
                          color: Constants.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget input(label,
      {int? lines, TextEditingController? controller, bool? readOnly}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            label + "\t\t",
            textAlign: TextAlign.start,
            style: TextStyle(
              // color: Colors.white,
              fontSize: SizeConfig.textMultiplier * 2.2,
            ),
          ),
        ),
        // SizedBox(height: 5,),
        InputField(
          placeHolder: "",
          controller: controller,
          readOnly: readOnly ?? false,
          lines: lines,
        ),
      ],
    );
  }

  Widget simpleDrop(
      {label,
      required List<String> items,
      required Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            label + "\t\t",
            textAlign: TextAlign.start,
            style: TextStyle(
              // color: Colors.white,
              fontSize: SizeConfig.textMultiplier * 2.2,
            ),
          ),
        ),
        // SizedBox(height: 5,),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular(18.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10.0,
                spreadRadius: 0.4,
                offset: Offset(0, 6.0),
              )
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<String>(
            onChanged: onChanged,
            isDense: true,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide:
                    BorderSide(color: Color(0xffBDBDBD).withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            items: items.map<DropdownMenuItem<String>>((String? value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value ?? 'N/A'),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget operatorDrop(label, List<Datum> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(label + "\t\t",
              textAlign: TextAlign.start,
              style: TextStyle(
                  // color: Colors.white,
                  fontSize: SizeConfig.textMultiplier * 2.2)),
        ),
        // SizedBox(height: 5,),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(18.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 0.4,
                    offset: Offset(0, 6.0))
              ]),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<Datum?>(
            onChanged: (Datum? newValue) {
              controller.currentOperator.value = newValue!;
              controller.regions.clear();
              controller.regions
                  .assignAll(controller.currentOperator.value.region!);
              controller.currentRegion.value = controller.regions.first;
              if (controller.isSubRegionSelected) {
                controller.subRegions.clear();
                controller.subRegions
                    .assignAll(controller.currentRegion.value!.subRegion!);
                controller.currentSubRegion.value =
                    controller.currentRegion.value!.subRegion!.first;
              }
              if (controller.isClusterSelected) {
                controller.clusters.clear();
                controller.clusters.assignAll(controller
                    .currentRegion.value!.subRegion!.first.clusterId!);
                controller.currentCluster.value = controller.clusters.first;
              }
              if (controller.isSiteIDSelected) {
                controller.siteIDs.clear();
                controller.siteIDs.assignAll(controller.currentRegion.value!
                    .subRegion!.first.clusterId!.first.siteReference!);
                controller.currentSite.value = controller.siteIDs.first;
              }
            },
            isDense: true,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide:
                    BorderSide(color: Color(0xffBDBDBD).withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            // value: controller.currentOperator.value,
            items: items.map<DropdownMenuItem<Datum?>>((Datum? value) {
              return DropdownMenuItem<Datum?>(
                value: value,
                child: Text("${value?.datumOperator}"),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget regionDrop(
    label,
    List<Region> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            label + "\t\t",
            textAlign: TextAlign.start,
            style: TextStyle(
              // color: Colors.white,
              fontSize: SizeConfig.textMultiplier * 2.2,
            ),
          ),
        ),
        // SizedBox(height: 5,),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular(18.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10.0,
                spreadRadius: 0.4,
                offset: Offset(0, 6.0),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<Region>(
            onChanged: (Region? newValue) {
              controller.currentRegion.value = newValue!;
              controller.subRegions
                  .assignAll(controller.currentRegion.value!.subRegion!);
              controller.currentSubRegion.value = controller.subRegions.first;
              if (controller.isClusterSelected) {
                controller.clusters.clear();
                controller.clusters
                    .assignAll(controller.currentSubRegion.value.clusterId!);
                controller.currentCluster.value = controller.clusters.first;
              }
              if (controller.isSiteIDSelected) {
                controller.siteIDs.clear();
                controller.siteIDs.assignAll(controller
                    .currentSubRegion.value.clusterId!.first.siteReference!);
                controller.currentSite.value = controller.siteIDs.first;
              }
            },
            isDense: true,
            value: controller.currentRegion.value,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide:
                    BorderSide(color: Color(0xffBDBDBD).withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            items: items.map<DropdownMenuItem<Region>>((Region value) {
              return DropdownMenuItem<Region>(
                value: value,
                child: Text(value.name!),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget subRegionDrop(label, List<SubRegion> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(label + "\t\t",
              textAlign: TextAlign.start,
              style: TextStyle(
                  // color: Colors.white,
                  fontSize: SizeConfig.textMultiplier * 2.2)),
        ),
        // SizedBox(height: 5,),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(18.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 0.4,
                    offset: Offset(0, 6.0))
              ]),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<SubRegion>(
            onChanged: (SubRegion? newValue) {
              controller.isSubRegionSelected = true;
              controller.currentSubRegion.value = newValue!;
              controller.clusters
                  .assignAll(controller.currentSubRegion.value.clusterId!);
              controller.currentCluster.value = controller.clusters.first;
              if (controller.isSiteIDSelected) {
                controller.siteIDs.clear();
                controller.siteIDs
                    .assignAll(controller.currentCluster.value.siteReference!);
                controller.currentSite.value = controller.siteIDs.first;
              }
            },
            isDense: true,
            value: controller.currentSubRegion.value,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide:
                    BorderSide(color: Color(0xffBDBDBD).withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            items: items.map<DropdownMenuItem<SubRegion>>((SubRegion value) {
              return DropdownMenuItem<SubRegion>(
                value: value,
                child: Text(value.name!),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget clusterDrop(label, List<ClusterId> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(label + "\t\t",
              textAlign: TextAlign.start,
              style: TextStyle(
                  // color: Colors.white,
                  fontSize: SizeConfig.textMultiplier * 2.2)),
        ),
        // SizedBox(height: 5,),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(18.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 0.4,
                    offset: Offset(0, 6.0))
              ]),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<ClusterId>(
            onChanged: (ClusterId? newValue) {
              controller.isClusterSelected = true;
              controller.currentCluster.value = newValue!;
              controller.siteIDs
                  .assignAll(controller.currentCluster.value.siteReference!);
              controller.currentSite.value = controller.siteIDs.first;
            },
            isDense: true,
            value: controller.currentCluster.value,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide:
                    BorderSide(color: Color(0xffBDBDBD).withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            items: items.map<DropdownMenuItem<ClusterId>>((ClusterId value) {
              return DropdownMenuItem<ClusterId>(
                value: value,
                child: Text(value.id!),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget siteIdDrop(label, List<SiteReference> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(label + "\t\t",
              textAlign: TextAlign.start,
              style: TextStyle(
                  // color: Colors.white,
                  fontSize: SizeConfig.textMultiplier * 2.2)),
        ),
        // SizedBox(height: 5,),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(18.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 0.4,
                    offset: Offset(0, 6.0))
              ]),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<SiteReference>(
            onChanged: (SiteReference? newValue) {
              controller.isSiteIDSelected = true;
              controller.currentSite.value = newValue!;
              controller.siteName.text = controller.currentSite.value.name;
            },
            isDense: true,
            value: controller.currentSite.value,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide:
                    BorderSide(color: Color(0xffBDBDBD).withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            items: items
                .map<DropdownMenuItem<SiteReference>>((SiteReference value) {
              return DropdownMenuItem<SiteReference>(
                value: value,
                child: Text(value.id),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void setData() {
    final data = _box.read('site_details');
    controller.siteDetails.value = SiteDetailModel(
      data: List<Datum>.from(data["data"].map((x) => Datum.fromJson(x))),
    );
    controller.operators.assignAll(controller.siteDetails.value.data!);
    controller.currentOperator.value = controller.operators.first;
    controller.regions = [];
    controller.subRegions = [];
    controller.clusters = [];
    controller.siteIDs = [];
    controller.currentRegion.value = Region();
    controller.currentSubRegion.value = SubRegion();
    controller.currentCluster.value = ClusterId();
    controller.currentSite.value = SiteReference(id: '', name: '');
    controller.siteName.text = '';
    controller.isRegionSelected = false;
    controller.isSubRegionSelected = false;
    controller.isClusterSelected = false;
    controller.isSiteIDSelected = false;
  }
}

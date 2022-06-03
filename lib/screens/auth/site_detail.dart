import 'dart:io';

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

class SiteDetail extends StatefulWidget {
  static GetStorage _box = GetStorage();
  SiteDetail({Key? key}) : super(key: key);

  @override
  State<SiteDetail> createState() => _SiteDetailState();
}

class _SiteDetailState extends State<SiteDetail> {
  final controller = Get.find<AuthController>();
  @override
  void initState() {
    controller.setLocation();
    super.initState();
  }

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
                      textController: controller.siteName,
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
              textController: controller.siteKeeper,
            ),
            SizedBox(
              height: 10,
            ),
            input(
              'Phone Number of Site Keeper',
              textController: controller.siteKeeperPhone,
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
                  child: input(
                    'Survey Start',
                    readOnly: true,
                    textController: controller.surveyStart,
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
                    textController: controller.longitude,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: input(
                    'Latitude',
                    textController: controller.latitude,
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
                    textController: controller.temperature,
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
              () => controller.validated.value
                  ? SizedBox()
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      child: Text(
                        'Please fill all fields!',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: SizeConfig.textMultiplier * 2.2,
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(
              () => RoundedButton(
                text: 'Submit',
                onPressed: () async {
                  controller.validated.value =
                      controller.key.currentState!.validate();
                  if (controller.validated.value) {
                    await controller.submitSiteDetails();
                  }
                },
                loading: controller.loading(),
                width: controller.loading() ? 100 : Get.width,
              ),
            ),
            SizedBox(
              height: 10,
            ),
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
          () => InkWell(
            onTap: () {
              controller.pickImage(ImageSource.camera);
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
              child: controller.image.value.path == ''
                  ? Column(
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
                    )
                  : Image.file(
                      File(
                        controller.image.value.path,
                      ),
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget input(label,
      {int? lines,
      TextEditingController? textController,
      FocusNode? node,
      bool? readOnly}) {
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
          controller: textController,
          readOnly: readOnly ?? false,
          validator: (String? text) => controller.stringValidator(text),
          node: node,
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
            validator: (String? value) => controller.stringValidator(value),
            decoration: Constants.decoration(
              hint: items.isEmpty ? 'Select' : null,
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
    items = items.toSet().toList();
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
                offset: Offset(
                  0,
                  6.0,
                ),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<Datum?>(
            onChanged: (Datum? newValue) {
              controller.currentOperator.value = newValue!;
              controller.regions.clear();
              controller.regions
                  .assignAll(controller.currentOperator.value!.region!);
              controller.currentRegion.value = null;
              controller.subRegions.clear();
              controller.currentSubRegion.value = null;
              controller.clusters.clear();
              controller.currentCluster.value = null;
              controller.siteIDs.clear();
              controller.currentSite.value = null;
              controller.siteName.text = '';
            },
            isDense: true,
            validator: (value) => controller.dynamicValidator(value),
            decoration: Constants.decoration(hint: 'Select'),
            value: controller.currentOperator.value,
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
    items = items.toSet().toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              10,
            ),
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
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<Region>(
            onChanged: (Region? newValue) {
              controller.currentRegion.value = newValue!;
              controller.subRegions
                  .assignAll(controller.currentRegion.value!.subRegion!);
              controller.currentSubRegion.value = null;
              controller.clusters.clear();
              controller.currentCluster.value = null;
              controller.siteIDs.clear();
              controller.currentSite.value = null;
              controller.siteName.text = '';
            },
            isDense: true,
            value: controller.currentRegion.value,
            validator: (value) => controller.dynamicValidator(value),
            decoration: Constants.decoration(
              hint: controller.regions.isEmpty ? null : 'Select',
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
    items = items.toSet().toList();
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
              fontSize: SizeConfig.textMultiplier * 2.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular(18.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10.0,
                spreadRadius: 0.4,
                offset: Offset(
                  0,
                  6.0,
                ),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<SubRegion>(
            onChanged: (SubRegion? newValue) {
              controller.currentSubRegion.value = newValue!;
              controller.clusters
                  .assignAll(controller.currentSubRegion.value!.clusterId!);
              controller.currentCluster.value = null;
              controller.siteIDs.clear();
              controller.currentSite.value = null;
              controller.siteName.text = '';
            },
            isDense: true,
            value: controller.currentSubRegion.value,
            validator: (SubRegion? region) =>
                controller.dynamicValidator(region),
            decoration: Constants.decoration(
              hint: controller.subRegions.isEmpty ? null : 'Select',
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
    items = items.toSet().toList();
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular(18.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10.0,
                spreadRadius: 0.4,
                offset: Offset(
                  0,
                  6.0,
                ),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<ClusterId>(
            onChanged: (ClusterId? newValue) {
              controller.currentCluster.value = newValue!;
              controller.siteIDs
                  .assignAll(controller.currentCluster.value!.siteReference!);
              controller.currentSite.value = null;
              controller.siteName.text = '';
            },
            isDense: true,
            value: controller.currentCluster.value,
            validator: (cluster) => controller.dynamicValidator(cluster),
            decoration: Constants.decoration(
              hint: controller.clusters.isEmpty ? null : 'Select',
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
    items = items.toSet().toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              10,
            ),
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular(18.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10.0,
                spreadRadius: 0.4,
                offset: Offset(
                  0,
                  6.0,
                ),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<SiteReference>(
            onChanged: (SiteReference? newValue) {
              controller.currentSite.value = newValue!;
              controller.siteName.text = controller.currentSite.value!.name;
            },
            isDense: true,
            value: controller.currentSite.value,
            validator: (siteId) => controller.dynamicValidator(siteId),
            decoration: Constants.decoration(
              hint: controller.siteIDs.isEmpty ? null : 'Select',
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
    final data = SiteDetail._box.read('site_details');
    controller.siteDetails.value = SiteDetailModel(
      data: List<Datum>.from(data["data"].map((x) => Datum.fromJson(x))),
    );
    controller.operators.assignAll(controller.siteDetails.value.data!);
    controller.currentOperator.value = controller.operators.first;
    controller.regions.value = [];
    controller.subRegions.value = [];
    controller.clusters.value = [];
    controller.siteIDs.value = [];
    controller.currentRegion.value = Region();
    controller.currentSubRegion.value = SubRegion();
    controller.currentCluster.value = ClusterId();
    controller.currentSite.value = SiteReference(id: '', name: '');
    controller.siteName.text = '';
  }
}

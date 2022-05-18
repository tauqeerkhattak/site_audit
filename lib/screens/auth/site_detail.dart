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
  final AuthController controller;
  static GetStorage _box = GetStorage();
  SiteDetail({Key? key, required this.controller}) : super(key: key);

  @override
  State<SiteDetail> createState() => _SiteDetailState();
}

class _SiteDetailState extends State<SiteDetail> {
  @override
  void initState() {
    widget.controller.setLocation();
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
        key: widget.controller.key,
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
                      widget.controller.operators,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: regionDrop(
                      'Site Region',
                      widget.controller.regions,
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
                      widget.controller.subRegions,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: clusterDrop(
                      'Site Cluster',
                      widget.controller.clusters,
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
                      widget.controller.siteIDs,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: input(
                      'Site Name',
                      textController: widget.controller.siteName,
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
              textController: widget.controller.siteKeeper,
            ),
            SizedBox(
              height: 10,
            ),
            input(
              'Phone Number of Site Keeper',
              textController: widget.controller.siteKeeperPhone,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: simpleDrop(
                    label: 'Physical Site Type',
                    items: widget.controller.physicalSiteTypes,
                    onChanged: (String? type) {
                      widget.controller.currentSiteTypes.value =
                          type ?? 'Outdoor';
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
                    textController: widget.controller.surveyStart,
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
                    textController: widget.controller.longitude,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: input(
                    'Latitude',
                    textController: widget.controller.latitude,
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
                    items: widget.controller.weatherType,
                    onChanged: (String? weather) {
                      widget.controller.currentWeather.value =
                          weather ?? "Sunny";
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: input(
                    'Temperature',
                    textController: widget.controller.temperature,
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
                  await widget.controller.submitSiteDetails();
                  // Get.to(() => TempScreen());
                },
                loading: widget.controller.loading(),
                width: widget.controller.loading() ? 100 : Get.width,
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
              widget.controller.pickImage(ImageSource.camera);
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
              child: widget.controller.image.value.path == ''
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
                        widget.controller.image.value.path,
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
      {int? lines, TextEditingController? textController, bool? readOnly}) {
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
          validator: (String? text) => widget.controller.stringValidator(text),
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
            validator: (String? value) =>
                widget.controller.stringValidator(value),
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
              widget.controller.currentOperator.value = newValue!;
              widget.controller.regions.clear();
              widget.controller.regions
                  .assignAll(widget.controller.currentOperator.value!.region!);
              widget.controller.currentRegion.value = null;
              widget.controller.subRegions.clear();
              widget.controller.currentSubRegion.value = null;
              widget.controller.clusters.clear();
              widget.controller.currentCluster.value = null;
              widget.controller.siteIDs.clear();
              widget.controller.currentSite.value = null;
              widget.controller.siteName.text = '';
            },
            isDense: true,
            validator: (value) => widget.controller.dynamicValidator(value),
            decoration: Constants.decoration(hint: 'Select'),
            value: widget.controller.currentOperator.value,
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
              widget.controller.currentRegion.value = newValue!;
              widget.controller.subRegions
                  .assignAll(widget.controller.currentRegion.value!.subRegion!);
              widget.controller.currentSubRegion.value = null;
              widget.controller.clusters.clear();
              widget.controller.currentCluster.value = null;
              widget.controller.siteIDs.clear();
              widget.controller.currentSite.value = null;
              widget.controller.siteName.text = '';
            },
            isDense: true,
            value: widget.controller.currentRegion.value,
            validator: (value) => widget.controller.dynamicValidator(value),
            decoration: Constants.decoration(
              hint: widget.controller.regions.isEmpty ? null : 'Select',
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
              widget.controller.currentSubRegion.value = newValue!;
              widget.controller.clusters.assignAll(
                  widget.controller.currentSubRegion.value!.clusterId!);
              widget.controller.currentCluster.value = null;
              widget.controller.siteIDs.clear();
              widget.controller.currentSite.value = null;
              widget.controller.siteName.text = '';
            },
            isDense: true,
            value: widget.controller.currentSubRegion.value,
            validator: (SubRegion? region) =>
                widget.controller.dynamicValidator(region),
            decoration: Constants.decoration(
              hint: widget.controller.subRegions.isEmpty ? null : 'Select',
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
              widget.controller.currentCluster.value = newValue!;
              widget.controller.siteIDs.assignAll(
                  widget.controller.currentCluster.value!.siteReference!);
              widget.controller.currentSite.value = null;
              widget.controller.siteName.text = '';
            },
            isDense: true,
            value: widget.controller.currentCluster.value,
            validator: (cluster) => widget.controller.dynamicValidator(cluster),
            decoration: Constants.decoration(
              hint: widget.controller.clusters.isEmpty ? null : 'Select',
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
              widget.controller.currentSite.value = newValue!;
              widget.controller.siteName.text =
                  widget.controller.currentSite.value!.name;
            },
            isDense: true,
            value: widget.controller.currentSite.value,
            validator: (siteId) => widget.controller.dynamicValidator(siteId),
            decoration: Constants.decoration(
              hint: widget.controller.siteIDs.isEmpty ? null : 'Select',
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
    widget.controller.siteDetails.value = SiteDetailModel(
      data: List<Datum>.from(data["data"].map((x) => Datum.fromJson(x))),
    );
    widget.controller.operators
        .assignAll(widget.controller.siteDetails.value.data!);
    widget.controller.currentOperator.value = widget.controller.operators.first;
    widget.controller.regions = [];
    widget.controller.subRegions = [];
    widget.controller.clusters = [];
    widget.controller.siteIDs = [];
    widget.controller.currentRegion.value = Region();
    widget.controller.currentSubRegion.value = SubRegion();
    widget.controller.currentCluster.value = ClusterId();
    widget.controller.currentSite.value = SiteReference(id: '', name: '');
    widget.controller.siteName.text = '';
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/controllers/auth_controller.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

import '../../models/site_detail_model.dart';

class SiteDetail extends StatelessWidget {
  final AuthController controller;
  SiteDetail({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 30),
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
          input('Name of Site Kepper'),
          SizedBox(
            height: 10,
          ),
          input('Phone Number of Site Kepper'),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(child: operatorDrop('Physical Site Type', [])),
              SizedBox(
                width: 20,
              ),
              Expanded(child: input('Survey Start')),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(child: input('Longitude')),
              SizedBox(
                width: 20,
              ),
              Expanded(child: input('Latitude')),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(child: operatorDrop('Weather', [])),
              SizedBox(
                width: 20,
              ),
              Expanded(child: input('Temperature')),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          input('Site Photo from main entrance', lines: 5),
          SizedBox(
            height: 20,
          ),
          Obx(() => RoundedButton(
                text: 'Submit',
                onPressed: () => null,
                loading: controller.loading(),
                width: controller.loading() ? 100 : Get.width,
              ))
        ],
      ),
    );
  }

  Widget input(label, {int? lines, TextEditingController? controller}) {
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
        InputField(
          placeHolder: "",
          controller: controller,
          lines: lines,
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

  Widget regionDrop(label, List<Region> items) {
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
}

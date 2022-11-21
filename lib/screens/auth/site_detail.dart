// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:site_audit/controllers/auth_controller.dart';
// import 'package:site_audit/utils/constants.dart';
// import 'package:site_audit/utils/size_config.dart';
// import 'package:site_audit/utils/widget_utils.dart';
// import 'package:site_audit/widgets/input_field.dart';
// import 'package:site_audit/widgets/rounded_button.dart';
//
// import '../../models/site_detail_model.dart';
//
// class SiteDetail extends StatefulWidget {
//   SiteDetail({Key? key}) : super(key: key);
//
//   @override
//   State<SiteDetail> createState() => _SiteDetailState();
// }
//
// class _SiteDetailState extends State<SiteDetail> {
//   final controller = Get.find<AuthController>();
//   static GetStorage _box = GetStorage();
//
//   @override
//   void initState() {
//     controller.setLocation();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //TODO: Comment this
//     // setData();
//     ThemeData _theme = Theme.of(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // PAGE TITLE
//         Padding(
//           padding: const EdgeInsets.only(top: 50.0, left: 30),
//           child: Text(
//             'Add Site Details:',
//             style: _theme.textTheme.headline4,
//           ),
//         ),
//
//         Flexible(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 30),
//             physics: BouncingScrollPhysics(),
//             child: Form(
//               key: controller.key,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Text(
//                   //   'Add Site Details:',
//                   //   style: _theme.textTheme.headline4,
//                   // ),
//                   // WidgetUtils.spaceVrt10,
//                   Obx(
//                     () => Row(
//                       children: [
//                         Expanded(
//                           child: operatorDrop(
//                             'Site Operator',
//                             controller.operators,
//                           ),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                           child: regionDrop(
//                             'Site Region',
//                             controller.regions,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   WidgetUtils.spaceVrt10,
//                   Obx(
//                     () => Row(
//                       children: [
//                         Expanded(
//                           child: subRegionDrop(
//                             'Site Sub-Region',
//                             controller.subRegions,
//                           ),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                           child: clusterDrop(
//                             'Site Cluster',
//                             controller.clusters,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   WidgetUtils.spaceVrt10,
//                   Obx(
//                     () => Row(
//                       children: [
//                         Expanded(
//                           child: siteIdDrop(
//                             'Site ID',
//                             controller.siteIDs,
//                           ),
//                         ),
//                         WidgetUtils.spaceHrz20,
//                         Expanded(
//                           child: input(
//                             'Site Name',
//                             textController: controller.siteName,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // WidgetUtils.spaceVrt40,
//                   input(
//                     'Name of Site Keeper',
//                     textController: controller.siteKeeper,
//                   ),
//                   // WidgetUtils.spaceVrt10,
//                   input('Phone Number of Site Keeper',
//                       textController: controller.siteKeeperPhone,
//                       inputType: TextInputType.phone),
//                   // WidgetUtils.spaceVrt30,
//                   Row(
//                     children: [
//                       Expanded(
//                         child: simpleDrop(
//                           label: 'Physical Site Type',
//                           items: controller.physicalSiteTypes,
//                           onChanged: (String? type) {
//                             controller.currentSiteTypes.value =
//                                 type ?? 'Outdoor';
//                           },
//                         ),
//                       ),
//                       WidgetUtils.spaceHrz20,
//                       Expanded(
//                         child: input(
//                           'Survey Start',
//                           readOnly: true,
//                           textController: controller.surveyStart,
//                         ),
//                       ),
//                     ],
//                   ),
//                   // ALTITUDE IN METERS FIELD
//                   input('Altitude in Meters',
//                       textController: controller.altitude,
//                       inputType: TextInputType.phone),
//                   // WidgetUtils.spaceVrt10,
//                   Row(
//                     children: [
//                       Expanded(
//                         child: input(
//                           'Longitude',
//                           textController: controller.longitude,
//                         ),
//                       ),
//                       WidgetUtils.spaceHrz20,
//                       Expanded(
//                         child: input(
//                           'Latitude',
//                           textController: controller.latitude,
//                         ),
//                       ),
//                     ],
//                   ),
//                   // WidgetUtils.spaceVrt10,
//                   Row(
//                     children: [
//                       Expanded(
//                         child: simpleDrop(
//                           label: 'Weather',
//                           items: controller.weatherType,
//                           onChanged: (String? weather) {
//                             controller.currentWeather.value =
//                                 weather ?? "Sunny";
//                           },
//                         ),
//                       ),
//                       WidgetUtils.spaceHrz20,
//                       Expanded(
//                         child: input('Temperature',
//                             textController: controller.temperature,
//                             inputType: TextInputType.phone),
//                       ),
//                     ],
//                   ),
//                   // WidgetUtils.spaceVrt10,
//                   Obx(
//                     () => imageInput(
//                         'Site Photo from main entrance',
//                         controller.handleMainEntrancePhoto,
//                         controller.image.value.path),
//                   ),
//                   WidgetUtils.spaceVrt10,
//                   Divider(color: Constants.primaryColor, thickness: 1.5),
//                   // WidgetUtils.spaceVrt10,
//                   // ADDITIONAL PHOTOS
//                   Obx(() => imageInput(
//                       'Additional Photo 1',
//                       controller.handleAdditionalPhoto1,
//                       controller.image1.value.path)),
//                   input('Add Description',
//                       textController: controller.description1,
//                       noValidate: true),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Obx(() => imageInput(
//                                 'Additional Photo 2',
//                                 controller.handleAdditionalPhoto2,
//                                 controller.image2.value.path,
//                                 boxSize: 0.15)),
//                             input('Add Description',
//                                 textController: controller.description2,
//                                 noValidate: true),
//                           ],
//                         ),
//                       ),
//                       WidgetUtils.spaceHrz20,
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Obx(() => imageInput(
//                                 'Additional Photo 3',
//                                 controller.handleAdditionalPhoto3,
//                                 controller.image3.value.path,
//                                 boxSize: 0.15)),
//                             input('Add Description',
//                                 textController: controller.description3,
//                                 noValidate: true),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   Obx(
//                     () => RoundedButton(
//                       text: 'Submit',
//                       onPressed: () async {
//                         // Get.to(() => HomeScreen());
//                         log('Submit');
//                         // await controller.submitSiteDetails(context);
//                         // Get.to(() => TempScreen());
//                       },
//                       loading: controller.loading(),
//                       width: controller.loading() ? 0.1 : Get.width,
//                     ),
//                   ),
//                   // WidgetUtils.spaceVrt10,
//                   // RoundedButton(
//                   //   text: 'Go to Camera screen',
//                   //   onPressed: () async {
//                   //     // final res = await AppService.getSiteDetails();
//                   //     // log("HEHE: $res");
//                   //     Get.to(
//                   //       () => CameraScreen(
//                   //         lat: controller.latitude.text,
//                   //         long: controller.longitude.text,
//                   //       ),
//                   //     );
//                   //   },
//                   //   loading: controller.loading(),
//                   //   width: controller.loading() ? 0.1 : Get.width,
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget imageInput(label, VoidCallback action, String filePath,
//       {double? boxSize}) {
//     return Column(
//       children: [
//         Container(
//           alignment: Alignment.centerLeft,
//           decoration: BoxDecoration(
//               color: Colors.white, borderRadius: BorderRadius.circular(10)),
//           padding: EdgeInsets.symmetric(vertical: 5),
//           child: Text(
//             label + "\t\t",
//             textAlign: TextAlign.start,
//             style: TextStyle(
//               // color: Colors.white,
//               fontSize: SizeConfig.textMultiplier * 2.2,
//             ),
//           ),
//         ),
//         InkWell(
//           onTap: action,
//           child: Container(
//             height: SizeConfig.screenHeight * (boxSize ?? 0.2),
//             width: Get.width,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(18),
//               border: Border.all(
//                 color: Constants.primaryColor,
//               ),
//             ),
//             clipBehavior: Clip.hardEdge,
//             // child: controller.image.value.path == ''
//             child: filePath == ''
//                 ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.camera_alt,
//                         color: Constants.primaryColor,
//                         size: 30,
//                       ),
//                       Text(
//                         "Take Photo",
//                         textAlign: TextAlign.start,
//                         style: TextStyle(
//                           // color: Colors.white,
//                           fontSize: SizeConfig.textMultiplier * 2.2,
//                         ),
//                       ),
//                     ],
//                   )
//                 : Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10.0),
//                         child: Image.file(
//                           File(filePath),
//                           fit: BoxFit.fill,
//                         )),
//                   ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget input(label,
//       {int? lines,
//       TextEditingController? textController,
//       bool? readOnly,
//       bool? noValidate,
//       TextInputType? inputType}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(10)),
//             padding: EdgeInsets.symmetric(vertical: 5),
//             child: Text(
//               label + "\t\t",
//               textAlign: TextAlign.start,
//               style: TextStyle(
//                 // color: Colors.white,
//                 fontSize: SizeConfig.textMultiplier * 2.2,
//               ),
//             ),
//           ),
//           // SizedBox(height: 5,),
//           InputField(
//             placeHolder: "",
//             controller: textController,
//             readOnly: readOnly ?? false,
//             validator: noValidate == true
//                 ? null
//                 : (String? text) => controller.stringValidator(text),
//             lines: lines,
//             inputType: inputType,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget simpleDrop(
//       {label,
//       required List<String> items,
//       required Function(String?) onChanged}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           padding: EdgeInsets.symmetric(vertical: 5),
//           child: Text(
//             label + "\t\t",
//             textAlign: TextAlign.start,
//             style: TextStyle(
//               // color: Colors.white,
//               fontSize: SizeConfig.textMultiplier * 2.2,
//             ),
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: new BorderRadius.circular(18.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 blurRadius: 10.0,
//                 spreadRadius: 0.4,
//                 offset: Offset(0, 6.0),
//               )
//             ],
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: DropdownButtonFormField<String>(
//             onChanged: onChanged,
//             isDense: true,
//             validator: (String? value) => controller.stringValidator(value),
//             decoration: WidgetUtils.decoration(
//               hint: items.isEmpty ? 'Select' : null,
//             ),
//             items: items.map<DropdownMenuItem<String>>((String? value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value ?? 'N/A'),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget operatorDrop(label, List<Datum> items) {
//     items = items.toSet().toList();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//               color: Colors.white, borderRadius: BorderRadius.circular(10)),
//           padding: EdgeInsets.symmetric(vertical: 5),
//           child: Text(
//             label + "\t\t",
//             textAlign: TextAlign.start,
//             style: TextStyle(
//               // color: Colors.white,
//               fontSize: SizeConfig.textMultiplier * 2.2,
//             ),
//           ),
//         ),
//         // SizedBox(height: 5,),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: new BorderRadius.circular(18.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 blurRadius: 10.0,
//                 spreadRadius: 0.4,
//                 offset: Offset(
//                   0,
//                   6.0,
//                 ),
//               ),
//             ],
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: DropdownButtonFormField<Datum?>(
//             onChanged: (Datum? newValue) {
//               controller.currentOperator.value = newValue!;
//               controller.regions.clear();
//               controller.regions
//                   .assignAll(controller.currentOperator.value!.region!);
//               controller.currentRegion.value = null;
//               controller.subRegions.clear();
//               controller.currentSubRegion.value = null;
//               controller.clusters.clear();
//               controller.currentCluster.value = null;
//               controller.siteIDs.clear();
//               controller.currentSite.value = null;
//               controller.siteName.text = '';
//             },
//             isDense: true,
//             validator: (value) => controller.dynamicValidator(value),
//             decoration: WidgetUtils.decoration(hint: 'Select'),
//             value: controller.currentOperator.value,
//             // value: controller.currentOperator.value,
//             items: items.map<DropdownMenuItem<Datum?>>((Datum? value) {
//               return DropdownMenuItem<Datum?>(
//                 value: value,
//                 child: Text("${value?.datumOperator}"),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget regionDrop(
//     label,
//     List<Region> items,
//   ) {
//     items = items.toSet().toList();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(
//               10,
//             ),
//           ),
//           padding: EdgeInsets.symmetric(vertical: 5),
//           child: Text(
//             label + "\t\t",
//             textAlign: TextAlign.start,
//             style: TextStyle(
//               // color: Colors.white,
//               fontSize: SizeConfig.textMultiplier * 2.2,
//             ),
//           ),
//         ),
//         // SizedBox(height: 5,),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: new BorderRadius.circular(18.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 blurRadius: 10.0,
//                 spreadRadius: 0.4,
//                 offset: Offset(0, 6.0),
//               ),
//             ],
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: DropdownButtonFormField<Region>(
//             onChanged: (Region? newValue) {
//               controller.currentRegion.value = newValue!;
//               controller.subRegions
//                   .assignAll(controller.currentRegion.value!.subRegion!);
//               controller.currentSubRegion.value = null;
//               controller.clusters.clear();
//               controller.currentCluster.value = null;
//               controller.siteIDs.clear();
//               controller.currentSite.value = null;
//               controller.siteName.text = '';
//             },
//             isDense: true,
//             value: controller.currentRegion.value,
//             validator: (value) => controller.dynamicValidator(value),
//             decoration: WidgetUtils.decoration(
//               hint: controller.regions.isEmpty ? null : 'Select',
//             ),
//             items: items.map<DropdownMenuItem<Region>>((Region value) {
//               return DropdownMenuItem<Region>(
//                 value: value,
//                 child: Text(value.name!),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget subRegionDrop(label, List<SubRegion> items) {
//     items = items.toSet().toList();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//               color: Colors.white, borderRadius: BorderRadius.circular(10)),
//           padding: EdgeInsets.symmetric(vertical: 5),
//           child: Text(
//             label + "\t\t",
//             textAlign: TextAlign.start,
//             style: TextStyle(
//               fontSize: SizeConfig.textMultiplier * 2.2,
//             ),
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: new BorderRadius.circular(18.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 blurRadius: 10.0,
//                 spreadRadius: 0.4,
//                 offset: Offset(
//                   0,
//                   6.0,
//                 ),
//               ),
//             ],
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: DropdownButtonFormField<SubRegion>(
//             onChanged: (SubRegion? newValue) {
//               controller.currentSubRegion.value = newValue!;
//               controller.clusters
//                   .assignAll(controller.currentSubRegion.value!.clusterId!);
//               controller.currentCluster.value = null;
//               controller.siteIDs.clear();
//               controller.currentSite.value = null;
//               controller.siteName.text = '';
//             },
//             isDense: true,
//             value: controller.currentSubRegion.value,
//             validator: (SubRegion? region) =>
//                 controller.dynamicValidator(region),
//             decoration: WidgetUtils.decoration(
//               hint: controller.subRegions.isEmpty ? null : 'Select',
//             ),
//             items: items.map<DropdownMenuItem<SubRegion>>((SubRegion value) {
//               return DropdownMenuItem<SubRegion>(
//                 value: value,
//                 child: Text(value.name!),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget clusterDrop(label, List<ClusterId> items) {
//     items = items.toSet().toList();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//               color: Colors.white, borderRadius: BorderRadius.circular(10)),
//           padding: EdgeInsets.symmetric(vertical: 5),
//           child: Text(
//             label + "\t\t",
//             textAlign: TextAlign.start,
//             style: TextStyle(
//               // color: Colors.white,
//               fontSize: SizeConfig.textMultiplier * 2.2,
//             ),
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: new BorderRadius.circular(18.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 blurRadius: 10.0,
//                 spreadRadius: 0.4,
//                 offset: Offset(
//                   0,
//                   6.0,
//                 ),
//               ),
//             ],
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: DropdownButtonFormField<ClusterId>(
//             onChanged: (ClusterId? newValue) {
//               controller.currentCluster.value = newValue!;
//               controller.siteIDs
//                   .assignAll(controller.currentCluster.value!.siteReference!);
//               controller.currentSite.value = null;
//               controller.siteName.text = '';
//             },
//             isDense: true,
//             value: controller.currentCluster.value,
//             validator: (cluster) => controller.dynamicValidator(cluster),
//             decoration: WidgetUtils.decoration(
//               hint: controller.clusters.isEmpty ? null : 'Select',
//             ),
//             items: items.map<DropdownMenuItem<ClusterId>>((ClusterId value) {
//               return DropdownMenuItem<ClusterId>(
//                 value: value,
//                 child: Text(value.id!),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget siteIdDrop(label, List<SiteReference> items) {
//     items = items.toSet().toList();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(
//               10,
//             ),
//           ),
//           padding: EdgeInsets.symmetric(vertical: 5),
//           child: Text(
//             label + "\t\t",
//             textAlign: TextAlign.start,
//             style: TextStyle(
//               // color: Colors.white,
//               fontSize: SizeConfig.textMultiplier * 2.2,
//             ),
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: new BorderRadius.circular(18.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 blurRadius: 10.0,
//                 spreadRadius: 0.4,
//                 offset: Offset(
//                   0,
//                   6.0,
//                 ),
//               ),
//             ],
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: DropdownButtonFormField<SiteReference>(
//             onChanged: (SiteReference? newValue) {
//               controller.currentSite.value = newValue!;
//               controller.siteName.text = controller.currentSite.value!.name;
//             },
//             isDense: true,
//             value: controller.currentSite.value,
//             validator: (siteId) => controller.dynamicValidator(siteId),
//             decoration: WidgetUtils.decoration(
//               hint: controller.siteIDs.isEmpty ? null : 'Select',
//             ),
//             items: items
//                 .map<DropdownMenuItem<SiteReference>>((SiteReference value) {
//               return DropdownMenuItem<SiteReference>(
//                 value: value,
//                 child: Text(value.id),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void setData() {
//     final data = _box.read('site_details');
//     controller.siteDetails.value = SiteDetailModel(
//       data: List<Datum>.from(data["data"].map((x) => Datum.fromJson(x))),
//     );
//     controller.operators.assignAll(controller.siteDetails.value.data!);
//     controller.currentOperator.value = controller.operators.first;
//     controller.regions = [];
//     controller.subRegions = [];
//     controller.clusters = [];
//     controller.siteIDs = [];
//     controller.currentRegion.value = Region();
//     controller.currentSubRegion.value = SubRegion();
//     controller.currentCluster.value = ClusterId();
//     controller.currentSite.value = SiteReference(id: '', name: '');
//     controller.siteName.text = '';
//   }
//
//   // Widget imageBox(VoidCallback action, String boxTitle, String filePath, {double? boxSize}) {
//   //   return ;
//   // }
// }

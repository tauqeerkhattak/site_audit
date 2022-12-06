import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/auth_controller.dart';
import 'package:site_audit/screens/dashboard/dashboard_screen.dart';
import 'package:site_audit/widgets/default_layout.dart';

import '../../models/static_drop_model.dart';
import '../../utils/ui_utils.dart';
import '../../utils/validator.dart';
import '../../utils/widget_utils.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/input_field.dart';
import '../../widgets/rounded_button.dart';

class AddSiteData extends StatelessWidget {
  final controller = Get.find<AuthController>();
  AddSiteData({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: DefaultLayout(
        padding: 10,
        showBackButton: false,
        title: 'Add Site Data',
        child: Obx(
          () {
            if (controller.loading.value) {
              return const Center(
                child: UiUtils.loadingIndicator,
              );
            } else if (controller.staticDrops.value != null) {
              return _body();
            } else {
              return const CustomErrorWidget(
                errorText: 'Something went wrong, please restart the app!',
                type: ErrorType.nullData,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _body() {
    return Form(
      key: controller.siteDataKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: operatorDrop(
                  'Site Operator',
                  controller.operators,
                ),
              ),
              UiUtils.spaceHzt20,
              Expanded(
                child: regionDrop(
                  'Site Region',
                  controller.regions,
                ),
              ),
            ],
          ),
          WidgetUtils.spaceVrt10,
          Row(
            children: [
              Expanded(
                child: subRegionDrop(
                  'Site Sub-Region',
                  controller.subRegions,
                ),
              ),
              UiUtils.spaceHzt20,
              Expanded(
                child: clusterDrop(
                  'Site Cluster',
                  controller.clusters,
                ),
              ),
            ],
          ),
          WidgetUtils.spaceVrt10,
          Row(
            children: [
              Expanded(
                child: siteIdDrop(
                  'Site ID',
                  controller.siteIDs,
                ),
              ),
              UiUtils.spaceHzt20,
              Expanded(
                child: InputField(
                  label: 'Site Name',
                  readOnly: true,
                  placeHolder: 'Site Name',
                  mandatory: true,
                  mandatoryText: '*',
                  validator: Validator.stringValidator,
                  controller: controller.siteName,
                ),
              ),
            ],
          ),
          const Spacer(),
          RoundedButton(
            color: Colors.green,
            text: 'Submit',
            onPressed: controller.onSubmit,
          ),
        ],
      ),
    );
  }

  Widget operatorDrop(label, List<Datum> items) {
    items = items.toSet().toList();
    return CustomDropdown<Datum?>(
      items: items,
      hint: 'Select',
      label: 'Site Operator',
      mandatory: true,
      mandatoryText: '*',
      validator: Validator.dynamicValidator,
      value: controller.currentOperator.value,
      onChanged: (value) {
        controller.currentOperator.value = value!;
        controller.regions.clear();
        controller.regions.assignAll(controller.currentOperator.value!.region!);
        controller.currentRegion.value = null;
        controller.subRegions.clear();
        controller.currentSubRegion.value = null;
        controller.clusters.clear();
        controller.currentCluster.value = null;
        controller.siteIDs.clear();
        controller.currentSite.value = null;
        controller.siteName.text = '';
      },
    );
  }

  Widget regionDrop(String label, List<Region> items) {
    items = items.toSet().toList();
    return CustomDropdown<Region>(
      items: items,
      label: label,
      hint: 'Select',
      validator: Validator.dynamicValidator,
      value: controller.currentRegion.value,
      mandatory: true,
      mandatoryText: '*',
      onChanged: (value) {
        controller.currentRegion.value = value!;
        controller.subRegions.assignAll(value.subRegion!);
        controller.currentSubRegion.value = null;
        controller.clusters.clear();
        controller.currentCluster.value = null;
        controller.siteIDs.clear();
        controller.currentSite.value = null;
        controller.siteName.text = '';
      },
    );
  }

  Widget subRegionDrop(label, List<SubRegion> items) {
    items = items.toSet().toList();
    return CustomDropdown<SubRegion>(
      label: 'Site Sub-Region',
      hint: 'Select',
      validator: Validator.dynamicValidator,
      value: controller.currentSubRegion.value,
      mandatory: true,
      mandatoryText: '*',
      items: items,
      onChanged: (value) {
        controller.currentSubRegion.value = value!;
        controller.clusters
            .assignAll(controller.currentSubRegion.value!.clusterId!);
        controller.currentCluster.value = null;
        controller.siteIDs.clear();
        controller.currentSite.value = null;
        controller.siteName.text = '';
      },
    );
  }

  Widget clusterDrop(label, List<ClusterId> items) {
    items = items.toSet().toList();
    return CustomDropdown<ClusterId>(
      label: 'Site Cluster',
      hint: 'Select',
      value: controller.currentCluster.value,
      validator: Validator.dynamicValidator,
      mandatory: true,
      mandatoryText: '*',
      items: items,
      onChanged: (value) {
        controller.currentCluster.value = value!;
        controller.siteIDs
            .assignAll(controller.currentCluster.value!.siteReference!);
        controller.currentSite.value = null;
        controller.siteName.text = '';
      },
    );
  }

  Widget siteIdDrop(label, List<SiteReference> items) {
    items = items.toSet().toList();
    return CustomDropdown<SiteReference>(
      items: items,
      label: 'Site ID',
      hint: 'Select',
      value: controller.currentSite.value,
      mandatory: true,
      mandatoryText: '*',
      validator: Validator.dynamicValidator,
      onChanged: (value) {
        controller.currentSite.value = value;
        controller.siteName.text = controller.currentSite.value!.name!;
      },
    );
  }
}

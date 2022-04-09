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
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Add\nSite\nDetails:', style: _theme.textTheme.headline4,),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: operatorDrop('Site Operator',controller.operators)),
              SizedBox(width: 20,),
              Expanded(child: regionDrop('Site Region',controller.regions)),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: operatorDrop('Site Sub-Region',[])),
              SizedBox(width: 20,),
              Expanded(child: operatorDrop('Site Cluster',[])),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: operatorDrop('Site ID',[])),
              SizedBox(width: 20,),
              Expanded(child: input('Site Name')),
            ],
          ),
          SizedBox(height: 40,),
          input('Name of Site Kepper'),
          SizedBox(height: 10,),
          input('Phone Number of Site Kepper'),
          SizedBox(height: 30,),
          Row(
            children: [
              Expanded(child: operatorDrop('Physical Site Type',[])),
              SizedBox(width: 20,),
              Expanded(child: input('Survey Start')),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: input('Longitude')),
              SizedBox(width: 20,),
              Expanded(child: input('Latitude')),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: operatorDrop('Weather',[])),
              SizedBox(width: 20,),
              Expanded(child: input('Temperature')),
            ],
          ),
          SizedBox(height: 10,),
          input('Site Photo from main entrance', lines: 5),
          SizedBox(height: 20,),
          Obx(() => RoundedButton(
            text: 'Submit',
            onPressed: () => null,
            loading: controller.loading(),
            width: controller.loading() ? 100 : Get.width,
          ))

        ],
      ),),
    );
  }

  Widget input(label, {int? lines}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(label + "\t\t",
              textAlign: TextAlign.start,
              style: TextStyle(
                // color: Colors.white,
                  fontSize: SizeConfig.textMultiplier * 2.2
              )),
        ),
        // SizedBox(height: 5,),
        InputField(
          placeHolder: "",
          lines: lines,
        ),
      ],
    );
  }

  Widget operatorDrop(label,List <Datum> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(label + "\t\t",
              textAlign: TextAlign.start,
              style: TextStyle(
                // color: Colors.white,
                  fontSize: SizeConfig.textMultiplier * 2.2
              )),
        ),
        // SizedBox(height: 5,),
        Container(
          decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(18.0),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10.0, spreadRadius: 0.4, offset: Offset(0, 6.0))
              ]),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<Datum>(
            onChanged: (Datum? newValue) {
              controller.currentOperator.value = newValue!;
              controller.regions = controller.currentOperator.value.region!;
            },
            isDense: true,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(color: Color(0xffBDBDBD).withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            items: items.map<DropdownMenuItem<Datum>>((Datum value) {
              return DropdownMenuItem<Datum>(
                value: value,
                child: Text(value.datumOperator!),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget regionDrop(label,List <Region> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(label + "\t\t",
              textAlign: TextAlign.start,
              style: TextStyle(
                // color: Colors.white,
                  fontSize: SizeConfig.textMultiplier * 2.2
              )),
        ),
        // SizedBox(height: 5,),
        Container(
          decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(18.0),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10.0, spreadRadius: 0.4, offset: Offset(0, 6.0))
              ]),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<String>(
            onChanged: (String? newValue) {},
            isDense: true,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(color: Color(0xffBDBDBD).withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            items: items.map<DropdownMenuItem<String>>((Region value) {
              return DropdownMenuItem<String>(
                value: value.name,
                child: Text(value.name!),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

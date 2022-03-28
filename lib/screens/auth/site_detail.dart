import 'package:flutter/material.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class SiteDetail extends StatelessWidget {
  const SiteDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(top: 70),
      child: Column(
        children: [
          Text('Add Site Details', style: _theme.textTheme.headline6),
          Divider(height: 40,),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text('Select value from dropdown menu,screen Auto-Builds Based',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              // color: Colors.white,
                                fontSize: 23
                            )),

                        SizedBox(height: 30,),
                        Row(
                          children: [
                            Expanded(child: selectionDrop('Site Operator')),
                            SizedBox(width: 20,),
                            Expanded(child: selectionDrop('Site Region')),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(child: selectionDrop('Site Sub-Region')),
                            SizedBox(width: 20,),
                            Expanded(child: selectionDrop('Site Cluster')),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(child: selectionDrop('Site ID')),
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
                            Expanded(child: selectionDrop('Physical Site Type')),
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
                            Expanded(child: selectionDrop('Weather')),
                            SizedBox(width: 20,),
                            Expanded(child: input('Temperature')),
                          ],
                        ),
                        SizedBox(height: 10,),
                        input('Site Photo from main entrance', lines: 5),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RoundedButton(text: 'Help', onPressed: () => null,),
                            RoundedButton(text: 'Next', onPressed: () => null),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget input(label, {int? lines}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            textAlign: TextAlign.start,
            style: TextStyle(
              // color: Colors.white,
                fontSize: 18
            )),
        SizedBox(height: 5,),
        InputField(
          placeHolder: "",
          lines: lines,
        ),
      ],
    );
  }

  Widget selectionDrop(label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            textAlign: TextAlign.start,
            style: TextStyle(
              // color: Colors.white,
                fontSize: 18
            )),
        SizedBox(height: 5,),
        DropdownButtonFormField<String>(
          onChanged: (String? newValue) {},
          isDense: true,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Color(0xffF6F6F6),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Color(0xffBDBDBD)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Color(0xffE8E8E8)),
            ),
          ),
          items: <String>['One', 'Two', 'Free', 'Four']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}

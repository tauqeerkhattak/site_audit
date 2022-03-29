import 'package:flutter/material.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class ConfirmDetail extends StatelessWidget {
  final action;
  const ConfirmDetail({Key? key, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 30, right: 30, top: 70, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Confirm\nEngineer\nDetails:', style: _theme.textTheme.headline4,),
          SizedBox(height: 10,),
          InputField(placeHolder: "Name",),
          SizedBox(height: 10,),
          InputField(placeHolder: "Email",),
          SizedBox(height: 10,),
          InputField(placeHolder: "Phone",),
          SizedBox(height: 30,),
          RoundedButton(text: 'Next', onPressed: () => action(),)
        ],
      ),
    );
  }
}
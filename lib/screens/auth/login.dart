import 'package:flutter/material.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class LoginScreen extends StatelessWidget {
  final action;
  const LoginScreen({Key? key, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return SingleChildScrollView(
      // height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(top: 70, left: 30, right: 30, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset("assets/images/op_co_services.png", scale: 3.0,),
          SizedBox(height: 20,),
          Text('iServAudit', style: _theme.textTheme.headline3,),
          SizedBox(height: 10,),
          Text('Site Audit\nApp\nLogin:', style: _theme.textTheme.headline4,),
          SizedBox(height: 10,),
          Text('Please enter the Engineer ID and Password that were supplied to you....',
              // textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                // fontWeight: FontWeight.w400
              )),

          SizedBox(height: 30,),
          InputField(placeHolder: "Email",),
          SizedBox(height: 20,),
          InputField(placeHolder: "Password",),
          SizedBox(height: 30,),
          RoundedButton(text: 'Login', onPressed: handleClick)
        ],
      ),
    );
  }

  handleClick() => action();
}

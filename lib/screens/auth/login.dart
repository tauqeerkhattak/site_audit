import 'package:flutter/material.dart';
import 'package:site_audit/widgets/input_field.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return SingleChildScrollView(
      // height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 30),
      child: Column(
        children: [
          Image.asset("assets/images/op_co_services.png", scale: 3.0,),
          SizedBox(height: 30,),
          Text('iServAudit', style: _theme.textTheme.headline3,),
          SizedBox(height: 30,),
          Text('Site Audit APP Login:', style: _theme.textTheme.headline4,),
          SizedBox(height: 30,),
          Text('Please enter the Engineer ID and Password that were supplied to you....',
              textAlign: TextAlign.center,
              style: TextStyle(
                // color: Colors.white,
                  fontSize: 23
              )),

          SizedBox(height: 30,),
          InputField(
            placeHolder: "",
          ),
          SizedBox(height: 10,),
          InputField(
            placeHolder: "",
          ),
        ],
      ),
    );
  }
}

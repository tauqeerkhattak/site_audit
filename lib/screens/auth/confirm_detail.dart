import 'package:flutter/material.dart';
import 'package:site_audit/widgets/input_field.dart';

class ConfirmDetail extends StatelessWidget {
  const ConfirmDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return SingleChildScrollView(
      // height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(top: 70, bottom: 30),
      child: Column(
        children: [
          // SizedBox(height: 30,),
          Text('Confirm Engineer Details', style: _theme.textTheme.headline6),
          Divider(height: 40,),
          SizedBox(height: 30,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text('If the details below are correct, tap "NEXT"',
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
                SizedBox(height: 10,),
                InputField(
                  placeHolder: "",
                ),
                SizedBox(height: 30,),
                Text('If any details have changed, TAP the incorrect field, update then tap "NEXT"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // color: Colors.white,
                        fontSize: 23
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
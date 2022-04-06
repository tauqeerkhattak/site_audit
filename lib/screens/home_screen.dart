import 'package:flutter/material.dart';
import 'package:site_audit/utils/size_config.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 70, left: 30, right: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Site Audit', style: _theme.textTheme.headline3,),
            SizedBox(height: 30,),
            //
            // Row(
            //   children: [
            //     progress(),
            //     SizedBox(width: 60,),
            //     progress(),
            //   ],
            // ),

            // SizedBox(height: 20,),
            // customCard(
            //   height: 100,
            //   image: 'assets/images/33810963.jpg',
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Text('Services', style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.8),),
            //       Text('128m'),
            //     ],
            //   )
            // ),

            SizedBox(height: 20,),

            Row(
              children: [
                tileCard('Antenna Support Structure', 3),
                SizedBox(width: 20,),
                tileCard('Equipment Housing\n', 2),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                tileCard('Radio Access\n(RAN)', 1),
                SizedBox(width: 20,),
                tileCard('Transmission Transport', 3),
              ],
            ),

            SizedBox(height: 20,),
            Row(
              children: [
                tileCard('AC Power \n', 1),
                SizedBox(width: 20,),
                tileCard('Site Security\n', 3),
              ],
            ),

            SizedBox(height: 20,),
            Row(
              children: [
                tileCard('Other Active', 0),
                SizedBox(width: 20,),
                tileCard('Other Passive', 0),
              ],
            ),

            SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedButton(text: 'Help', onPressed: () => null,),
                RoundedButton(text: 'Send Data', onPressed: () => null, color: Colors.green,),
              ],
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: customCard(
            //           height: 100,
            //           image: 'assets/images/istockphoto-1184778656-612x612.jpg',
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.stretch,
            //             // mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Text('Strength', style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.8),),
            //               Text('128m'),
            //             ],
            //           )
            //       ),
            //     ),
            //     SizedBox(width: 20,),
            //     Expanded(
            //       child: customCard(
            //           height: 100,
            //           image: 'assets/images/33810971.jpg',
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.stretch,
            //             // mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Text('Areas', style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.8),),
            //               Text('128m'),
            //             ],
            //           )
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget tileCard(text, length) {
    return Expanded(
      child: customCard(
          height: 120,
          image: 'assets/images/istockphoto-1184778656-612x612.jpg',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.0, fontWeight: FontWeight.w700),),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5.0)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(length, (index) => Checkbox(
                    checkColor: Colors.white,
                    value: true,
                    onChanged: (bool? value) {},
                  )),
                ),
              ),
              // Text('128m'),
            ],
          )
      ),
    );
  }

  Widget customCard({required Widget child, double? height, String? image}) {
    return Container(
      decoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular(18.0),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10.0, spreadRadius: 0.4, offset: Offset(0, 0.0))
          ],
        // image: DecorationImage(
        //   image: AssetImage(image!),
        //   alignment: Alignment.centerRight,
        // )
      ),
      clipBehavior: Clip.antiAlias,
      height: height ?? null,
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.0),
      child: child,
    );
  }

  Widget progress() {
    return Expanded(child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Services', style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.8),),
        Text('128m/300m', style: TextStyle(color: Colors.grey),),
        Container(
          height: 3,
          width: 100,
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20)
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20)
              ),
              height: 3,
              width: 60,
            ),
          ),
        ),
      ],
    ));
  }
}

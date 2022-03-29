import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:site_audit/screens/auth/confirm_detail.dart';
import 'package:site_audit/screens/auth/login.dart';
import 'package:site_audit/screens/auth/site_detail.dart';
import 'package:site_audit/widgets/rounded_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  PageController pageController = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: new Image.asset("assets/images/transmission-tower-6504538_1280.png", fit: BoxFit.cover,),
          ),

          Center(
            child: new ClipRect(
              child: new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: new Container(
                  // width: 200.0,
                  // height: 200.0,
                  decoration: new BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
                  child: Container(
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: pageController,
                      children: [
                        LoginScreen(),
                        ConfirmDetail(),
                        SiteDetail()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          if(index <= 1)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundedButton(text: 'Help', onPressed: () => null,),
                  RoundedButton(text: 'Next', onPressed: handleNext),
                ],
              ),
            ),

        ],
      ),
      // bottomNavigationBar: index > 1 ? null : Padding(
      //   padding: const EdgeInsets.only(bottom: 20.0, right: 20, left: 20),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       RoundedButton(text: 'Help', onPressed: () => null,),
      //       RoundedButton(text: 'Next', onPressed: handleNext),
      //     ],
      //   ),
      // ),
    );
  }

  handleNext() {
    setState(() {
      index += 1;
    });
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
}

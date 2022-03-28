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
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            LoginScreen(),
            ConfirmDetail(),
            SiteDetail()
          ],
      ),
      bottomNavigationBar: index > 1 ? null : Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 20, left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundedButton(text: 'Help', onPressed: () => null,),
            RoundedButton(text: 'Next', onPressed: handleNext),
          ],
        ),
      ),
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

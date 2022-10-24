import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/ui_utils.dart';

class CustomCard extends StatelessWidget {
  final String title, buttonText;
  final void Function() onTap;

  const CustomCard({
    Key? key,
    required this.title,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      elevation: 10.0,
      color: Colors.white.withRed(250),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: UiUtils.allInsets10,
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: onTap,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Constants.primaryColor,
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(10.0),
                  ),
                ),
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

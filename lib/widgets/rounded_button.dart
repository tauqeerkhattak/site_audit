import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  const RoundedButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => null,
        child: Text(text),
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        textStyle: TextStyle(fontSize: 20)
      ),
    );
  }
}

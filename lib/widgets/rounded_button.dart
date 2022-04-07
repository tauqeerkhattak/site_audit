import 'package:flutter/material.dart';
import 'package:site_audit/utils/constants.dart';
import 'package:site_audit/utils/size_config.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color? color;
  final bool? loading;
  final double? width;
  final VoidCallback? onPressed;
  const RoundedButton({Key? key, required this.text, this.width, this.onPressed, this.color, this.loading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          decoration: BoxDecoration(
            color: color ?? Constants.primaryColor,
            borderRadius: loading! ? BorderRadius.circular(100.0) : BorderRadius.circular(18.0),
            // shape: loading! ? BoxShape.circle : BoxShape.rectangle,
          ),
          // width: !loading! ? 100 : double.infinity,
          width: width!,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: loading! ?
          CircularProgressIndicator(color: Colors.white,) :
          Text(text, style: TextStyle(color: Colors.white, fontSize: SizeConfig.textMultiplier * 2.8, fontFamily: 'Ubuntu', fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}

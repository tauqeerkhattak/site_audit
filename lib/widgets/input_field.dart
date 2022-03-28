import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({Key? key, this.onTap, this.placeHolder, this.readOnly, this.icon, this.vertical, this.horizontal}) : super(key: key);

  final String? placeHolder;
  final Widget? icon;
  final bool? readOnly;
  final double? vertical, horizontal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical ?? 0.0, horizontal: horizontal ?? 0.0,),
      child: TextField(
        // style: TextStyle(fontFamily: 'Heebo'),
        readOnly: readOnly ?? false,
        onTap: onTap,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Color(0xffF6F6F6),
          hintText: placeHolder.toString(),
          prefixIcon: icon,
          hintStyle: TextStyle(fontFamily: 'Heebo'),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Color(0xffBDBDBD)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Color(0xffE8E8E8)),
          ),
        ),
      ),
    );
  }
}

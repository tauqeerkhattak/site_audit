import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({Key? key, this.onTap, this.placeHolder, this.readOnly, this.icon, this.vertical, this.horizontal, this.lines}) : super(key: key);

  final String? placeHolder;
  final Widget? icon;
  final bool? readOnly;
  final double? vertical, horizontal;
  final VoidCallback? onTap;
  final int? lines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      // style: TextStyle(fontFamily: 'Heebo'),
      readOnly: readOnly ?? false,
      onTap: onTap,
      maxLines: lines ?? null,
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
    );
  }
}

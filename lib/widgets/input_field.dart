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
    return Container(
      decoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10.0, spreadRadius: 0.4, offset: Offset(0, 6.0))
          ]),
      clipBehavior: Clip.antiAlias,
      child: TextField(
        // style: TextStyle(fontFamily: 'Heebo'),
        readOnly: readOnly ?? false,
        onTap: onTap,
        maxLines: lines ?? null,
        decoration: InputDecoration(
          // isDense: true,
          filled: true,
          // fillColor: Color(0xffF6F6F6),
          fillColor: Colors.white,
          hintText: placeHolder.toString(),
          prefixIcon: icon,
          hintStyle: TextStyle(fontFamily: 'Ubuntu', color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.w500),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Color(0xffBDBDBD).withOpacity(0.5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            // borderSide: BorderSide(color: Color(0xffE8E8E8)),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

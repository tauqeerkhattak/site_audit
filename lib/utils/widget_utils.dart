import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WidgetUtils {
  static SizedBox spaceVrt10 = const SizedBox(
    height: 10.0,
  );
  static SizedBox spaceVrt20 = const SizedBox(
    height: 20.0,
  );
  static SizedBox spaceVrt30 = const SizedBox(
    height: 30.0,
  );
  static SizedBox spaceVrt40 = const SizedBox(
    height: 40.0,
  );
  static SizedBox spaceHrz10 = const SizedBox(
    width: 10.0,
  );
  static SizedBox spaceHrz20 = const SizedBox(
    width: 20.0,
  );

  static InputDecoration decoration({String? hint}) {
    return InputDecoration(
      isDense: true,
      filled: true,
      hintText: hint,
      fillColor: Colors.white,
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide.none,
        gapPadding: 0.0,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        borderSide: BorderSide(color: const Color(0xffBDBDBD).withOpacity(0.5)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide.none,
        gapPadding: 0.0,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }

  static Widget imageWidget({
    required File image,
    required double lat,
    required double long,
    required DateTime dateTime,
  }) {
    DateFormat format = DateFormat('dd-MM-yyyy hh:mm a');
    return Container(
      height: Get.height * 0.9,
      width: Get.width,
      //width: 20,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          Image.file(
            image,
            fit: BoxFit.cover,
            // height: Get.height * 0.8,
            width: Get.width,
          ),
          Positioned(
            bottom: 60,
            left: 20,
            child: Text(
              'Lat: $lat',
              style: const TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: Text(
              'Long: $long',
              style: const TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              'Dated: ${format.format(dateTime)}',
              style: const TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

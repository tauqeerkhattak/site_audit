import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SizeConfig {
  static late double _screenWidth;
  static late double _screenHeight;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;
  static late double screenWidth;
  static late double screenHeight;

  static void init(Orientation orientation) {
    final size = Get.size;
    if (orientation == Orientation.portrait) {
      _screenWidth = size.width;
      _screenHeight = size.height;
    } else {
      _screenWidth = size.height;
      _screenHeight = size.width;
    }
    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    screenWidth = _screenWidth;
    screenHeight = _screenHeight;
    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;

    // print("Image Size\n");
    // print(imageSizeMultiplier);

    // print("Text Size\n");
    // print(textMultiplier);

    // print("Height Size\n");
    // print(heightMultiplier);
  }
}

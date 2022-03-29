import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _blockSizeHorizontal = 0;
  static late double _blockSizeVertical = 0;

  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;
  static late double screenWidth;
  static late double screenHeight;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
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

import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerService extends GetxService {
  static final ImagePicker _picker = ImagePicker();

  Future<String?> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      return image.path;
    } else {
      return null;
    }
  }
}

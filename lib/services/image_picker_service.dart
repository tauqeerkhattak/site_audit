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
      final directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      String imagePath = image.path;
      List<String> splits = imagePath.split('.');
      final extension = splits.last;
      File imageFile = File(imagePath);
      imageFile = await imageFile.copy('$path/.$extension');
      return imageFile.path;
    } else {
      return null;
    }
  }
}

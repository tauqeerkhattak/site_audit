// import 'package:get_storage/get_storage.dart';
import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<void> request() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.location,
      Permission.camera,
      Permission.storage,
    ].request();
    log('TOTAL PERMISSIONS: ${permissions.length}');
  }
}

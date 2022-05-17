import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static GetStorage _box = GetStorage();
  static void request() async {
    await _box.erase();
    Map<Permission, PermissionStatus> permissions = await [
      Permission.location,
      Permission.camera,
      Permission.storage,
    ].request();
  }
}

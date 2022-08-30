import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageService extends GetxService {
  final _box = GetStorage();

  Future<void> save({required String key, required dynamic value}) async {
    log('Data has been written!');
    await _box.write(key, value);
  }

  bool hasKey({required String key}) {
    return _box.hasData(key);
  }

  dynamic get({required String key}) {
    if (hasKey(key: key)) {
      final data = _box.read(key);
      return data;
    } else {
      return null;
    }
  }

  Future<void> clearAll() async {
    await _box.erase();
  }
}

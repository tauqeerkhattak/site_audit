import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageService extends GetxService {
  final _box = GetStorage();

  Future<void> save({required String key, required dynamic value}) async {
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

  void listen({required String key, required void Function(dynamic) listener}) {
    _box.listenKey(key, listener);
  }

  void remove({required String key}) {
    if (hasKey(key: key)) {
      _box.remove(key);
    }
  }

  Future<void> clearAll() async {
    await _box.erase();
  }

  Future<List<String>> getAllKeys() async {
    final data = await _box.getKeys().toList();
    return data;
  }
}

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

/// Cache local simple : on stocke du JSON (String) dans une box Hive.
class CacheService {
  static const boxName = 'cache';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(boxName);
  }

  Box<String> get _box => Hive.box<String>(boxName);

  Future<void> saveList(String key, List<Map<String, dynamic>> items) =>
      _box.put(key, jsonEncode(items));

  List<Map<String, dynamic>>? readList(String key) {
    final raw = _box.get(key);
    if (raw == null) return null;
    return (jsonDecode(raw) as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<void> saveMap(String key, Map<String, dynamic> map) =>
      _box.put(key, jsonEncode(map));

  Map<String, dynamic>? readMap(String key) {
    final raw = _box.get(key);
    if (raw == null) return null;
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  Future<void> clear() => _box.clear();
}

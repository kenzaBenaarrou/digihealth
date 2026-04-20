import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegionStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _regionKey = "region_data";

  Future<void> saveRegionData(String regionData) async {
    await _secureStorage.write(key: _regionKey, value: regionData);
  }

  Future<String?> getRegionData() async {
    return await _secureStorage.read(key: _regionKey);
  }
}

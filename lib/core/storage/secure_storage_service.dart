// lib/core/storage/secure_storage_service.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';

class SecureStorageService extends GetxService {
  late SharedPreferences _prefs;

  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
  }

  // Token
  Future<void> saveToken(String token) async {
    await _prefs.setString(ApiConstants.keyToken, token);
  }

  Future<String?> getToken() async {
    return _prefs.getString(ApiConstants.keyToken);
  }

  Future<void> deleteToken() async {
    await _prefs.remove(ApiConstants.keyToken);
  }

  // User ID
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(ApiConstants.keyUserId, userId);
  }

  Future<String?> getUserId() async {
    return _prefs.getString(ApiConstants.keyUserId);
  }

  // User Data
  Future<void> saveUserData(String json) async {
    await _prefs.setString(ApiConstants.keyUserData, json);
  }

  Future<String?> getUserData() async {
    return _prefs.getString(ApiConstants.keyUserData);
  }

  // Clear
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
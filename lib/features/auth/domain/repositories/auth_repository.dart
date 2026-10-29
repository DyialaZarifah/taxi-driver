// lib/features/auth/domain/repositories/auth_repository.dart
import 'dart:convert';

import 'package:get/get.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../data/models/driver_model.dart';
import '../../data/services/auth_service.dart';

class AuthRepository extends GetxService {
  final AuthService _authService = Get.find<AuthService>();
  final SecureStorageService _storage = Get.find<SecureStorageService>();

  Future<DriverModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _authService.login(
      email: email,
      password: password,
    );

    await _storage.saveToken(response.token);
    await _storage.saveUserId(response.user.id.toString());
    await _storage.saveUserData(jsonEncode(response.user.toJson()));

    return response.user;
  }

  Future<DriverModel?> getCurrentUser() async {
    final jsonStr = await _storage.getUserData();
    if (jsonStr == null || jsonStr.isEmpty) return null;

    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return DriverModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    return await _storage.hasToken();
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }
}
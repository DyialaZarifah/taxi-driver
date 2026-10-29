// lib/features/auth/data/services/auth_service.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_response.dart';

class AuthService extends GetxService {
  final DioClient _dioClient = Get.find<DioClient>();

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponse.fromJson(response.data as Map<String, dynamic>);
      }
      throw 'فشل تسجيل الدخول — حاول مرة أخرى';
    } on DioException catch (e) {
      throw _extractErrorMessage(e);
    } catch (e) {
      throw 'حدث خطأ غير متوقع';
    }
  }

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;

    // ═══════════════════════════════════════════
    // حالة 1: errors كـ List من الكائنات
    // { "errors": [{ "code": "...", "message": "..." }] }
    // ═══════════════════════════════════════════
    if (data is Map && data['errors'] is List) {
      final errors = data['errors'] as List;
      if (errors.isNotEmpty) {
        final first = errors.first;
        if (first is Map && first['message'] != null) {
          return first['message'].toString();
        }
        return first.toString();
      }
    }

    // ═══════════════════════════════════════════
    // حالة 2: errors كـ Map من الحقول (Laravel Validation 422)
    // { "errors": { "email": ["البريد مستخدم"] } }
    // ═══════════════════════════════════════════
    if (data is Map && data['errors'] is Map) {
      final errors = data['errors'] as Map;
      if (errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
        return firstError.toString();
      }
    }

    // ═══════════════════════════════════════════
    // حالة 3: message مباشر
    // ═══════════════════════════════════════════
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    // ═══════════════════════════════════════════
    // حالة 4: حسب Status Code
    // ═══════════════════════════════════════════
    switch (e.response?.statusCode) {
      case 401:
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case 403:
        return 'حسابك غير نشط — تواصل مع الإدارة';
      case 422:
        return 'البيانات المدخلة غير صحيحة';
      case 500:
        return 'خطأ في السيرفر — حاول لاحقًا';
      default:
        return 'تعذر الاتصال بالخادم';
    }
  }
}
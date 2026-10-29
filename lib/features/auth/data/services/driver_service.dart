// lib/features/auth/data/services/driver_service.dart
import 'dart:math';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart' hide Response;

import '../../../../core/network/dio_client.dart';
import '../models/trip_model.dart';
import '../models/vehicle_model.dart';

class DriverService extends GetxService {
  final DioClient _dioClient = Get.find<DioClient>();

  // دالة مساعدة لتوليد Idempotency-Key
  String _generateIdempotencyKey() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(16, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // ═══════════════════════════════════════════
  // 1) جلب الرحلات المتاحة (Offers)
  // ═══════════════════════════════════════════
  Future<List<TripModel>> getAvailableTrips() async {
    try {
      // ✅ المسار مطابق تماماً لما في Postman
      final response = await _dioClient.dio.get('/driver/offers');
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        return data.map((e) => TripModel.fromJson(e)).toList();
      }
    } on dio.DioException catch (e) {
      print('❌ getAvailableTrips: ${e.message}');
    }
    return [];
  }

  // ═══════════════════════════════════════════
  // 2) قبول الرحلة (Accept Offer)
  // ═══════════════════════════════════════════
  Future<bool> acceptTrip(int offerId) async {
    try {
      // ✅ المسار مطابق + إضافة Idempotency-Key كما يتطلب الباك إند
      final response = await _dioClient.dio.post(
        '/driver/offers/$offerId/accept',
        options: dio.Options(
          headers: {
            'Idempotency-Key': _generateIdempotencyKey(),
          },
        ),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on dio.DioException catch (e) {
      print('❌ acceptTrip: ${e.message}');
      throw _extractErrorMessage(e);
    }
  }

  // ═══════════════════════════════════════════
  // 3) رفض الرحلة (Reject Offer)
  // ═══════════════════════════════════════════
  Future<bool> rejectTrip(int offerId) async {
    try {
      // ✅ المسار مطابق + إضافة Idempotency-Key
      final response = await _dioClient.dio.post(
        '/driver/offers/$offerId/reject',
        options: dio.Options(
          headers: {
            'Idempotency-Key': _generateIdempotencyKey(),
          },
        ),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on dio.DioException catch (e) {
      print('❌ rejectTrip: ${e.message}');
      throw _extractErrorMessage(e);
    }
  }

  // ═══════════════════════════════════════════
  // 4) تغيير الحالة (Online/Offline)
  // ═══════════════════════════════════════════
  Future<bool> toggleStatus(bool isOnline) async {
    try {
      final response = await _dioClient.dio.patch(
        '/driver/presence',
        data: {'is_online': isOnline},
      );
      return response.statusCode == 200;
    } on dio.DioException catch (e) {
      print('❌ toggleStatus: ${e.message}');
      return false;
    }
  }

  // ═══════════════════════════════════════════
  // 5) دوال المركبات (كما هي)
  // ═══════════════════════════════════════════
  Future<List<VehicleModel>> getVehicles() async {
    try {
      final response = await _dioClient.dio.get('/driver/vehicles');
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        return data.map((e) => VehicleModel.fromJson(e)).toList();
      }
    } on dio.DioException catch (e) {
      print('❌ getVehicles: ${e.message}');
    }
    return [];
  }

  Future<VehicleModel?> createVehicle({
    required String plateNumber,
    required String make,
    required String model,
    required String color,
    required int year,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/driver/vehicles',
        data: {
          'plate_number': plateNumber,
          'make': make,
          'model': model,
          'color': color,
          'year': year,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return VehicleModel.fromJson(response.data['data']);
      }
    } on dio.DioException catch (e) {
      throw _extractErrorMessage(e);
    }
    return null;
  }

  // ═══════════════════════════════════════════
  // استخراج رسالة الخطأ
  // ═══════════════════════════════════════════
  String _extractErrorMessage(dio.DioException e) {
    final data = e.response?.data;
    if (data is Map && data['errors'] is List) {
      final errors = data['errors'] as List;
      if (errors.isNotEmpty && errors.first is Map) {
        return errors.first['message'].toString();
      }
    }
    return 'حدث خطأ — حاول مرة أخرى';
  }
}
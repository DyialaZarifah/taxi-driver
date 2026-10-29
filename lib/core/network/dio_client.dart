// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../constants/api_constants.dart';
import '../storage/secure_storage_service.dart';

class DioClient extends GetxService {
  late final Dio dio;

  final SecureStorageService _storage = Get.find<SecureStorageService>();

  @override
  void onInit() {
    super.onInit();
    _initDio();
  }

  void _initDio() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('🌐 ${options.method} ${options.uri}');
          if (options.data != null) print('📤 ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ ${response.statusCode} ${response.requestOptions.uri}');
          print('📥 ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('❌ ${e.response?.statusCode} ${e.requestOptions.uri}');
          print('❌ ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );
  }
}
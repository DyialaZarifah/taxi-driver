// lib/features/documents/data/services/documents_service.dart
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart' hide Response;

import '../../../../core/network/dio_client.dart';
import '../models/document_model.dart';

class DocumentsService extends GetxService {
  final DioClient _dioClient = Get.find<DioClient>();

  Future<List<DocumentModel>> getDocuments() async {
    try {
      final response = await _dioClient.dio.get('/driver/documents');
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        return data.map((e) => DocumentModel.fromJson(e)).toList();
      }
    } on dio.DioException catch (e) {
      print('❌ getDocuments: ${e.message}');
    }
    return [];
  }

  Future<DocumentModel?> getDocumentById(int id) async {
    try {
      final response = await _dioClient.dio.get('/driver/documents/$id');
      if (response.statusCode == 200) {
        return DocumentModel.fromJson(response.data['data']);
      }
    } on dio.DioException catch (e) {
      print('❌ getDocumentById: ${e.message}');
    }
    return null;
  }

  Future<DocumentModel?> uploadDocument({
    required PlatformFile file,
    required String documentType,
    int? vehicleId,
    String? expiresAt,
  }) async {
    try {
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        ),
        'document_type': documentType,
        if (vehicleId != null) 'vehicle_id': vehicleId,
        if (expiresAt != null) 'expires_at': expiresAt,
      });

      final response = await _dioClient.dio.post(
        '/driver/documents',
        data: formData,
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DocumentModel.fromJson(response.data['data']);
      }
    } on dio.DioException catch (e) {
      throw _extractErrorMessage(e);
    }
    return null;
  }

  String _extractErrorMessage(dio.DioException e) {
    final data = e.response?.data;
    if (data is Map && data['errors'] is List) {
      final errors = data['errors'] as List;
      if (errors.isNotEmpty && errors.first is Map) {
        return errors.first['message'].toString();
      }
    }
    return 'تعذر رفع الملف — حاول مرة أخرى';
  }
}
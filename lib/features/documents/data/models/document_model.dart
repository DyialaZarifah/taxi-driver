// lib/features/documents/data/models/document_model.dart
class DocumentModel {
  final int id;
  final String documentType;
  final int version;
  final int? vehicleId;
  final String originalName;
  final String mimeType;
  final int sizeBytes;
  final String? expiresAt;
  final String reviewStatus;
  final String? rejectionReason;
  final String? reviewedAt;
  final bool isCurrent;

  const DocumentModel({
    required this.id,
    required this.documentType,
    required this.version,
    this.vehicleId,
    required this.originalName,
    required this.mimeType,
    required this.sizeBytes,
    this.expiresAt,
    required this.reviewStatus,
    this.rejectionReason,
    this.reviewedAt,
    required this.isCurrent,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: (json['id'] ?? 0) as int,
      documentType: json['document_type'] ?? '',
      version: (json['version'] ?? 1) as int,
      vehicleId: json['vehicle_id'] as int?,
      originalName: json['original_name'] ?? '',
      mimeType: json['mime_type'] ?? '',
      sizeBytes: (json['size_bytes'] ?? 0) as int,
      expiresAt: json['expires_at'] as String?,
      reviewStatus: json['review_status'] ?? 'pending',
      rejectionReason: json['rejection_reason'] as String?,
      reviewedAt: json['reviewed_at'] as String?,
      isCurrent: json['is_current'] ?? true,
    );
  }

  bool get isApproved => reviewStatus == 'approved';
  bool get isPending => reviewStatus == 'pending';
  bool get isRejected => reviewStatus == 'rejected';

  String get statusLabel {
    switch (reviewStatus) {
      case 'approved':
        return 'مقبولة';
      case 'rejected':
        return 'مرفوضة';
      default:
        return 'قيد المراجعة';
    }
  }

  String get displayType {
    switch (documentType) {
      case 'national_id':
        return 'الهوية الوطنية';
      case 'driving_license':
        return 'رخصة القيادة';
      case 'vehicle_registration':
        return 'أوراق المركبة';
      case 'vehicle_insurance':
        return 'تأمين المركبة';
      default:
        return documentType;
    }
  }

  String get displaySize {
    final kb = sizeBytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    return '${(kb / 1024).toStringAsFixed(2)} MB';
  }
}
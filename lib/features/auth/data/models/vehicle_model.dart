// lib/features/auth/data/models/vehicle_model.dart
class VehicleModel {
  final int id;
  final String plateNumber;
  final String make;
  final String model;
  final String displayName;
  final String color;
  final int year;
  final String status;             // pending | approved | rejected
  final String? rejectionReason;
  final DateTime? reviewedAt;

  const VehicleModel({
    required this.id,
    required this.plateNumber,
    required this.make,
    required this.model,
    required this.displayName,
    required this.color,
    required this.year,
    required this.status,
    this.rejectionReason,
    this.reviewedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: (json['id'] ?? 0) as int,
      plateNumber: json['plate_number'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      displayName: json['display_name'] ?? '${json['make'] ?? ''} ${json['model'] ?? ''}',
      color: json['color'] ?? '',
      year: (json['year'] ?? 0) as int,
      status: json['status'] ?? 'pending',
      rejectionReason: json['rejection_reason'] as String?,
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.tryParse(json['reviewed_at'].toString())
          : null,
    );
  }

  // ═══════════════════════════════════════════
  // Getters مساعدة
  // ═══════════════════════════════════════════
  bool get isApproved => status == 'approved';
  bool get isPending => status == 'pending';
  bool get isRejected => status == 'rejected';

  /// نص الحالة بالعربية
  String get statusLabel {
    switch (status) {
      case 'approved':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'قيد المراجعة';
    }
  }
}
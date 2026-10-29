// lib/features/documents/presentation/pages/documents_page.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/document_model.dart';
import '../../data/services/documents_service.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final DocumentsService _service = Get.find<DocumentsService>();

  List<DocumentModel> _documents = [];
  bool _isLoading = true;

  // الأنواع الأربعة الثابتة المطلوبة من الباك إند
  final List<Map<String, dynamic>> _requiredDocuments = [
    {
      'type': 'national_id',
      'title': 'الهوية الوطنية',
      'icon': Icons.badge_outlined,
    },
    {
      'type': 'driving_license',
      'title': 'رخصة القيادة',
      'icon': Icons.drive_eta_outlined,
    },
    {
      'type': 'vehicle_registration',
      'title': 'أوراق المركبة',
      'icon': Icons.description_outlined,
    },
    {
      'type': 'vehicle_insurance',
      'title': 'تأمين المركبة',
      'icon': Icons.shield_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() => _isLoading = true);
    final docs = await _service.getDocuments();
    if (mounted) {
      setState(() {
        _documents = docs;
        _isLoading = false;
      });
    }
  }

  // ═══════════════════════════════════════════
  // رفع / تحديث وثيقة
  // ═══════════════════════════════════════════
  Future<void> _pickAndUpload(String documentType) async {
    // 1) فتح المتصفح (صور أو PDF حسب ما يدعمه الباك)
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;

    try {
      Get.dialog(
        const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        barrierDismissible: false,
      );

      // 2) الرفع للباك إند
      await _service.uploadDocument(
        file: file,
        documentType: documentType,
        // vehicleId: 1, // يمكن تمريره إذا كانت الوثيقة خاصة بمركبة (أوراق المركبة والتأمين)
      );

      Get.back(); // إغلاق اللودينج
      Get.snackbar(
        '✅ تم الرفع',
        'تم رفع الوثيقة بنجاح، وهي الآن قيد المراجعة',
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );

      _loadDocuments(); // تحديث القائمة
    } catch (e) {
      Get.back();
      Get.snackbar(
        '⚠️ خطأ',
        e.toString(),
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _loadDocuments,
        child: ListView(
          padding: EdgeInsets.all(0.05.sw),
          children: [
            ..._requiredDocuments.map((docInfo) {
              // البحث عن الوثيقة الحالية في القائمة
              final currentDoc = _documents.firstWhereOrNull(
                    (d) => d.documentType == docInfo['type'],
              );

              return _buildDocumentCard(
                type: docInfo['type'],
                title: docInfo['title'],
                icon: docInfo['icon'],
                document: currentDoc,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard({
    required String type,
    required String title,
    required IconData icon,
    DocumentModel? document,
  }) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (document == null) {
      statusColor = AppColors.textSecondary;
      statusIcon = Icons.upload_file_rounded;
      statusText = 'لم تُرفع بعد';
    } else if (document.isApproved) {
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle_rounded;
      statusText = 'مقبولة';
    } else if (document.isRejected) {
      statusColor = AppColors.error;
      statusIcon = Icons.cancel_rounded;
      statusText = 'مرفوضة';
    } else {
      statusColor = AppColors.warning;
      statusIcon = Icons.hourglass_bottom_rounded;
      statusText = 'قيد المراجعة';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 0.02.sh),
      padding: EdgeInsets.all(0.045.sw),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(0.045.sw),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: document != null ? statusColor.withOpacity(0.3) : AppColors.borderGrey,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── العنوان والحالة ───
          Row(
            children: [
              Container(
                width: 0.12.sw,
                height: 0.12.sw,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(0.03.sw),
                ),
                child: Icon(icon, size: 0.06.sw, color: AppColors.primaryDark),
              ),
              SizedBox(width: 0.03.sw),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 0.04.sw,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 0.005.sh),
                    Row(
                      children: [
                        Icon(statusIcon, size: 0.03.sw, color: statusColor),
                        SizedBox(width: 0.01.sw),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 0.03.sw,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ─── تفاصيل الوثيقة (إن وجدت) ───
          if (document != null) ...[
            SizedBox(height: 0.015.sh),
            Container(
              padding: EdgeInsets.all(0.025.sw),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(0.03.sw),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.insert_drive_file, size: 0.035.sw, color: AppColors.textSecondary),
                      SizedBox(width: 0.01.sw),
                      Expanded(
                        child: Text(
                          document.originalName,
                          style: TextStyle(fontSize: 0.03.sw, color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (document.expiresAt != null) ...[
                    SizedBox(height: 0.005.sh),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 0.03.sw, color: AppColors.textSecondary),
                        SizedBox(width: 0.01.sw),
                        Text(
                          'صالح حتى: ${document.expiresAt}',
                          style: TextStyle(fontSize: 0.028.sw, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                  if (document.isRejected && document.rejectionReason != null) ...[
                    SizedBox(height: 0.005.sh),
                    Text(
                      'سبب الرفض: ${document.rejectionReason}',
                      style: TextStyle(fontSize: 0.028.sw, color: AppColors.error),
                    ),
                  ],
                ],
              ),
            ),
          ],

          SizedBox(height: 0.02.sh),

          // ─── زر الرفع / التحديث ───
          SizedBox(
            width: double.infinity,
            height: 0.05.sh,
            child: OutlinedButton.icon(
              onPressed: () => _pickAndUpload(type),
              icon: Icon(
                document == null ? Icons.upload_file_rounded : Icons.refresh_rounded,
                color: AppColors.primaryDark,
                size: 0.045.sw,
              ),
              label: Text(
                document == null ? 'رفع الوثيقة' : 'تحديث الصورة',
                style: TextStyle(
                  fontSize: 0.035.sw,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.03.sw),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
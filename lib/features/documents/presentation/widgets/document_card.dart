// lib/features/documents/presentation/widgets/document_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/document_model.dart';

class DocumentCard extends StatelessWidget {
  final DocumentModel document;
  final VoidCallback? onTap;

  const DocumentCard({
    super.key,
    required this.document,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    IconData typeIcon;

    if (document.isApproved) {
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle_rounded;
    } else if (document.isRejected) {
      statusColor = AppColors.error;
      statusIcon = Icons.cancel_rounded;
    } else {
      statusColor = AppColors.warning;
      statusIcon = Icons.hourglass_bottom_rounded;
    }

    switch (document.documentType) {
      case 'national_id':
        typeIcon = Icons.badge_outlined;
        break;
      case 'driving_license':
        typeIcon = Icons.drive_eta_outlined;
        break;
      case 'vehicle_registration':
        typeIcon = Icons.description_outlined;
        break;
      case 'vehicle_insurance':
        typeIcon = Icons.shield_outlined;
        break;
      default:
        typeIcon = Icons.insert_drive_file_outlined;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 0.015.sh),
        padding: EdgeInsets.all(0.04.sw),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(0.04.sw),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 0.13.sw,
                  height: 0.13.sw,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(0.03.sw),
                  ),
                  child: Icon(typeIcon,
                      size: 0.06.sw, color: AppColors.primaryDark),
                ),
                SizedBox(width: 0.03.sw),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.displayType,
                        style: TextStyle(
                          fontSize: 0.04.sw,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 0.004.sh),
                      Text(
                        '${document.originalName} • ${document.displaySize}',
                        style: TextStyle(
                          fontSize: 0.028.sw,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0.02.sw,
                    vertical: 0.005.sh,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(0.02.sw),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 0.03.sw, color: statusColor),
                      SizedBox(width: 0.01.sw),
                      Text(
                        document.statusLabel,
                        style: TextStyle(
                          fontSize: 0.027.sw,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (document.isRejected && document.rejectionReason != null) ...[
              SizedBox(height: 0.01.sh),
              Container(
                padding: EdgeInsets.all(0.02.sw),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(0.02.sw),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 0.035.sw, color: AppColors.error),
                    SizedBox(width: 0.015.sw),
                    Expanded(
                      child: Text(
                        document.rejectionReason!,
                        style: TextStyle(
                          fontSize: 0.028.sw,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (document.expiresAt != null) ...[
              SizedBox(height: 0.01.sh),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 0.03.sw, color: AppColors.textSecondary),
                  SizedBox(width: 0.01.sw),
                  Text(
                    'صالح حتى: ${document.expiresAt}',
                    style: TextStyle(
                      fontSize: 0.027.sw,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
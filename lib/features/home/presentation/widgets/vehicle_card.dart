// lib/features/home/presentation/widgets/vehicle_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../auth/data/models/vehicle_model.dart';

class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;

  const VehicleCard({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    if (vehicle.isApproved) {
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle_rounded;
    } else if (vehicle.isRejected) {
      statusColor = AppColors.error;
      statusIcon = Icons.cancel_rounded;
    } else {
      statusColor = AppColors.warning;
      statusIcon = Icons.hourglass_bottom_rounded;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 0.015.sh),
      padding: EdgeInsets.all(0.045.sw),
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
                width: 0.12.sw,
                height: 0.12.sw,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(0.03.sw),
                ),
                child: Icon(
                  Icons.local_taxi_rounded,
                  color: AppColors.primaryDark,
                  size: 0.06.sw,
                ),
              ),
              SizedBox(width: 0.03.sw),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.displayName,
                      style: TextStyle(
                        fontSize: 0.04.sw,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 0.004.sh),
                    Text(
                      '${vehicle.plateNumber} • ${vehicle.color} • ${vehicle.year}',
                      style: TextStyle(
                        fontSize: 0.03.sw,
                        color: AppColors.textSecondary,
                      ),
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
                      vehicle.statusLabel,
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
          if (vehicle.isRejected && vehicle.rejectionReason != null) ...[
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
                      vehicle.rejectionReason!,
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
        ],
      ),
    );
  }
}
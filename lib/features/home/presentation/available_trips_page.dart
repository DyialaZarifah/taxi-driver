// lib/features/home/presentation/pages/available_trips_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../auth/data/models/trip_model.dart';
import '../../auth/data/services/driver_service.dart';

class AvailableTripsPage extends StatefulWidget {
  const AvailableTripsPage({super.key});

  @override
  State<AvailableTripsPage> createState() => _AvailableTripsPageState();
}

class _AvailableTripsPageState extends State<AvailableTripsPage> {
  final DriverService _service = Get.find<DriverService>();
  List<TripModel> _trips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    setState(() => _isLoading = true);
    final trips = await _service.getAvailableTrips();
    if (mounted) {
      setState(() {
        _trips = trips;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleAccept(TripModel trip) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        barrierDismissible: false,
      );

      final success = await _service.acceptTrip(trip.id);
      Get.back(); // إغلاق اللودينج

      if (success) {
        Get.snackbar(
          '✅ تم القبول',
          'الرحلة قيد التنفيذ الآن',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
        );
        Get.back(); // العودة للوحة التحكم
      }
    } catch (e) {
      Get.back();
      Get.snackbar('⚠️ خطأ', e.toString(), backgroundColor: AppColors.error, colorText: AppColors.white);
    }
  }

  Future<void> _handleReject(TripModel trip) async {
    try {
      final success = await _service.rejectTrip(trip.id);
      if (success) {
        setState(() => _trips.removeWhere((t) => t.id == trip.id));
        Get.snackbar('تم الرفض', 'تم رفض الرحلة بنجاح', backgroundColor: AppColors.textSecondary, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('⚠️ خطأ', e.toString(), backgroundColor: AppColors.error, colorText: AppColors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'الرحلات المتاحة',
          style: TextStyle(fontSize: 0.045.sw, fontWeight: FontWeight.w800, color: AppColors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _trips.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _fetchTrips,
        child: ListView.builder(
          padding: EdgeInsets.all(0.05.sw),
          itemCount: _trips.length,
          itemBuilder: (context, index) {
            return _buildTripCard(_trips[index]);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 0.2.sw, color: AppColors.textHint),
          SizedBox(height: 0.02.sh),
          Text(
            'لا توجد رحلات متاحة حالياً',
            style: TextStyle(fontSize: 0.045.sw, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          SizedBox(height: 0.01.sh),
          Text('اسحب للأسفل للتحديث', style: TextStyle(fontSize: 0.035.sw, color: AppColors.textHint)),
        ],
      ),
    );
  }

  Widget _buildTripCard(TripModel trip) {
    return Container(
      margin: EdgeInsets.only(bottom: 0.02.sh),
      padding: EdgeInsets.all(0.045.sw),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(0.04.sw),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── السعر والمسافة ───
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${trip.price.toStringAsFixed(0)} ${trip.currency}',
                style: TextStyle(fontSize: 0.05.sw, fontWeight: FontWeight.w900, color: AppColors.primaryDark),
              ),
              Text(
                '${trip.distanceKm.toStringAsFixed(1)} كم',
                style: TextStyle(fontSize: 0.035.sw, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 0.015.sh),
          Divider(color: AppColors.borderGrey, height: 1),
          SizedBox(height: 0.015.sh),

          // ─── المسار ───
          Row(
            children: [
              Column(
                children: [
                  Icon(Icons.circle, size: 0.025.sw, color: AppColors.success),
                  Container(width: 2, height: 0.03.sh, color: AppColors.borderGrey),
                  Icon(Icons.location_on, size: 0.035.sw, color: AppColors.error),
                ],
              ),
              SizedBox(width: 0.03.sw),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.pickupAddress, style: TextStyle(fontSize: 0.038.sw, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    SizedBox(height: 0.025.sh),
                    Text(trip.dropoffAddress, style: TextStyle(fontSize: 0.038.sw, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 0.02.sh),

          // ─── بيانات الراكب ───
          Row(
            children: [
              Icon(Icons.person, size: 0.04.sw, color: AppColors.textSecondary),
              SizedBox(width: 0.01.sw),
              Text('${trip.riderName} • ${trip.riderPhone}', style: TextStyle(fontSize: 0.032.sw, color: AppColors.textSecondary)),
            ],
          ),

          SizedBox(height: 0.02.sh),

          // ─── أزرار القبول والرفض ───
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _handleReject(trip),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.03.sw)),
                  ),
                  child: const Text('رفض', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(width: 0.02.sw),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _handleAccept(trip),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.03.sw)),
                  ),
                  child: const Text('قبول الرحلة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
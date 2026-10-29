// lib/features/home/presentation/pages/driver_home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../auth/data/models/driver_model.dart';
import '../../../auth/data/models/vehicle_model.dart';
import '../../../auth/data/services/driver_service.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../widgets/vehicle_card.dart';
import 'add_vehicle_page.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  DriverModel? _user;
  List<VehicleModel> _vehicles = [];
  bool _isOnline = false;
  bool _isLoadingStatus = false;

  final AuthRepository _authRepo = Get.find<AuthRepository>();
  final DriverService _driverService = Get.find<DriverService>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _authRepo.getCurrentUser();
    final vehicles = await _driverService.getVehicles();

    if (mounted) {
      setState(() {
        _user = user;
        _vehicles = vehicles;
      });
    }
  }

  Future<void> _toggleStatus(bool value) async {
    setState(() => _isLoadingStatus = true);
    final success = await _driverService.toggleStatus(value);
    if (mounted) {
      setState(() {
        _isOnline = success ? value : _isOnline;
        _isLoadingStatus = false;
      });

      if (success) {
        Get.snackbar(
          value ? '🟢 متصل' : '🔴 غير متصل',
          value ? 'أنت الآن جاهز لاستقبال الطلبات' : 'تم إيقاف استقبال الطلبات',
          backgroundColor: value ? AppColors.success : AppColors.textSecondary,
          colorText: AppColors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  Future<void> _openAddVehicle() async {
    final result = await Get.to(() => const AddVehiclePage());
    if (result != null) {
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Scaffold مطلوب لأن بعض عناصر Material (مثل Switch) تحتاجه
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(0.05.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(),
              SizedBox(height: 0.02.sh),
              _buildDriverInfoCard(),
              SizedBox(height: 0.03.sh),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'مركباتي',
                    style: TextStyle(
                      fontSize: 0.045.sw,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _openAddVehicle,
                    icon: const Icon(Icons.add, color: AppColors.primaryDark),
                    label: Text(
                      'إضافة',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.01.sh),
              if (_vehicles.isEmpty)
                _buildEmptyVehicles()
              else
                ..._vehicles.map((v) => VehicleCard(vehicle: v)),
              SizedBox(height: 0.1.sh),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: EdgeInsets.all(0.05.sw),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(0.05.sw),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ✅ نستخدم Expanded لتجنب الـ overflow
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 0.03.sw,
                  height: 0.03.sw,
                  decoration: BoxDecoration(
                    color: _isOnline
                        ? AppColors.success
                        : AppColors.textSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 0.02.sw),
                Flexible(
                  child: Text(
                    _isOnline ? 'متصل' : 'غير متصل',
                    style: TextStyle(
                      fontSize: 0.04.sw,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          _isLoadingStatus
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Switch(
            value: _isOnline,
            onChanged: _toggleStatus,
            activeColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfoCard() {
    return Container(
      padding: EdgeInsets.all(0.05.sw),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(0.05.sw),
      ),
      child: Row(
        children: [
          Container(
            width: 0.15.sw,
            height: 0.15.sw,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _user?.initial ?? 'D',
              style: TextStyle(
                fontSize: 0.06.sw,
                fontWeight: FontWeight.w900,
                color: AppColors.black,
              ),
            ),
          ),
          SizedBox(width: 0.04.sw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user?.displayName ?? 'سائق',
                  style: TextStyle(
                    fontSize: 0.048.sw,
                    fontWeight: FontWeight.w900,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 0.005.sh),
                Text(
                  _user?.phone ?? '',
                  style: TextStyle(
                    fontSize: 0.032.sw,
                    color: AppColors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyVehicles() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(0.06.sw),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(0.04.sw),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          Icon(Icons.directions_car_outlined,
              size: 0.15.sw, color: AppColors.textHint),
          SizedBox(height: 0.015.sh),
          Text(
            'لم تُضف أي مركبة بعد',
            style: TextStyle(
              fontSize: 0.04.sw,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 0.005.sh),
          Text(
            'أضف مركبة لتبدأ العمل',
            style: TextStyle(
              fontSize: 0.033.sw,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 0.02.sh),
          ElevatedButton.icon(
            onPressed: _openAddVehicle,
            icon: const Icon(Icons.add, color: AppColors.black),
            label: Text(
              'إضافة مركبة',
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.03.sw),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
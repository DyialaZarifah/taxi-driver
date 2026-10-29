// lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../auth/data/models/driver_model.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DriverModel? _user;
  final AuthRepository _authRepo = Get.find<AuthRepository>();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authRepo.getCurrentUser();
    if (mounted) setState(() => _user = user);
  }

  Future<void> _logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.04.sw)),
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('خروج'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authRepo.logout();
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(0.05.sw),
      child: Column(
        children: [
          // ─── البطاقة الشخصية ───
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(0.06.sw),
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
            child: Column(
              children: [
                Container(
                  width: 0.2.sw,
                  height: 0.2.sw,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _user?.initial ?? 'D',
                    style: TextStyle(
                      fontSize: 0.08.sw,
                      fontWeight: FontWeight.w900,
                      color: AppColors.black,
                    ),
                  ),
                ),
                SizedBox(height: 0.02.sh),
                Text(
                  _user?.displayName ?? 'سائق',
                  style: TextStyle(
                    fontSize: 0.05.sw,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 0.005.sh),
                Text(
                  '@${_user?.username ?? ''}',
                  style: TextStyle(
                    fontSize: 0.033.sw,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0.02.sh),

          // ─── معلومات ───
          _buildInfoTile(Icons.email_outlined, 'البريد الإلكتروني',
              _user?.email ?? '—'),
          _buildInfoTile(Icons.phone_outlined, 'رقم الهاتف', _user?.phone ?? '—'),
          _buildInfoTile(Icons.badge_outlined, 'الحالة',
              _user?.isActive == true ? 'نشط' : 'غير نشط'),

          SizedBox(height: 0.03.sh),

          // ─── زر الخروج ───
          SizedBox(
            width: double.infinity,
            height: 0.06.sh,
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout_rounded, color: AppColors.error),
              label: Text(
                'تسجيل الخروج',
                style: TextStyle(
                  fontSize: 0.04.sw,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.04.sw),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 0.015.sh),
      padding: EdgeInsets.all(0.04.sw),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(0.04.sw),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryDark, size: 0.05.sw),
          SizedBox(width: 0.03.sw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 0.03.sw,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 0.004.sh),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 0.038.sw,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
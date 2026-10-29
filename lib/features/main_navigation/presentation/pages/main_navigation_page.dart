// lib/features/main_navigation/presentation/pages/main_navigation_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../documents/presentation/pages/documents_page.dart';
import '../../../home/presentation/pages/driver_home_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../trips/presentation/pages/trips_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DriverHomePage(),
    TripsPage(),
    DocumentsPage(),
    ProfilePage(),
  ];

  final List<String> _titles = const [
    'لوحة السائق',
    'الرحلات',
    'الوثائق',
    'الملف الشخصي',
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          _titles[_currentIndex],
          style: TextStyle(
            fontSize: 0.045.sw,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          // ─── زر الإشعارات ───
          IconButton(
            onPressed: () {
              Get.snackbar(
                '🔔 الإشعارات',
                'لا توجد إشعارات جديدة',
                backgroundColor: AppColors.primaryDark,
                colorText: AppColors.white,
                snackPosition: SnackPosition.TOP,
              );
            },
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.black,
                  size: 28,
                ),
                // نقطة حمراء صغيرة (مؤشر إشعارات جديدة)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 0.02.sw),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.primaryDark,
            unselectedItemColor: AppColors.textSecondary,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(
              fontSize: 0.028.sw,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 0.026.sw,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_taxi_outlined),
                activeIcon: Icon(Icons.local_taxi_rounded),
                label: 'الرحلات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description_outlined),
                activeIcon: Icon(Icons.description_rounded),
                label: 'الوثائق',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'الملف',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
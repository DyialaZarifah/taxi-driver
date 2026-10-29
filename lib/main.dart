// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/constants/app_colors.dart';
import 'core/network/dio_client.dart';
import 'core/storage/secure_storage_service.dart';
import 'features/auth/data/services/auth_service.dart';
import 'features/auth/data/services/driver_service.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/documents/data/services/documents_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency Injection
  Get.put<SecureStorageService>(SecureStorageService(), permanent: true);
  Get.put<DioClient>(DioClient(), permanent: true);
  Get.put<AuthService>(AuthService(), permanent: true);
  Get.put<AuthRepository>(AuthRepository(), permanent: true);
  Get.put<DriverService>(DriverService(), permanent: true);
  Get.put<DocumentsService>(DocumentsService(), permanent: true);
  runApp(const TaxiDriverApp());
}

class TaxiDriverApp extends StatelessWidget {
  const TaxiDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Taxi Driver',
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar'),
          fallbackLocale: const Locale('ar'),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.background,
          ),
          home: const LoginPage(),
        );
      },
    );
  }
}
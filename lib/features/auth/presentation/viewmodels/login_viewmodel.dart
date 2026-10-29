// lib/features/auth/presentation/viewmodels/login_viewmodel.dart
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../main_navigation/presentation/pages/main_navigation_page.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginViewModel extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();

  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxBool isObscure = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isAutoLoginLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final loggedIn = await _authRepo.isLoggedIn();
    if (loggedIn) {
      final user = await _authRepo.getCurrentUser();
      if (user != null && user.isActive) {
        Get.offAll(() => const MainNavigationPage());
        return;
      }
    }
    isAutoLoginLoading.value = false;
  }

  void toggleObscure() => isObscure.value = !isObscure.value;

  Future<void> login() async {
    if (email.value.trim().isEmpty) {
      _showError('الرجاء إدخال البريد الإلكتروني');
      return;
    }
    if (!_isValidEmail(email.value.trim())) {
      _showError('البريد الإلكتروني غير صحيح');
      return;
    }
    if (password.value.trim().isEmpty) {
      _showError('الرجاء إدخال كلمة المرور');
      return;
    }
    if (password.value.trim().length < 6) {
      _showError('كلمة المرور قصيرة جدًا');
      return;
    }

    isLoading.value = true;

    try {
      final user = await _authRepo.login(
        email: email.value.trim(),
        password: password.value,
      );

      if (!user.isActive) {
        _showError('حسابك غير نشط — تواصل مع الإدارة');
        isLoading.value = false;
        return;
      }

      Get.snackbar(
        '✅ مرحبًا ${user.displayName}',
        'تم تسجيل الدخول بنجاح',
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );

      Get.offAll(() => const MainNavigationPage());
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showError(String message) {
    Get.snackbar(
      '⚠️ خطأ',
      message,
      backgroundColor: AppColors.error,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }
}
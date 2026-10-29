// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(LoginViewModel());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (vm.isAutoLoginLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_taxi_rounded,
                      size: 0.15.sw, color: AppColors.primary),
                  SizedBox(height: 0.03.sh),
                  const CircularProgressIndicator(color: AppColors.primary),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 0.08.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.08.sh),

                // Logo
                Center(
                  child: Container(
                    width: 0.25.sw,
                    height: 0.25.sw,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(Icons.local_taxi_rounded,
                        size: 0.13.sw, color: AppColors.black),
                  ),
                ),

                SizedBox(height: 0.04.sh),

                Center(
                  child: Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: 0.07.sw,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 0.01.sh),
                Center(
                  child: Text(
                    AppStrings.appTagline,
                    style: TextStyle(
                      fontSize: 0.035.sw,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                SizedBox(height: 0.06.sh),

                _buildLabel(AppStrings.emailLabel),
                SizedBox(height: 0.01.sh),
                _buildTextField(
                  hint: AppStrings.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => vm.email.value = v,
                  prefixIcon: Icons.email_outlined,
                ),
                SizedBox(height: 0.025.sh),

                _buildLabel(AppStrings.passwordLabel),
                SizedBox(height: 0.01.sh),
                _buildTextField(
                  hint: AppStrings.passwordHint,
                  isPassword: true,
                  isObscure: vm.isObscure.value,
                  onToggleObscure: vm.toggleObscure,
                  onChanged: (v) => vm.password.value = v,
                  prefixIcon: Icons.lock_outline_rounded,
                ),
                SizedBox(height: 0.05.sh),

                SizedBox(
                  width: double.infinity,
                  height: 0.065.sh,
                  child: ElevatedButton(
                    onPressed: vm.isLoading.value ? null : vm.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor:
                      AppColors.primary.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.04.sw),
                      ),
                      elevation: 0,
                    ),
                    child: vm.isLoading.value
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.black,
                        strokeWidth: 2.5,
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login_rounded,
                            color: AppColors.black, size: 0.05.sw),
                        SizedBox(width: 0.02.sw),
                        Text(
                          AppStrings.loginButton,
                          style: TextStyle(
                            fontSize: 0.045.sw,
                            fontWeight: FontWeight.w800,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 0.02.sh),

                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      AppStrings.forgotPassword,
                      style: TextStyle(
                        fontSize: 0.035.sw,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.05.sh),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 0.035.sw,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onToggleObscure,
    IconData? prefixIcon,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(0.035.sw),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: TextField(
        keyboardType: keyboardType,
        obscureText: isPassword && isObscure,
        onChanged: onChanged,
        style: TextStyle(fontSize: 0.038.sw, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
          TextStyle(fontSize: 0.035.sw, color: AppColors.textHint),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon,
              size: 0.05.sw, color: AppColors.textSecondary)
              : null,
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              isObscure
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              size: 0.05.sw,
              color: AppColors.textSecondary,
            ),
            onPressed: onToggleObscure,
          )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 0.018.sh,
            horizontal: 0.02.sw,
          ),
        ),
      ),
    );
  }
}
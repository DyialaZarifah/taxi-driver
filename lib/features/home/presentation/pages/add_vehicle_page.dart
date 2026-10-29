// lib/features/home/presentation/pages/add_vehicle_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../auth/data/services/driver_service.dart';

class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({super.key});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  final DriverService _service = Get.find<DriverService>();

  final _plateController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();
  final _yearController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 💡 توليد رقم لوحة فريد تلقائياً عند فتح الشاشة لتجنب خطأ التكرار 500
    final uniqueId = DateTime.now().millisecondsSinceEpoch.toString().substring(5);
    _plateController.text = "PM-$uniqueId";
  }

  @override
  void dispose() {
    _plateController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final vehicle = await _service.createVehicle(
        plateNumber: _plateController.text.trim(),
        make: _makeController.text.trim(),
        model: _modelController.text.trim(),
        color: _colorController.text.trim(),
        year: int.tryParse(_yearController.text.trim()) ?? 2022,
      );

      if (vehicle != null) {
        Get.back(result: vehicle);
        Get.snackbar(
          '✅ تمت الإضافة',
          'المركبة قيد المراجعة من الإدارة',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        '⚠️ خطأ',
        e.toString(),
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'إضافة مركبة',
          style: TextStyle(
            fontSize: 0.045.sw,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(0.06.sw),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildField('رقم اللوحة', _plateController, hint: 'مثال: 123456'),
                SizedBox(height: 0.02.sh),
                _buildField('الشركة المصنعة', _makeController, hint: 'مثال: Kia'),
                SizedBox(height: 0.02.sh),
                _buildField('الموديل', _modelController, hint: 'مثال: Rio'),
                SizedBox(height: 0.02.sh),
                _buildField('اللون', _colorController, hint: 'مثال: White'),
                SizedBox(height: 0.02.sh),
                _buildField(
                  'سنة الصنع',
                  _yearController,
                  hint: 'مثال: 2022',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 0.04.sh),
                SizedBox(
                  width: double.infinity,
                  height: 0.065.sh,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.04.sw),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: AppColors.black)
                        : Text(
                      'إرسال للمراجعة',
                      style: TextStyle(
                        fontSize: 0.045.sw,
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      String label,
      TextEditingController controller, {
        String? hint,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 0.035.sw,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 0.008.sh),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(0.035.sw),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 0.033.sw,
                color: AppColors.textHint,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 0.018.sh,
                horizontal: 0.03.sw,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
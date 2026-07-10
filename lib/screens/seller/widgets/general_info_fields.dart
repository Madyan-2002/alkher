import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';

class GeneralInfoFields extends StatelessWidget {
  final Color accent;
  final TextEditingController nameController;
  final TextEditingController descController;
  final TextEditingController contactController; // ← جديد

  const GeneralInfoFields({
    super.key,
    required this.accent,
    required this.nameController,
    required this.descController,
    required this.contactController, // ← جديد
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField(
                accent: accent,
                label: 'اسم الإعلان',
                hint: 'مثلاً: سماعات لاسلكية',
                controller: nameController,
                validator: (val) => val == null || val.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
              ),
              const SizedBox(height: 14),
              _buildField(
                accent: accent,
                label: 'الوصف',
                hint: 'اكتب تفاصيل أكثر...',
                controller: descController,
                maxLines: 3,
                maxLength: 300,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // ── بطاقة رقم التواصل (واتساب) ──────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.chat_outlined, size: 16, color: Color(0xFF25D366)),
                  const SizedBox(width: 6),
                  const Text(
                    'رقم التواصل (واتساب)',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: contactController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: AppColors.textPrimary),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'رقم التواصل مطلوب';
                  final digitsOnly = val.replaceAll(RegExp(r'[^0-9]'), '');
                  if (digitsOnly.length < 9) return 'الرجاء إدخال رقم صحيح مع رمز الدولة';
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'مثال: 962791234567 (بدون + أو 00)',
                  hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
                  filled: true,
                  fillColor: AppColors.surface,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: accent, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'أدخل الرقم مع رمز الدولة بدون + أو أصفار البداية',
                style: TextStyle(fontSize: 10.5, color: AppColors.textHint),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required Color accent,
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            counterText: maxLength != null ? null : '',
            hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
            filled: true,
            fillColor: AppColors.surface,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: accent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}
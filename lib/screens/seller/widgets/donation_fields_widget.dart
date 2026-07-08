import 'package:flutter/material.dart';
import 'package:alkher/styles/app_colors.dart';

class DonationFieldsWidget extends StatelessWidget {
  final Color accent;
  final DateTime? deadline;
  final VoidCallback onPickDeadline;

  const DonationFieldsWidget({
    super.key,
    required this.accent,
    required this.deadline,
    required this.onPickDeadline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'آخر موعد للتبرع',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          FormField<DateTime>(
            initialValue: deadline,
            validator: (_) =>
                deadline == null ? 'الرجاء اختيار التاريخ النهائي' : null,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: onPickDeadline,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: state.hasError
                              ? AppColors.error
                              : AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: accent,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            deadline == null
                                ? 'اختر التاريخ'
                                : '${deadline!.day}/${deadline!.month}/${deadline!.year}',
                            style: TextStyle(
                              color: deadline == null
                                  ? AppColors.textHint
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 8),
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class QuestionDisplayWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final int? selectedOption;
  final Function(int) onOptionSelected;

  const QuestionDisplayWidget({
    super.key,
    required this.question,
    this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              question['question'] as String? ?? '',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                fontSize: 16.sp,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Options
          ...List.generate(
            (question['options'] as List?)?.length ?? 0,
            (index) => _buildOptionButton(
              index,
              (question['options'] as List)[index] as String,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(int index, String optionText) {
    final isSelected = selectedOption == index;
    final optionLabels = ['A', 'B', 'C', 'D'];

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: GestureDetector(
        onTap: () => onOptionSelected(index),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Option label circle
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    optionLabels[index],
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Option text
              Expanded(
                child: Text(
                  optionText,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    height: 1.4,
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

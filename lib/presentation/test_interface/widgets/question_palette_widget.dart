import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuestionPaletteWidget extends StatelessWidget {
  final int totalQuestions;
  final int currentQuestion;
  final List<int> attemptedQuestions;
  final List<int> markedQuestions;
  final Function(int) onQuestionTap;
  final VoidCallback onClose;

  const QuestionPaletteWidget({
    super.key,
    required this.totalQuestions,
    required this.currentQuestion,
    required this.attemptedQuestions,
    required this.markedQuestions,
    required this.onQuestionTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question Palette',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Legend
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  label: 'Current',
                ),
                _buildLegendItem(
                  color: AppTheme.getSuccessColor(true),
                  label: 'Attempted',
                ),
                _buildLegendItem(
                  color: AppTheme.getWarningColor(true),
                  label: 'Marked',
                ),
                _buildLegendItem(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  label: 'Not Visited',
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Question grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 1.h,
                  childAspectRatio: 1,
                ),
                itemCount: totalQuestions,
                itemBuilder: (context, index) {
                  final questionNumber = index + 1;
                  return _buildQuestionButton(questionNumber);
                },
              ),
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionButton(int questionNumber) {
    Color backgroundColor;
    Color textColor = AppTheme.lightTheme.colorScheme.onSurface;

    if (questionNumber == currentQuestion) {
      backgroundColor = AppTheme.lightTheme.colorScheme.primary;
      textColor = AppTheme.lightTheme.colorScheme.onPrimary;
    } else if (markedQuestions.contains(questionNumber)) {
      backgroundColor = AppTheme.getWarningColor(true);
      textColor = Colors.white;
    } else if (attemptedQuestions.contains(questionNumber)) {
      backgroundColor = AppTheme.getSuccessColor(true);
      textColor = Colors.white;
    } else {
      backgroundColor =
          AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3);
    }

    return GestureDetector(
      onTap: () => onQuestionTap(questionNumber),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: questionNumber == currentQuestion
              ? Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                )
              : null,
        ),
        child: Center(
          child: Text(
            questionNumber.toString(),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

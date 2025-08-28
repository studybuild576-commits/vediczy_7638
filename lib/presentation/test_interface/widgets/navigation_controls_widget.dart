import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NavigationControlsWidget extends StatelessWidget {
  final bool canGoPrevious;
  final bool canGoNext;
  final bool isMarkedForReview;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onMarkForReview;
  final VoidCallback onSubmitTest;
  final bool isLastQuestion;

  const NavigationControlsWidget({
    super.key,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.isMarkedForReview,
    required this.onPrevious,
    required this.onNext,
    required this.onMarkForReview,
    required this.onSubmitTest,
    required this.isLastQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mark for review button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onMarkForReview,
              icon: CustomIconWidget(
                iconName: isMarkedForReview ? 'bookmark' : 'bookmark_border',
                color: isMarkedForReview
                    ? AppTheme.getWarningColor(true)
                    : AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              label: Text(
                isMarkedForReview ? 'Marked for Review' : 'Mark for Review',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: isMarkedForReview
                      ? AppTheme.getWarningColor(true)
                      : AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isMarkedForReview
                      ? AppTheme.getWarningColor(true)
                      : AppTheme.lightTheme.colorScheme.primary,
                ),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Navigation buttons
          Row(
            children: [
              // Previous button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: canGoPrevious ? onPrevious : null,
                  icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: canGoPrevious
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                    size: 20,
                  ),
                  label: Text(
                    'Previous',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: canGoPrevious
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canGoPrevious
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Next/Submit button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isLastQuestion
                      ? onSubmitTest
                      : (canGoNext ? onNext : null),
                  icon: CustomIconWidget(
                    iconName: isLastQuestion ? 'check' : 'arrow_forward',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: Text(
                    isLastQuestion ? 'Submit Test' : 'Next',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLastQuestion
                        ? AppTheme.getSuccessColor(true)
                        : AppTheme.lightTheme.colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

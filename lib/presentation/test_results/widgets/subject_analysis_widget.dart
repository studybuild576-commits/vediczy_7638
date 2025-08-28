import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubjectAnalysisWidget extends StatelessWidget {
  final Map<String, Map<String, double>> subjects;

  const SubjectAnalysisWidget({
    Key? key,
    required this.subjects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subject-wise Analysis',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...subjects.entries.map((entry) {
            final subjectName = entry.key;
            final subjectData = entry.value;
            final accuracy = subjectData['accuracy'] ?? 0.0;
            final totalQuestions = subjectData['totalQuestions'] ?? 0.0;
            final correctAnswers = subjectData['correctAnswers'] ?? 0.0;

            // Determine performance level
            Color performanceColor;
            String performanceText;
            String iconName;

            if (accuracy >= 80) {
              performanceColor = Colors.green;
              performanceText = 'Excellent';
              iconName = 'star';
            } else if (accuracy >= 60) {
              performanceColor = Colors.blue;
              performanceText = 'Good';
              iconName = 'thumb_up';
            } else if (accuracy >= 40) {
              performanceColor = Colors.orange;
              performanceText = 'Average';
              iconName = 'trending_flat';
            } else {
              performanceColor = Colors.red;
              performanceText = 'Needs Work';
              iconName = 'trending_down';
            }

            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: performanceColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: performanceColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  // Header Row
                  Row(
                    children: [
                      Container(
                        width: 10.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: performanceColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: iconName,
                            color: performanceColor,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subjectName,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              performanceText,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: performanceColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${accuracy.toStringAsFixed(1)}%',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: performanceColor,
                            ),
                          ),
                          Text(
                            'Accuracy',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Progress Bar
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${correctAnswers.toInt()}/${totalQuestions.toInt()} Correct',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '${(totalQuestions - correctAnswers).toInt()} Incorrect',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      LinearProgressIndicator(
                        value: accuracy / 100,
                        backgroundColor: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(performanceColor),
                        minHeight: 8,
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Recommendation
                  if (accuracy < 70) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: performanceColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'lightbulb',
                            color: performanceColor,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              accuracy < 40
                                  ? 'Focus on basics and practice more questions'
                                  : 'Practice more questions to improve accuracy',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: performanceColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

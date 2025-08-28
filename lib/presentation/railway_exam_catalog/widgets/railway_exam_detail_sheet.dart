import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RailwayExamDetailSheet extends StatelessWidget {
  final Map<String, dynamic> examData;
  final VoidCallback? onModelTest;
  final VoidCallback? onPYQTest;
  final VoidCallback? onRevision;

  const RailwayExamDetailSheet({
    Key? key,
    required this.examData,
    this.onModelTest,
    this.onPYQTest,
    this.onRevision,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.dividerDark : AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with logo
                  Row(
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'train',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 8.w,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              examData['name'] ?? 'Railway Exam',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                        ? AppTheme.textPrimaryDark
                                        : AppTheme.textPrimaryLight,
                                  ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              examData['department'] ?? 'Railway Department',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: isDarkMode
                                        ? AppTheme.textSecondaryDark
                                        : AppTheme.textSecondaryLight,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Description
                  if (examData['description'] != null) ...[
                    _buildDetailSection(
                      context: context,
                      title: 'About This Exam',
                      content: examData['description'],
                    ),
                    SizedBox(height: 3.h),
                  ],

                  // Exam Details Grid
                  _buildDetailGrid(context),

                  SizedBox(height: 3.h),

                  // Eligibility Criteria
                  if (examData['eligibility'] != null) ...[
                    _buildDetailSection(
                      context: context,
                      title: 'Eligibility Criteria',
                      content: examData['eligibility'],
                    ),
                    SizedBox(height: 3.h),
                  ],

                  // Exam Pattern
                  if (examData['examPattern'] != null) ...[
                    _buildExamPattern(context),
                    SizedBox(height: 3.h),
                  ],

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onModelTest,
                          icon: CustomIconWidget(
                            iconName: 'quiz',
                            color: AppTheme.onPrimaryLight,
                            size: 5.w,
                          ),
                          label: Text(
                            'Model Test',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme.onPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.lightTheme.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onPYQTest,
                          icon: CustomIconWidget(
                            iconName: 'history_edu',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 5.w,
                          ),
                          label: Text(
                            'PYQ Test',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme.lightTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            side: BorderSide(
                                color: AppTheme.lightTheme.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onRevision,
                      icon: CustomIconWidget(
                        iconName: 'menu_book',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 5.w,
                      ),
                      label: Text(
                        'Revision Materials',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.lightTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        side:
                            BorderSide(color: AppTheme.lightTheme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).padding.bottom + 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDarkMode
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
              ),
        ),
        SizedBox(height: 1.h),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDarkMode
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
                height: 1.5,
              ),
        ),
      ],
    );
  }

  Widget _buildDetailGrid(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, String>> details = [
      if (examData['vacancies'] != null)
        {
          'icon': 'people',
          'label': 'Vacancies',
          'value': '${examData['vacancies']}'
        },
      if (examData['deadline'] != null)
        {
          'icon': 'schedule',
          'label': 'Deadline',
          'value': examData['deadline']
        },
      if (examData['ageLimit'] != null)
        {'icon': 'cake', 'label': 'Age Limit', 'value': examData['ageLimit']},
      if (examData['salary'] != null)
        {
          'icon': 'account_balance_wallet',
          'label': 'Salary',
          'value': examData['salary']
        },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exam Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDarkMode
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
              ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 3,
          ),
          itemCount: details.length,
          itemBuilder: (context, index) {
            final detail = details[index];
            return Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppTheme.cardDark
                    : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      isDarkMode ? AppTheme.dividerDark : AppTheme.dividerLight,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: detail['icon']!,
                    color: AppTheme.lightTheme.primaryColor,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          detail['label']!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDarkMode
                                        ? AppTheme.textSecondaryDark
                                        : AppTheme.textSecondaryLight,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          detail['value']!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode
                                        ? AppTheme.textPrimaryDark
                                        : AppTheme.textPrimaryLight,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildExamPattern(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final examPattern = examData['examPattern'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exam Pattern',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDarkMode
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
              ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppTheme.cardDark
                : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? AppTheme.dividerDark : AppTheme.dividerLight,
            ),
          ),
          child: Column(
            children: [
              if (examPattern['duration'] != null)
                _buildPatternRow(context, 'Duration', examPattern['duration']),
              if (examPattern['totalMarks'] != null)
                _buildPatternRow(
                    context, 'Total Marks', '${examPattern['totalMarks']}'),
              if (examPattern['totalQuestions'] != null)
                _buildPatternRow(context, 'Total Questions',
                    '${examPattern['totalQuestions']}'),
              if (examPattern['negativeMarking'] != null)
                _buildPatternRow(context, 'Negative Marking',
                    examPattern['negativeMarking']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPatternRow(BuildContext context, String label, String value) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                ),
          ),
        ],
      ),
    );
  }
}

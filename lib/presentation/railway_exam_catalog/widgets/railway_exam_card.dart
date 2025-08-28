import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RailwayExamCard extends StatelessWidget {
  final Map<String, dynamic> examData;
  final VoidCallback? onModelTest;
  final VoidCallback? onPYQTest;
  final VoidCallback? onRevision;
  final VoidCallback? onBookmark;
  final VoidCallback? onTap;

  const RailwayExamCard({
    Key? key,
    required this.examData,
    this.onModelTest,
    this.onPYQTest,
    this.onRevision,
    this.onBookmark,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool isBookmarked = examData['isBookmarked'] ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with logo and bookmark
                Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'train',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 6.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            examData['name'] ?? 'Railway Exam',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? AppTheme.textPrimaryDark
                                      : AppTheme.textPrimaryLight,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            examData['department'] ?? 'Railway Department',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDarkMode
                                          ? AppTheme.textSecondaryDark
                                          : AppTheme.textSecondaryLight,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onBookmark,
                      icon: CustomIconWidget(
                        iconName: isBookmarked ? 'bookmark' : 'bookmark_border',
                        color: isBookmarked
                            ? AppTheme.lightTheme.primaryColor
                            : (isDarkMode
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight),
                        size: 5.w,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Exam details
                if (examData['description'] != null) ...[
                  Text(
                    examData['description'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDarkMode
                              ? AppTheme.textSecondaryDark
                              : AppTheme.textSecondaryLight,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                ],

                // Metadata row
                Row(
                  children: [
                    if (examData['vacancies'] != null) ...[
                      CustomIconWidget(
                        iconName: 'people',
                        color: isDarkMode
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${examData['vacancies']} Vacancies',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDarkMode
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight,
                            ),
                      ),
                      SizedBox(width: 4.w),
                    ],
                    if (examData['deadline'] != null) ...[
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: isDarkMode
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          'Deadline: ${examData['deadline']}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDarkMode
                                        ? AppTheme.textSecondaryDark
                                        : AppTheme.textSecondaryLight,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 3.h),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        context: context,
                        label: 'Model Test',
                        icon: 'quiz',
                        onPressed: onModelTest,
                        isPrimary: true,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: _buildActionButton(
                        context: context,
                        label: 'PYQ Test',
                        icon: 'history_edu',
                        onPressed: onPYQTest,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: _buildActionButton(
                        context: context,
                        label: 'Revision',
                        icon: 'menu_book',
                        onPressed: onRevision,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required String icon,
    required VoidCallback? onPressed,
    bool isPrimary = false,
  }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 5.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? AppTheme.lightTheme.primaryColor
              : (isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight),
          foregroundColor: isPrimary
              ? AppTheme.onPrimaryLight
              : AppTheme.lightTheme.primaryColor,
          elevation: isPrimary ? 2 : 0,
          side: isPrimary
              ? null
              : BorderSide(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isPrimary
                  ? AppTheme.onPrimaryLight
                  : AppTheme.lightTheme.primaryColor,
              size: 4.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    color: isPrimary
                        ? AppTheme.onPrimaryLight
                        : AppTheme.lightTheme.primaryColor,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

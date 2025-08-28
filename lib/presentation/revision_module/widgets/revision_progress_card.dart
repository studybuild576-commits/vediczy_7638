import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RevisionProgressCard extends StatelessWidget {
  final Map<String, dynamic> progressData;

  const RevisionProgressCard({
    Key? key,
    required this.progressData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalMaterials = progressData['totalMaterials'] as int? ?? 0;
    final completedMaterials = progressData['completedMaterials'] as int? ?? 0;
    final studyStreak = progressData['studyStreak'] as int? ?? 0;
    final todayStudyTime = progressData['todayStudyTime'] as int? ?? 0;
    final overallProgress =
        totalMaterials > 0 ? completedMaterials / totalMaterials : 0.0;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
              AppTheme.lightTheme.colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'trending_up',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Your Progress',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildProgressIndicator(
                    'Overall Progress',
                    overallProgress,
                    '$completedMaterials/$totalMaterials materials',
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    children: [
                      _buildStatCard(
                        'Study Streak',
                        '$studyStreak days',
                        'local_fire_department',
                        AppTheme.getAccentColor(true),
                      ),
                      SizedBox(height: 2.h),
                      _buildStatCard(
                        'Today',
                        '${todayStudyTime}min',
                        'schedule',
                        AppTheme.getSuccessColor(true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            _buildWeeklyProgress(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(
      String title, double progress, String subtitle, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 20,
            color: color,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    final weeklyData = [
      {'day': 'Mon', 'progress': 0.8},
      {'day': 'Tue', 'progress': 0.6},
      {'day': 'Wed', 'progress': 1.0},
      {'day': 'Thu', 'progress': 0.4},
      {'day': 'Fri', 'progress': 0.9},
      {'day': 'Sat', 'progress': 0.7},
      {'day': 'Sun', 'progress': 0.3},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weeklyData.map((data) {
            final progress = data['progress'] as double;
            final day = data['day'] as String;
            final isToday = day == 'Wed'; // Mock today as Wednesday

            return Column(
              children: [
                Container(
                  width: 8.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 8.w,
                      height: (6.h * progress),
                      decoration: BoxDecoration(
                        color: isToday
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.getSuccessColor(true),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  day,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isToday
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

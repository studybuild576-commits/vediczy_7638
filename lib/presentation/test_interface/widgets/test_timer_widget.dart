import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TestTimerWidget extends StatelessWidget {
  final Duration remainingTime;
  final Duration totalTime;

  const TestTimerWidget({
    super.key,
    required this.remainingTime,
    required this.totalTime,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = remainingTime.inSeconds / totalTime.inSeconds;
    Color timerColor;

    if (percentage > 0.5) {
      timerColor = AppTheme.getSuccessColor(true);
    } else if (percentage > 0.25) {
      timerColor = AppTheme.getWarningColor(true);
    } else {
      timerColor = AppTheme.lightTheme.colorScheme.error;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Timer display
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: timerColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                _formatTime(remainingTime),
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: timerColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Progress indicator
          Container(
            width: 20.w,
            height: 0.8.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: timerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}

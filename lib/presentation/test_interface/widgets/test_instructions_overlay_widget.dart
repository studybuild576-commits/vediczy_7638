import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TestInstructionsOverlayWidget extends StatelessWidget {
  final VoidCallback onClose;
  final Duration remainingTime;
  final int totalQuestions;
  final int attemptedQuestions;

  const TestInstructionsOverlayWidget({
    super.key,
    required this.onClose,
    required this.remainingTime,
    required this.totalQuestions,
    required this.attemptedQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          width: 90.w,
          height: 70.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Test Instructions',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Test stats
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildStatRow(
                                'Total Questions', totalQuestions.toString()),
                            SizedBox(height: 1.h),
                            _buildStatRow(
                                'Attempted', attemptedQuestions.toString()),
                            SizedBox(height: 1.h),
                            _buildStatRow(
                                'Time Remaining', _formatTime(remainingTime)),
                          ],
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Instructions
                      Text(
                        'Instructions:',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInstructionItem(
                                  '• Each question carries equal marks'),
                              _buildInstructionItem(
                                  '• There is no negative marking'),
                              _buildInstructionItem(
                                  '• You can navigate between questions using Previous/Next buttons'),
                              _buildInstructionItem(
                                  '• Use the question palette to jump to any question'),
                              _buildInstructionItem(
                                  '• Mark questions for review if you want to revisit them'),
                              _buildInstructionItem(
                                  '• Your answers are automatically saved'),
                              _buildInstructionItem(
                                  '• Submit the test before time runs out'),
                              _buildInstructionItem(
                                  '• Swipe left/right to navigate between questions'),
                              _buildInstructionItem(
                                  '• Long press on options for better readability'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Close button
              Padding(
                padding: EdgeInsets.all(4.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onClose,
                    child: Text('Continue Test'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionItem(String instruction) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(
        instruction,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          height: 1.4,
        ),
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

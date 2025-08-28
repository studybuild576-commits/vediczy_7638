import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExamCardWidget extends StatelessWidget {
  final Map<String, dynamic> examData;
  final VoidCallback? onBookmark;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;
  final VoidCallback? onModelTest;
  final VoidCallback? onPyqTest;
  final VoidCallback? onRevision;
  final VoidCallback? onTap;
  final bool isExpanded;

  const ExamCardWidget({
    Key? key,
    required this.examData,
    this.onBookmark,
    this.onDownload,
    this.onShare,
    this.onModelTest,
    this.onPyqTest,
    this.onRevision,
    this.onTap,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(examData['id']),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onBookmark?.call(),
              backgroundColor: AppTheme.getAccentColor(!isDarkMode),
              foregroundColor: Colors.white,
              icon: Icons.bookmark_add,
              label: 'Bookmark',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: (_) => onDownload?.call(),
              backgroundColor: AppTheme.getSuccessColor(!isDarkMode),
              foregroundColor: Colors.white,
              icon: Icons.download,
              label: 'Download',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: (_) => onShare?.call(),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: _getExamColor(
                                      examData['type'] as String? ?? '')
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: _getExamIcon(
                                    examData['type'] as String? ?? ''),
                                color: _getExamColor(
                                    examData['type'] as String? ?? ''),
                                size: 24,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  examData['name'] as String? ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  examData['description'] as String? ?? '',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (examData['isBookmarked'] == true)
                            CustomIconWidget(
                              iconName: 'bookmark',
                              color: AppTheme.getAccentColor(!isDarkMode),
                              size: 20,
                            ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              context,
                              'Model Test',
                              Theme.of(context).colorScheme.primary,
                              onModelTest,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              'PYQ Test',
                              Theme.of(context).colorScheme.secondary,
                              onPyqTest,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              'Revision',
                              Theme.of(context).colorScheme.tertiary,
                              onRevision,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isExpanded) _buildExpandedContent(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    Color color,
    VoidCallback? onPressed,
  ) {
    return SizedBox(
      height: 5.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Syllabus Overview',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            examData['syllabus'] as String? ??
                'Detailed syllabus information will be available here.',
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'update',
                color: Theme.of(context).colorScheme.secondary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Last updated: ${examData['lastUpdated'] as String? ?? 'Recently'}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getExamColor(String examType) {
    switch (examType.toLowerCase()) {
      case 'cgl':
        return const Color(0xFF2E7D8F);
      case 'chsl':
        return const Color(0xFF5BA3B8);
      case 'mts':
        return const Color(0xFFF4A261);
      case 'cpo':
        return const Color(0xFF2A9D8F);
      case 'je':
        return const Color(0xFFE76F51);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getExamIcon(String examType) {
    switch (examType.toLowerCase()) {
      case 'cgl':
        return 'account_balance';
      case 'chsl':
        return 'description';
      case 'mts':
        return 'build';
      case 'cpo':
        return 'security';
      case 'je':
        return 'engineering';
      default:
        return 'school';
    }
  }
}

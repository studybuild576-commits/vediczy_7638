import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RevisionSectionCard extends StatelessWidget {
  final Map<String, dynamic> section;
  final bool isExpanded;
  final VoidCallback onTap;
  final Function(Map<String, dynamic>) onMaterialTap;
  final Function(Map<String, dynamic>) onDownload;
  final Function(Map<String, dynamic>) onBookmark;
  final Function(Map<String, dynamic>) onShare;
  final Function(Map<String, dynamic>) onMarkComplete;

  const RevisionSectionCard({
    Key? key,
    required this.section,
    required this.isExpanded,
    required this.onTap,
    required this.onMaterialTap,
    required this.onDownload,
    required this.onBookmark,
    required this.onShare,
    required this.onMarkComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final materials = (section['materials'] as List?) ?? [];
    final progress = (section['progress'] as double?) ?? 0.0;
    final isDownloaded = section['isDownloaded'] as bool? ?? false;
    final lastAccessed = section['lastAccessed'] as String? ?? '';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section['title'] as String? ?? '',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'description',
                                  size: 16,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  '${materials.length} materials',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                if (isDownloaded) ...[
                                  CustomIconWidget(
                                    iconName: 'download_done',
                                    size: 16,
                                    color: AppTheme.getSuccessColor(true),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Downloaded',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.getSuccessColor(true),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (lastAccessed.isNotEmpty) ...[
                              SizedBox(height: 0.5.h),
                              Text(
                                'Last accessed: $lastAccessed',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 3,
                            backgroundColor: AppTheme
                                .lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress >= 1.0
                                  ? AppTheme.getSuccessColor(true)
                                  : AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: progress >= 1.0
                                  ? AppTheme.getSuccessColor(true)
                                  : AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: isExpanded ? 'expand_less' : 'expand_more',
                        size: 24,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded && materials.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: materials.map<Widget>((material) {
                  return _buildMaterialItem(context, material);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMaterialItem(
      BuildContext context, Map<String, dynamic> material) {
    final isCompleted = material['isCompleted'] as bool? ?? false;
    final type = material['type'] as String? ?? 'pdf';
    final isBookmarked = material['isBookmarked'] as bool? ?? false;

    return InkWell(
      onTap: () => onMaterialTap(material),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: _getTypeColor(type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getTypeIcon(type),
                  size: 20,
                  color: _getTypeColor(type),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material['title'] as String? ?? '',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Text(
                        type.toUpperCase(),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: _getTypeColor(type),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '•',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        material['size'] as String? ?? '',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isBookmarked)
                  CustomIconWidget(
                    iconName: 'bookmark',
                    size: 18,
                    color: AppTheme.getAccentColor(true),
                  ),
                if (isCompleted) ...[
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'check_circle',
                    size: 18,
                    color: AppTheme.getSuccessColor(true),
                  ),
                ],
                SizedBox(width: 2.w),
                PopupMenuButton<String>(
                  icon: CustomIconWidget(
                    iconName: 'more_vert',
                    size: 18,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'download':
                        onDownload(material);
                        break;
                      case 'bookmark':
                        onBookmark(material);
                        break;
                      case 'share':
                        onShare(material);
                        break;
                      case 'complete':
                        onMarkComplete(material);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'download',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'download',
                            size: 18,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                          SizedBox(width: 3.w),
                          Text('Download'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'bookmark',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: isBookmarked
                                ? 'bookmark_remove'
                                : 'bookmark_add',
                            size: 18,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                          SizedBox(width: 3.w),
                          Text(isBookmarked ? 'Remove Bookmark' : 'Bookmark'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'share',
                            size: 18,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                          SizedBox(width: 3.w),
                          Text('Share'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'complete',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: isCompleted
                                ? 'radio_button_unchecked'
                                : 'check_circle',
                            size: 18,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                          SizedBox(width: 3.w),
                          Text(isCompleted
                              ? 'Mark Incomplete'
                              : 'Mark Complete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return 'picture_as_pdf';
      case 'video':
        return 'play_circle_filled';
      case 'notes':
        return 'note';
      case 'formula':
        return 'functions';
      case 'quiz':
        return 'quiz';
      default:
        return 'description';
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'video':
        return Colors.blue;
      case 'notes':
        return Colors.green;
      case 'formula':
        return Colors.purple;
      case 'quiz':
        return Colors.orange;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatMessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final VoidCallback? onReport;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    this.onCopy,
    this.onShare,
    this.onSave,
    this.onReport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isUser = message['isUser'] as bool;
    final String content = message['content'] as String;
    final DateTime timestamp = message['timestamp'] as DateTime;
    final String? imageUrl = message['imageUrl'] as String?;
    final bool isLoading = message['isLoading'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor,
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: CustomIconWidget(
                iconName: 'smart_toy',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 4.w,
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: !isUser && !isLoading
                  ? () => _showMessageActions(context)
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isUser
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.w),
                    topRight: Radius.circular(4.w),
                    bottomLeft:
                        isUser ? Radius.circular(4.w) : Radius.circular(1.w),
                    bottomRight:
                        isUser ? Radius.circular(1.w) : Radius.circular(4.w),
                  ),
                  border: !isUser
                      ? Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          width: 1,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2.w),
                        child: CustomImageWidget(
                          imageUrl: imageUrl,
                          width: double.infinity,
                          height: 20.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 1.h),
                    ],
                    if (isLoading)
                      _buildTypingIndicator()
                    else
                      Text(
                        content,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isUser
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          height: 1.4,
                        ),
                      ),
                    SizedBox(height: 1.h),
                    Text(
                      _formatTimestamp(timestamp),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: isUser
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.7)
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 2.w),
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSecondary,
                size: 4.w,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      children: [
        Text(
          'AI is thinking',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(width: 2.w),
        SizedBox(
          width: 6.w,
          height: 6.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  void _showMessageActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(0.25.h),
              ),
            ),
            SizedBox(height: 2.h),
            _buildActionTile(
              context,
              icon: 'content_copy',
              title: 'Copy',
              onTap: () {
                Navigator.pop(context);
                if (onCopy != null) onCopy!();
                _copyToClipboard(context);
              },
            ),
            _buildActionTile(
              context,
              icon: 'share',
              title: 'Share',
              onTap: () {
                Navigator.pop(context);
                if (onShare != null) onShare!();
              },
            ),
            _buildActionTile(
              context,
              icon: 'bookmark_add',
              title: 'Save to Favorites',
              onTap: () {
                Navigator.pop(context);
                if (onSave != null) onSave!();
              },
            ),
            _buildActionTile(
              context,
              icon: 'report',
              title: 'Report Issue',
              onTap: () {
                Navigator.pop(context);
                if (onReport != null) onReport!();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.lightTheme.colorScheme.onSurface,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.w),
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: message['content'] as String));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileMenuItemWidget extends StatelessWidget {
  final String iconName;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showBadge;
  final String? badgeText;

  const ProfileMenuItemWidget({
    Key? key,
    required this.iconName,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showBadge = false,
    this.badgeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (showBadge && badgeText != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badgeText!,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 16,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
    );
  }
}

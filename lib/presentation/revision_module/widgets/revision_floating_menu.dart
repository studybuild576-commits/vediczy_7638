import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RevisionFloatingMenu extends StatefulWidget {
  final VoidCallback onPersonalNotesTap;
  final VoidCallback onBookmarksTap;
  final VoidCallback onOfflineContentTap;

  const RevisionFloatingMenu({
    Key? key,
    required this.onPersonalNotesTap,
    required this.onBookmarksTap,
    required this.onOfflineContentTap,
  }) : super(key: key);

  @override
  State<RevisionFloatingMenu> createState() => _RevisionFloatingMenuState();
}

class _RevisionFloatingMenuState extends State<RevisionFloatingMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: Opacity(
                opacity: _animation.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuButton(
                      'Personal Notes',
                      'note_add',
                      AppTheme.getAccentColor(true),
                      widget.onPersonalNotesTap,
                    ),
                    SizedBox(height: 2.h),
                    _buildMenuButton(
                      'Bookmarks',
                      'bookmark',
                      AppTheme.getWarningColor(true),
                      widget.onBookmarksTap,
                    ),
                    SizedBox(height: 2.h),
                    _buildMenuButton(
                      'Offline Content',
                      'offline_pin',
                      AppTheme.getSuccessColor(true),
                      widget.onOfflineContentTap,
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            );
          },
        ),
        FloatingActionButton(
          onPressed: _toggleMenu,
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          child: AnimatedRotation(
            turns: _isExpanded ? 0.125 : 0.0,
            duration: Duration(milliseconds: 300),
            child: CustomIconWidget(
              iconName: _isExpanded ? 'close' : 'add',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton(
      String label, String iconName, Color color, VoidCallback onTap) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.2),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        FloatingActionButton.small(
          onPressed: () {
            _toggleMenu();
            onTap();
          },
          backgroundColor: color,
          foregroundColor: Colors.white,
          heroTag: iconName,
          child: CustomIconWidget(
            iconName: iconName,
            size: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

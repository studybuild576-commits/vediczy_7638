import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RailwaySearchBar extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;

  const RailwaySearchBar({
    Key? key,
    this.hintText,
    this.onChanged,
    this.onFilterTap,
    this.controller,
  }) : super(key: key);

  @override
  State<RailwaySearchBar> createState() => _RailwaySearchBarState();
}

class _RailwaySearchBarState extends State<RailwaySearchBar> {
  late TextEditingController _controller;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _showClearButton = _controller.text.isNotEmpty;
    });
    widget.onChanged?.call(_controller.text);
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color:
                    isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isDarkMode ? AppTheme.dividerDark : AppTheme.dividerLight,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _controller,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDarkMode
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                    ),
                decoration: InputDecoration(
                  hintText: widget.hintText ?? 'Search Railway exams...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? AppTheme.textDisabledDark
                            : AppTheme.textDisabledLight,
                      ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: isDarkMode
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                      size: 5.w,
                    ),
                  ),
                  suffixIcon: _showClearButton
                      ? IconButton(
                          onPressed: _clearSearch,
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: isDarkMode
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight,
                            size: 5.w,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            height: 6.h,
            width: 6.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: widget.onFilterTap,
              icon: CustomIconWidget(
                iconName: 'tune',
                color: AppTheme.onPrimaryLight,
                size: 5.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

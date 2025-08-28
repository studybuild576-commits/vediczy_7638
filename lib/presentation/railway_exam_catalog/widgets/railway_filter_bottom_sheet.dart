import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RailwayFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>>? onFiltersChanged;

  const RailwayFilterBottomSheet({
    Key? key,
    required this.currentFilters,
    this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<RailwayFilterBottomSheet> createState() =>
      _RailwayFilterBottomSheetState();
}

class _RailwayFilterBottomSheetState extends State<RailwayFilterBottomSheet> {
  late Map<String, dynamic> _filters;

  final List<String> _examTypes = [
    'All',
    'RRB NTPC',
    'RRB Group D',
    'RRB JE',
    'RRB ALP',
    'RRB TC',
    'RRB SSE',
    'RAILWAY APPRENTICE',
  ];

  final List<String> _sortOptions = [
    'Name A-Z',
    'Name Z-A',
    'Latest First',
    'Deadline Soon',
    'Most Vacancies',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  void _applyFilters() {
    widget.onFiltersChanged?.call(_filters);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _filters = {
        'examType': 'All',
        'sortBy': 'Name A-Z',
        'showBookmarked': false,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.dividerDark : AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Railway Exams',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? AppTheme.textPrimaryDark
                            : AppTheme.textPrimaryLight,
                      ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: isDarkMode ? AppTheme.dividerDark : AppTheme.dividerLight,
            height: 1,
          ),

          // Filter content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exam Type Filter
                  _buildFilterSection(
                    title: 'Exam Type',
                    child: Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _examTypes.map((type) {
                        final isSelected = _filters['examType'] == type;
                        return FilterChip(
                          label: Text(
                            type,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isSelected
                                          ? AppTheme.onPrimaryLight
                                          : (isDarkMode
                                              ? AppTheme.textPrimaryDark
                                              : AppTheme.textPrimaryLight),
                                      fontWeight: isSelected
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                    ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _filters['examType'] = type;
                            });
                          },
                          backgroundColor: isDarkMode
                              ? AppTheme.surfaceDark
                              : AppTheme.surfaceLight,
                          selectedColor: AppTheme.lightTheme.primaryColor,
                          checkmarkColor: AppTheme.onPrimaryLight,
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : (isDarkMode
                                    ? AppTheme.dividerDark
                                    : AppTheme.dividerLight),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Sort By Filter
                  _buildFilterSection(
                    title: 'Sort By',
                    child: Column(
                      children: _sortOptions.map((option) {
                        final isSelected = _filters['sortBy'] == option;
                        return RadioListTile<String>(
                          title: Text(
                            option,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isDarkMode
                                      ? AppTheme.textPrimaryDark
                                      : AppTheme.textPrimaryLight,
                                ),
                          ),
                          value: option,
                          groupValue: _filters['sortBy'],
                          onChanged: (value) {
                            setState(() {
                              _filters['sortBy'] = value;
                            });
                          },
                          activeColor: AppTheme.lightTheme.primaryColor,
                          contentPadding: EdgeInsets.zero,
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Show Bookmarked Toggle
                  _buildFilterSection(
                    title: 'Preferences',
                    child: SwitchListTile(
                      title: Text(
                        'Show Only Bookmarked',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDarkMode
                                  ? AppTheme.textPrimaryDark
                                  : AppTheme.textPrimaryLight,
                            ),
                      ),
                      value: _filters['showBookmarked'] ?? false,
                      onChanged: (value) {
                        setState(() {
                          _filters['showBookmarked'] = value;
                        });
                      },
                      activeColor: AppTheme.lightTheme.primaryColor,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                foregroundColor: AppTheme.onPrimaryLight,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.onPrimaryLight,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDarkMode
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
              ),
        ),
        SizedBox(height: 2.h),
        child,
      ],
    );
  }
}

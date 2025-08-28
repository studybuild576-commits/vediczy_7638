import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RevisionFilterSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const RevisionFilterSheet({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<RevisionFilterSheet> createState() => _RevisionFilterSheetState();
}

class _RevisionFilterSheetState extends State<RevisionFilterSheet> {
  late Map<String, dynamic> _filters;

  final List<String> _subjects = [
    'Mathematics',
    'General Knowledge',
    'English',
    'Reasoning',
    'General Science',
    'Current Affairs',
    'Computer Knowledge',
    'Geography',
    'History',
    'Economics',
  ];

  final List<String> _materialTypes = [
    'PDF',
    'Video',
    'Notes',
    'Formula',
    'Quiz',
  ];

  final List<String> _progressFilters = [
    'Not Started',
    'In Progress',
    'Completed',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSubjectFilter(),
                  SizedBox(height: 3.h),
                  _buildMaterialTypeFilter(),
                  SizedBox(height: 3.h),
                  _buildProgressFilter(),
                  SizedBox(height: 3.h),
                  _buildDownloadStatusFilter(),
                  SizedBox(height: 3.h),
                  _buildSortOptions(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Filter & Sort',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          TextButton(
            onPressed: _clearAllFilters,
            child: Text(
              'Clear All',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectFilter() {
    final selectedSubjects = (_filters['subjects'] as List<String>?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subjects',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _subjects.map((subject) {
            final isSelected = selectedSubjects.contains(subject);
            return FilterChip(
              label: Text(subject),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedSubjects.add(subject);
                  } else {
                    selectedSubjects.remove(subject);
                  }
                  _filters['subjects'] = selectedSubjects;
                });
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
              labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMaterialTypeFilter() {
    final selectedTypes = (_filters['materialTypes'] as List<String>?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Material Types',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _materialTypes.map((type) {
            final isSelected = selectedTypes.contains(type);
            return FilterChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedTypes.add(type);
                  } else {
                    selectedTypes.remove(type);
                  }
                  _filters['materialTypes'] = selectedTypes;
                });
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
              labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProgressFilter() {
    final selectedProgress = _filters['progress'] as String? ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress Status',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Column(
          children: _progressFilters.map((progress) {
            return RadioListTile<String>(
              title: Text(
                progress,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              value: progress,
              groupValue: selectedProgress,
              onChanged: (value) {
                setState(() {
                  _filters['progress'] = value ?? '';
                });
              },
              activeColor: AppTheme.lightTheme.colorScheme.primary,
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDownloadStatusFilter() {
    final downloadedOnly = _filters['downloadedOnly'] as bool? ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Download Status',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        SwitchListTile(
          title: Text(
            'Show only downloaded materials',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          value: downloadedOnly,
          onChanged: (value) {
            setState(() {
              _filters['downloadedOnly'] = value;
            });
          },
          activeColor: AppTheme.lightTheme.colorScheme.primary,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildSortOptions() {
    final sortBy = _filters['sortBy'] as String? ?? 'name';
    final sortOrder = _filters['sortOrder'] as String? ?? 'asc';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        DropdownButtonFormField<String>(
          value: sortBy,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          ),
          items: [
            DropdownMenuItem(value: 'name', child: Text('Name')),
            DropdownMenuItem(value: 'progress', child: Text('Progress')),
            DropdownMenuItem(
                value: 'lastAccessed', child: Text('Last Accessed')),
            DropdownMenuItem(
                value: 'materialCount', child: Text('Material Count')),
          ],
          onChanged: (value) {
            setState(() {
              _filters['sortBy'] = value ?? 'name';
            });
          },
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text(
                  'Ascending',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                value: 'asc',
                groupValue: sortOrder,
                onChanged: (value) {
                  setState(() {
                    _filters['sortOrder'] = value ?? 'asc';
                  });
                },
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text(
                  'Descending',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                value: 'desc',
                groupValue: sortOrder,
                onChanged: (value) {
                  setState(() {
                    _filters['sortOrder'] = value ?? 'desc';
                  });
                },
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                widget.onFiltersChanged(_filters);
                Navigator.pop(context);
              },
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
        'subjects': <String>[],
        'materialTypes': <String>[],
        'progress': '',
        'downloadedOnly': false,
        'sortBy': 'name',
        'sortOrder': 'asc',
      };
    });
  }
}

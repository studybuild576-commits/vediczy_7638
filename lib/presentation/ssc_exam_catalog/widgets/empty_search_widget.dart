import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptySearchWidget extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onClearSearch;
  final List<String> suggestions;

  const EmptySearchWidget({
    Key? key,
    required this.searchQuery,
    this.onClearSearch,
    this.suggestions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 3.h),
          Text(
            'No exams found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            searchQuery.isNotEmpty
                ? 'No results found for "$searchQuery"'
                : 'Try searching for SSC exams like CGL, CHSL, MTS',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          if (searchQuery.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onClearSearch,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Clear Search'),
              ),
            ),
          if (suggestions.isNotEmpty) ...[
            SizedBox(height: 3.h),
            Text(
              'Popular searches:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: suggestions.map((suggestion) {
                return ActionChip(
                  label: Text(
                    suggestion,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  onPressed: () {
                    // This would trigger search with the suggestion
                    // Implementation would be handled by parent widget
                  },
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

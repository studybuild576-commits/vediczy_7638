import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/revision_filter_sheet.dart';
import './widgets/revision_floating_menu.dart';
import './widgets/revision_progress_card.dart';
import './widgets/revision_search_bar.dart';
import './widgets/revision_section_card.dart';

class RevisionModule extends StatefulWidget {
  const RevisionModule({Key? key}) : super(key: key);

  @override
  State<RevisionModule> createState() => _RevisionModuleState();
}

class _RevisionModuleState extends State<RevisionModule>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final RefreshIndicator _refreshIndicatorKey = RefreshIndicator(
    onRefresh: () async {},
    child: Container(),
  );

  String _searchQuery = '';
  Map<String, dynamic> _currentFilters = {
    'subjects': <String>[],
    'materialTypes': <String>[],
    'progress': '',
    'downloadedOnly': false,
    'sortBy': 'name',
    'sortOrder': 'asc',
  };

  Set<String> _expandedSections = {};
  bool _isLoading = false;
  int _currentTabIndex = 2; // Revision tab active

  // Mock data for revision sections
  final List<Map<String, dynamic>> _revisionSections = [
    {
      'id': '1',
      'title': 'Mathematics - Quantitative Aptitude',
      'subject': 'Mathematics',
      'progress': 0.75,
      'isDownloaded': true,
      'lastAccessed': '2 hours ago',
      'materials': [
        {
          'id': 'm1',
          'title': 'Number System Formulas',
          'type': 'formula',
          'size': '2.5 MB',
          'isCompleted': true,
          'isBookmarked': true,
        },
        {
          'id': 'm2',
          'title': 'Algebra Practice Questions',
          'type': 'pdf',
          'size': '15.2 MB',
          'isCompleted': false,
          'isBookmarked': false,
        },
        {
          'id': 'm3',
          'title': 'Geometry Video Lectures',
          'type': 'video',
          'size': '125 MB',
          'isCompleted': true,
          'isBookmarked': true,
        },
      ],
    },
    {
      'id': '2',
      'title': 'General Knowledge & Current Affairs',
      'subject': 'General Knowledge',
      'progress': 0.45,
      'isDownloaded': false,
      'lastAccessed': '1 day ago',
      'materials': [
        {
          'id': 'm4',
          'title': 'Indian History Notes',
          'type': 'notes',
          'size': '8.7 MB',
          'isCompleted': false,
          'isBookmarked': true,
        },
        {
          'id': 'm5',
          'title': 'Geography Quick Reference',
          'type': 'pdf',
          'size': '12.1 MB',
          'isCompleted': true,
          'isBookmarked': false,
        },
        {
          'id': 'm6',
          'title': 'Current Affairs Quiz',
          'type': 'quiz',
          'size': '3.2 MB',
          'isCompleted': false,
          'isBookmarked': false,
        },
      ],
    },
    {
      'id': '3',
      'title': 'English Language & Comprehension',
      'subject': 'English',
      'progress': 0.90,
      'isDownloaded': true,
      'lastAccessed': '3 hours ago',
      'materials': [
        {
          'id': 'm7',
          'title': 'Grammar Rules & Examples',
          'type': 'notes',
          'size': '6.4 MB',
          'isCompleted': true,
          'isBookmarked': true,
        },
        {
          'id': 'm8',
          'title': 'Vocabulary Building',
          'type': 'pdf',
          'size': '9.8 MB',
          'isCompleted': true,
          'isBookmarked': false,
        },
        {
          'id': 'm9',
          'title': 'Reading Comprehension Practice',
          'type': 'pdf',
          'size': '18.5 MB',
          'isCompleted': true,
          'isBookmarked': true,
        },
      ],
    },
    {
      'id': '4',
      'title': 'Logical Reasoning & Analytical Ability',
      'subject': 'Reasoning',
      'progress': 0.30,
      'isDownloaded': false,
      'lastAccessed': '2 days ago',
      'materials': [
        {
          'id': 'm10',
          'title': 'Logical Puzzles Collection',
          'type': 'pdf',
          'size': '22.3 MB',
          'isCompleted': false,
          'isBookmarked': false,
        },
        {
          'id': 'm11',
          'title': 'Coding-Decoding Techniques',
          'type': 'video',
          'size': '89 MB',
          'isCompleted': true,
          'isBookmarked': true,
        },
        {
          'id': 'm12',
          'title': 'Blood Relations Formula Sheet',
          'type': 'formula',
          'size': '1.8 MB',
          'isCompleted': false,
          'isBookmarked': false,
        },
      ],
    },
    {
      'id': '5',
      'title': 'General Science & Computer Knowledge',
      'subject': 'General Science',
      'progress': 0.60,
      'isDownloaded': true,
      'lastAccessed': '5 hours ago',
      'materials': [
        {
          'id': 'm13',
          'title': 'Physics Fundamentals',
          'type': 'notes',
          'size': '11.2 MB',
          'isCompleted': true,
          'isBookmarked': false,
        },
        {
          'id': 'm14',
          'title': 'Chemistry Important Reactions',
          'type': 'formula',
          'size': '4.1 MB',
          'isCompleted': false,
          'isBookmarked': true,
        },
        {
          'id': 'm15',
          'title': 'Computer Basics Quiz',
          'type': 'quiz',
          'size': '2.7 MB',
          'isCompleted': true,
          'isBookmarked': false,
        },
      ],
    },
  ];

  // Mock progress data
  final Map<String, dynamic> _progressData = {
    'totalMaterials': 15,
    'completedMaterials': 9,
    'studyStreak': 7,
    'todayStudyTime': 45,
  };

  @override
  void initState() {
    super.initState();
    _loadRevisionData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadRevisionData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    await _loadRevisionData();
    Fluttertoast.showToast(
      msg: "Revision materials updated",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  List<Map<String, dynamic>> _getFilteredSections() {
    List<Map<String, dynamic>> filtered = List.from(_revisionSections);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((section) {
        final title = (section['title'] as String).toLowerCase();
        final materials = section['materials'] as List;
        final materialTitles = materials
            .map((m) => (m['title'] as String).toLowerCase())
            .join(' ');
        return title.contains(_searchQuery.toLowerCase()) ||
            materialTitles.contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply subject filter
    final selectedSubjects = _currentFilters['subjects'] as List<String>;
    if (selectedSubjects.isNotEmpty) {
      filtered = filtered.where((section) {
        return selectedSubjects.contains(section['subject']);
      }).toList();
    }

    // Apply material type filter
    final selectedTypes = _currentFilters['materialTypes'] as List<String>;
    if (selectedTypes.isNotEmpty) {
      filtered = filtered.where((section) {
        final materials = section['materials'] as List;
        return materials.any((material) {
          return selectedTypes
              .contains((material['type'] as String).toUpperCase());
        });
      }).toList();
    }

    // Apply progress filter
    final progressFilter = _currentFilters['progress'] as String;
    if (progressFilter.isNotEmpty) {
      filtered = filtered.where((section) {
        final progress = section['progress'] as double;
        switch (progressFilter) {
          case 'Not Started':
            return progress == 0.0;
          case 'In Progress':
            return progress > 0.0 && progress < 1.0;
          case 'Completed':
            return progress >= 1.0;
          default:
            return true;
        }
      }).toList();
    }

    // Apply download status filter
    final downloadedOnly = _currentFilters['downloadedOnly'] as bool;
    if (downloadedOnly) {
      filtered = filtered.where((section) {
        return section['isDownloaded'] as bool;
      }).toList();
    }

    // Apply sorting
    final sortBy = _currentFilters['sortBy'] as String;
    final sortOrder = _currentFilters['sortOrder'] as String;

    filtered.sort((a, b) {
      int comparison = 0;
      switch (sortBy) {
        case 'name':
          comparison = (a['title'] as String).compareTo(b['title'] as String);
          break;
        case 'progress':
          comparison =
              (a['progress'] as double).compareTo(b['progress'] as double);
          break;
        case 'lastAccessed':
          // Simple mock comparison
          comparison = (a['lastAccessed'] as String)
              .compareTo(b['lastAccessed'] as String);
          break;
        case 'materialCount':
          final aCount = (a['materials'] as List).length;
          final bCount = (b['materials'] as List).length;
          comparison = aCount.compareTo(bCount);
          break;
      }
      return sortOrder == 'desc' ? -comparison : comparison;
    });

    return filtered;
  }

  bool _hasActiveFilters() {
    final subjects = _currentFilters['subjects'] as List<String>;
    final types = _currentFilters['materialTypes'] as List<String>;
    final progress = _currentFilters['progress'] as String;
    final downloadedOnly = _currentFilters['downloadedOnly'] as bool;

    return subjects.isNotEmpty ||
        types.isNotEmpty ||
        progress.isNotEmpty ||
        downloadedOnly ||
        _currentFilters['sortBy'] != 'name' ||
        _currentFilters['sortOrder'] != 'asc';
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RevisionFilterSheet(
        currentFilters: _currentFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _currentFilters = filters;
          });
        },
      ),
    );
  }

  void _toggleSectionExpansion(String sectionId) {
    setState(() {
      if (_expandedSections.contains(sectionId)) {
        _expandedSections.remove(sectionId);
      } else {
        _expandedSections.add(sectionId);
      }
    });
  }

  void _handleMaterialTap(Map<String, dynamic> material) {
    Fluttertoast.showToast(
      msg: "Opening ${material['title']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleDownload(Map<String, dynamic> material) {
    Fluttertoast.showToast(
      msg: "Downloading ${material['title']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleBookmark(Map<String, dynamic> material) {
    final isBookmarked = material['isBookmarked'] as bool;
    Fluttertoast.showToast(
      msg: isBookmarked ? "Removed from bookmarks" : "Added to bookmarks",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleShare(Map<String, dynamic> material) {
    Fluttertoast.showToast(
      msg: "Sharing ${material['title']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleMarkComplete(Map<String, dynamic> material) {
    final isCompleted = material['isCompleted'] as bool;
    Fluttertoast.showToast(
      msg: isCompleted ? "Marked as incomplete" : "Marked as complete",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handlePersonalNotes() {
    Fluttertoast.showToast(
      msg: "Opening personal notes",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleBookmarks() {
    Fluttertoast.showToast(
      msg: "Opening bookmarked materials",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleOfflineContent() {
    Fluttertoast.showToast(
      msg: "Opening offline content",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSections = _getFilteredSections();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Revision Module',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to profile or settings
            },
            icon: CustomIconWidget(
              iconName: 'account_circle',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            RevisionSearchBar(
              searchQuery: _searchQuery,
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              onFilterTap: _showFilterSheet,
              hasActiveFilters: _hasActiveFilters(),
            ),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : RefreshIndicator(
                      onRefresh: _refreshData,
                      child: filteredSections.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.only(bottom: 10.h),
                              itemCount: filteredSections.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return RevisionProgressCard(
                                    progressData: _progressData,
                                  );
                                }

                                final section = filteredSections[index - 1];
                                final sectionId = section['id'] as String;
                                final isExpanded =
                                    _expandedSections.contains(sectionId);

                                return RevisionSectionCard(
                                  section: section,
                                  isExpanded: isExpanded,
                                  onTap: () =>
                                      _toggleSectionExpansion(sectionId),
                                  onMaterialTap: _handleMaterialTap,
                                  onDownload: _handleDownload,
                                  onBookmark: _handleBookmark,
                                  onShare: _handleShare,
                                  onMarkComplete: _handleMarkComplete,
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: RevisionFloatingMenu(
        onPersonalNotesTap: _handlePersonalNotes,
        onBookmarksTap: _handleBookmarks,
        onOfflineContentTap: _handleOfflineContent,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading revision materials...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              size: 64,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 3.h),
            Text(
              'No materials found',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search or filters to find what you\'re looking for.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _currentFilters = {
                    'subjects': <String>[],
                    'materialTypes': <String>[],
                    'progress': '',
                    'downloadedOnly': false,
                    'sortBy': 'name',
                    'sortOrder': 'asc',
                  };
                });
              },
              child: Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      onTap: (index) {
        setState(() {
          _currentTabIndex = index;
        });

        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/ai-doubt-solve');
            break;
          case 1:
            Navigator.pushNamed(context, '/test-interface');
            break;
          case 2:
            // Current screen - Revision
            break;
          case 3:
            Navigator.pushNamed(context, '/dashboard');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'psychology',
            size: 24,
            color: _currentTabIndex == 0
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          label: 'AI Doubt',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'quiz',
            size: 24,
            color: _currentTabIndex == 1
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          label: 'Test',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'book',
            size: 24,
            color: _currentTabIndex == 2
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          label: 'Revision',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            size: 24,
            color: _currentTabIndex == 3
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}

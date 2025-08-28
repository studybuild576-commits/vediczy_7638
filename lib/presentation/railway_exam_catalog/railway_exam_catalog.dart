import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/railway_exam_card.dart';
import './widgets/railway_exam_detail_sheet.dart';
import './widgets/railway_filter_bottom_sheet.dart';
import './widgets/railway_search_bar.dart';

class RailwayExamCatalog extends StatefulWidget {
  const RailwayExamCatalog({Key? key}) : super(key: key);

  @override
  State<RailwayExamCatalog> createState() => _RailwayExamCatalogState();
}

class _RailwayExamCatalogState extends State<RailwayExamCatalog> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _allExams = [];
  List<Map<String, dynamic>> _filteredExams = [];
  bool _isLoading = false;
  bool _isRefreshing = false;

  Map<String, dynamic> _currentFilters = {
    'examType': 'All',
    'sortBy': 'Name A-Z',
    'showBookmarked': false,
  };

  @override
  void initState() {
    super.initState();
    _loadExamData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more data if needed
    }
  }

  Future<void> _loadExamData() async {
    setState(() {
      _isLoading = true;
    });

    // Mock Railway exam data
    _allExams = [
      {
        "id": 1,
        "name": "RRB NTPC (Non-Technical Popular Categories)",
        "department": "Railway Recruitment Board",
        "description":
            "Recruitment for various non-technical posts in Indian Railways including Station Master, Goods Guard, Commercial Apprentice, and Traffic Assistant positions.",
        "vacancies": "35,281",
        "deadline": "15/03/2025",
        "ageLimit": "18-33 years",
        "salary": "₹19,900 - ₹63,200",
        "eligibility":
            "Graduate from recognized university. Age limit varies by category with relaxation for reserved categories.",
        "examPattern": {
          "duration": "90 minutes",
          "totalMarks": "100",
          "totalQuestions": "100",
          "negativeMarking": "1/3 mark deduction"
        },
        "isBookmarked": false,
        "category": "RRB NTPC"
      },
      {
        "id": 2,
        "name": "RRB Group D (Level 1 Posts)",
        "department": "Railway Recruitment Board",
        "description":
            "Recruitment for Track Maintainer Grade-IV, Helper/Assistant in various technical departments, Assistant Pointsman and other Group D posts.",
        "vacancies": "1,03,769",
        "deadline": "28/02/2025",
        "ageLimit": "18-33 years",
        "salary": "₹18,000 - ₹56,900",
        "eligibility":
            "10th pass or ITI from institutions recognized by NCVT/SCVT or equivalent qualification.",
        "examPattern": {
          "duration": "90 minutes",
          "totalMarks": "100",
          "totalQuestions": "100",
          "negativeMarking": "1/3 mark deduction"
        },
        "isBookmarked": true,
        "category": "RRB Group D"
      },
      {
        "id": 3,
        "name": "RRB JE (Junior Engineer)",
        "department": "Railway Recruitment Board",
        "description":
            "Recruitment for Junior Engineer posts in Civil, Mechanical, Electrical, Electronics & Telecommunication, and Information Technology departments.",
        "vacancies": "13,487",
        "deadline": "10/04/2025",
        "ageLimit": "18-33 years",
        "salary": "₹35,400 - ₹1,12,400",
        "eligibility":
            "Engineering Degree/Diploma in relevant discipline from recognized university/institution.",
        "examPattern": {
          "duration": "90 minutes",
          "totalMarks": "100",
          "totalQuestions": "100",
          "negativeMarking": "1/3 mark deduction"
        },
        "isBookmarked": false,
        "category": "RRB JE"
      },
      {
        "id": 4,
        "name": "RRB ALP (Assistant Loco Pilot)",
        "department": "Railway Recruitment Board",
        "description":
            "Recruitment for Assistant Loco Pilot and Technician Grade III posts in various technical departments of Indian Railways.",
        "vacancies": "27,795",
        "deadline": "22/03/2025",
        "ageLimit": "18-28 years",
        "salary": "₹19,900 - ₹63,200",
        "eligibility":
            "10+2 with Physics and Mathematics OR ITI in relevant trade OR Diploma in Engineering.",
        "examPattern": {
          "duration": "60 minutes",
          "totalMarks": "75",
          "totalQuestions": "75",
          "negativeMarking": "1/3 mark deduction"
        },
        "isBookmarked": true,
        "category": "RRB ALP"
      },
      {
        "id": 5,
        "name": "RRB TC (Ticket Collector)",
        "department": "Railway Recruitment Board",
        "description":
            "Recruitment for Ticket Collector, Ticket Examiner, and other commercial posts in passenger services department.",
        "vacancies": "8,500",
        "deadline": "05/04/2025",
        "ageLimit": "18-33 years",
        "salary": "₹21,700 - ₹69,100",
        "eligibility":
            "Graduate from recognized university with preference for Commerce/Management background.",
        "examPattern": {
          "duration": "90 minutes",
          "totalMarks": "100",
          "totalQuestions": "100",
          "negativeMarking": "1/3 mark deduction"
        },
        "isBookmarked": false,
        "category": "RRB TC"
      },
      {
        "id": 6,
        "name": "RRB SSE (Senior Section Engineer)",
        "department": "Railway Recruitment Board",
        "description":
            "Recruitment for Senior Section Engineer posts in Civil, Mechanical, Electrical, and Signal & Telecommunication departments.",
        "vacancies": "2,900",
        "deadline": "18/04/2025",
        "ageLimit": "20-30 years",
        "salary": "₹35,400 - ₹1,12,400",
        "eligibility":
            "Engineering Degree in relevant discipline with minimum 60% marks from recognized university.",
        "examPattern": {
          "duration": "120 minutes",
          "totalMarks": "150",
          "totalQuestions": "150",
          "negativeMarking": "1/3 mark deduction"
        },
        "isBookmarked": false,
        "category": "RRB SSE"
      },
      {
        "id": 7,
        "name": "Railway Apprentice",
        "department": "Railway Recruitment Board",
        "description":
            "Apprenticeship training program in various technical trades including Fitter, Electrician, Welder, Machinist, and other skilled trades.",
        "vacancies": "50,000+",
        "deadline": "30/03/2025",
        "ageLimit": "15-24 years",
        "salary": "₹8,000 - ₹12,000 (Stipend)",
        "eligibility":
            "10th pass with ITI in relevant trade OR 10+2 with Physics, Chemistry and Mathematics.",
        "examPattern": {
          "duration": "75 minutes",
          "totalMarks": "100",
          "totalQuestions": "100",
          "negativeMarking": "No negative marking"
        },
        "isBookmarked": true,
        "category": "RAILWAY APPRENTICE"
      },
    ];

    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      _isLoading = false;
      _filteredExams = List.from(_allExams);
    });

    _applyFiltersAndSearch();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(Duration(seconds: 1));
    await _loadExamData();

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onSearchChanged(String query) {
    _applyFiltersAndSearch();
  }

  void _applyFiltersAndSearch() {
    List<Map<String, dynamic>> filtered = List.from(_allExams);

    // Apply search filter
    String searchQuery = _searchController.text.toLowerCase().trim();
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((exam) {
        return (exam['name'] as String).toLowerCase().contains(searchQuery) ||
            (exam['department'] as String)
                .toLowerCase()
                .contains(searchQuery) ||
            (exam['description'] as String).toLowerCase().contains(searchQuery);
      }).toList();
    }

    // Apply exam type filter
    if (_currentFilters['examType'] != 'All') {
      filtered = filtered.where((exam) {
        return exam['category'] == _currentFilters['examType'];
      }).toList();
    }

    // Apply bookmarked filter
    if (_currentFilters['showBookmarked'] == true) {
      filtered =
          filtered.where((exam) => exam['isBookmarked'] == true).toList();
    }

    // Apply sorting
    switch (_currentFilters['sortBy']) {
      case 'Name A-Z':
        filtered.sort(
            (a, b) => (a['name'] as String).compareTo(b['name'] as String));
        break;
      case 'Name Z-A':
        filtered.sort(
            (a, b) => (b['name'] as String).compareTo(a['name'] as String));
        break;
      case 'Latest First':
        filtered.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));
        break;
      case 'Deadline Soon':
        filtered.sort((a, b) {
          // Simple deadline sorting (in real app, parse dates properly)
          return (a['deadline'] as String).compareTo(b['deadline'] as String);
        });
        break;
      case 'Most Vacancies':
        filtered.sort((a, b) {
          String aVacancies =
              (a['vacancies'] as String).replaceAll(RegExp(r'[^0-9]'), '');
          String bVacancies =
              (b['vacancies'] as String).replaceAll(RegExp(r'[^0-9]'), '');
          return int.parse(bVacancies.isEmpty ? '0' : bVacancies)
              .compareTo(int.parse(aVacancies.isEmpty ? '0' : aVacancies));
        });
        break;
    }

    setState(() {
      _filteredExams = filtered;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RailwayFilterBottomSheet(
        currentFilters: _currentFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          _applyFiltersAndSearch();
        },
      ),
    );
  }

  void _showExamDetails(Map<String, dynamic> examData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RailwayExamDetailSheet(
        examData: examData,
        onModelTest: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/test-interface');
        },
        onPYQTest: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/test-interface');
        },
        onRevision: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/revision-module');
        },
      ),
    );
  }

  void _toggleBookmark(int examId) {
    setState(() {
      final examIndex = _allExams.indexWhere((exam) => exam['id'] == examId);
      if (examIndex != -1) {
        _allExams[examIndex]['isBookmarked'] =
            !(_allExams[examIndex]['isBookmarked'] ?? false);
      }
    });
    _applyFiltersAndSearch();
  }

  void _navigateToTest(String testType) {
    Navigator.pushNamed(context, '/test-interface');
  }

  void _navigateToRevision() {
    Navigator.pushNamed(context, '/revision-module');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Railway Exams',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDarkMode
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
              ),
        ),
        backgroundColor:
            isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        elevation: 0,
        leading: IconButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/dashboard'),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: isDarkMode
                ? AppTheme.textPrimaryDark
                : AppTheme.textPrimaryLight,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/ssc-exam-catalog'),
            icon: CustomIconWidget(
              iconName: 'swap_horiz',
              color: isDarkMode
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          RailwaySearchBar(
            controller: _searchController,
            hintText: 'Search Railway exams...',
            onChanged: _onSearchChanged,
            onFilterTap: _showFilterBottomSheet,
          ),

          // Results count
          if (!_isLoading) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_filteredExams.length} exam${_filteredExams.length != 1 ? 's' : ''} found',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDarkMode
                              ? AppTheme.textSecondaryDark
                              : AppTheme.textSecondaryLight,
                        ),
                  ),
                  if (_currentFilters['examType'] != 'All' ||
                      _currentFilters['showBookmarked'] == true ||
                      _searchController.text.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _currentFilters = {
                            'examType': 'All',
                            'sortBy': 'Name A-Z',
                            'showBookmarked': false,
                          };
                          _searchController.clear();
                        });
                        _applyFiltersAndSearch();
                      },
                      child: Text(
                        'Clear Filters',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                ],
              ),
            ),
          ],

          // Content
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _filteredExams.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _refreshData,
                        color: AppTheme.lightTheme.primaryColor,
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: _filteredExams.length,
                          itemBuilder: (context, index) {
                            final exam = _filteredExams[index];
                            return RailwayExamCard(
                              examData: exam,
                              onTap: () => _showExamDetails(exam),
                              onBookmark: () => _toggleBookmark(exam['id']),
                              onModelTest: () => _navigateToTest('model'),
                              onPYQTest: () => _navigateToTest('pyq'),
                              onRevision: _navigateToRevision,
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppTheme.dividerDark
                              : AppTheme.dividerLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 2.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppTheme.dividerDark
                                    : AppTheme.dividerLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Container(
                              height: 1.5.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppTheme.dividerDark
                                    : AppTheme.dividerLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Container(
                    height: 1.5.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppTheme.dividerDark
                          : AppTheme.dividerLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    height: 1.5.h,
                    width: 70.w,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppTheme.dividerDark
                          : AppTheme.dividerLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: List.generate(
                        3,
                        (index) => Expanded(
                              child: Container(
                                height: 5.h,
                                margin:
                                    EdgeInsets.only(right: index < 2 ? 2.w : 0),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? AppTheme.dividerDark
                                      : AppTheme.dividerLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'search_off',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 15.w,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'No Railway Exams Found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Try adjusting your search terms or filters to find the Railway exam you\'re looking for.'
                  : 'No Railway exams match your current filters. Try adjusting your filter settings.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDarkMode
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentFilters = {
                          'examType': 'All',
                          'sortBy': 'Name A-Z',
                          'showBookmarked': false,
                        };
                        _searchController.clear();
                      });
                      _applyFiltersAndSearch();
                    },
                    child: Text(
                      'Clear Filters',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/dashboard'),
                    child: Text(
                      'Back to Dashboard',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.onPrimaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

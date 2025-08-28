import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_search_widget.dart';
import './widgets/exam_card_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/skeleton_card_widget.dart';

class SscExamCatalog extends StatefulWidget {
  const SscExamCatalog({Key? key}) : super(key: key);

  @override
  State<SscExamCatalog> createState() => _SscExamCatalogState();
}

class _SscExamCatalogState extends State<SscExamCatalog> {
  bool _isLoading = false;
  bool _isSearchVisible = false;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String? _expandedExamId;

  final List<String> _filters = ['All', 'Beginner', 'Intermediate', 'Advanced'];
  final List<String> _searchSuggestions = ['CGL', 'CHSL', 'MTS', 'CPO', 'JE'];

  final List<Map<String, dynamic>> _sscExams = [
    {
      "id": "ssc_cgl_2024",
      "name": "SSC CGL",
      "fullName": "Staff Selection Commission Combined Graduate Level",
      "description":
          "Combined Graduate Level examination for Group B and Group C posts in various ministries",
      "type": "CGL",
      "difficulty": "Advanced",
      "syllabus":
          "General Intelligence & Reasoning, General Awareness, Quantitative Aptitude, English Comprehension. Tier-II includes Statistics, General Studies (Finance & Economics), and Computer Knowledge.",
      "lastUpdated": "15 Aug 2024",
      "isBookmarked": false,
      "totalQuestions": 200,
      "duration": "60 minutes per tier",
      "eligibility": "Bachelor's degree from recognized university",
      "ageLimit": "18-32 years",
      "applicationFee": "₹100 (General/OBC), Free (SC/ST/Women)",
    },
    {
      "id": "ssc_chsl_2024",
      "name": "SSC CHSL",
      "fullName": "Staff Selection Commission Combined Higher Secondary Level",
      "description":
          "Combined Higher Secondary Level examination for Data Entry Operator, Lower Division Clerk posts",
      "type": "CHSL",
      "difficulty": "Intermediate",
      "syllabus":
          "General Intelligence, English Language, Quantitative Aptitude, General Awareness. Tier-II includes Essay Writing and Letter/Application Writing.",
      "lastUpdated": "12 Aug 2024",
      "isBookmarked": true,
      "totalQuestions": 100,
      "duration": "60 minutes",
      "eligibility": "12th pass from recognized board",
      "ageLimit": "18-27 years",
      "applicationFee": "₹100 (General/OBC), Free (SC/ST/Women)",
    },
    {
      "id": "ssc_mts_2024",
      "name": "SSC MTS",
      "fullName": "Staff Selection Commission Multi-Tasking Staff",
      "description":
          "Multi-Tasking Staff examination for Group C non-gazetted, non-ministerial posts",
      "type": "MTS",
      "difficulty": "Beginner",
      "syllabus":
          "General Intelligence & Reasoning, Numerical Aptitude, General Awareness, English Language. Paper-II includes English Language and Comprehension.",
      "lastUpdated": "10 Aug 2024",
      "isBookmarked": false,
      "totalQuestions": 100,
      "duration": "90 minutes",
      "eligibility": "Matriculation or equivalent from recognized board",
      "ageLimit": "18-25 years",
      "applicationFee": "₹100 (General/OBC), Free (SC/ST/Women)",
    },
    {
      "id": "ssc_cpo_2024",
      "name": "SSC CPO",
      "fullName": "Staff Selection Commission Central Police Organisation",
      "description":
          "Central Police Organisation examination for Sub-Inspector posts in various forces",
      "type": "CPO",
      "difficulty": "Advanced",
      "syllabus":
          "General Intelligence & Reasoning, General Knowledge & General Awareness, Quantitative Aptitude, English Comprehension. Includes Physical Standards Test and Medical Examination.",
      "lastUpdated": "08 Aug 2024",
      "isBookmarked": true,
      "totalQuestions": 200,
      "duration": "120 minutes",
      "eligibility": "Bachelor's degree from recognized university",
      "ageLimit": "20-25 years",
      "applicationFee": "₹100 (General/OBC), Free (SC/ST/Women)",
    },
    {
      "id": "ssc_je_2024",
      "name": "SSC JE",
      "fullName": "Staff Selection Commission Junior Engineer",
      "description":
          "Junior Engineer examination for technical posts in various departments and ministries",
      "type": "JE",
      "difficulty": "Advanced",
      "syllabus":
          "General Intelligence & Reasoning, General Awareness, Technical subjects (Civil/Mechanical/Electrical Engineering). Paper-II includes technical subjects based on specialization.",
      "lastUpdated": "05 Aug 2024",
      "isBookmarked": false,
      "totalQuestions": 200,
      "duration": "120 minutes",
      "eligibility":
          "Diploma/Degree in Engineering from recognized institution",
      "ageLimit": "18-32 years",
      "applicationFee": "₹100 (General/OBC), Free (SC/ST/Women)",
    },
    {
      "id": "ssc_gd_2024",
      "name": "SSC GD",
      "fullName": "Staff Selection Commission General Duty",
      "description":
          "General Duty Constable examination for various paramilitary forces under MHA",
      "type": "GD",
      "difficulty": "Intermediate",
      "syllabus":
          "General Intelligence & Reasoning, General Knowledge & General Awareness, Elementary Mathematics, English/Hindi. Includes Physical Efficiency Test and Medical Examination.",
      "lastUpdated": "03 Aug 2024",
      "isBookmarked": false,
      "totalQuestions": 80,
      "duration": "60 minutes",
      "eligibility": "Matriculation or equivalent from recognized board",
      "ageLimit": "18-23 years",
      "applicationFee": "₹100 (General/OBC), Free (SC/ST/Women)",
    },
    {
      "id": "ssc_stenographer_2024",
      "name": "SSC Stenographer",
      "fullName": "Staff Selection Commission Stenographer Grade C & D",
      "description":
          "Stenographer examination for Grade C and Grade D posts in various ministries",
      "type": "Stenographer",
      "difficulty": "Intermediate",
      "syllabus":
          "General Intelligence & Reasoning, General Awareness, English Language & Comprehension. Skill Test includes Stenography Test in English/Hindi.",
      "lastUpdated": "01 Aug 2024",
      "isBookmarked": true,
      "totalQuestions": 200,
      "duration": "120 minutes",
      "eligibility": "12th pass from recognized board",
      "ageLimit": "18-27 years",
      "applicationFee": "₹100 (General/OBC), Free (SC/ST/Women)",
    },
  ];

  List<Map<String, dynamic>> get _filteredExams {
    List<Map<String, dynamic>> filtered = _sscExams;

    // Apply difficulty filter
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((exam) => exam['difficulty'] == _selectedFilter)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((exam) {
        final name = (exam['name'] as String).toLowerCase();
        final fullName = (exam['fullName'] as String).toLowerCase();
        final description = (exam['description'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return name.contains(query) ||
            fullName.contains(query) ||
            description.contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  Future<void> _loadExams() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshExams() async {
    await _loadExams();
    _showToast('Exam catalog updated successfully');
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchQuery = '';
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
  }

  void _onFilterSelected(String filter) {
    setState(() => _selectedFilter = filter);
  }

  void _onExamTap(String examId) {
    setState(() {
      _expandedExamId = _expandedExamId == examId ? null : examId;
    });
  }

  void _onBookmark(String examId) {
    setState(() {
      final examIndex = _sscExams.indexWhere((exam) => exam['id'] == examId);
      if (examIndex != -1) {
        _sscExams[examIndex]['isBookmarked'] =
            !(_sscExams[examIndex]['isBookmarked'] as bool);
        final isBookmarked = _sscExams[examIndex]['isBookmarked'] as bool;
        _showToast(
            isBookmarked ? 'Added to bookmarks' : 'Removed from bookmarks');
      }
    });
  }

  void _onDownload(String examId) {
    final exam = _sscExams.firstWhere((exam) => exam['id'] == examId);
    _showToast('Downloading ${exam['name']} content...');
  }

  void _onShare(String examId) {
    final exam = _sscExams.firstWhere((exam) => exam['id'] == examId);
    _showToast('Sharing ${exam['name']} exam details');
  }

  void _onModelTest(String examId) {
    final exam = _sscExams.firstWhere((exam) => exam['id'] == examId);
    _showToast('Starting ${exam['name']} Model Test');
    Navigator.pushNamed(context, '/test-interface');
  }

  void _onPyqTest(String examId) {
    final exam = _sscExams.firstWhere((exam) => exam['id'] == examId);
    _showToast('Starting ${exam['name']} PYQ Test');
    Navigator.pushNamed(context, '/test-interface');
  }

  void _onRevision(String examId) {
    final exam = _sscExams.firstWhere((exam) => exam['id'] == examId);
    _showToast('Opening ${exam['name']} Revision Module');
    Navigator.pushNamed(context, '/revision-module');
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      textColor: Theme.of(context).colorScheme.onInverseSurface,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStickyHeader(),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'SSC Exams',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: _isSearchVisible ? 'close' : 'search',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyHeader() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          SearchBarWidget(
            hintText: 'Search SSC exams...',
            onSearchChanged: _onSearchChanged,
            onClear: () => setState(() => _searchQuery = ''),
            isVisible: _isSearchVisible,
          ),
          FilterChipsWidget(
            filters: _filters,
            selectedFilter: _selectedFilter,
            onFilterSelected: _onFilterSelected,
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    final filteredExams = _filteredExams;

    if (filteredExams.isEmpty) {
      return EmptySearchWidget(
        searchQuery: _searchQuery,
        onClearSearch: () {
          setState(() {
            _searchQuery = '';
            _isSearchVisible = false;
          });
        },
        suggestions: _searchSuggestions,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshExams,
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 2.h),
        itemCount: filteredExams.length,
        itemBuilder: (context, index) {
          final exam = filteredExams[index];
          final examId = exam['id'] as String;

          return ExamCardWidget(
            examData: exam,
            isExpanded: _expandedExamId == examId,
            onTap: () => _onExamTap(examId),
            onBookmark: () => _onBookmark(examId),
            onDownload: () => _onDownload(examId),
            onShare: () => _onShare(examId),
            onModelTest: () => _onModelTest(examId),
            onPyqTest: () => _onPyqTest(examId),
            onRevision: () => _onRevision(examId),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 2.h),
      itemCount: 5,
      itemBuilder: (context, index) => const SkeletonCardWidget(),
    );
  }
}

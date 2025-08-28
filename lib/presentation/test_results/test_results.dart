import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/performance_chart_widget.dart';
import './widgets/subject_analysis_widget.dart';
import './widgets/test_result_card_widget.dart';

class TestResults extends StatefulWidget {
  const TestResults({Key? key}) : super(key: key);

  @override
  State<TestResults> createState() => _TestResultsState();
}

class _TestResultsState extends State<TestResults>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilterIndex = 0;

  final List<String> _filterOptions = [
    'All Tests',
    'This Week',
    'This Month',
    'SSC CGL',
    'Railway'
  ];

  final List<Map<String, dynamic>> _testResults = [
    {
      'id': 1,
      'testName': 'SSC CGL Mock Test #15',
      'examType': 'SSC CGL',
      'totalQuestions': 100,
      'correctAnswers': 78,
      'incorrectAnswers': 15,
      'unattempted': 7,
      'score': 78,
      'totalMarks': 200,
      'scoredMarks': 234,
      'percentile': 85.6,
      'timeSpent': 118, // minutes 'date': '2024-08-26',
      'rank': 245,
      'subjects': {
        'General Intelligence': {'correct': 22, 'total': 25, 'accuracy': 88.0},
        'General Awareness': {'correct': 18, 'total': 25, 'accuracy': 72.0},
        'Quantitative Aptitude': {'correct': 20, 'total': 25, 'accuracy': 80.0},
        'English Language': {'correct': 18, 'total': 25, 'accuracy': 72.0},
      }
    },
    {
      'id': 2,
      'testName': 'Railway NTPC Practice Test #8',
      'examType': 'Railway',
      'totalQuestions': 120,
      'correctAnswers': 89,
      'incorrectAnswers': 23,
      'unattempted': 8,
      'score': 89,
      'totalMarks': 120,
      'scoredMarks': 89,
      'percentile': 78.3,
      'timeSpent': 105,
      'date': '2024-08-24',
      'rank': 890,
      'subjects': {
        'Mathematics': {'correct': 24, 'total': 30, 'accuracy': 80.0},
        'General Intelligence': {'correct': 26, 'total': 30, 'accuracy': 86.7},
        'General Awareness': {'correct': 21, 'total': 30, 'accuracy': 70.0},
        'General Science': {'correct': 18, 'total': 30, 'accuracy': 60.0},
      }
    },
    {
      'id': 3,
      'testName': 'SSC CGL Mock Test #14',
      'examType': 'SSC CGL',
      'totalQuestions': 100,
      'correctAnswers': 72,
      'incorrectAnswers': 20,
      'unattempted': 8,
      'score': 72,
      'totalMarks': 200,
      'scoredMarks': 216,
      'percentile': 82.1,
      'timeSpent': 115,
      'date': '2024-08-22',
      'rank': 312,
      'subjects': {
        'General Intelligence': {'correct': 19, 'total': 25, 'accuracy': 76.0},
        'General Awareness': {'correct': 16, 'total': 25, 'accuracy': 64.0},
        'Quantitative Aptitude': {'correct': 18, 'total': 25, 'accuracy': 72.0},
        'English Language': {'correct': 19, 'total': 25, 'accuracy': 76.0},
      }
    },
  ];

  final List<FlSpot> _performanceData = [
    const FlSpot(0, 65),
    const FlSpot(1, 72),
    const FlSpot(2, 68),
    const FlSpot(3, 75),
    const FlSpot(4, 78),
    const FlSpot(5, 72),
    const FlSpot(6, 85),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredResults {
    switch (_selectedFilterIndex) {
      case 0:
        return _testResults;
      case 1:
        // This Week filter (mock implementation)
        return _testResults.where((test) {
          final testDate = DateTime.parse(test['date']);
          final weekAgo = DateTime.now().subtract(const Duration(days: 7));
          return testDate.isAfter(weekAgo);
        }).toList();
      case 2:
        // This Month filter
        return _testResults.where((test) {
          final testDate = DateTime.parse(test['date']);
          final monthAgo = DateTime.now().subtract(const Duration(days: 30));
          return testDate.isAfter(monthAgo);
        }).toList();
      case 3:
        return _testResults
            .where((test) => test['examType'] == 'SSC CGL')
            .toList();
      case 4:
        return _testResults
            .where((test) => test['examType'] == 'Railway')
            .toList();
      default:
        return _testResults;
    }
  }

  Map<String, dynamic> get _overallStats {
    final filtered = _filteredResults;
    if (filtered.isEmpty) {
      return {
        'totalTests': 0,
        'averageScore': 0,
        'highestScore': 0,
        'averagePercentile': 0.0,
        'totalTimeSpent': 0,
      };
    }

    final totalTests = filtered.length;
    final averageScore =
        (filtered.fold(0, (sum, test) => sum + test['score'] as int) /
                totalTests)
            .round();
    final highestScore = filtered
        .map((test) => test['score'] as int)
        .reduce((a, b) => a > b ? a : b);
    final averagePercentile =
        filtered.fold(0.0, (sum, test) => sum + test['percentile']) /
            totalTests;
    final totalTimeSpent =
        filtered.fold(0, (sum, test) => sum + test['timeSpent'] as int);

    return {
      'totalTests': totalTests,
      'averageScore': averageScore,
      'highestScore': highestScore,
      'averagePercentile': averagePercentile,
      'totalTimeSpent': totalTimeSpent,
    };
  }

  @override
  Widget build(BuildContext context) {
    final stats = _overallStats;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Test Results',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          indicatorColor: AppTheme.lightTheme.colorScheme.primary,
          tabs: const [
            Tab(text: 'Results'),
            Tab(text: 'Analysis'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            height: 6.h,
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: _filterOptions.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedFilterIndex;
                return Container(
                  margin: EdgeInsets.only(right: 2.w),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(_filterOptions[index]),
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                    backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                    selectedColor: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.2),
                    labelStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                );
              },
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Results Tab
                _buildResultsTab(stats),

                // Analysis Tab
                _buildAnalysisTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTab(Map<String, dynamic> stats) {
    return Column(
      children: [
        // Stats Summary
        Container(
          margin: EdgeInsets.all(4.w),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildStatItem(
                      'Total Tests', stats['totalTests'].toString(), 'quiz'),
                  SizedBox(width: 4.w),
                  _buildStatItem('Average Score', '${stats['averageScore']}%',
                      'analytics'),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  _buildStatItem(
                      'Highest Score', '${stats['highestScore']}%', 'star'),
                  SizedBox(width: 4.w),
                  _buildStatItem(
                      'Avg Percentile',
                      '${stats['averagePercentile'].toStringAsFixed(1)}',
                      'trending_up'),
                ],
              ),
            ],
          ),
        ),

        // Test Results List
        Expanded(
          child: _filteredResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'quiz',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No test results found',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: _filteredResults.length,
                  itemBuilder: (context, index) {
                    final test = _filteredResults[index];
                    return TestResultCardWidget(
                      testName: test['testName'],
                      examType: test['examType'],
                      score: test['score'],
                      totalQuestions: test['totalQuestions'],
                      percentile: test['percentile'],
                      date: test['date'],
                      onTap: () => _showTestDetail(test),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAnalysisTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Performance Chart
          PerformanceChartWidget(
            data: _performanceData,
            title: 'Performance Trend',
          ),

          SizedBox(height: 3.h),

          // Subject Analysis
          if (_filteredResults.isNotEmpty) ...[
            SubjectAnalysisWidget(
              subjects: _calculateSubjectAnalysis(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String iconName) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, Map<String, double>> _calculateSubjectAnalysis() {
    final Map<String, Map<String, dynamic>> subjectTotals = {};

    for (final test in _filteredResults) {
      final subjects = test['subjects'] as Map<String, dynamic>;
      for (final entry in subjects.entries) {
        final subjectName = entry.key;
        final subjectData = entry.value as Map<String, dynamic>;

        if (subjectTotals[subjectName] == null) {
          subjectTotals[subjectName] = {
            'totalCorrect': 0,
            'totalQuestions': 0,
            'testCount': 0,
          };
        }

        subjectTotals[subjectName]!['totalCorrect'] +=
            subjectData['correct'] as int;
        subjectTotals[subjectName]!['totalQuestions'] +=
            subjectData['total'] as int;
        subjectTotals[subjectName]!['testCount'] += 1;
      }
    }

    final Map<String, Map<String, double>> analysis = {};

    for (final entry in subjectTotals.entries) {
      final subjectName = entry.key;
      final data = entry.value;
      final accuracy =
          (data['totalCorrect'] as int) / (data['totalQuestions'] as int) * 100;

      analysis[subjectName] = {
        'accuracy': accuracy,
        'totalQuestions': (data['totalQuestions'] as int).toDouble(),
        'correctAnswers': (data['totalCorrect'] as int).toDouble(),
      };
    }

    return analysis;
  }

  void _showTestDetail(Map<String, dynamic> test) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              // Test Name
              Text(
                test['testName'],
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),

              // Date and Time
              Text(
                'Attempted on ${test['date']} • ${test['timeSpent']} minutes',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 3.h),

              // Quick Stats
              Row(
                children: [
                  _buildDetailStatItem(
                      'Score', '${test['score']}/${test['totalQuestions']}'),
                  _buildDetailStatItem('Percentile', '${test['percentile']}%'),
                  _buildDetailStatItem('Rank', '#${test['rank']}'),
                ],
              ),
              SizedBox(height: 3.h),

              // Subject Breakdown
              Text(
                'Subject-wise Performance',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),

              ...((test['subjects'] as Map<String, dynamic>)
                  .entries
                  .map((entry) {
                final subjectData = entry.value as Map<String, dynamic>;
                final accuracy = subjectData['accuracy'] as double;

                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${accuracy.toStringAsFixed(1)}%',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: accuracy >= 75
                                  ? Colors.green
                                  : accuracy >= 50
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      LinearProgressIndicator(
                        value: accuracy / 100,
                        backgroundColor: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          accuracy >= 75
                              ? Colors.green
                              : accuracy >= 50
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${subjectData['correct']} correct out of ${subjectData['total']}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailStatItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(2.w),
        margin: EdgeInsets.only(right: 2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

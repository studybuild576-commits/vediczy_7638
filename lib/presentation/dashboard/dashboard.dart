import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/current_affairs_service.dart';
import './widgets/current_affairs_banner_widget.dart';
import './widgets/exam_category_card_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/recent_activity_card_widget.dart';
import './widgets/study_streak_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  int _selectedTabIndex = 1; // Test tab active
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // OpenAI Current Affairs Service
  final CurrentAffairsService _currentAffairsService = CurrentAffairsService();

  // Mock data
  final List<Map<String, dynamic>> _examCategories = [
    {
      "id": 1,
      "title": "SSC Exams",
      "imageUrl":
          "https://images.pexels.com/photos/159711/books-bookstore-book-reading-159711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "examCount": 12,
      "completionPercentage": 65.0,
      "route": "/ssc-exam-catalog",
    },
    {
      "id": 2,
      "title": "Railway Exams",
      "imageUrl":
          "https://images.pixabay.com/photos/2016/02/19/11/19/office-1209640_1280.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "examCount": 8,
      "completionPercentage": 42.0,
      "route": "/railway-exam-catalog",
    },
  ];

  final List<Map<String, dynamic>> _recentActivities = [
    {
      "id": 1,
      "title": "SSC CGL Mock Test",
      "subtitle": "Scored 85/100 in Quantitative Aptitude",
      "iconName": "quiz",
      "iconColor": Color(0xFF2E7D8F),
      "timeAgo": "2h ago",
      "route": "/test-interface",
    },
    {
      "id": 2,
      "title": "AI Doubt Solved",
      "subtitle": "Algebra question about quadratic equations",
      "iconName": "psychology",
      "iconColor": Color(0xFFF4A261),
      "timeAgo": "4h ago",
      "route": "/ai-doubt-solve",
    },
    {
      "id": 3,
      "title": "Revision Completed",
      "subtitle": "General Knowledge - Indian History",
      "iconName": "book",
      "iconColor": Color(0xFF2A9D8F),
      "timeAgo": "1d ago",
      "route": "/revision-module",
    },
  ];

  // AI-Generated Current Affairs (replaces mock data)
  Map<String, dynamic> _currentAffairs = {
    "title": "Loading Current Affairs...",
    "content": "Fetching today's current affairs using AI...",
    "date":
        "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}",
  };

  final Map<String, dynamic> _studyStreak = {
    "streakDays": 15,
    "totalStudyHours": 127,
  };

  bool _isLoadingCurrentAffairs = false;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: _selectedTabIndex);
    _loadCurrentAffairs();
  }

  // Load AI-generated current affairs
  Future<void> _loadCurrentAffairs() async {
    setState(() {
      _isLoadingCurrentAffairs = true;
    });

    try {
      final currentAffairs = await _currentAffairsService.getCurrentAffairs();

      if (mounted) {
        setState(() {
          _currentAffairs = {
            "title": currentAffairs.title,
            "content": currentAffairs.content,
            "date": currentAffairs.date,
          };
          _isLoadingCurrentAffairs = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentAffairs = {
            "title": "Current Affairs Update",
            "content":
                "Unable to fetch today's current affairs. Please check your internet connection and try refreshing.",
            "date":
                "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}",
          };
          _isLoadingCurrentAffairs = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    // Refresh current affairs from AI
    setState(() {
      _isLoadingCurrentAffairs = true;
    });

    try {
      final currentAffairs =
          await _currentAffairsService.refreshCurrentAffairs();

      if (mounted) {
        setState(() {
          _currentAffairs = {
            "title": currentAffairs.title,
            "content": currentAffairs.content,
            "date": currentAffairs.date,
          };
          _isLoadingCurrentAffairs = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCurrentAffairs = false;
        });
      }
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });

    // Navigate based on tab selection
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/ai-doubt-solve');
        break;
      case 1:
        // Dashboard - stay on current screen
        break;
      case 2:
        Navigator.pushNamed(context, '/revision-module');
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.profileManagement);
        break;
    }
  }

  void _showQuickActions(String categoryTitle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "$categoryTitle Quick Actions",
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildQuickActionItem("Download Content", "download", () {
              Navigator.pop(context);
            }),
            _buildQuickActionItem("View Progress", "analytics", () {
              Navigator.pop(context);
            }),
            _buildQuickActionItem("Settings", "settings", () {
              Navigator.pop(context);
            }),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
      String title, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 10.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              // Greeting Header
              SliverToBoxAdapter(
                child: GreetingHeaderWidget(
                  userName: "Rahul Kumar",
                  onNotificationTap: () {
                    // Handle notification tap
                  },
                ),
              ),

              // Exam Categories
              SliverToBoxAdapter(
                child: Column(
                  children: (_examCategories as List).map((category) {
                    return ExamCategoryCardWidget(
                      title: category["title"] as String,
                      imageUrl: category["imageUrl"] as String,
                      examCount: category["examCount"] as int,
                      completionPercentage:
                          category["completionPercentage"] as double,
                      onTap: () {
                        Navigator.pushNamed(
                            context, category["route"] as String);
                      },
                      onLongPress: () {
                        _showQuickActions(category["title"] as String);
                      },
                    );
                  }).toList(),
                ),
              ),

              // Current Affairs Banner (AI-Generated)
              SliverToBoxAdapter(
                child: _isLoadingCurrentAffairs
                    ? Container(
                        height: 20.h,
                        margin: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.lightTheme.colorScheme.primary,
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Generating Today\'s Current Affairs...',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : CurrentAffairsBannerWidget(
                        title: _currentAffairs["title"] as String,
                        content: _currentAffairs["content"] as String,
                        date: _currentAffairs["date"] as String,
                        onTap: () {
                          // Handle current affairs tap
                        },
                      ),
              ),

              // Study Streak
              SliverToBoxAdapter(
                child: StudyStreakWidget(
                  streakDays: _studyStreak["streakDays"] as int,
                  totalStudyHours: _studyStreak["totalStudyHours"] as int,
                  onTap: () {
                    // Handle study streak tap
                  },
                ),
              ),

              // Recent Activities Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    children: [
                      Text(
                        "Recent Activity",
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // Handle view all tap
                        },
                        child: Text(
                          "View All",
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Recent Activities
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final activity = _recentActivities[index];
                    return RecentActivityCardWidget(
                      title: activity["title"] as String,
                      subtitle: activity["subtitle"] as String,
                      iconName: activity["iconName"] as String,
                      iconColor: activity["iconColor"] as Color,
                      timeAgo: activity["timeAgo"] as String,
                      onTap: () {
                        Navigator.pushNamed(
                            context, activity["route"] as String);
                      },
                    );
                  },
                  childCount: _recentActivities.length,
                ),
              ),

              // Bottom spacing
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          selectedLabelStyle:
              AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium,
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'psychology',
                color: _selectedTabIndex == 0
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: "AI Doubt",
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'quiz',
                color: _selectedTabIndex == 1
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: "Test",
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'book',
                color: _selectedTabIndex == 2
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: "Revision",
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'person',
                color: _selectedTabIndex == 3
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/test-interface');
        },
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'flash_on',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 20,
        ),
        label: Text(
          "Quick Test",
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

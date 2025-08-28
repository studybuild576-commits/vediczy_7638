
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/edit_profile_bottom_sheet_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_menu_item_widget.dart';
import './widgets/profile_stats_widget.dart';

class ProfileManagement extends StatefulWidget {
  const ProfileManagement({Key? key}) : super(key: key);

  @override
  State<ProfileManagement> createState() => _ProfileManagementState();
}

class _ProfileManagementState extends State<ProfileManagement> {
  final ImagePicker _imagePicker = ImagePicker();

  // User profile data
  Map<String, dynamic> _userProfile = {
    'name': 'Rahul Kumar',
    'email': 'rahul.kumar@example.com',
    'phone': '+91 9876543210',
    'profileImage': null,
    'examTarget': 'SSC CGL',
    'joinDate': '2024-01-15',
    'location': 'New Delhi, India',
    'studyGoal': 'Clear SSC CGL 2024',
  };

  Map<String, int> _userStats = {
    'testsAttempted': 45,
    'questionsAnswered': 2340,
    'studyHours': 127,
    'currentStreak': 15,
    'averageScore': 78,
    'rank': 1250,
  };

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _userProfile = {
        'name': prefs.getString('user_name') ?? 'Rahul Kumar',
        'email': prefs.getString('user_email') ?? 'rahul.kumar@example.com',
        'phone': prefs.getString('user_phone') ?? '+91 9876543210',
        'profileImage': prefs.getString('user_profile_image'),
        'examTarget': prefs.getString('user_exam_target') ?? 'SSC CGL',
        'joinDate': prefs.getString('user_join_date') ?? '2024-01-15',
        'location': prefs.getString('user_location') ?? 'New Delhi, India',
        'studyGoal': prefs.getString('user_study_goal') ?? 'Clear SSC CGL 2024',
      };

      _userStats = {
        'testsAttempted': prefs.getInt('user_tests_attempted') ?? 45,
        'questionsAnswered': prefs.getInt('user_questions_answered') ?? 2340,
        'studyHours': prefs.getInt('user_study_hours') ?? 127,
        'currentStreak': prefs.getInt('user_current_streak') ?? 15,
        'averageScore': prefs.getInt('user_average_score') ?? 78,
        'rank': prefs.getInt('user_rank') ?? 1250,
      };
    });
  }

  Future<void> _saveUserProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_name', _userProfile['name'] ?? '');
    await prefs.setString('user_email', _userProfile['email'] ?? '');
    await prefs.setString('user_phone', _userProfile['phone'] ?? '');
    await prefs.setString(
        'user_profile_image', _userProfile['profileImage'] ?? '');
    await prefs.setString('user_exam_target', _userProfile['examTarget'] ?? '');
    await prefs.setString('user_join_date', _userProfile['joinDate'] ?? '');
    await prefs.setString('user_location', _userProfile['location'] ?? '');
    await prefs.setString('user_study_goal', _userProfile['studyGoal'] ?? '');
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _userProfile['profileImage'] = image.path;
        });
        await _saveUserProfile();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  void _showEditProfileBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileBottomSheetWidget(
        userProfile: _userProfile,
        onProfileUpdated: (updatedProfile) {
          setState(() {
            _userProfile = updatedProfile;
          });
          _saveUserProfile();
        },
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showEditProfileBottomSheet,
            icon: CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            ProfileHeaderWidget(
              name: _userProfile['name'] ?? 'User',
              email: _userProfile['email'] ?? '',
              profileImagePath: _userProfile['profileImage'],
              onImageTap: _pickProfileImage,
              examTarget: _userProfile['examTarget'] ?? 'Competitive Exams',
              joinDate: _userProfile['joinDate'] ?? '',
            ),

            SizedBox(height: 2.h),

            // Profile Stats
            ProfileStatsWidget(
              testsAttempted: _userStats['testsAttempted'] ?? 0,
              averageScore: _userStats['averageScore'] ?? 0,
              studyHours: _userStats['studyHours'] ?? 0,
              currentStreak: _userStats['currentStreak'] ?? 0,
            ),

            SizedBox(height: 3.h),

            // Menu Items
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
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
                  ProfileMenuItemWidget(
                    iconName: 'quiz',
                    title: 'Test Results',
                    subtitle: 'View your test performance',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.testResults),
                  ),
                  const Divider(height: 1),
                  ProfileMenuItemWidget(
                    iconName: 'analytics',
                    title: 'Study Analytics',
                    subtitle: 'Track your progress',
                    onTap: () {
                      _showSuccessSnackBar(
                          'Study Analytics feature coming soon!');
                    },
                  ),
                  const Divider(height: 1),
                  ProfileMenuItemWidget(
                    iconName: 'bookmark',
                    title: 'Saved Questions',
                    subtitle: 'Your bookmarked questions',
                    onTap: () {
                      _showSuccessSnackBar(
                          'Saved Questions feature coming soon!');
                    },
                  ),
                  const Divider(height: 1),
                  ProfileMenuItemWidget(
                    iconName: 'download',
                    title: 'Downloads',
                    subtitle: 'Downloaded content',
                    onTap: () {
                      _showSuccessSnackBar('Downloads feature coming soon!');
                    },
                  ),
                  const Divider(height: 1),
                  ProfileMenuItemWidget(
                    iconName: 'settings',
                    title: 'Settings',
                    subtitle: 'App preferences',
                    onTap: () {
                      _showSuccessSnackBar('Settings feature coming soon!');
                    },
                  ),
                  const Divider(height: 1),
                  ProfileMenuItemWidget(
                    iconName: 'help',
                    title: 'Help & Support',
                    subtitle: 'Get assistance',
                    onTap: () {
                      _showSuccessSnackBar(
                          'Help & Support feature coming soon!');
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // Logout Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showSuccessSnackBar('Logout successful!');
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'logout',
                  color: Colors.red,
                  size: 20,
                ),
                label: Text(
                  'Logout',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}

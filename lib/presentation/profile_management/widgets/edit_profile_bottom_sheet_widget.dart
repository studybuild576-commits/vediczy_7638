import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EditProfileBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  final Function(Map<String, dynamic>) onProfileUpdated;

  const EditProfileBottomSheetWidget({
    Key? key,
    required this.userProfile,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  State<EditProfileBottomSheetWidget> createState() =>
      _EditProfileBottomSheetWidgetState();
}

class _EditProfileBottomSheetWidgetState
    extends State<EditProfileBottomSheetWidget> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _studyGoalController;

  String _selectedExamTarget = 'SSC CGL';
  final List<String> _examTargets = [
    'SSC CGL',
    'SSC CHSL',
    'Railway NTPC',
    'Railway Group D',
    'IBPS PO',
    'IBPS Clerk',
    'SBI PO',
    'SBI Clerk',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile['name']);
    _emailController = TextEditingController(text: widget.userProfile['email']);
    _phoneController = TextEditingController(text: widget.userProfile['phone']);
    _locationController =
        TextEditingController(text: widget.userProfile['location']);
    _studyGoalController =
        TextEditingController(text: widget.userProfile['studyGoal']);
    _selectedExamTarget = widget.userProfile['examTarget'] ?? 'SSC CGL';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _studyGoalController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updatedProfile = Map<String, dynamic>.from(widget.userProfile);
    updatedProfile.addAll({
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'location': _locationController.text.trim(),
      'studyGoal': _studyGoalController.text.trim(),
      'examTarget': _selectedExamTarget,
    });

    widget.onProfileUpdated(updatedProfile);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Edit Profile',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  SizedBox(height: 2.h),

                  // Name Field
                  _buildTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    iconName: 'person',
                  ),

                  SizedBox(height: 2.h),

                  // Email Field
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    iconName: 'email',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: 2.h),

                  // Phone Field
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    iconName: 'phone',
                    keyboardType: TextInputType.phone,
                  ),

                  SizedBox(height: 2.h),

                  // Location Field
                  _buildTextField(
                    controller: _locationController,
                    label: 'Location',
                    iconName: 'location_on',
                  ),

                  SizedBox(height: 2.h),

                  // Exam Target Dropdown
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedExamTarget,
                      decoration: InputDecoration(
                        labelText: 'Target Exam',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'quiz',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                      ),
                      items: _examTargets.map((exam) {
                        return DropdownMenuItem(
                          value: exam,
                          child: Text(exam),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedExamTarget = value ?? 'SSC CGL';
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Study Goal Field
                  _buildTextField(
                    controller: _studyGoalController,
                    label: 'Study Goal',
                    iconName: 'flag',
                    maxLines: 2,
                  ),

                  SizedBox(height: 4.h),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save Changes',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String iconName,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppTheme.lightTheme.colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      ),
    );
  }
}

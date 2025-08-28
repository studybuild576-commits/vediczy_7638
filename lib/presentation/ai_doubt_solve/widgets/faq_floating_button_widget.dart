import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FaqFloatingButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const FaqFloatingButtonWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showFaqBottomSheet(context),
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
      elevation: 4.0,
      icon: CustomIconWidget(
        iconName: 'help_outline',
        color: AppTheme.lightTheme.colorScheme.onTertiary,
        size: 5.w,
      ),
      label: Text(
        'FAQ',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onTertiary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showFaqBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(0.25.h),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Frequently Asked Questions',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: _faqData.length,
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemBuilder: (context, index) {
                    final faq = _faqData[index];
                    return _buildFaqItem(
                      question: faq['question'] as String,
                      answer: faq['answer'] as String,
                      onTap: () {
                        Navigator.pop(context);
                        onTap();
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  answer,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 2.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onTap,
                    child: Text('Ask this question'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static final List<Map<String, dynamic>> _faqData = [
    {
      "question": "How do I solve quadratic equations?",
      "answer":
          "Quadratic equations can be solved using the quadratic formula: x = (-b ± √(b²-4ac)) / 2a, where ax² + bx + c = 0. You can also use factoring or completing the square methods."
    },
    {
      "question": "What are the important topics for SSC CGL Maths?",
      "answer":
          "Key topics include Arithmetic (percentage, profit & loss, time & work), Algebra (equations, graphs), Geometry (triangles, circles), Trigonometry, and Statistics. Focus on speed and accuracy."
    },
    {
      "question": "How to prepare for Railway Group D exam?",
      "answer":
          "Cover Mathematics (basic arithmetic), General Science (physics, chemistry, biology), General Intelligence & Reasoning, and General Awareness. Practice previous year questions regularly."
    },
    {
      "question":
          "What is the best strategy for time management in competitive exams?",
      "answer":
          "Practice mock tests regularly, identify your strong and weak areas, allocate time based on marks weightage, and always attempt easier questions first to maximize your score."
    },
    {
      "question": "How can I improve my English for competitive exams?",
      "answer":
          "Read newspapers daily, practice vocabulary, focus on grammar rules, solve comprehension passages, and practice previous year questions. Regular reading improves both speed and accuracy."
    },
    {
      "question": "What are the important current affairs topics?",
      "answer":
          "Focus on national and international news, government schemes, sports, awards, books & authors, important days, and economic developments from the last 6-12 months."
    }
  ];
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/chat_message_widget.dart';
import './widgets/faq_floating_button_widget.dart';
import './widgets/input_section_widget.dart';

class AiDoubtSolve extends StatefulWidget {
  const AiDoubtSolve({Key? key}) : super(key: key);

  @override
  State<AiDoubtSolve> createState() => _AiDoubtSolveState();
}

class _AiDoubtSolveState extends State<AiDoubtSolve> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialMessages() {
    final initialMessages = [
      {
        "id": 1,
        "content":
            "Hello! I'm your AI Doubt Solver. I'm here to help you with your competitive exam preparation. You can ask me questions about SSC, Railway exams, or any study-related doubts. Feel free to type your question or upload an image of the problem you're facing.",
        "isUser": false,
        "timestamp": DateTime.now().subtract(Duration(minutes: 5)),
        "isLoading": false,
      }
    ];

    setState(() {
      _messages.addAll(initialMessages);
    });
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    final userMessage = {
      "id": _messages.length + 1,
      "content": _textController.text.trim(),
      "isUser": true,
      "timestamp": DateTime.now(),
      "isLoading": false,
    };

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _textController.clear();
    _scrollToBottom();
    _simulateAiResponse(userMessage['content'] as String);
  }

  void _simulateAiResponse(String userQuery) {
    // Add loading message
    final loadingMessage = {
      "id": _messages.length + 1,
      "content": "",
      "isUser": false,
      "timestamp": DateTime.now(),
      "isLoading": true,
    };

    setState(() {
      _messages.add(loadingMessage);
    });

    _scrollToBottom();

    // Simulate AI processing time
    Future.delayed(Duration(seconds: 2), () {
      final aiResponse = _generateAiResponse(userQuery);

      setState(() {
        _messages.removeLast(); // Remove loading message
        _messages.add({
          "id": _messages.length + 1,
          "content": aiResponse,
          "isUser": false,
          "timestamp": DateTime.now(),
          "isLoading": false,
        });
        _isLoading = false;
      });

      _scrollToBottom();
    });
  }

  String _generateAiResponse(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('quadratic') || lowerQuery.contains('equation')) {
      return "To solve quadratic equations (ax² + bx + c = 0), you can use:\n\n1. **Quadratic Formula**: x = (-b ± √(b²-4ac)) / 2a\n\n2. **Factoring**: Find two numbers that multiply to 'ac' and add to 'b'\n\n3. **Completing the Square**: Rewrite as (x + p)² = q\n\nExample: x² - 5x + 6 = 0\nFactoring: (x-2)(x-3) = 0\nSolutions: x = 2 or x = 3\n\nWould you like me to solve a specific quadratic equation for you?";
    }

    if (lowerQuery.contains('ssc') ||
        lowerQuery.contains('cgl') ||
        lowerQuery.contains('chsl')) {
      return "**SSC Exam Preparation Tips:**\n\n📚 **Key Subjects:**\n• Quantitative Aptitude (25-30%)\n• English Language (20-25%)\n• General Intelligence & Reasoning (25%)\n• General Awareness (20-25%)\n\n⏰ **Study Strategy:**\n• Practice 2-3 hours daily\n• Solve previous year papers\n• Take mock tests regularly\n• Focus on speed and accuracy\n\n🎯 **Important Topics:**\n• Arithmetic: Percentage, Profit & Loss\n• Algebra: Linear equations\n• Geometry: Triangles, Circles\n• Current Affairs: Last 6 months\n\nNeed help with any specific SSC topic?";
    }

    if (lowerQuery.contains('railway') ||
        lowerQuery.contains('rrb') ||
        lowerQuery.contains('ntpc')) {
      return "**Railway Exam Preparation Guide:**\n\n🚂 **Major Railway Exams:**\n• RRB NTPC (Non-Technical Popular Categories)\n• RRB Group D (Track Maintainer, Helper)\n• RRB JE (Junior Engineer)\n• RRB ALP (Assistant Loco Pilot)\n\n📖 **Common Syllabus:**\n• Mathematics (30-35 questions)\n• General Science (25-30 questions)\n• General Intelligence & Reasoning (30 questions)\n• General Awareness (40 questions)\n\n💡 **Preparation Tips:**\n• Focus on basic concepts\n• Practice numerical problems\n• Stay updated with current affairs\n• Solve mock tests\n\nWhich Railway exam are you preparing for?";
    }

    if (lowerQuery.contains('percentage') ||
        lowerQuery.contains('profit') ||
        lowerQuery.contains('loss')) {
      return "**Percentage & Profit-Loss Concepts:**\n\n📊 **Basic Percentage Formula:**\n• Percentage = (Part/Whole) × 100\n• Increase% = [(New-Old)/Old] × 100\n• Decrease% = [(Old-New)/Old] × 100\n\n💰 **Profit & Loss Formulas:**\n• Profit = SP - CP\n• Loss = CP - SP\n• Profit% = (Profit/CP) × 100\n• Loss% = (Loss/CP) × 100\n• SP = CP × (100 ± Profit%)/100\n\n🔢 **Quick Tricks:**\n• 10% of any number: Move decimal one place left\n• 50% = Half, 25% = Quarter\n• Successive discounts: Use (100-d1)(100-d2)/100\n\nNeed help solving a specific problem?";
    }

    if (lowerQuery.contains('time') && lowerQuery.contains('work')) {
      return "**Time and Work Concepts:**\n\n⏱️ **Basic Formulas:**\n• Work = Rate × Time\n• If A can do work in 'n' days, A's rate = 1/n per day\n• Combined rate = Sum of individual rates\n\n👥 **Multiple Workers:**\n• A and B together: 1/A + 1/B = 1/Combined\n• Time for combined work = 1/(1/A + 1/B)\n\n📝 **Example:**\nA can complete work in 10 days, B in 15 days\nA's rate = 1/10 per day\nB's rate = 1/15 per day\nCombined rate = 1/10 + 1/15 = 5/30 = 1/6\nTogether they finish in 6 days\n\n🎯 **Quick Method:**\nTime together = (A × B)/(A + B)\n= (10 × 15)/(10 + 15) = 150/25 = 6 days\n\nWant to practice more problems?";
    }

    if (lowerQuery.contains('current affairs') ||
        lowerQuery.contains('gk') ||
        lowerQuery.contains('general knowledge')) {
      return "**Current Affairs Study Strategy:**\n\n📰 **Daily Sources:**\n• The Hindu, Indian Express newspapers\n• PIB (Press Information Bureau)\n• Government official websites\n• Monthly current affairs magazines\n\n🏛️ **Important Categories:**\n• National & International News\n• Government Schemes & Policies\n• Sports & Awards\n• Books & Authors\n• Important Days & Dates\n• Economic Developments\n\n📅 **Time Frame:**\n• Last 6 months for most exams\n• Last 12 months for major events\n• Static GK: Always relevant\n\n💡 **Study Tips:**\n• Make monthly notes\n• Practice MCQs daily\n• Connect events with dates\n• Focus on government initiatives\n\nNeed updates on any specific current affairs topic?";
    }

    // Default response for general queries
    return "I understand you're asking about: \"" +
        query +
        "\"\n\nI'm here to help with your competitive exam preparation! I can assist you with:\n\n📚 **Subjects:**\n• Mathematics & Quantitative Aptitude\n• English Language & Comprehension\n• General Intelligence & Reasoning\n• General Awareness & Current Affairs\n• General Science\n\n🎯 **Exam Preparation:**\n• SSC (CGL, CHSL, MTS, CPO, JE)\n• Railway (RRB NTPC, Group D, JE, ALP)\n• Study strategies and time management\n• Previous year question analysis\n\n💡 **How I can help:**\n• Solve mathematical problems step-by-step\n• Explain concepts with examples\n• Provide study tips and strategies\n• Share important formulas and shortcuts\n\nPlease ask me a more specific question, and I'll provide detailed help!";
  }

  void _handleImageSelected(String imagePath) {
    final imageMessage = {
      "id": _messages.length + 1,
      "content":
          "I've uploaded an image with my doubt. Can you help me solve this problem?",
      "isUser": true,
      "timestamp": DateTime.now(),
      "imageUrl": imagePath,
      "isLoading": false,
    };

    setState(() {
      _messages.add(imageMessage);
    });

    _scrollToBottom();
    _simulateImageAnalysis();
  }

  void _simulateImageAnalysis() {
    final loadingMessage = {
      "id": _messages.length + 1,
      "content": "",
      "isUser": false,
      "timestamp": DateTime.now(),
      "isLoading": true,
    };

    setState(() {
      _messages.add(loadingMessage);
    });

    _scrollToBottom();

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _messages.removeLast();
        _messages.add({
          "id": _messages.length + 1,
          "content":
              "I can see the image you've uploaded! 📸\n\nBased on the mathematical problem in your image, here's how to solve it:\n\n**Step-by-step Solution:**\n\n1️⃣ **Identify the problem type**: This appears to be a quadratic equation problem\n\n2️⃣ **Given information**: \n• Equation: x² - 7x + 12 = 0\n\n3️⃣ **Solution method**: Using factoring\n• Find two numbers that multiply to 12 and add to -7\n• Those numbers are -3 and -4\n• So: (x - 3)(x - 4) = 0\n\n4️⃣ **Final answer**: x = 3 or x = 4\n\n✅ **Verification**: \n• For x = 3: 3² - 7(3) + 12 = 9 - 21 + 12 = 0 ✓\n• For x = 4: 4² - 7(4) + 12 = 16 - 28 + 12 = 0 ✓\n\nWould you like me to explain any specific step in more detail?",
          "isUser": false,
          "timestamp": DateTime.now(),
          "isLoading": false,
        });
      });

      _scrollToBottom();
    });
  }

  void _handleVoiceRecorded(String audioPath) {
    final voiceMessage = {
      "id": _messages.length + 1,
      "content":
          "🎤 Voice message: \"How do I solve problems related to compound interest for competitive exams?\"",
      "isUser": true,
      "timestamp": DateTime.now(),
      "isLoading": false,
    };

    setState(() {
      _messages.add(voiceMessage);
    });

    _scrollToBottom();
    _simulateAiResponse("compound interest competitive exams");
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _refreshMessages() async {
    await Future.delayed(Duration(seconds: 1));
    // In a real app, this would load previous conversations from server
    setState(() {
      // Add some historical messages
      _messages.insertAll(0, [
        {
          "id": 0,
          "content":
              "Previous conversation loaded. You asked about time and distance problems yesterday.",
          "isUser": false,
          "timestamp": DateTime.now().subtract(Duration(days: 1)),
          "isLoading": false,
        }
      ]);
    });
  }

  void _handleFaqTap() {
    // This will be called when user taps on FAQ questions
    _textController.text = "How do I solve quadratic equations?";
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'AI Doubt Solver',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to AI preferences/settings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('AI Settings - Coming Soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshMessages,
              color: AppTheme.lightTheme.primaryColor,
              child: _messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return ChatMessageWidget(
                          message: message,
                          onCopy: () {
                            // Copy functionality handled in widget
                          },
                          onShare: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Share functionality - Coming Soon!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          onSave: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Saved to favorites!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          onReport: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Issue reported. Thank you!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
          InputSectionWidget(
            textController: _textController,
            onSendMessage: _sendMessage,
            onImageSelected: _handleImageSelected,
            onVoiceRecorded: _handleVoiceRecorded,
          ),
        ],
      ),
      floatingActionButton: FaqFloatingButtonWidget(
        onTap: _handleFaqTap,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: CustomIconWidget(
              iconName: 'smart_toy',
              color: AppTheme.lightTheme.primaryColor,
              size: 10.w,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'AI Doubt Solver',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              'Ask me anything about your competitive exam preparation. I can help with Math, English, Reasoning, and General Knowledge.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 4.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: [
              _buildSuggestionChip('Solve Math Problem'),
              _buildSuggestionChip('SSC Preparation'),
              _buildSuggestionChip('Railway Exam Tips'),
              _buildSuggestionChip('Current Affairs'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () {
        _textController.text = text;
        _sendMessage();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1, // AI Doubt Solve is at index 1
      selectedItemColor: AppTheme.lightTheme.primaryColor,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 8.0,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'dashboard',
            color: AppTheme.lightTheme.primaryColor,
            size: 6.w,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'smart_toy',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'smart_toy',
            color: AppTheme.lightTheme.primaryColor,
            size: 6.w,
          ),
          label: 'AI Doubt',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'quiz',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'quiz',
            color: AppTheme.lightTheme.primaryColor,
            size: 6.w,
          ),
          label: 'Test',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'book',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'book',
            color: AppTheme.lightTheme.primaryColor,
            size: 6.w,
          ),
          label: 'Revision',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'person',
            color: AppTheme.lightTheme.primaryColor,
            size: 6.w,
          ),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/dashboard');
            break;
          case 1:
            // Already on AI Doubt Solve screen
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/test-interface');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/revision-module');
            break;
          case 4:
            // Profile navigation would be implemented
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Profile - Coming Soon!'),
                duration: Duration(seconds: 2),
              ),
            );
            break;
        }
      },
    );
  }
}

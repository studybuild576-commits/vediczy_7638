import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/navigation_controls_widget.dart';
import './widgets/question_display_widget.dart';
import './widgets/question_palette_widget.dart';
import './widgets/test_instructions_overlay_widget.dart';
import './widgets/test_timer_widget.dart';

class TestInterface extends StatefulWidget {
  const TestInterface({super.key});

  @override
  State<TestInterface> createState() => _TestInterfaceState();
}

class _TestInterfaceState extends State<TestInterface>
    with TickerProviderStateMixin {
  // Test data
  late List<Map<String, dynamic>> _questions;
  late Map<int, int> _selectedAnswers;
  late List<int> _attemptedQuestions;
  late List<int> _markedQuestions;

  // Test state
  int _currentQuestionIndex = 0;
  late Duration _remainingTime;
  late Duration _totalTime;
  Timer? _timer;
  bool _showInstructions = false;
  bool _showQuestionPalette = false;

  // Page controller for swipe navigation
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _initializeTest();
    _startTimer();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _initializeTest() {
    // Mock test data
    _questions = [
      {
        "id": 1,
        "question": "What is the capital of India?",
        "options": ["Mumbai", "New Delhi", "Kolkata", "Chennai"],
        "correctAnswer": 1,
        "subject": "General Knowledge"
      },
      {
        "id": 2,
        "question":
            "Which of the following is the largest planet in our solar system?",
        "options": ["Earth", "Mars", "Jupiter", "Saturn"],
        "correctAnswer": 2,
        "subject": "Science"
      },
      {
        "id": 3,
        "question": "The Indian Constitution was adopted on which date?",
        "options": [
          "15th August 1947",
          "26th January 1950",
          "26th November 1949",
          "2nd October 1948"
        ],
        "correctAnswer": 2,
        "subject": "History"
      },
      {
        "id": 4,
        "question": "What is the square root of 144?",
        "options": ["10", "11", "12", "13"],
        "correctAnswer": 2,
        "subject": "Mathematics"
      },
      {
        "id": 5,
        "question": "Who wrote the national anthem of India?",
        "options": [
          "Rabindranath Tagore",
          "Bankim Chandra Chattopadhyay",
          "Sarojini Naidu",
          "Mahatma Gandhi"
        ],
        "correctAnswer": 0,
        "subject": "Literature"
      },
      {
        "id": 6,
        "question": "Which gas is most abundant in Earth's atmosphere?",
        "options": ["Oxygen", "Carbon Dioxide", "Nitrogen", "Hydrogen"],
        "correctAnswer": 2,
        "subject": "Science"
      },
      {
        "id": 7,
        "question": "The Quit India Movement was launched in which year?",
        "options": ["1940", "1942", "1944", "1946"],
        "correctAnswer": 1,
        "subject": "History"
      },
      {
        "id": 8,
        "question": "What is 15% of 200?",
        "options": ["25", "30", "35", "40"],
        "correctAnswer": 1,
        "subject": "Mathematics"
      },
      {
        "id": 9,
        "question": "Which river is known as the Ganga of the South?",
        "options": ["Krishna", "Godavari", "Kaveri", "Narmada"],
        "correctAnswer": 2,
        "subject": "Geography"
      },
      {
        "id": 10,
        "question":
            "The headquarters of the United Nations is located in which city?",
        "options": ["Geneva", "Paris", "New York", "London"],
        "correctAnswer": 2,
        "subject": "General Knowledge"
      }
    ];

    _selectedAnswers = {};
    _attemptedQuestions = [];
    _markedQuestions = [];
    _totalTime = Duration(hours: 2); // 2 hours test
    _remainingTime = _totalTime;
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        });
      } else {
        _submitTest();
      }
    });
  }

  void _selectAnswer(int optionIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = optionIndex;
      if (!_attemptedQuestions.contains(_currentQuestionIndex + 1)) {
        _attemptedQuestions.add(_currentQuestionIndex + 1);
      }
    });

    // Haptic feedback
    HapticFeedback.selectionClick();

    // Auto-save (in real app, this would save to local storage)
    _saveProgress();
  }

  void _saveProgress() {
    // In a real app, this would save to local storage or send to server
    // For now, we'll just print the progress
    debugPrint('Progress saved: ${_selectedAnswers.length} questions answered');
  }

  void _navigateToQuestion(int questionNumber) {
    final index = questionNumber - 1;
    if (index >= 0 && index < _questions.length) {
      setState(() {
        _currentQuestionIndex = index;
        _showQuestionPalette = false;
      });
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleMarkForReview() {
    setState(() {
      final questionNumber = _currentQuestionIndex + 1;
      if (_markedQuestions.contains(questionNumber)) {
        _markedQuestions.remove(questionNumber);
      } else {
        _markedQuestions.add(questionNumber);
      }
    });
    HapticFeedback.lightImpact();
  }

  void _submitTest() {
    _timer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Submit Test'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to submit the test?'),
            SizedBox(height: 2.h),
            Text(
                'Attempted: ${_attemptedQuestions.length}/${_questions.length}'),
            Text('Marked for Review: ${_markedQuestions.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startTimer(); // Resume timer
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showTestResults();
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showTestResults() {
    int correctAnswers = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i]['correctAnswer']) {
        correctAnswers++;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Test Completed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your Score: $correctAnswers/${_questions.length}'),
            Text(
                'Percentage: ${((correctAnswers / _questions.length) * 100).toStringAsFixed(1)}%'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            child: Text('Back to Dashboard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Timer header
                TestTimerWidget(
                  remainingTime: _remainingTime,
                  totalTime: _totalTime,
                ),

                // Question counter and instructions button
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _showInstructions = true;
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: 'info_outline',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        label: Text('Instructions'),
                      ),
                    ],
                  ),
                ),

                // Question content
                Expanded(
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      // Handle swipe gestures
                      if (details.delta.dx > 10) {
                        // Swipe right - previous question
                        if (_currentQuestionIndex > 0) {
                          _previousQuestion();
                        }
                      } else if (details.delta.dx < -10) {
                        // Swipe left - next question
                        if (_currentQuestionIndex < _questions.length - 1) {
                          _nextQuestion();
                        }
                      }
                    },
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentQuestionIndex = index;
                        });
                      },
                      itemCount: _questions.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: QuestionDisplayWidget(
                            question: _questions[index],
                            selectedOption: _selectedAnswers[index],
                            onOptionSelected: _selectAnswer,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Navigation controls
                NavigationControlsWidget(
                  canGoPrevious: _currentQuestionIndex > 0,
                  canGoNext: _currentQuestionIndex < _questions.length - 1,
                  isMarkedForReview:
                      _markedQuestions.contains(_currentQuestionIndex + 1),
                  onPrevious: _previousQuestion,
                  onNext: _nextQuestion,
                  onMarkForReview: _toggleMarkForReview,
                  onSubmitTest: _submitTest,
                  isLastQuestion:
                      _currentQuestionIndex == _questions.length - 1,
                ),
              ],
            ),

            // Question palette overlay
            if (_showQuestionPalette)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showQuestionPalette = false;
                  });
                },
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: QuestionPaletteWidget(
                      totalQuestions: _questions.length,
                      currentQuestion: _currentQuestionIndex + 1,
                      attemptedQuestions: _attemptedQuestions,
                      markedQuestions: _markedQuestions,
                      onQuestionTap: _navigateToQuestion,
                      onClose: () {
                        setState(() {
                          _showQuestionPalette = false;
                        });
                      },
                    ),
                  ),
                ),
              ),

            // Instructions overlay
            if (_showInstructions)
              TestInstructionsOverlayWidget(
                onClose: () {
                  setState(() {
                    _showInstructions = false;
                  });
                },
                remainingTime: _remainingTime,
                totalQuestions: _questions.length,
                attemptedQuestions: _attemptedQuestions.length,
              ),
          ],
        ),
      ),

      // Floating action button for question palette
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showQuestionPalette = true;
          });
        },
        child: CustomIconWidget(
          iconName: 'grid_view',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
        tooltip: 'Question Palette',
      ),
    );
  }
}

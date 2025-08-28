import 'package:dio/dio.dart';

class OpenAIService {
  static final OpenAIService _instance = OpenAIService._internal();
  late final Dio _dio;
  static const String apiKey = String.fromEnvironment('OPENAI_API_KEY');

  // Factory constructor to return the singleton instance
  factory OpenAIService() {
    return _instance;
  }

  // Private constructor for singleton pattern
  OpenAIService._internal() {
    _initializeService();
  }

  void _initializeService() {
    // Load API key from environment variables
    if (apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY must be provided via --dart-define');
    }

    // Configure Dio with base URL and headers
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.openai.com/v1',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
      ),
    );
  }

  Dio get dio => _dio;
}

class OpenAIClient {
  final Dio dio;

  OpenAIClient(this.dio);

  /// Generates a text response for current affairs
  Future<Completion> createChatCompletion({
    required List<Message> messages,
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async {
    try {
      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages
              .map((m) => {
                    'role': m.role,
                    'content': m.content,
                  })
              .toList(),
          if (options != null) ...options,
        },
      );
      final text = response.data['choices'][0]['message']['content'];
      return Completion(text: text);
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// Generates daily current affairs content
  Future<CurrentAffairsItem> generateDailyCurrentAffairs() async {
    try {
      final messages = [
        Message(
          role: 'user',
          content:
              '''Generate today's current affairs for competitive exam preparation in India. 
          Please provide:
          1. A catchy headline (max 60 characters)
          2. Content summary for exam relevance (200-250 words)
          3. Focus on topics like: Government policies, Economic updates, International relations, Science & Technology, Sports achievements, Important appointments
          
          Format the response as educational content suitable for SSC, Railway, and other competitive exams.
          Make it factual, concise, and exam-oriented.''',
        ),
      ];

      final response = await createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.7},
      );

      // Parse the response to extract title and content
      final text = response.text;
      final lines =
          text.split('\n').where((line) => line.trim().isNotEmpty).toList();

      String title = "Today's Current Affairs Update";
      String content = text;

      // Try to extract title from first meaningful line
      if (lines.isNotEmpty) {
        final firstLine = lines.first.trim();
        if (firstLine.length <= 80 && !firstLine.contains('.')) {
          title = firstLine.replaceAll(RegExp(r'^[#*\-\d\.]+\s*'), '');
          content = lines.skip(1).join('\n').trim();
        }
      }

      final now = DateTime.now();
      final date =
          "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";

      return CurrentAffairsItem(
        title: title,
        content: content.isEmpty ? text : content,
        date: date,
        timestamp: now,
      );
    } on OpenAIException {
      rethrow;
    } catch (e) {
      throw OpenAIException(
        statusCode: 500,
        message: 'Failed to generate current affairs: $e',
      );
    }
  }
}

// Support classes
class Message {
  final String role;
  final dynamic content;

  Message({required this.role, required this.content});
}

class Completion {
  final String text;

  Completion({required this.text});
}

class CurrentAffairsItem {
  final String title;
  final String content;
  final String date;
  final DateTime timestamp;

  CurrentAffairsItem({
    required this.title,
    required this.content,
    required this.date,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'date': date,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  factory CurrentAffairsItem.fromJson(Map<String, dynamic> json) =>
      CurrentAffairsItem(
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        date: json['date'] ?? '',
        timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] ?? 0),
      );
}

class OpenAIException implements Exception {
  final int statusCode;
  final String message;

  OpenAIException({required this.statusCode, required this.message});

  @override
  String toString() => 'OpenAIException: $statusCode - $message';
}

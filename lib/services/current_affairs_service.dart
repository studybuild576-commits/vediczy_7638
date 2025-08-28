import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import './openai_service.dart';

class CurrentAffairsService {
  static const String _currentAffairsKey = 'daily_current_affairs';
  static const String _lastUpdateKey = 'current_affairs_last_update';

  final OpenAIClient _openAIClient = OpenAIClient(OpenAIService().dio);

  /// Get current affairs with automatic daily refresh
  Future<CurrentAffairsItem> getCurrentAffairs() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if we need to update (daily refresh)
    final lastUpdate = prefs.getString(_lastUpdateKey);
    final today =
        DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD format

    if (lastUpdate != today) {
      // Generate new content
      try {
        final newContent = await _openAIClient.generateDailyCurrentAffairs();
        await _saveCurrentAffairs(newContent);
        return newContent;
      } catch (e) {
        // If API fails, try to return cached content or fallback
        final cached = await _getCachedCurrentAffairs();
        return cached ?? _getFallbackCurrentAffairs();
      }
    }

    // Return cached content if updated today
    final cached = await _getCachedCurrentAffairs();
    return cached ?? _getFallbackCurrentAffairs();
  }

  /// Manually refresh current affairs
  Future<CurrentAffairsItem> refreshCurrentAffairs() async {
    try {
      final newContent = await _openAIClient.generateDailyCurrentAffairs();
      await _saveCurrentAffairs(newContent);
      return newContent;
    } catch (e) {
      final cached = await _getCachedCurrentAffairs();
      return cached ?? _getFallbackCurrentAffairs();
    }
  }

  /// Save current affairs to local storage
  Future<void> _saveCurrentAffairs(CurrentAffairsItem item) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentAffairsKey, json.encode(item.toJson()));
    await prefs.setString(
        _lastUpdateKey, DateTime.now().toIso8601String().substring(0, 10));
  }

  /// Get cached current affairs
  Future<CurrentAffairsItem?> _getCachedCurrentAffairs() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedJson = prefs.getString(_currentAffairsKey);

    if (cachedJson != null) {
      try {
        final data = json.decode(cachedJson) as Map<String, dynamic>;
        return CurrentAffairsItem.fromJson(data);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Fallback content when API is unavailable
  CurrentAffairsItem _getFallbackCurrentAffairs() {
    final now = DateTime.now();
    final date =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";

    return CurrentAffairsItem(
      title: "Current Affairs Update",
      content:
          "Stay updated with the latest current affairs for competitive exams. Daily content is generated using AI to keep you informed about important events, government policies, and developments relevant for your exam preparation.",
      date: date,
      timestamp: now,
    );
  }
}

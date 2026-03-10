/// App-wide constants for Solo Leveling Fitness App
class AppConstants {
  // ═══════════════════════════════════════════════════
  // App Info
  // ═══════════════════════════════════════════════════
  static const String appName = 'Solo Leveling Fitness';
  static const String appVersion = '1.0.0';

  // ═══════════════════════════════════════════════════
  // Quest Constants
  // ═══════════════════════════════════════════════════
  static const double dailyRunningTarget = 10.0; // 10 km
  static const int dailyPushupsTarget = 100;     // 100 push-ups
  static const int dailySitupsTarget = 100;      // 100 sit-ups

  // ═══════════════════════════════════════════════════
  // XP & Rewards
  // ═══════════════════════════════════════════════════
  static const int runningQuestXP = 100;
  static const int pushupsQuestXP = 50;
  static const int situpsQuestXP = 50;

  static const int runningQuestGold = 50;
  static const int pushupsQuestGold = 25;
  static const int situpsQuestGold = 25;

  // ═══════════════════════════════════════════════════
  // Leveling System
  // ═══════════════════════════════════════════════════
  static const int baseXPPerLevel = 100;
  static const double xpMultiplier = 1.5; // Each level requires 1.5x more XP

  /// Calculate XP required for a specific level
  static int xpRequiredForLevel(int level) {
    if (level <= 1) return 0;
    return (baseXPPerLevel * (level - 1) * xpMultiplier).round();
  }

  /// Calculate total XP required to reach a level from level 1
  static int totalXPForLevel(int level) {
    int total = 0;
    for (int i = 2; i <= level; i++) {
      total += xpRequiredForLevel(i);
    }
    return total;
  }

  /// Calculate current level from total XP
  static int levelFromXP(int totalXP) {
    int level = 1;
    int xpNeeded = 0;

    while (totalXP >= xpNeeded) {
      level++;
      xpNeeded = totalXPForLevel(level);
    }

    return level - 1;
  }

  // ═══════════════════════════════════════════════════
  // Database
  // ═══════════════════════════════════════════════════
  static const String databaseName = 'solo_leveling.db';
  static const int databaseVersion = 1;

  // ═══════════════════════════════════════════════════
  // HealthKit
  // ═══════════════════════════════════════════════════
  static const Duration healthSyncInterval = Duration(minutes: 15);
  static const Duration healthDataLookback = Duration(days: 1);

  // ═══════════════════════════════════════════════════
  // Quest IDs (these should match database)
  // ═══════════════════════════════════════════════════
  static const String runningQuestId = 'quest_running_10km';
  static const String pushupsQuestId = 'quest_pushups_100';
  static const String situpsQuestId = 'quest_situps_100';

  // ═══════════════════════════════════════════════════
  // Animation Durations
  // ═══════════════════════════════════════════════════
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 600);
  static const Duration longAnimationDuration = Duration(milliseconds: 1000);

  // ═══════════════════════════════════════════════════
  // UI Constants
  // ═══════════════════════════════════════════════════
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 20.0;

  // ═══════════════════════════════════════════════════
  // Stat Increases Per Level
  // ═══════════════════════════════════════════════════
  static const int strengthPerLevel = 2;
  static const int agilityPerLevel = 2;
  static const int intelligencePerLevel = 1;
  static const int vitalityPerLevel = 3;
}

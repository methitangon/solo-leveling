import '../constants/app_constants.dart';

/// Helper class for XP and leveling calculations
class XPCalculator {
  /// Calculate XP required to reach next level from current level
  static int xpForNextLevel(int currentLevel) {
    return AppConstants.xpRequiredForLevel(currentLevel + 1);
  }

  /// Calculate total XP required to reach a specific level
  static int totalXPForLevel(int level) {
    return AppConstants.totalXPForLevel(level);
  }

  /// Calculate current level from total XP
  static int getCurrentLevel(int totalXP) {
    return AppConstants.levelFromXP(totalXP);
  }

  /// Calculate XP progress towards next level
  /// Returns a value between 0.0 and 1.0
  static double getProgressToNextLevel(int currentXP, int currentLevel) {
    final xpForCurrentLevel = totalXPForLevel(currentLevel);
    final xpForNextLevel = totalXPForLevel(currentLevel + 1);
    final xpNeededForNextLevel = xpForNextLevel - xpForCurrentLevel;

    if (xpNeededForNextLevel <= 0) return 1.0;

    final xpInCurrentLevel = currentXP - xpForCurrentLevel;
    final progress = xpInCurrentLevel / xpNeededForNextLevel;

    return progress.clamp(0.0, 1.0);
  }

  /// Calculate XP remaining to next level
  static int xpRemainingToNextLevel(int currentXP, int currentLevel) {
    final xpForNextLevel = totalXPForLevel(currentLevel + 1);
    final remaining = xpForNextLevel - currentXP;
    return remaining > 0 ? remaining : 0;
  }

  /// Check if XP gain will cause a level up
  static bool willLevelUp(int currentXP, int xpGain, int currentLevel) {
    final newTotalXP = currentXP + xpGain;
    final newLevel = getCurrentLevel(newTotalXP);
    return newLevel > currentLevel;
  }

  /// Calculate new level after XP gain
  static int getNewLevel(int currentXP, int xpGain) {
    final newTotalXP = currentXP + xpGain;
    return getCurrentLevel(newTotalXP);
  }

  /// Calculate how many levels gained from XP
  static int getLevelsGained(int currentXP, int xpGain, int currentLevel) {
    final newLevel = getNewLevel(currentXP, xpGain);
    return newLevel - currentLevel;
  }

  /// Calculate stat increases for leveling up
  static Map<String, int> getStatIncreases(int levelsGained) {
    return {
      'strength': AppConstants.strengthPerLevel * levelsGained,
      'agility': AppConstants.agilityPerLevel * levelsGained,
      'intelligence': AppConstants.intelligencePerLevel * levelsGained,
      'vitality': AppConstants.vitalityPerLevel * levelsGained,
    };
  }

  /// Format XP number with commas (e.g., 1,234,567)
  static String formatXP(int xp) {
    return xp.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  /// Get level title based on level
  static String getLevelTitle(int level) {
    if (level >= 100) return 'Shadow Monarch';
    if (level >= 75) return 'Nation-Level Hunter';
    if (level >= 50) return 'S-Rank Hunter';
    if (level >= 40) return 'A-Rank Hunter';
    if (level >= 30) return 'B-Rank Hunter';
    if (level >= 20) return 'C-Rank Hunter';
    if (level >= 10) return 'D-Rank Hunter';
    return 'E-Rank Hunter';
  }

  /// Get percentage to next level
  static int getPercentageToNextLevel(int currentXP, int currentLevel) {
    final progress = getProgressToNextLevel(currentXP, currentLevel);
    return (progress * 100).round();
  }
}

import 'package:equatable/equatable.dart';
import '../../../../core/utils/xp_calculator.dart';

/// Player entity - represents the user's character/stats
/// Pure Dart class with no Flutter dependencies
class Player extends Equatable {
  final String id;
  final String name;
  final int level;
  final int currentXP;
  final int totalXP;
  final int gold;
  final int strength;
  final int agility;
  final int intelligence;
  final int vitality;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Player({
    required this.id,
    required this.name,
    required this.level,
    required this.currentXP,
    required this.totalXP,
    required this.gold,
    required this.strength,
    required this.agility,
    required this.intelligence,
    required this.vitality,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get XP required for next level
  int get xpForNextLevel {
    return XPCalculator.xpForNextLevel(level);
  }

  /// Get XP progress to next level (0.0 - 1.0)
  double get xpProgressToNextLevel {
    return XPCalculator.getProgressToNextLevel(totalXP, level);
  }

  /// Get XP remaining to next level
  int get xpRemainingToNextLevel {
    return XPCalculator.xpRemainingToNextLevel(totalXP, level);
  }

  /// Get percentage to next level (0-100)
  int get percentageToNextLevel {
    return XPCalculator.getPercentageToNextLevel(totalXP, level);
  }

  /// Get level title (e.g., "S-Rank Hunter")
  String get levelTitle {
    return XPCalculator.getLevelTitle(level);
  }

  /// Get total combat power (sum of all stats)
  int get combatPower {
    return strength + agility + intelligence + vitality;
  }

  /// Add XP and return new player with updated level/stats
  Player addXP(int xp) {
    final newTotalXP = totalXP + xp;
    final newLevel = XPCalculator.getCurrentLevel(newTotalXP);
    final levelsGained = newLevel - level;

    if (levelsGained > 0) {
      // Player leveled up!
      final statIncreases = XPCalculator.getStatIncreases(levelsGained);

      return copyWith(
        level: newLevel,
        totalXP: newTotalXP,
        currentXP: newTotalXP,
        strength: strength + (statIncreases['strength'] ?? 0),
        agility: agility + (statIncreases['agility'] ?? 0),
        intelligence: intelligence + (statIncreases['intelligence'] ?? 0),
        vitality: vitality + (statIncreases['vitality'] ?? 0),
        updatedAt: DateTime.now(),
      );
    } else {
      // No level up, just add XP
      return copyWith(
        totalXP: newTotalXP,
        currentXP: newTotalXP,
        updatedAt: DateTime.now(),
      );
    }
  }

  /// Add gold
  Player addGold(int amount) {
    return copyWith(
      gold: gold + amount,
      updatedAt: DateTime.now(),
    );
  }

  /// Factory constructor for new player
  factory Player.newPlayer({
    required String id,
    required String name,
  }) {
    final now = DateTime.now();
    return Player(
      id: id,
      name: name,
      level: 1,
      currentXP: 0,
      totalXP: 0,
      gold: 0,
      strength: 10,
      agility: 10,
      intelligence: 10,
      vitality: 10,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Copy with updated values
  Player copyWith({
    String? id,
    String? name,
    int? level,
    int? currentXP,
    int? totalXP,
    int? gold,
    int? strength,
    int? agility,
    int? intelligence,
    int? vitality,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      currentXP: currentXP ?? this.currentXP,
      totalXP: totalXP ?? this.totalXP,
      gold: gold ?? this.gold,
      strength: strength ?? this.strength,
      agility: agility ?? this.agility,
      intelligence: intelligence ?? this.intelligence,
      vitality: vitality ?? this.vitality,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        level,
        currentXP,
        totalXP,
        gold,
        strength,
        agility,
        intelligence,
        vitality,
        createdAt,
        updatedAt,
      ];

  @override
  bool get stringify => true;
}

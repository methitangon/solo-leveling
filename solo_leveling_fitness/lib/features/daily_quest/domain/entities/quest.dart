import 'package:equatable/equatable.dart';

/// Quest types enum
enum QuestType {
  running('running', 'Run 10km'),
  pushups('pushups', 'Do 100 Push-ups'),
  situps('situps', 'Do 100 Sit-ups');

  final String value;
  final String displayName;

  const QuestType(this.value, this.displayName);

  static QuestType fromString(String value) {
    return QuestType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => QuestType.running,
    );
  }
}

/// Quest entity - represents a daily quest
/// This is a pure Dart class with no Flutter dependencies
class Quest extends Equatable {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final double targetValue;
  final double currentValue;
  final int xpReward;
  final int goldReward;
  final bool isCompleted;
  final DateTime? completedAt;

  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.currentValue,
    required this.xpReward,
    required this.goldReward,
    required this.isCompleted,
    this.completedAt,
  });

  /// Get progress percentage (0-100)
  double get progressPercentage {
    if (targetValue <= 0) return 0;
    return ((currentValue / targetValue) * 100).clamp(0, 100);
  }

  /// Get progress as decimal (0.0-1.0)
  double get progressDecimal {
    return progressPercentage / 100;
  }

  /// Check if quest can be completed
  bool get canComplete {
    return currentValue >= targetValue && !isCompleted;
  }

  /// Get remaining value to complete
  double get remainingValue {
    final remaining = targetValue - currentValue;
    return remaining > 0 ? remaining : 0;
  }

  /// Get unit string based on quest type
  String get unitString {
    switch (type) {
      case QuestType.running:
        return 'km';
      case QuestType.pushups:
      case QuestType.situps:
        return 'reps';
    }
  }

  /// Format current progress as string
  String get progressString {
    return '${currentValue.toStringAsFixed(type == QuestType.running ? 1 : 0)} / ${targetValue.toStringAsFixed(type == QuestType.running ? 1 : 0)} $unitString';
  }

  /// Copy quest with updated values
  Quest copyWith({
    String? id,
    String? title,
    String? description,
    QuestType? type,
    double? targetValue,
    double? currentValue,
    int? xpReward,
    int? goldReward,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      xpReward: xpReward ?? this.xpReward,
      goldReward: goldReward ?? this.goldReward,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        targetValue,
        currentValue,
        xpReward,
        goldReward,
        isCompleted,
        completedAt,
      ];

  @override
  bool get stringify => true;
}

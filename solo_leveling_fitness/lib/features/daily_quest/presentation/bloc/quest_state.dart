import 'package:equatable/equatable.dart';
import '../../domain/entities/quest.dart';

/// Base class for all Quest states
abstract class QuestState extends Equatable {
  const QuestState();

  @override
  List<Object?> get props => [];
}

/// Initial state when BLoC is created
class QuestInitial extends QuestState {
  const QuestInitial();
}

/// Loading state - show loading indicator
class QuestLoading extends QuestState {
  const QuestLoading();
}

/// Quests loaded successfully
class QuestsLoaded extends QuestState {
  final List<Quest> quests;
  final int totalCompleted;
  final int totalQuests;

  const QuestsLoaded({
    required this.quests,
    required this.totalCompleted,
    required this.totalQuests,
  });

  /// Get completion percentage (0-100)
  double get completionPercentage =>
      totalQuests > 0 ? (totalCompleted / totalQuests * 100) : 0;

  /// Check if all quests are completed
  bool get allQuestsCompleted => totalCompleted == totalQuests && totalQuests > 0;

  /// Get quest by ID
  Quest? getQuestById(String id) {
    try {
      return quests.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [quests, totalCompleted, totalQuests];
}

/// Quest progress updated (e.g., running distance synced)
class QuestProgressUpdated extends QuestState {
  final Quest updatedQuest;
  final List<Quest> allQuests;

  const QuestProgressUpdated({
    required this.updatedQuest,
    required this.allQuests,
  });

  @override
  List<Object?> get props => [updatedQuest, allQuests];
}

/// Quest completed with rewards!
class QuestCompletedWithRewards extends QuestState {
  final Quest completedQuest;
  final int xpGained;
  final int goldGained;
  final bool leveledUp;
  final int? newLevel;
  final Map<String, int>? statIncreases;

  const QuestCompletedWithRewards({
    required this.completedQuest,
    required this.xpGained,
    required this.goldGained,
    required this.leveledUp,
    this.newLevel,
    this.statIncreases,
  });

  @override
  List<Object?> get props => [
        completedQuest,
        xpGained,
        goldGained,
        leveledUp,
        newLevel,
        statIncreases,
      ];
}

/// All daily quests completed! (Special state for achievement)
class AllQuestsCompleted extends QuestState {
  final int totalXPGained;
  final int totalGoldGained;
  final bool leveledUp;
  final int? newLevel;

  const AllQuestsCompleted({
    required this.totalXPGained,
    required this.totalGoldGained,
    required this.leveledUp,
    this.newLevel,
  });

  @override
  List<Object?> get props => [
        totalXPGained,
        totalGoldGained,
        leveledUp,
        newLevel,
      ];
}

/// Quests reset (new day)
class QuestsReset extends QuestState {
  final DateTime resetDate;

  const QuestsReset({required this.resetDate});

  @override
  List<Object?> get props => [resetDate];
}

/// Error state
class QuestError extends QuestState {
  final String message;
  final String? errorCode;

  const QuestError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

import 'package:equatable/equatable.dart';

/// Base class for all Quest events
abstract class QuestEvent extends Equatable {
  const QuestEvent();

  @override
  List<Object?> get props => [];
}

/// Event: Load today's daily quests
class LoadDailyQuests extends QuestEvent {
  const LoadDailyQuests();
}

/// Event: Refresh running progress from HealthKit
class RefreshRunningProgress extends QuestEvent {
  const RefreshRunningProgress();
}

/// Event: Manually complete a quest
class CompleteQuest extends QuestEvent {
  final String questId;

  const CompleteQuest(this.questId);

  @override
  List<Object?> get props => [questId];
}

/// Event: Update quest progress manually
/// (Used for push-ups and sit-ups)
class UpdateQuestProgress extends QuestEvent {
  final String questId;
  final double newValue;

  const UpdateQuestProgress({
    required this.questId,
    required this.newValue,
  });

  @override
  List<Object?> get props => [questId, newValue];
}

/// Event: Reset all daily quests (called at midnight)
class ResetDailyQuests extends QuestEvent {
  const ResetDailyQuests();
}

/// Event: Increment quest value (e.g., +1 push-up)
class IncrementQuestValue extends QuestEvent {
  final String questId;
  final double incrementBy;

  const IncrementQuestValue({
    required this.questId,
    this.incrementBy = 1.0,
  });

  @override
  List<Object?> get props => [questId, incrementBy];
}

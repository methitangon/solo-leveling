import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/quest.dart';
import 'quest_event.dart';
import 'quest_state.dart';

/// Quest BLoC - Manages daily quest state and logic
///
/// This is a simplified version using mock data for now.
/// Later we'll connect it to repositories for real data persistence.
class QuestBloc extends Bloc<QuestEvent, QuestState> {
  // Mock data for now - will be replaced with repository
  List<Quest> _mockQuests = [];

  QuestBloc() : super(const QuestInitial()) {
    // Register event handlers
    on<LoadDailyQuests>(_onLoadDailyQuests);
    on<RefreshRunningProgress>(_onRefreshRunningProgress);
    on<CompleteQuest>(_onCompleteQuest);
    on<UpdateQuestProgress>(_onUpdateQuestProgress);
    on<IncrementQuestValue>(_onIncrementQuestValue);
    on<ResetDailyQuests>(_onResetDailyQuests);
  }

  /// Initialize mock quests
  void _initializeMockQuests() {
    _mockQuests = [
      Quest(
        id: 'quest_running_10km',
        title: 'Run 10 km',
        description: 'Complete your daily 10km run',
        type: QuestType.running,
        targetValue: 10.0,
        currentValue: 0.0,
        xpReward: 100,
        goldReward: 50,
        isCompleted: false,
      ),
      Quest(
        id: 'quest_pushups_100',
        title: 'Do 100 Push-ups',
        description: 'Complete 100 push-ups today',
        type: QuestType.pushups,
        targetValue: 100.0,
        currentValue: 0.0,
        xpReward: 50,
        goldReward: 25,
        isCompleted: false,
      ),
      Quest(
        id: 'quest_situps_100',
        title: 'Do 100 Sit-ups',
        description: 'Complete 100 sit-ups today',
        type: QuestType.situps,
        targetValue: 100.0,
        currentValue: 0.0,
        xpReward: 50,
        goldReward: 25,
        isCompleted: false,
      ),
    ];
  }

  /// Load daily quests
  Future<void> _onLoadDailyQuests(
    LoadDailyQuests event,
    Emitter<QuestState> emit,
  ) async {
    emit(const QuestLoading());

    try {
      // Simulate network/database delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Initialize mock quests if empty
      if (_mockQuests.isEmpty) {
        _initializeMockQuests();
      }

      final completedCount = _mockQuests.where((q) => q.isCompleted).length;

      emit(QuestsLoaded(
        quests: List.from(_mockQuests),
        totalCompleted: completedCount,
        totalQuests: _mockQuests.length,
      ));
    } catch (e) {
      emit(QuestError(message: 'Failed to load quests: $e'));
    }
  }

  /// Refresh running progress from HealthKit
  Future<void> _onRefreshRunningProgress(
    RefreshRunningProgress event,
    Emitter<QuestState> emit,
  ) async {
    try {
      // TODO: Later - get actual distance from HealthKit
      // For now, simulate getting data
      await Future.delayed(const Duration(milliseconds: 300));

      final runningQuestIndex = _mockQuests.indexWhere(
        (q) => q.type == QuestType.running,
      );

      if (runningQuestIndex != -1) {
        // Simulate progress (random for demo)
        final simulatedDistance = 5.2; // Mock: 5.2 km ran

        _mockQuests[runningQuestIndex] = _mockQuests[runningQuestIndex].copyWith(
          currentValue: simulatedDistance,
        );

        final completedCount = _mockQuests.where((q) => q.isCompleted).length;

        emit(QuestsLoaded(
          quests: List.from(_mockQuests),
          totalCompleted: completedCount,
          totalQuests: _mockQuests.length,
        ));
      }
    } catch (e) {
      emit(QuestError(message: 'Failed to refresh running progress: $e'));
    }
  }

  /// Update quest progress manually
  Future<void> _onUpdateQuestProgress(
    UpdateQuestProgress event,
    Emitter<QuestState> emit,
  ) async {
    try {
      final questIndex = _mockQuests.indexWhere((q) => q.id == event.questId);

      if (questIndex != -1) {
        _mockQuests[questIndex] = _mockQuests[questIndex].copyWith(
          currentValue: event.newValue,
        );

        final completedCount = _mockQuests.where((q) => q.isCompleted).length;

        emit(QuestsLoaded(
          quests: List.from(_mockQuests),
          totalCompleted: completedCount,
          totalQuests: _mockQuests.length,
        ));
      }
    } catch (e) {
      emit(QuestError(message: 'Failed to update quest: $e'));
    }
  }

  /// Increment quest value (e.g., +1 push-up)
  Future<void> _onIncrementQuestValue(
    IncrementQuestValue event,
    Emitter<QuestState> emit,
  ) async {
    try {
      final questIndex = _mockQuests.indexWhere((q) => q.id == event.questId);

      if (questIndex != -1) {
        final quest = _mockQuests[questIndex];
        final newValue = quest.currentValue + event.incrementBy;

        _mockQuests[questIndex] = quest.copyWith(
          currentValue: newValue.clamp(0, quest.targetValue),
        );

        final completedCount = _mockQuests.where((q) => q.isCompleted).length;

        emit(QuestsLoaded(
          quests: List.from(_mockQuests),
          totalCompleted: completedCount,
          totalQuests: _mockQuests.length,
        ));
      }
    } catch (e) {
      emit(QuestError(message: 'Failed to increment quest: $e'));
    }
  }

  /// Complete a quest and award rewards
  Future<void> _onCompleteQuest(
    CompleteQuest event,
    Emitter<QuestState> emit,
  ) async {
    try {
      final questIndex = _mockQuests.indexWhere((q) => q.id == event.questId);

      if (questIndex != -1) {
        final quest = _mockQuests[questIndex];

        // Check if quest can be completed
        if (!quest.canComplete) {
          emit(const QuestError(
            message: 'Quest not ready to complete! Keep going!',
          ));
          return;
        }

        // Mark as completed
        _mockQuests[questIndex] = quest.copyWith(
          isCompleted: true,
          completedAt: DateTime.now(),
        );

        // Emit completion state with rewards
        emit(QuestCompletedWithRewards(
          completedQuest: _mockQuests[questIndex],
          xpGained: quest.xpReward,
          goldGained: quest.goldReward,
          leveledUp: false, // TODO: Calculate from player stats
          newLevel: null,
        ));

        // After showing rewards, reload quests
        await Future.delayed(const Duration(milliseconds: 500));
        add(const LoadDailyQuests());
      }
    } catch (e) {
      emit(QuestError(message: 'Failed to complete quest: $e'));
    }
  }

  /// Reset all daily quests
  Future<void> _onResetDailyQuests(
    ResetDailyQuests event,
    Emitter<QuestState> emit,
  ) async {
    try {
      emit(const QuestLoading());

      // Reset all quests
      _initializeMockQuests();

      emit(QuestsReset(resetDate: DateTime.now()));

      // Reload quests
      await Future.delayed(const Duration(milliseconds: 300));
      add(const LoadDailyQuests());
    } catch (e) {
      emit(QuestError(message: 'Failed to reset quests: $e'));
    }
  }
}

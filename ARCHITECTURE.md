# Solo Leveling Fitness App - Architecture Guide

**Created**: 2026-03-10
**Purpose**: A comprehensive guide to understand BLoC pattern and project architecture

---

## Table of Contents
1. [Understanding BLoC Pattern](#understanding-bloc-pattern)
2. [Project Folder Structure](#project-folder-structure)
3. [Data Flow Explained](#data-flow-explained)
4. [Complete Example: Daily Quest Feature](#complete-example-daily-quest-feature)
5. [Database Schema](#database-schema)
6. [Dependencies](#dependencies)

---

## Understanding BLoC Pattern

### What is BLoC?

**BLoC = Business Logic Component**

Think of BLoC as a **middleman** between your UI and your data. It's like a manager who handles all the business logic.

```
┌─────────────────────────────────────────────────────────┐
│                     THE BLOC FLOW                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   UI Screen          BLoC              Data/Repository  │
│   ────────          ─────              ────────────     │
│                                                         │
│   [Button]  ──1──>  Event                              │
│   Pressed           (User wants                        │
│                     something)                         │
│                        │                               │
│                        │                               │
│                        v                               │
│                     BLoC Logic                         │
│                     (Process the      ──2──>  Fetch    │
│                      request)                  Data    │
│                        │                        │      │
│                        │                <──3──  Data   │
│                        │                        Return │
│                        v                               │
│   [Screen]  <──4──  State                             │
│   Updates           (New data                         │
│                      to show)                         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### The BLoC Cycle (Simple Explanation)

1. **UI sends Event** → "Hey BLoC, user wants to complete a quest!"
2. **BLoC processes** → "Okay, let me update the database and calculate XP"
3. **BLoC emits State** → "Done! Here's the new state with updated progress"
4. **UI rebuilds** → "Got it! Showing updated UI with level up animation"

### BLoC Components Explained

#### 1. **Events** (What the user wants to do)
```dart
// events/quest_event.dart
abstract class QuestEvent {}

// User wants to load today's quests
class LoadDailyQuests extends QuestEvent {}

// User completed a quest
class CompleteQuest extends QuestEvent {
  final String questId;
  CompleteQuest(this.questId);
}

// User wants to check running progress
class CheckRunningProgress extends QuestEvent {}
```

**Think of Events as**: "User actions" or "Things that happen"

#### 2. **States** (How the UI should look)
```dart
// states/quest_state.dart
abstract class QuestState {}

// Initial state when app starts
class QuestInitial extends QuestState {}

// Loading data
class QuestLoading extends QuestState {}

// Data loaded successfully
class QuestLoaded extends QuestState {
  final List<Quest> quests;
  final int completedCount;
  QuestLoaded(this.quests, this.completedCount);
}

// Quest completed with rewards
class QuestCompleted extends QuestState {
  final int xpGained;
  final int goldGained;
  QuestCompleted(this.xpGained, this.goldGained);
}

// Error occurred
class QuestError extends QuestState {
  final String message;
  QuestError(this.message);
}
```

**Think of States as**: "Different looks/conditions of your screen"

#### 3. **BLoC** (The brain that connects Events → States)
```dart
// blocs/quest_bloc.dart
class QuestBloc extends Bloc<QuestEvent, QuestState> {
  final QuestRepository repository;

  QuestBloc(this.repository) : super(QuestInitial()) {

    // When LoadDailyQuests event comes in
    on<LoadDailyQuests>((event, emit) async {
      emit(QuestLoading()); // Show loading
      try {
        final quests = await repository.getDailyQuests();
        emit(QuestLoaded(quests, 0)); // Show quests
      } catch (e) {
        emit(QuestError(e.toString())); // Show error
      }
    });

    // When CompleteQuest event comes in
    on<CompleteQuest>((event, emit) async {
      try {
        final rewards = await repository.completeQuest(event.questId);
        emit(QuestCompleted(rewards.xp, rewards.gold)); // Show rewards
      } catch (e) {
        emit(QuestError(e.toString()));
      }
    });
  }
}
```

**Think of BLoC as**: "The manager who listens to events and decides what state to show"

---

## Your Confusion: "BLoC calls state, state calls logic?"

### Let me clarify the CORRECT flow:

```
❌ WRONG (This is the confusion):
UI → State → BLoC → Logic

✅ CORRECT:
UI → Event → BLoC (contains logic) → State → UI updates
```

**The Truth:**
- **Events** don't contain logic (they're just messages)
- **States** don't contain logic (they're just data containers)
- **BLoC** contains ALL the logic (it listens to events and emits states)

### Example: User presses "Complete Quest" button

```dart
// 1. UI sends Event
onPressed: () {
  context.read<QuestBloc>().add(CompleteQuest('quest_1'));
  //                        ^^^
  //                        Adding an EVENT to the BLoC
}

// 2. BLoC receives Event and processes it
on<CompleteQuest>((event, emit) async {
  // THIS IS WHERE LOGIC LIVES
  final quest = await repository.getQuest(event.questId);
  final xp = quest.xpReward;
  final gold = quest.goldReward;

  await repository.markComplete(event.questId);

  // 3. BLoC emits new State
  emit(QuestCompleted(xp, gold));
});

// 4. UI rebuilds based on State
BlocBuilder<QuestBloc, QuestState>(
  builder: (context, state) {
    if (state is QuestCompleted) {
      return Text('Gained ${state.xpGained} XP!');
      //           ^^^^^^^^^^^^^^^^^^^^^^
      //           Reading data from STATE
    }
  },
)
```

---

## Project Folder Structure

Here's the **COMPLETE** folder structure with explanations:

```
solo_leveling_fitness/
│
├── lib/
│   ├── main.dart                      # App entry point
│   │
│   ├── core/                          # Core utilities (shared across app)
│   │   ├── constants/
│   │   │   ├── app_constants.dart     # Constants (quest types, XP values, etc.)
│   │   │   ├── theme_constants.dart   # Solo Leveling colors, text styles
│   │   │   └── routes.dart            # Route names
│   │   ├── theme/
│   │   │   ├── app_theme.dart         # Dark Solo Leveling theme
│   │   │   └── colors.dart            # Solo Leveling color palette
│   │   ├── utils/
│   │   │   ├── date_helper.dart       # Date formatting utilities
│   │   │   └── xp_calculator.dart     # Calculate XP, levels, etc.
│   │   └── errors/
│   │       └── failures.dart          # Error handling classes
│   │
│   ├── features/                      # Each feature is self-contained
│   │   │
│   │   ├── daily_quest/               # ✨ DAILY QUEST FEATURE ✨
│   │   │   ├── data/                  # Data layer (where data comes from)
│   │   │   │   ├── models/            # Data models (JSON <-> Dart objects)
│   │   │   │   │   ├── quest_model.dart
│   │   │   │   │   └── quest_progress_model.dart
│   │   │   │   ├── datasources/       # Where to get data
│   │   │   │   │   ├── quest_local_datasource.dart    # SQLite
│   │   │   │   │   └── health_datasource.dart         # HealthKit
│   │   │   │   └── repositories/      # Combines datasources
│   │   │   │       └── quest_repository_impl.dart
│   │   │   │
│   │   │   ├── domain/                # Business rules (pure Dart, no Flutter)
│   │   │   │   ├── entities/          # Core business objects
│   │   │   │   │   ├── quest.dart
│   │   │   │   │   └── quest_progress.dart
│   │   │   │   ├── repositories/      # Abstract repository (interface)
│   │   │   │   │   └── quest_repository.dart
│   │   │   │   └── usecases/          # Business logic operations
│   │   │   │       ├── get_daily_quests.dart
│   │   │   │       ├── complete_quest.dart
│   │   │   │       └── check_running_progress.dart
│   │   │   │
│   │   │   └── presentation/          # UI layer (Flutter widgets)
│   │   │       ├── bloc/              # ⭐ THE BLOC LIVES HERE ⭐
│   │   │       │   ├── quest_bloc.dart      # The manager
│   │   │       │   ├── quest_event.dart     # Events (user actions)
│   │   │       │   └── quest_state.dart     # States (UI conditions)
│   │   │       ├── pages/             # Full screens
│   │   │       │   └── daily_quest_page.dart
│   │   │       └── widgets/           # Reusable widgets
│   │   │           ├── quest_card.dart
│   │   │           ├── progress_bar.dart
│   │   │           └── reward_popup.dart
│   │   │
│   │   ├── player_status/             # Player stats, level, XP
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── player_bloc.dart
│   │   │       │   ├── player_event.dart
│   │   │       │   └── player_state.dart
│   │   │       ├── pages/
│   │   │       │   └── status_page.dart
│   │   │       └── widgets/
│   │   │           └── stat_display.dart
│   │   │
│   │   ├── rewards/                   # Rewards system
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       └── widgets/
│   │   │           ├── level_up_animation.dart
│   │   │           └── reward_notification.dart
│   │   │
│   │   └── health_tracking/           # HealthKit integration
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── healthkit_datasource.dart
│   │       │   └── repositories/
│   │       │       └── health_repository_impl.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── workout_data.dart
│   │       │   ├── repositories/
│   │       │   │   └── health_repository.dart
│   │       │   └── usecases/
│   │       │       ├── get_running_distance.dart
│   │       │       └── sync_health_data.dart
│   │       └── presentation/
│   │           └── bloc/
│   │               ├── health_bloc.dart
│   │               ├── health_event.dart
│   │               └── health_state.dart
│   │
│   └── app.dart                       # MaterialApp setup

```

---

## Which File Belongs Where? (Your Main Confusion)

### Quick Reference Table

| File Type | Goes In | Purpose | Example |
|-----------|---------|---------|---------|
| **Screens** | `features/xxx/presentation/pages/` | Full pages | `daily_quest_page.dart` |
| **Widgets** | `features/xxx/presentation/widgets/` | Reusable UI pieces | `quest_card.dart` |
| **BLoC** | `features/xxx/presentation/bloc/` | State management | `quest_bloc.dart` |
| **Events** | `features/xxx/presentation/bloc/` | User actions | `quest_event.dart` |
| **States** | `features/xxx/presentation/bloc/` | UI states | `quest_state.dart` |
| **Models** | `features/xxx/data/models/` | JSON ↔ Dart | `quest_model.dart` |
| **Entities** | `features/xxx/domain/entities/` | Pure business objects | `quest.dart` |
| **Repositories** | `features/xxx/data/repositories/` | Actual implementation | `quest_repository_impl.dart` |
| **Repositories (abstract)** | `features/xxx/domain/repositories/` | Interface/contract | `quest_repository.dart` |
| **Datasources** | `features/xxx/data/datasources/` | Talk to SQLite, API, etc. | `quest_local_datasource.dart` |
| **Usecases** | `features/xxx/domain/usecases/` | Single business actions | `complete_quest.dart` |

### Rule of Thumb:

```
presentation/ → Everything the USER SEES (UI, BLoC)
domain/       → Business RULES (pure Dart, no Flutter imports)
data/         → Where DATA comes from (database, API, HealthKit)
```

---

## Data Flow Explained

### The Complete Journey: User Completes Running Quest

```
┌──────────────────────────────────────────────────────────────────────┐
│                        DATA FLOW DIAGRAM                             │
└──────────────────────────────────────────────────────────────────────┘

1. USER TAPS BUTTON
   │
   ├─> daily_quest_page.dart (UI)
   │   │
   │   └─> BlocProvider.of<QuestBloc>(context).add(
   │         CheckRunningProgress()  ← Creates EVENT
   │       );
   │
   ▼

2. EVENT GOES TO BLOC
   │
   ├─> quest_bloc.dart
   │   │
   │   └─> on<CheckRunningProgress>((event, emit) async {
   │         emit(QuestLoading());  ← Show loading state
   │
   │         // Call usecase (business logic)
   │         final result = await checkRunningProgressUsecase();
   │
   │         emit(QuestProgressUpdated(result));  ← New state
   │       });
   │
   ▼

3. BLOC CALLS USECASE (Domain Layer)
   │
   ├─> check_running_progress.dart (usecase)
   │   │
   │   └─> Future<double> call() async {
   │         // Get data from repository
   │         return await questRepository.getRunningProgress();
   │       }
   │
   ▼

4. USECASE CALLS REPOSITORY (Domain → Data)
   │
   ├─> quest_repository.dart (abstract)
   │   │
   │   └─> Interface that defines: getRunningProgress()
   │
   ▼

5. REPOSITORY IMPLEMENTATION (Data Layer)
   │
   ├─> quest_repository_impl.dart
   │   │
   │   └─> Future<double> getRunningProgress() async {
   │         // Get from HealthKit datasource
   │         final healthData = await healthDatasource.getRunningDistance();
   │
   │         // Get from local database
   │         final savedProgress = await localDatasource.getSavedProgress();
   │
   │         // Combine and return
   │         return healthData + savedProgress;
   │       }
   │
   ▼

6. DATASOURCE GETS ACTUAL DATA
   │
   ├─> health_datasource.dart
   │   │
   │   └─> Future<double> getRunningDistance() async {
   │         // Talk to HealthKit
   │         final healthData = await Health().getHealthDataFromTypes(...);
   │         return calculateTotalDistance(healthData);
   │       }
   │
   ▼

7. DATA FLOWS BACK UP
   │
   ├─> Datasource → Repository → Usecase → BLoC
   │
   ▼

8. BLOC EMITS NEW STATE
   │
   ├─> emit(QuestProgressUpdated(distance: 5.2));  ← 5.2 km ran
   │
   ▼

9. UI REBUILDS
   │
   └─> BlocBuilder<QuestBloc, QuestState>(
         builder: (context, state) {
           if (state is QuestProgressUpdated) {
             return Text('${state.distance} / 10 km');  ← SHOWS ON SCREEN
           }
         },
       )
```

---

## Complete Example: Daily Quest Feature

Let me show you EXACTLY how to build the 10km running quest feature.

### Step 1: Define the Entity (Domain Layer)

**File**: `lib/features/daily_quest/domain/entities/quest.dart`

```dart
/// Pure Dart class - no Flutter imports!
class Quest {
  final String id;
  final String title;           // "Run 10 km"
  final String description;     // "Complete your daily run"
  final QuestType type;         // running, pushups, situps
  final double targetValue;     // 10.0 (km)
  final double currentValue;    // 5.2 (km completed so far)
  final int xpReward;           // 100 XP
  final int goldReward;         // 50 Gold
  final bool isCompleted;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.currentValue,
    required this.xpReward,
    required this.goldReward,
    required this.isCompleted,
  });

  double get progressPercentage => (currentValue / targetValue * 100).clamp(0, 100);

  bool get canComplete => currentValue >= targetValue;
}

enum QuestType {
  running,
  pushups,
  situps,
}
```

### Step 2: Define Events

**File**: `lib/features/daily_quest/presentation/bloc/quest_event.dart`

```dart
abstract class QuestEvent {}

// Load today's quests from database
class LoadDailyQuests extends QuestEvent {}

// Refresh running progress from HealthKit
class RefreshRunningProgress extends QuestEvent {}

// User manually completes a quest
class CompleteQuest extends QuestEvent {
  final String questId;
  CompleteQuest(this.questId);
}

// Reset daily quests (midnight or manual)
class ResetDailyQuests extends QuestEvent {}
```

### Step 3: Define States

**File**: `lib/features/daily_quest/presentation/bloc/quest_state.dart`

```dart
abstract class QuestState {}

// Initial state
class QuestInitial extends QuestState {}

// Loading data
class QuestLoading extends QuestState {}

// Quests loaded successfully
class QuestLoaded extends QuestState {
  final List<Quest> quests;
  final int totalCompleted;
  final int totalQuests;

  QuestLoaded({
    required this.quests,
    required this.totalCompleted,
    required this.totalQuests,
  });

  double get completionPercentage =>
    totalQuests > 0 ? (totalCompleted / totalQuests * 100) : 0;
}

// Running progress updated
class RunningProgressUpdated extends QuestState {
  final double distance;       // in km
  final double targetDistance; // 10.0 km

  RunningProgressUpdated({
    required this.distance,
    required this.targetDistance,
  });

  double get progressPercentage => (distance / targetDistance * 100).clamp(0, 100);
}

// Quest completed with rewards
class QuestCompletedWithRewards extends QuestState {
  final Quest completedQuest;
  final int xpGained;
  final int goldGained;
  final bool leveledUp;
  final int? newLevel;

  QuestCompletedWithRewards({
    required this.completedQuest,
    required this.xpGained,
    required this.goldGained,
    required this.leveledUp,
    this.newLevel,
  });
}

// Error state
class QuestError extends QuestState {
  final String message;
  QuestError(this.message);
}
```

### Step 4: Create the BLoC

**File**: `lib/features/daily_quest/presentation/bloc/quest_bloc.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_daily_quests.dart';
import '../../domain/usecases/complete_quest.dart';
import '../../domain/usecases/check_running_progress.dart';
import 'quest_event.dart';
import 'quest_state.dart';

class QuestBloc extends Bloc<QuestEvent, QuestState> {
  final GetDailyQuests getDailyQuestsUsecase;
  final CompleteQuest completeQuestUsecase;
  final CheckRunningProgress checkRunningProgressUsecase;

  QuestBloc({
    required this.getDailyQuestsUsecase,
    required this.completeQuestUsecase,
    required this.checkRunningProgressUsecase,
  }) : super(QuestInitial()) {

    // ═══════════════════════════════════════════════════
    // EVENT HANDLER: Load Daily Quests
    // ═══════════════════════════════════════════════════
    on<LoadDailyQuests>((event, emit) async {
      emit(QuestLoading());

      try {
        // Call usecase to get quests
        final quests = await getDailyQuestsUsecase();

        final completed = quests.where((q) => q.isCompleted).length;

        emit(QuestLoaded(
          quests: quests,
          totalCompleted: completed,
          totalQuests: quests.length,
        ));
      } catch (e) {
        emit(QuestError('Failed to load quests: $e'));
      }
    });

    // ═══════════════════════════════════════════════════
    // EVENT HANDLER: Refresh Running Progress
    // ═══════════════════════════════════════════════════
    on<RefreshRunningProgress>((event, emit) async {
      try {
        // Get running distance from HealthKit
        final distance = await checkRunningProgressUsecase();

        emit(RunningProgressUpdated(
          distance: distance,
          targetDistance: 10.0,
        ));
      } catch (e) {
        emit(QuestError('Failed to get running data: $e'));
      }
    });

    // ═══════════════════════════════════════════════════
    // EVENT HANDLER: Complete Quest
    // ═══════════════════════════════════════════════════
    on<CompleteQuest>((event, emit) async {
      try {
        // Complete the quest and get rewards
        final result = await completeQuestUsecase(event.questId);

        emit(QuestCompletedWithRewards(
          completedQuest: result.quest,
          xpGained: result.xpGained,
          goldGained: result.goldGained,
          leveledUp: result.leveledUp,
          newLevel: result.newLevel,
        ));

        // Reload quests after completion
        add(LoadDailyQuests());
      } catch (e) {
        emit(QuestError('Failed to complete quest: $e'));
      }
    });
  }
}
```

### Step 5: Use BLoC in UI

**File**: `lib/features/daily_quest/presentation/pages/daily_quest_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/quest_bloc.dart';
import '../bloc/quest_event.dart';
import '../bloc/quest_state.dart';
import '../widgets/quest_card.dart';

class DailyQuestPage extends StatelessWidget {
  const DailyQuestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Quests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // ✅ SEND EVENT TO BLOC
              context.read<QuestBloc>().add(RefreshRunningProgress());
            },
          ),
        ],
      ),
      body: BlocConsumer<QuestBloc, QuestState>(
        // ═══════════════════════════════════════════════════
        // LISTENER: React to state changes (show popups, etc.)
        // ═══════════════════════════════════════════════════
        listener: (context, state) {
          if (state is QuestCompletedWithRewards) {
            // Show reward popup
            _showRewardDialog(context, state);
          } else if (state is QuestError) {
            // Show error snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },

        // ═══════════════════════════════════════════════════
        // BUILDER: Build UI based on state
        // ═══════════════════════════════════════════════════
        builder: (context, state) {
          // Loading state
          if (state is QuestLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Loaded state
          if (state is QuestLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.quests.length,
              itemBuilder: (context, index) {
                final quest = state.quests[index];
                return QuestCard(
                  quest: quest,
                  onComplete: () {
                    // ✅ SEND EVENT TO BLOC
                    context.read<QuestBloc>().add(
                      CompleteQuest(quest.id),
                    );
                  },
                );
              },
            );
          }

          // Initial/other states
          return const Center(
            child: Text('Pull down to load quests'),
          );
        },
      ),
    );
  }

  void _showRewardDialog(BuildContext context, QuestCompletedWithRewards state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quest Complete! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('XP Gained: +${state.xpGained}'),
            Text('Gold Gained: +${state.goldGained}'),
            if (state.leveledUp)
              Text('LEVEL UP! You are now level ${state.newLevel}!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }
}
```

---

## Database Schema

### SQLite Tables

```sql
-- ═══════════════════════════════════════════════════
-- Table: players
-- Stores player stats and progress
-- ═══════════════════════════════════════════════════
CREATE TABLE players (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  level INTEGER DEFAULT 1,
  current_xp INTEGER DEFAULT 0,
  total_xp INTEGER DEFAULT 0,
  gold INTEGER DEFAULT 0,
  strength INTEGER DEFAULT 10,
  agility INTEGER DEFAULT 10,
  intelligence INTEGER DEFAULT 10,
  vitality INTEGER DEFAULT 10,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- ═══════════════════════════════════════════════════
-- Table: quests
-- Daily quest templates
-- ═══════════════════════════════════════════════════
CREATE TABLE quests (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  quest_type TEXT NOT NULL, -- 'running', 'pushups', 'situps'
  target_value REAL NOT NULL,
  xp_reward INTEGER NOT NULL,
  gold_reward INTEGER NOT NULL
);

-- ═══════════════════════════════════════════════════
-- Table: daily_quest_progress
-- Track daily progress for each quest
-- ═══════════════════════════════════════════════════
CREATE TABLE daily_quest_progress (
  id TEXT PRIMARY KEY,
  quest_id TEXT NOT NULL,
  date TEXT NOT NULL, -- YYYY-MM-DD format
  current_value REAL DEFAULT 0,
  is_completed INTEGER DEFAULT 0, -- 0 or 1 (boolean)
  completed_at INTEGER,
  created_at INTEGER NOT NULL,
  FOREIGN KEY (quest_id) REFERENCES quests(id)
);

-- ═══════════════════════════════════════════════════
-- Table: health_sync_log
-- Track last HealthKit sync
-- ═══════════════════════════════════════════════════
CREATE TABLE health_sync_log (
  id TEXT PRIMARY KEY,
  last_sync_date INTEGER NOT NULL,
  sync_type TEXT NOT NULL, -- 'running', 'steps', etc.
  data_points_synced INTEGER DEFAULT 0
);

-- ═══════════════════════════════════════════════════
-- Table: rewards_history
-- Track all rewards earned
-- ═══════════════════════════════════════════════════
CREATE TABLE rewards_history (
  id TEXT PRIMARY KEY,
  quest_id TEXT,
  xp_gained INTEGER DEFAULT 0,
  gold_gained INTEGER DEFAULT 0,
  level_before INTEGER,
  level_after INTEGER,
  earned_at INTEGER NOT NULL,
  FOREIGN KEY (quest_id) REFERENCES quests(id)
);

-- ═══════════════════════════════════════════════════
-- Indexes for better performance
-- ═══════════════════════════════════════════════════
CREATE INDEX idx_daily_quest_progress_date ON daily_quest_progress(date);
CREATE INDEX idx_rewards_history_earned_at ON rewards_history(earned_at);
```

---

## Dependencies

### pubspec.yaml

```yaml
name: solo_leveling_fitness
description: A Solo Leveling inspired fitness tracker app
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.11.0

dependencies:
  flutter:
    sdk: flutter

  # ═══════════════════════════════════════════════════
  # State Management
  # ═══════════════════════════════════════════════════
  flutter_bloc: ^8.1.6           # BLoC pattern
  equatable: ^2.0.5               # Easy value comparison for BLoC

  # ═══════════════════════════════════════════════════
  # Health & Fitness
  # ═══════════════════════════════════════════════════
  health: ^11.0.0                 # HealthKit + Health Connect

  # ═══════════════════════════════════════════════════
  # Database
  # ═══════════════════════════════════════════════════
  sqflite: ^2.3.3                 # SQLite database
  path: ^1.9.0                    # File path utilities

  # ═══════════════════════════════════════════════════
  # Dependency Injection
  # ═══════════════════════════════════════════════════
  get_it: ^8.0.2                  # Service locator (for dependency injection)
  injectable: ^2.4.4              # Code generation for get_it

  # ═══════════════════════════════════════════════════
  # Utilities
  # ═══════════════════════════════════════════════════
  intl: ^0.19.0                   # Date formatting
  uuid: ^4.5.1                    # Generate unique IDs
  shared_preferences: ^2.3.3      # Simple key-value storage

  # ═══════════════════════════════════════════════════
  # UI & Animations
  # ═══════════════════════════════════════════════════
  flutter_animate: ^4.5.0         # Easy animations
  shimmer: ^3.0.0                 # Loading shimmer effects
  fl_chart: ^0.70.1               # Charts for stats

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.13           # For code generation
  injectable_generator: ^2.6.2    # For dependency injection

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/sounds/
    - assets/fonts/
```

---

## Summary: Your BLoC Cheat Sheet

```
┌─────────────────────────────────────────────────────────────┐
│              WHEN TO CREATE WHAT FILE                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Need to store data?                                        │
│    → Create Entity (domain/entities/)                      │
│    → Create Model (data/models/)                           │
│                                                             │
│  Need to do a business action?                             │
│    → Create Usecase (domain/usecases/)                     │
│                                                             │
│  Need to get data from somewhere?                          │
│    → Create Datasource (data/datasources/)                 │
│    → Create Repository Implementation (data/repositories/) │
│    → Create Repository Interface (domain/repositories/)    │
│                                                             │
│  Need to manage UI state?                                  │
│    → Create Event (presentation/bloc/xxx_event.dart)       │
│    → Create State (presentation/bloc/xxx_state.dart)       │
│    → Create BLoC (presentation/bloc/xxx_bloc.dart)         │
│                                                             │
│  Need to show something on screen?                         │
│    → Create Page (presentation/pages/)                     │
│    → Create Widget (presentation/widgets/)                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### The Golden Rule:

**If you're confused about where something goes, ask:**

1. Is it about **what the user sees**? → `presentation/`
2. Is it about **business rules**? → `domain/`
3. Is it about **where data comes from**? → `data/`

---

**Next Steps:**
1. Review this architecture
2. Ask questions if anything is unclear
3. Start implementing step by step
4. Build the running quest feature first

Good luck! You've got this! 🚀

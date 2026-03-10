# Solo Leveling Fitness - Project Structure Guide

This document explains the project structure and where to find/add files.

## 📁 Folder Structure Overview

```
lib/
├── core/                    # Shared code across the entire app
│   ├── constants/           # ✅ DONE - App-wide constants
│   │   └── app_constants.dart
│   ├── theme/               # ✅ DONE - UI theming
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   ├── utils/               # ✅ DONE - Helper functions
│   │   ├── date_helper.dart
│   │   └── xp_calculator.dart
│   └── errors/              # TODO - Error handling
│
├── features/                # Feature-based organization
│   │
│   ├── daily_quest/         # Daily Quest Feature
│   │   ├── domain/          # ✅ DONE - Business logic (pure Dart)
│   │   │   └── entities/
│   │   │       └── quest.dart
│   │   ├── data/            # TODO - Data layer
│   │   └── presentation/    # TODO - UI layer (BLoC, Pages, Widgets)
│   │
│   ├── player_status/       # Player Stats Feature
│   │   ├── domain/          # ✅ DONE - Business logic
│   │   │   └── entities/
│   │   │       └── player.dart
│   │   ├── data/            # TODO - Data layer
│   │   └── presentation/    # TODO - UI layer
│   │
│   └── health_tracking/     # HealthKit Integration Feature
│       ├── domain/          # TODO
│       ├── data/            # TODO
│       └── presentation/    # TODO
│
└── main.dart                # TODO - App entry point

assets/                      # Assets folder
├── images/                  # TODO - Add images here
├── sounds/                  # TODO - Add sound effects here
└── animations/              # TODO - Add animation files here
```

## ✅ Completed Files

### Core Layer (Foundation)
1. ✅ `lib/core/constants/app_constants.dart`
   - Quest targets (10km, 100 push-ups, 100 sit-ups)
   - XP and rewards constants
   - Leveling system calculations
   - Database configuration

2. ✅ `lib/core/theme/app_colors.dart`
   - Solo Leveling color palette
   - Blue/cyan primary colors
   - Dark theme colors
   - Glow effects

3. ✅ `lib/core/theme/app_theme.dart`
   - Complete Material 3 dark theme
   - Button styles
   - Text styles
   - Card and surface styles

4. ✅ `lib/core/utils/date_helper.dart`
   - Date formatting utilities
   - Relative time ("2 hours ago")
   - Date comparisons

5. ✅ `lib/core/utils/xp_calculator.dart`
   - XP calculations
   - Level calculations
   - Progress tracking
   - Level titles ("S-Rank Hunter", etc.)

### Domain Layer (Business Logic)
6. ✅ `lib/features/daily_quest/domain/entities/quest.dart`
   - Quest entity with all properties
   - Progress calculations
   - Quest type enum

7. ✅ `lib/features/player_status/domain/entities/player.dart`
   - Player entity with stats
   - Level/XP management
   - Stat increases on level up
   - Combat power calculation

### Project Documentation
8. ✅ `ARCHITECTURE.md` - Comprehensive BLoC guide
9. ✅ `PROJECT_STRUCTURE.md` - This file
10. ✅ `pubspec.yaml` - All dependencies configured

## 📋 Next Steps (TODO)

### Immediate Next Steps
1. **Create BLoC files** for daily quest feature:
   - `lib/features/daily_quest/presentation/bloc/quest_event.dart`
   - `lib/features/daily_quest/presentation/bloc/quest_state.dart`
   - `lib/features/daily_quest/presentation/bloc/quest_bloc.dart`

2. **Create UI pages**:
   - `lib/features/daily_quest/presentation/pages/daily_quest_page.dart`
   - `lib/features/player_status/presentation/pages/status_page.dart`

3. **Set up database**:
   - `lib/core/database/database_helper.dart`
   - Create tables for quests, player, progress

4. **HealthKit integration**:
   - Configure iOS permissions
   - Create HealthKit datasource
   - Implement running distance tracking

5. **Update main.dart**:
   - Set up BLoC providers
   - Configure routing
   - Apply theme

## 🎯 How to Use This Structure

### When creating a new feature:
1. Create folder in `lib/features/your_feature/`
2. Add three subfolders: `domain/`, `data/`, `presentation/`
3. Follow the pattern shown in `daily_quest/` feature

### When adding BLoC:
- Events go in: `presentation/bloc/xxx_event.dart`
- States go in: `presentation/bloc/xxx_state.dart`
- BLoC goes in: `presentation/bloc/xxx_bloc.dart`

### When adding UI:
- Full screens: `presentation/pages/xxx_page.dart`
- Reusable widgets: `presentation/widgets/xxx_widget.dart`

### When adding data sources:
- Database queries: `data/datasources/xxx_local_datasource.dart`
- API calls: `data/datasources/xxx_remote_datasource.dart`
- HealthKit: `data/datasources/health_datasource.dart`

## 📖 Quick Reference

### Where does each file type go?

| What you're creating | Where it goes |
|---------------------|---------------|
| Screen/Page | `features/xxx/presentation/pages/` |
| Widget | `features/xxx/presentation/widgets/` |
| BLoC | `features/xxx/presentation/bloc/` |
| Entity (business object) | `features/xxx/domain/entities/` |
| Repository interface | `features/xxx/domain/repositories/` |
| Usecase | `features/xxx/domain/usecases/` |
| Model (JSON) | `features/xxx/data/models/` |
| Datasource | `features/xxx/data/datasources/` |
| Repository implementation | `features/xxx/data/repositories/` |
| App constant | `core/constants/` |
| Utility function | `core/utils/` |
| Theme/color | `core/theme/` |

## 🚀 Running the App

1. Make sure Flutter is in PATH (close and reopen terminal after installation)
2. Connect your iPhone or run iOS simulator
3. Navigate to project:
   ```bash
   cd solo_leveling_fitness
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## 📚 Additional Resources

- See `ARCHITECTURE.md` for detailed BLoC explanation
- See `README.md` for project overview
- See `pubspec.yaml` for all dependencies

---

**Status**: Foundation complete ✅
**Next**: Implement BLoC and UI for daily quests

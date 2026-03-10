import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/daily_quest/presentation/bloc/quest_bloc.dart';
import 'features/daily_quest/presentation/bloc/quest_event.dart';
import 'features/daily_quest/presentation/pages/daily_quest_page.dart';

void main() {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style (status bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const SoloLevelingFitnessApp());
}

class SoloLevelingFitnessApp extends StatelessWidget {
  const SoloLevelingFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Quest BLoC
        BlocProvider(
          create: (context) => QuestBloc()
            ..add(const LoadDailyQuests()), // Load quests on app start
        ),
        // TODO: Add Player BLoC when ready
        // TODO: Add Health BLoC when ready
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const DailyQuestPage(),
      ),
    );
  }
}

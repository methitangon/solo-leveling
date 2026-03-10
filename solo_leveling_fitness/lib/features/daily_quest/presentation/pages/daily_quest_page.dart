import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/quest_bloc.dart';
import '../bloc/quest_event.dart';
import '../bloc/quest_state.dart';
import '../widgets/quest_card.dart';

/// Daily Quest Page - Main screen showing all daily quests
class DailyQuestPage extends StatelessWidget {
  const DailyQuestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              _buildAppBar(context),

              // Content
              Expanded(
                child: BlocConsumer<QuestBloc, QuestState>(
                  listener: (context, state) {
                    // Show rewards dialog
                    if (state is QuestCompletedWithRewards) {
                      _showRewardDialog(context, state);
                    }

                    // Show all quests completed dialog
                    if (state is AllQuestsCompleted) {
                      _showAllQuestsCompletedDialog(context, state);
                    }

                    // Show error snackbar
                    if (state is QuestError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.accentDanger,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    // Loading state
                    if (state is QuestLoading) {
                      return _buildLoading();
                    }

                    // Loaded state
                    if (state is QuestsLoaded) {
                      return _buildQuestList(context, state);
                    }

                    // Initial state
                    return _buildInitialState(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build app bar
  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DAILY QUESTS',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Complete to gain XP and level up',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),

              // Refresh button
              IconButton(
                onPressed: () {
                  context.read<QuestBloc>().add(const LoadDailyQuests());
                },
                icon: const Icon(Icons.refresh),
                color: AppColors.primary,
                iconSize: 28,
              ),
            ],
          ),

          // Progress summary
          BlocBuilder<QuestBloc, QuestState>(
            builder: (context, state) {
              if (state is QuestsLoaded) {
                return _buildProgressSummary(context, state);
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2, end: 0);
  }

  /// Build progress summary
  Widget _buildProgressSummary(BuildContext context, QuestsLoaded state) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Progress: ${state.totalCompleted}/${state.totalQuests}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            '${state.completionPercentage.toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  /// Build quest list
  Widget _buildQuestList(BuildContext context, QuestsLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<QuestBloc>().add(const LoadDailyQuests());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: state.quests.length,
        itemBuilder: (context, index) {
          final quest = state.quests[index];
          return QuestCard(
            quest: quest,
            onComplete: () {
              context.read<QuestBloc>().add(CompleteQuest(quest.id));
            },
            onIncrement: () {
              context.read<QuestBloc>().add(
                    IncrementQuestValue(questId: quest.id, incrementBy: 1),
                  );
            },
          )
              .animate()
              .fadeIn(delay: (index * 100).ms, duration: 400.ms)
              .slideX(begin: 0.2, end: 0);
        },
      ),
    );
  }

  /// Build loading state
  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          )
              .animate(onPlay: (controller) => controller.repeat())
              .scale(duration: 1000.ms, curve: Curves.easeInOut)
              .then()
              .scale(begin: const Offset(1.2, 1.2), end: const Offset(1.0, 1.0)),
          const SizedBox(height: 24),
          Text(
            'Loading quests...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Build initial state
  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment,
            size: 80,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Pull down to load quests',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              context.read<QuestBloc>().add(const LoadDailyQuests());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Load Quests'),
          ),
        ],
      ),
    );
  }

  /// Show reward dialog when quest is completed
  void _showRewardDialog(BuildContext context, QuestCompletedWithRewards state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.questCompleted.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.questCompleted.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 64,
                  color: AppColors.questCompleted,
                ),
              )
                  .animate()
                  .scale(duration: 300.ms, curve: Curves.elasticOut)
                  .then()
                  .shake(),

              const SizedBox(height: 24),

              // Title
              Text(
                'QUEST COMPLETE!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.questCompleted,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 16),

              // Rewards
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildRewardRow(
                      context,
                      icon: Icons.auto_awesome,
                      label: 'XP Gained',
                      value: '+${state.xpGained}',
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    _buildRewardRow(
                      context,
                      icon: Icons.monetization_on,
                      label: 'Gold Gained',
                      value: '+${state.goldGained}',
                      color: AppColors.accent,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.questCompleted,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'AWESOME!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show all quests completed dialog
  void _showAllQuestsCompletedDialog(
      BuildContext context, AllQuestsCompleted state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('🎉 ALL QUESTS COMPLETED!'),
        content: Text(
          'You\'ve completed all daily quests!\n\nTotal XP: ${state.totalXPGained}\nTotal Gold: ${state.totalGoldGained}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Amazing!'),
          ),
        ],
      ),
    );
  }

  /// Build reward row in dialog
  Widget _buildRewardRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

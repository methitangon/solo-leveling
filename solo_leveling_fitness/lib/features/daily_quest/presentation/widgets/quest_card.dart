import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/quest.dart';
import 'quest_progress_bar.dart';

/// Quest card widget - displays a single quest
class QuestCard extends StatelessWidget {
  final Quest quest;
  final VoidCallback? onComplete;
  final VoidCallback? onIncrement;
  final VoidCallback? onTap;

  const QuestCard({
    Key? key,
    required this.quest,
    this.onComplete,
    this.onIncrement,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompleted = quest.isCompleted;
    final canComplete = quest.canComplete && !isCompleted;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.surface,
              AppColors.surfaceLight.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          border: Border.all(
            color: isCompleted
                ? AppColors.questCompleted.withValues(alpha: 0.5)
                : canComplete
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : AppColors.glassBorder.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: isCompleted || canComplete
              ? [
                  BoxShadow(
                    color: (isCompleted
                            ? AppColors.questCompleted
                            : AppColors.primary)
                        .withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : AppColors.cardShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quest header
              Row(
                children: [
                  // Quest icon
                  _buildQuestIcon(),
                  const SizedBox(width: 12),

                  // Quest title and description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quest.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: isCompleted
                                    ? AppColors.questCompleted
                                    : AppColors.textPrimary,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          quest.description,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ),

                  // Status indicator
                  if (isCompleted)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.questCompleted,
                      size: 32,
                    ).animate().scale(duration: 300.ms).then().shake(),
                ],
              ),

              const SizedBox(height: 16),

              // Progress bar
              AnimatedQuestProgressBar(
                progress: quest.progressDecimal,
                height: 10,
                progressColor: isCompleted
                    ? AppColors.questCompleted
                    : quest.progressPercentage > 50
                        ? AppColors.questInProgress
                        : AppColors.primary,
              ),

              const SizedBox(height: 12),

              // Progress text and rewards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Progress text
                  Text(
                    quest.progressString,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isCompleted
                              ? AppColors.questCompleted
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  // Rewards
                  Row(
                    children: [
                      // XP reward
                      _buildRewardChip(
                        icon: Icons.auto_awesome,
                        value: '+${quest.xpReward} XP',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),

                      // Gold reward
                      _buildRewardChip(
                        icon: Icons.monetization_on,
                        value: '+${quest.goldReward}',
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                ],
              ),

              // Action buttons
              if (!isCompleted) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Increment button (for push-ups and sit-ups)
                    if (quest.type != QuestType.running && onIncrement != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onIncrement,
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text('+1'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),

                    if (quest.type != QuestType.running && onIncrement != null)
                      const SizedBox(width: 8),

                    // Complete button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: canComplete ? onComplete : null,
                        icon: const Icon(Icons.check, size: 20),
                        label: Text(canComplete ? 'Complete' : 'In Progress'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canComplete
                              ? AppColors.questCompleted
                              : AppColors.questIncomplete,
                          foregroundColor: AppColors.background,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build quest icon based on type
  Widget _buildQuestIcon() {
    IconData iconData;
    Color color;

    switch (quest.type) {
      case QuestType.running:
        iconData = Icons.directions_run;
        color = AppColors.primary;
        break;
      case QuestType.pushups:
        iconData = Icons.fitness_center;
        color = AppColors.accentWarning;
        break;
      case QuestType.situps:
        iconData = Icons.self_improvement;
        color = AppColors.accentSuccess;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Icon(
        iconData,
        color: color,
        size: 28,
      ),
    );
  }

  /// Build reward chip (XP or Gold)
  Widget _buildRewardChip({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

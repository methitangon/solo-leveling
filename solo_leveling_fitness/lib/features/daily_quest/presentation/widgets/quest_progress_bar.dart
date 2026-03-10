import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Solo Leveling styled progress bar with glow effect
class QuestProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final bool showGlow;
  final Color? progressColor;
  final Color? backgroundColor;

  const QuestProgressBar({
    Key? key,
    required this.progress,
    this.height = 8.0,
    this.showGlow = true,
    this.progressColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fillColor = progressColor ?? AppColors.primary;
    final bgColor = backgroundColor ?? AppColors.questIncomplete;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        color: bgColor,
        border: Border.all(
          color: AppColors.glassBorder.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: Stack(
          children: [
            // Progress fill
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      fillColor,
                      fillColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: showGlow
                      ? [
                          BoxShadow(
                            color: fillColor.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
            // Shimmer effect
            if (progress > 0 && progress < 1)
              Positioned.fill(
                child: ClipRect(
                  child: FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            fillColor.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Animated progress bar that animates to target value
class AnimatedQuestProgressBar extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final bool showGlow;
  final Color? progressColor;
  final Color? backgroundColor;
  final Duration duration;

  const AnimatedQuestProgressBar({
    Key? key,
    required this.progress,
    this.height = 8.0,
    this.showGlow = true,
    this.progressColor,
    this.backgroundColor,
    this.duration = const Duration(milliseconds: 600),
  }) : super(key: key);

  @override
  State<AnimatedQuestProgressBar> createState() =>
      _AnimatedQuestProgressBarState();
}

class _AnimatedQuestProgressBarState extends State<AnimatedQuestProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedQuestProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return QuestProgressBar(
          progress: _animation.value,
          height: widget.height,
          showGlow: widget.showGlow,
          progressColor: widget.progressColor,
          backgroundColor: widget.backgroundColor,
        );
      },
    );
  }
}

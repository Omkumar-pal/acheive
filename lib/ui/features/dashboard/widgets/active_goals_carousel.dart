import 'package:flutter/material.dart';
import '../../../../domain/models/goal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_card.dart';
import '../../../core/widgets/status_badge.dart';

class ActiveGoalsCarousel extends StatelessWidget {
  final List<Goal> goals;
  final Function(Goal) onGoalTap;

  const ActiveGoalsCarousel({
    super.key,
    required this.goals,
    required this.onGoalTap,
  });

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Active Goals', style: AppTypography.tagline),
              Text(
                '${goals.length} in progress',
                style: AppTypography.caption.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 175,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: goals.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final goal = goals[index];
              return _buildGoalCard(goal);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(Goal goal) {
    final progressInt = (goal.progressPercentage * 100).toInt();

    return SizedBox(
      width: 260,
      child: AppleCard(
        onTap: () => onGoalTap(goal),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.canvasParchment,
                    borderRadius: AppRadius.roundedSm,
                  ),
                  child: Center(
                    child: Text(
                      goal.iconEmoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                StatusBadge(status: goal.progressStatus),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              goal.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyStrong.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${goal.completedActionsCount} of ${goal.totalActionsCount} actions',
                      style: AppTypography.micro.copyWith(color: AppColors.textMuted),
                    ),
                    Text(
                      '$progressInt%',
                      style: AppTypography.captionStrong.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: goal.progressPercentage,
                    minHeight: 5,
                    backgroundColor: AppColors.hairline,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

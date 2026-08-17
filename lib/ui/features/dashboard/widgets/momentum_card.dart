import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_card.dart';
import '../../../core/widgets/momentum_ring.dart';

class MomentumCard extends StatelessWidget {
  final double progress;
  final int completedActions;
  final int totalActions;
  final int streakDays;

  const MomentumCard({
    super.key,
    required this.progress,
    required this.completedActions,
    required this.totalActions,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    return AppleCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          MomentumRing(
            progress: progress,
            completedCount: completedActions,
            totalCount: totalActions,
            size: 96,
            strokeWidth: 9,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      '$streakDays Day Streak',
                      style: AppTypography.captionStrong.copyWith(
                        color: AppColors.statusNeedsAttention,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  completedActions == totalActions && totalActions > 0
                      ? "Daily Momentum Peak"
                      : "Today's Momentum",
                  style: AppTypography.bodyStrong,
                ),
                const SizedBox(height: 4),
                Text(
                  completedActions == totalActions && totalActions > 0
                      ? "Flawless consistency today. Keep the momentum going!"
                      : "$completedActions of $totalActions actions completed. Stay steady.",
                  style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

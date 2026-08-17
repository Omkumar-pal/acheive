import 'package:flutter/material.dart';
import '../../../../domain/models/weekly_reflection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_card.dart';

class WeeklyMetricsScorecard extends StatelessWidget {
  final WeeklyReflection reflection;

  const WeeklyMetricsScorecard({
    super.key,
    required this.reflection,
  });

  @override
  Widget build(BuildContext context) {
    final consistencyPercent = (reflection.consistencyScore * 100).toInt();

    return AppleCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Weekly Scorecard', style: AppTypography.tagline),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.statusOnTrack.withOpacity(0.12),
                  borderRadius: AppRadius.roundedPill,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, size: 14, color: AppColors.statusOnTrack),
                    const SizedBox(width: 4),
                    Text(
                      '$consistencyPercent% Momentum',
                      style: AppTypography.micro.copyWith(
                        color: AppColors.statusOnTrack,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _buildMetricTile(
                title: 'Actions Completed',
                value: '${reflection.totalActionsCompleted}',
                subtitle: 'out of ${reflection.totalActionsPlanned} planned',
                icon: Icons.check_circle_outline,
                iconColor: AppColors.primary,
              ),
              const SizedBox(width: 12),
              _buildMetricTile(
                title: 'Strongest Focus',
                value: reflection.strongestCategory,
                subtitle: 'Peak consistency',
                icon: Icons.stars_outlined,
                iconColor: AppColors.statusNeedsAttention,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.canvasParchment,
          borderRadius: AppRadius.roundedMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.micro.copyWith(color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTypography.bodyStrong.copyWith(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTypography.caption.copyWith(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

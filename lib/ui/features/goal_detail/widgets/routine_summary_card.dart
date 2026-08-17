import 'package:flutter/material.dart';
import '../../../../domain/models/routine.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_card.dart';

class RoutineSummaryCard extends StatelessWidget {
  final Routine routine;

  const RoutineSummaryCard({
    super.key,
    required this.routine,
  });

  @override
  Widget build(BuildContext context) {
    return AppleCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Personal Routine', style: AppTypography.tagline),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: AppRadius.roundedPill,
                ),
                child: Text(
                  '${routine.targetSessionsPerWeek}x / week',
                  style: AppTypography.micro.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildMetricChip(
                icon: Icons.calendar_today_outlined,
                label: 'Scheduled Days',
                value: routine.daysFormatted,
              ),
              const SizedBox(width: 12),
              _buildMetricChip(
                icon: Icons.access_time_outlined,
                label: 'Preferred Time',
                value: '${routine.preferredTime} (${routine.targetDurationMinutes}m)',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.canvasParchment,
          borderRadius: AppRadius.roundedMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text(label, style: AppTypography.micro),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTypography.bodyStrong.copyWith(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

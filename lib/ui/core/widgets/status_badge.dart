import 'package:flutter/material.dart';
import '../../../domain/models/goal.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

class StatusBadge extends StatelessWidget {
  final GoalProgressStatus status;
  final String? customLabel;

  const StatusBadge({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;
    String label;
    IconData icon;

    switch (status) {
      case GoalProgressStatus.ahead:
        bg = AppColors.statusAhead.withOpacity(0.1);
        textColor = AppColors.statusAhead;
        label = customLabel ?? 'Ahead';
        icon = Icons.trending_up;
        break;
      case GoalProgressStatus.onTrack:
        bg = AppColors.statusOnTrack.withOpacity(0.12);
        textColor = AppColors.statusOnTrack;
        label = customLabel ?? 'On Track';
        icon = Icons.check_circle_outline;
        break;
      case GoalProgressStatus.needsAttention:
        bg = AppColors.statusNeedsAttention.withOpacity(0.12);
        textColor = AppColors.statusNeedsAttention;
        label = customLabel ?? 'Needs Attention';
        icon = Icons.priority_high;
        break;
      case GoalProgressStatus.behind:
        bg = AppColors.statusBehind.withOpacity(0.12);
        textColor = AppColors.statusBehind;
        label = customLabel ?? 'Behind';
        icon = Icons.schedule;
        break;
      case GoalProgressStatus.completed:
        bg = AppColors.statusOnTrack.withOpacity(0.15);
        textColor = AppColors.statusOnTrack;
        label = customLabel ?? 'Achieved';
        icon = Icons.emoji_events_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.roundedPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.micro.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../domain/models/action_item.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';

class MilestoneActionTile extends StatelessWidget {
  final ActionItem action;
  final VoidCallback onToggle;

  const MilestoneActionTile({
    super.key,
    required this.action,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: AppRadius.roundedSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            // Micro check circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: action.isCompleted ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: action.isCompleted ? AppColors.primary : AppColors.hairline,
                  width: 1.8,
                ),
              ),
              child: action.isCompleted
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                action.title,
                style: AppTypography.body.copyWith(
                  fontSize: 15,
                  decoration: action.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: action.isCompleted
                      ? AppColors.textMuted
                      : AppColors.ink,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.canvasParchment,
                borderRadius: AppRadius.roundedPill,
              ),
              child: Text(
                '${action.estimatedMinutes}m',
                style: AppTypography.micro.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

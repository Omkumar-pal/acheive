import 'package:flutter/material.dart';
import '../../../../domain/models/action_item.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_card.dart';

class TodayActionsList extends StatelessWidget {
  final List<ActionItem> actions;
  final Function(ActionItem) onToggleAction;
  final String Function(String) getGoalTitle;
  final String Function(String) getGoalEmoji;

  const TodayActionsList({
    super.key,
    required this.actions,
    required this.onToggleAction,
    required this.getGoalTitle,
    required this.getGoalEmoji,
  });

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return AppleCard(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 40, color: AppColors.statusOnTrack),
              const SizedBox(height: 12),
              const Text('All actions complete for today!',
                  style: AppTypography.bodyStrong),
              const SizedBox(height: 4),
              Text(
                'Enjoy your progress and recharge for tomorrow.',
                style: AppTypography.caption.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Today's Actions", style: AppTypography.tagline),
              Text(
                '${actions.where((a) => a.isCompleted).length}/${actions.length} completed',
                style: AppTypography.caption.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final action = actions[index];
            final goalTitle = getGoalTitle(action.goalId);
            final emoji = getGoalEmoji(action.goalId);
            return _buildActionItem(action, goalTitle, emoji);
          },
        ),
      ],
    );
  }

  Widget _buildActionItem(ActionItem action, String goalTitle, String emoji) {
    return AppleCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: () => onToggleAction(action),
      child: Row(
        children: [
          // Checkbox circle
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: action.isCompleted ? AppColors.primary : Colors.transparent,
              border: Border.all(
                color: action.isCompleted ? AppColors.primary : AppColors.hairline,
                width: 2,
              ),
            ),
            child: action.isCompleted
                ? const Icon(Icons.check, size: 15, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 14),
          // Action details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.title,
                  style: AppTypography.bodyStrong.copyWith(
                    decoration: action.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: action.isCompleted
                        ? AppColors.textMuted
                        : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        goalTitle,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.micro.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.hairline,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${action.estimatedMinutes} min',
                      style: AppTypography.micro.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Time pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.canvasParchment,
              borderRadius: AppRadius.roundedPill,
            ),
            child: Text(
              action.preferredTime,
              style: AppTypography.micro.copyWith(
                color: AppColors.inkMuted80,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

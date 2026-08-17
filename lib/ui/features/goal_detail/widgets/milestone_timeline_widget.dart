import 'package:flutter/material.dart';
import '../../../../domain/models/milestone.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_card.dart';
import 'milestone_action_tile.dart';

class MilestoneTimelineWidget extends StatelessWidget {
  final List<Milestone> milestones;
  final Function(String milestoneId, String actionId) onToggleAction;
  final Function(String milestoneId) onAddActionTap;

  const MilestoneTimelineWidget({
    super.key,
    required this.milestones,
    required this.onToggleAction,
    required this.onAddActionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (milestones.isEmpty) {
      return AppleCard(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.flag_outlined, size: 36, color: AppColors.textMuted),
              const SizedBox(height: 10),
              const Text('No Milestones Yet', style: AppTypography.bodyStrong),
              const SizedBox(height: 4),
              Text(
                'Break this goal into smaller, tangible stages.',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Milestones & Steps', style: AppTypography.tagline),
            Text(
              '${milestones.where((m) => m.isCompleted).length} / ${milestones.length} achieved',
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: milestones.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final milestone = milestones[index];
            return _buildMilestoneCard(milestone, index + 1);
          },
        ),
      ],
    );
  }

  Widget _buildMilestoneCard(Milestone milestone, int orderNumber) {
    final progressPercent = (milestone.progress * 100).toInt();

    return AppleCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Milestone Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order / Status Badge
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: milestone.isCompleted
                      ? AppColors.statusOnTrack.withOpacity(0.15)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: AppRadius.roundedSm,
                ),
                child: Center(
                  child: milestone.isCompleted
                      ? const Icon(Icons.check, size: 16, color: AppColors.statusOnTrack)
                      : Text(
                          '$orderNumber',
                          style: AppTypography.captionStrong.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      milestone.title,
                      style: AppTypography.bodyStrong.copyWith(
                        color: milestone.isCompleted
                            ? AppColors.textMuted
                            : AppColors.ink,
                      ),
                    ),
                    if (milestone.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        milestone.description,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                '$progressPercent%',
                style: AppTypography.captionStrong.copyWith(
                  color: milestone.isCompleted
                      ? AppColors.statusOnTrack
                      : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: milestone.progress,
              minHeight: 4,
              backgroundColor: AppColors.hairline,
              valueColor: AlwaysStoppedAnimation<Color>(
                milestone.isCompleted
                    ? AppColors.statusOnTrack
                    : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Actions List inside Milestone
          if (milestone.actions.isNotEmpty) ...[
            const Divider(color: AppColors.hairline),
            const SizedBox(height: 6),
            ...milestone.actions.map(
              (action) => MilestoneActionTile(
                action: action,
                onToggle: () => onToggleAction(milestone.id, action.id),
              ),
            ),
          ],

          // Quick Add Action
          const SizedBox(height: 8),
          InkWell(
            onTap: () => onAddActionTap(milestone.id),
            borderRadius: AppRadius.roundedSm,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Add step',
                    style: AppTypography.captionStrong.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

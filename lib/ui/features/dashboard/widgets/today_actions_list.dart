import 'package:flutter/material.dart';
import '../../../../domain/models/action_item.dart';
import '../../../../domain/models/goal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_card.dart';

class TodayActionsList extends StatefulWidget {
  final List<ActionItem> actions;
  final List<Goal> goals;
  final Function(ActionItem) onToggleAction;
  final String Function(String) getGoalTitle;
  final String Function(String) getGoalEmoji;
  final VoidCallback? onNewGoalTap;

  const TodayActionsList({
    super.key,
    required this.actions,
    this.goals = const [],
    required this.onToggleAction,
    required this.getGoalTitle,
    required this.getGoalEmoji,
    this.onNewGoalTap,
  });

  @override
  State<TodayActionsList> createState() => _TodayActionsListState();
}

class _TodayActionsListState extends State<TodayActionsList> {
  // Map of goalId -> isExpanded boolean
  final Map<String, bool> _expandedGoals = {};

  @override
  Widget build(BuildContext context) {
    if (widget.actions.isEmpty && widget.goals.isEmpty) {
      return AppleCard(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
        child: Center(
          child: Column(
            children: [
              const Text('🎯', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              const Text('No goals scheduled yet', style: AppTypography.bodyStrong),
              const SizedBox(height: 6),
              Text(
                'Start by defining your first personal ambition.',
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              if (widget.onNewGoalTap != null)
                TextButton.icon(
                  onPressed: widget.onNewGoalTap,
                  icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
                  label: const Text('Create First Goal',
                      style: TextStyle(
                          color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ),
      );
    }

    if (widget.actions.isEmpty) {
      return AppleCard(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 36, color: AppColors.statusOnTrack),
              const SizedBox(height: 10),
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

    // Group actions by goalId
    final Map<String, List<ActionItem>> groupedActions = {};
    for (final action in widget.actions) {
      if (!groupedActions.containsKey(action.goalId)) {
        groupedActions[action.goalId] = [];
      }
      groupedActions[action.goalId]!.add(action);
    }

    final totalCompleted = widget.actions.where((a) => a.isCompleted).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Today's Action Plans", style: AppTypography.tagline),
              Text(
                '$totalCompleted/${widget.actions.length} completed',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...groupedActions.entries.map((entry) {
          final goalId = entry.key;
          final goalActions = entry.value;
          final goalTitle = widget.getGoalTitle(goalId);
          final goalEmoji = widget.getGoalEmoji(goalId);

          final isExpanded = _expandedGoals[goalId] ?? true; // expanded by default
          final completedInGoal = goalActions.where((a) => a.isCompleted).length;
          final goalProgress = goalActions.isEmpty ? 0.0 : (completedInGoal / goalActions.length);
          final percentInt = (goalProgress * 100).toInt();

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: AppRadius.roundedMd,
              border: Border.all(color: AppColors.hairline),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x05000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Goal Group Header Card (Tappable Dropdown)
                InkWell(
                  onTap: () {
                    setState(() {
                      _expandedGoals[goalId] = !isExpanded;
                    });
                  },
                  borderRadius: isExpanded
                      ? const BorderRadius.vertical(top: Radius.circular(16))
                      : AppRadius.roundedMd,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(goalEmoji, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                goalTitle,
                                style: AppTypography.bodyStrong.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: goalProgress == 1.0
                                    ? AppColors.statusOnTrack.withOpacity(0.12)
                                    : AppColors.primary.withOpacity(0.1),
                                borderRadius: AppRadius.roundedPill,
                              ),
                              child: Text(
                                '$completedInGoal/${goalActions.length} today ($percentInt%)',
                                style: AppTypography.micro.copyWith(
                                  color: goalProgress == 1.0
                                      ? AppColors.statusOnTrack
                                      : AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: AppColors.textMuted,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Goal Day Task Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: goalProgress,
                            minHeight: 5,
                            backgroundColor: AppColors.canvasParchment,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              goalProgress == 1.0
                                  ? AppColors.statusOnTrack
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Collapsible Action Items for this Goal
                if (isExpanded) ...[
                  const Divider(color: AppColors.hairline, height: 1),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: goalActions.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: AppColors.hairline, height: 1, indent: 48),
                    itemBuilder: (context, index) {
                      final action = goalActions[index];
                      return _buildActionRow(action);
                    },
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildActionRow(ActionItem action) {
    return InkWell(
      onTap: () => widget.onToggleAction(action),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Checkbox circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: action.isCompleted ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: action.isCompleted ? AppColors.primary : AppColors.hairline,
                  width: 2,
                ),
              ),
              child: action.isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            // Action details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.title,
                    style: AppTypography.bodyStrong.copyWith(
                      fontSize: 14,
                      decoration: action.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: action.isCompleted
                          ? AppColors.textMuted
                          : AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${action.estimatedMinutes} min estimated',
                    style: AppTypography.micro.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Preferred Time pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.canvasParchment,
                borderRadius: AppRadius.roundedPill,
              ),
              child: Text(
                action.preferredTime,
                style: AppTypography.micro.copyWith(
                  color: AppColors.inkMuted80,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

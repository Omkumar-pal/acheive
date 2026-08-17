import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_card.dart';
import '../../../core/widgets/apple_pill_button.dart';
import '../../../core/widgets/consistency_heatmap.dart';
import '../../../core/widgets/responsive_container.dart';
import '../../../core/widgets/status_badge.dart';
import '../view_models/goal_detail_view_model.dart';
import '../widgets/milestone_timeline_widget.dart';
import '../widgets/routine_summary_card.dart';

class GoalDetailView extends StatelessWidget {
  final GoalDetailViewModel viewModel;
  final VoidCallback onBack;

  const GoalDetailView({
    super.key,
    required this.viewModel,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        final goal = viewModel.goal;
        if (goal == null) {
          return Scaffold(
            appBar: AppBar(leading: BackButton(onPressed: onBack)),
            body: const Center(child: Text('Goal not found')),
          );
        }

        final targetFormatted =
            DateFormat('MMMM yyyy').format(goal.targetDate);
        final progressInt = (goal.progressPercentage * 100).toInt();

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: ResponsiveContainer(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: onBack,
                          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                        Text(
                          goal.categoryDisplay.toUpperCase(),
                          style: AppTypography.micro.copyWith(
                            letterSpacing: 1.2,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 40), // Balance back button
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Macro Goal Hero Card
                    AppleCard(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.canvasParchment,
                                  borderRadius: AppRadius.roundedMd,
                                ),
                                child: Center(
                                  child: Text(
                                    goal.iconEmoji,
                                    style: const TextStyle(fontSize: 26),
                                  ),
                                ),
                              ),
                              StatusBadge(status: goal.progressStatus),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(goal.title, style: AppTypography.displayLg),
                          if (goal.whyItMatters.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.canvasParchment,
                                borderRadius: AppRadius.roundedSm,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.lightbulb_outline,
                                      size: 16, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '"${goal.whyItMatters}"',
                                      style: AppTypography.caption.copyWith(
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Target: $targetFormatted',
                                style: AppTypography.caption
                                    .copyWith(color: AppColors.textMuted),
                              ),
                              Text(
                                '$progressInt% Completed',
                                style: AppTypography.captionStrong
                                    .copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: goal.progressPercentage,
                              minHeight: 8,
                              backgroundColor: AppColors.hairline,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Routine Summary
                    RoutineSummaryCard(routine: goal.routine),
                    const SizedBox(height: 24),

                    // Consistency Rhythm Matrix
                    AppleCard(
                      padding: const EdgeInsets.all(18),
                      child: ConsistencyHeatmap(days: viewModel.consistencyDays),
                    ),
                    const SizedBox(height: 24),

                    // Milestones Timeline
                    MilestoneTimelineWidget(
                      milestones: goal.milestones,
                      onToggleAction: viewModel.toggleAction,
                      onAddActionTap: (mId) =>
                          _showAddActionDialog(context, mId),
                    ),
                    const SizedBox(height: 24),

                    // Add Milestone Button
                    Center(
                      child: ApplePillButton(
                        text: 'Add Milestone',
                        icon: Icons.add_circle_outline,
                        isSecondary: true,
                        onPressed: () => _showAddMilestoneDialog(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddMilestoneDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.canvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Milestone', style: AppTypography.displayMd),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Milestone Title',
                  hintText: 'e.g. Build Basic Vocabulary',
                  filled: true,
                  fillColor: AppColors.canvasParchment,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.roundedSm,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'e.g. Master top 500 words',
                  filled: true,
                  fillColor: AppColors.canvasParchment,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.roundedSm,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ApplePillButton(
                  text: 'Create Milestone',
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      viewModel.addMilestone(
                        titleController.text.trim(),
                        descController.text.trim(),
                      );
                      Navigator.pop(ctx);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddActionDialog(BuildContext context, String milestoneId) {
    final titleController = TextEditingController();
    final durationController = TextEditingController(text: '30');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.canvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Step', style: AppTypography.displayMd),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Action Title',
                  hintText: 'e.g. Complete 20 flashcards',
                  filled: true,
                  fillColor: AppColors.canvasParchment,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.roundedSm,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Estimated Duration (minutes)',
                  filled: true,
                  fillColor: AppColors.canvasParchment,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.roundedSm,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ApplePillButton(
                  text: 'Add Step',
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      final duration =
                          int.tryParse(durationController.text.trim()) ?? 30;
                      viewModel.addAction(
                        milestoneId,
                        titleController.text.trim(),
                        duration,
                        '08:00 AM',
                      );
                      Navigator.pop(ctx);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

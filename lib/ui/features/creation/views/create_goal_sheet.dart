import 'package:flutter/material.dart';
import '../../../../domain/models/action_item.dart';
import '../../../../domain/models/goal.dart';
import '../../../../domain/models/milestone.dart';
import '../../../../domain/models/routine.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_pill_button.dart';

class CreateGoalSheet extends StatefulWidget {
  final Function(Goal) onGoalCreated;

  const CreateGoalSheet({
    super.key,
    required this.onGoalCreated,
  });

  @override
  State<CreateGoalSheet> createState() => _CreateGoalSheetState();
}

class _CreateGoalSheetState extends State<CreateGoalSheet> {
  final _titleController = TextEditingController();
  final _whyController = TextEditingController();
  final _milestoneController = TextEditingController();
  final _actionController = TextEditingController();

  GoalCategory _selectedCategory = GoalCategory.personal;
  String _selectedEmoji = '🎯';
  int _targetMonths = 6;
  int _sessionsPerWeek = 3;
  final List<int> _selectedDays = [1, 3, 5]; // Mon, Wed, Fri

  final List<Map<String, dynamic>> _categories = [
    {'cat': GoalCategory.health, 'name': 'Health', 'emoji': '🏃‍♂️'},
    {'cat': GoalCategory.learning, 'name': 'Learning', 'emoji': '📚'},
    {'cat': GoalCategory.career, 'name': 'Career', 'emoji': '🚀'},
    {'cat': GoalCategory.personal, 'name': 'Personal', 'emoji': '🎯'},
    {'cat': GoalCategory.finance, 'name': 'Finance', 'emoji': '💰'},
    {'cat': GoalCategory.relationships, 'name': 'Relationships', 'emoji': '🤝'},
    {'cat': GoalCategory.productivity, 'name': 'Productivity', 'emoji': '⚡'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _whyController.dispose();
    _milestoneController.dispose();
    _actionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) return;

    final now = DateTime.now();
    final targetDate = now.add(Duration(days: _targetMonths * 30));
    final goalId = 'goal-${DateTime.now().millisecondsSinceEpoch}';
    final milestoneId = 'm-${DateTime.now().millisecondsSinceEpoch}';

    final initialMilestoneTitle = _milestoneController.text.trim().isNotEmpty
        ? _milestoneController.text.trim()
        : 'Foundational Stage 1';

    final initialActionTitle = _actionController.text.trim().isNotEmpty
        ? _actionController.text.trim()
        : 'Initial step towards goal';

    final newGoal = Goal(
      id: goalId,
      title: _titleController.text.trim(),
      whyItMatters: _whyController.text.trim(),
      category: _selectedCategory,
      iconEmoji: _selectedEmoji,
      startDate: now,
      targetDate: targetDate,
      routine: Routine(
        preferredDays: _selectedDays,
        targetSessionsPerWeek: _sessionsPerWeek,
        targetDurationMinutes: 45,
      ),
      milestones: [
        Milestone(
          id: milestoneId,
          goalId: goalId,
          title: initialMilestoneTitle,
          order: 1,
          actions: [
            ActionItem(
              id: 'act-${DateTime.now().millisecondsSinceEpoch}',
              milestoneId: milestoneId,
              goalId: goalId,
              title: initialActionTitle,
              estimatedMinutes: 30,
              preferredTime: '08:00 AM',
              status: ActionStatus.upcoming,
              dueDate: now,
            ),
          ],
        ),
      ],
    );

    widget.onGoalCreated(newGoal);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sheet handle
            Center(
              child: Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.hairline,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 18),

            const Text('Create New Goal', style: AppTypography.displayMd),
            const SizedBox(height: 4),
            Text(
              'Set a clear direction and build your routine.',
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),

            // Goal Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'What do you want to achieve?',
                hintText: 'e.g. Master Conversational French',
                filled: true,
                fillColor: AppColors.canvasParchment,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.roundedSm,
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Motivation / Why it matters
            TextField(
              controller: _whyController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Why does this goal matter to you?',
                hintText: 'e.g. To converse effortlessly during my trip and connect with people...',
                filled: true,
                fillColor: AppColors.canvasParchment,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.roundedSm,
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Category Chips
            const Text('Category', style: AppTypography.captionStrong),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((c) {
                final isSelected = _selectedCategory == c['cat'];
                return ChoiceChip(
                  label: Text('${c['emoji']} ${c['name']}'),
                  selected: isSelected,
                  selectedColor: AppColors.primary.withOpacity(0.15),
                  backgroundColor: AppColors.canvasParchment,
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.hairline,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.ink,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  onSelected: (val) {
                    setState(() {
                      _selectedCategory = c['cat'] as GoalCategory;
                      _selectedEmoji = c['emoji'] as String;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // Target Timeframe
            const Text('Target Timeframe', style: AppTypography.captionStrong),
            const SizedBox(height: 8),
            Row(
              children: [3, 6, 12].map((months) {
                final isSelected = _targetMonths == months;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(months == 12 ? '1 Year' : '$months Months'),
                    selected: isSelected,
                    selectedColor: AppColors.primary.withOpacity(0.15),
                    backgroundColor: AppColors.canvasParchment,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.hairline,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.ink,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    onSelected: (_) {
                      setState(() => _targetMonths = months);
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // Routine Schedule Days
            const Text('Preferred Routine Days', style: AppTypography.captionStrong),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final dayNum = index + 1;
                final isSelected = _selectedDays.contains(dayNum);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedDays.remove(dayNum);
                      } else {
                        _selectedDays.add(dayNum);
                      }
                    });
                  },
                  borderRadius: AppRadius.roundedSm,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.canvasParchment,
                      borderRadius: AppRadius.roundedSm,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.hairline,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        dayNames[index],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.ink,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),

            // First Milestone & Action
            const Text('Initial Milestone & Action', style: AppTypography.captionStrong),
            const SizedBox(height: 8),
            TextField(
              controller: _milestoneController,
              decoration: InputDecoration(
                labelText: 'First Milestone (e.g. Stage 1)',
                hintText: 'e.g. Master core 300 words',
                filled: true,
                fillColor: AppColors.canvasParchment,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.roundedSm,
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _actionController,
              decoration: InputDecoration(
                labelText: 'First Actionable Step',
                hintText: 'e.g. Complete 20 mins of listening',
                filled: true,
                fillColor: AppColors.canvasParchment,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.roundedSm,
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ApplePillButton(
                text: 'Create Goal & Routine',
                onPressed: _submit,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

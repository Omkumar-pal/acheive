import 'package:flutter_test/flutter_test.dart';
import 'package:achieve/domain/models/action_item.dart';
import 'package:achieve/domain/models/goal.dart';
import 'package:achieve/domain/models/milestone.dart';
import 'package:achieve/domain/use_cases/progress_calculator.dart';

void main() {
  group('ProgressCalculator', () {
    const calculator = ProgressCalculator();

    test('calculates 0% for milestone with no completed actions', () {
      const milestone = Milestone(
        id: 'm1',
        goalId: 'g1',
        title: 'Stage 1',
        order: 1,
        actions: [
          ActionItem(id: 'a1', milestoneId: 'm1', goalId: 'g1', title: 'Step 1'),
          ActionItem(id: 'a2', milestoneId: 'm1', goalId: 'g1', title: 'Step 2'),
        ],
      );

      final progress = calculator.calculateMilestoneProgress(milestone);
      expect(progress, 0.0);
    });

    test('calculates 50% when 1 of 2 actions is completed', () {
      const milestone = Milestone(
        id: 'm1',
        goalId: 'g1',
        title: 'Stage 1',
        order: 1,
        actions: [
          ActionItem(
            id: 'a1',
            milestoneId: 'm1',
            goalId: 'g1',
            title: 'Step 1',
            status: ActionStatus.completed,
          ),
          ActionItem(
            id: 'a2',
            milestoneId: 'm1',
            goalId: 'g1',
            title: 'Step 2',
            status: ActionStatus.upcoming,
          ),
        ],
      );

      final progress = calculator.calculateMilestoneProgress(milestone);
      expect(progress, 0.5);
    });

    test('calculates goal progress across multiple milestones', () {
      final now = DateTime.now();
      final goal = Goal(
        id: 'g1',
        title: 'Test Goal',
        startDate: now,
        targetDate: now.add(const Duration(days: 30)),
        milestones: const [
          Milestone(
            id: 'm1',
            goalId: 'g1',
            title: 'Stage 1',
            order: 1,
            actions: [
              ActionItem(
                id: 'a1',
                milestoneId: 'm1',
                goalId: 'g1',
                title: 'Step 1',
                status: ActionStatus.completed,
              ),
            ],
          ),
          Milestone(
            id: 'm2',
            goalId: 'g1',
            title: 'Stage 2',
            order: 2,
            actions: [
              ActionItem(
                id: 'a2',
                milestoneId: 'm2',
                goalId: 'g1',
                title: 'Step 2',
                status: ActionStatus.upcoming,
              ),
            ],
          ),
        ],
      );

      final progress = calculator.calculateGoalProgress(goal);
      expect(progress, 0.5);
    });
  });
}

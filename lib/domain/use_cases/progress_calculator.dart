import '../models/goal.dart';
import '../models/milestone.dart';

class ProgressCalculator {
  const ProgressCalculator();

  double calculateGoalProgress(Goal goal) {
    if (goal.milestones.isEmpty) return 0.0;
    int totalActions = 0;
    int completedActions = 0;

    for (final milestone in goal.milestones) {
      totalActions += milestone.actions.length;
      completedActions += milestone.actions.where((a) => a.isCompleted).length;
    }

    if (totalActions == 0) {
      int completedMilestones =
          goal.milestones.where((m) => m.isCompleted).length;
      return completedMilestones / goal.milestones.length;
    }

    return (completedActions / totalActions).clamp(0.0, 1.0);
  }

  double calculateMilestoneProgress(Milestone milestone) {
    if (milestone.actions.isEmpty) {
      return milestone.isCompleted ? 1.0 : 0.0;
    }
    final completed = milestone.actions.where((a) => a.isCompleted).length;
    return (completed / milestone.actions.length).clamp(0.0, 1.0);
  }

  GoalProgressStatus evaluateProgressStatus(Goal goal) {
    return goal.progressStatus;
  }
}

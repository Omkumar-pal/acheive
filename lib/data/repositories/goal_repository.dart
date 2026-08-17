import '../../domain/models/action_item.dart';
import '../../domain/models/consistency_day.dart';
import '../../domain/models/goal.dart';
import '../../domain/models/milestone.dart';
import 'mock_data.dart';

abstract class IGoalRepository {
  Future<List<Goal>> getGoals();
  Future<Goal?> getGoalById(String id);
  Future<void> saveGoal(Goal goal);
  Future<void> deleteGoal(String id);
  Future<void> toggleActionStatus(String goalId, String milestoneId, String actionId);
  Future<void> addMilestone(String goalId, Milestone milestone);
  Future<void> addAction(String goalId, String milestoneId, ActionItem action);
  Future<List<ConsistencyDay>> getConsistencyHistory();
  Future<List<ActionItem>> getTodayActions();
}

class GoalRepository implements IGoalRepository {
  List<Goal> _goals = [];
  List<ConsistencyDay> _consistencyHistory = [];

  GoalRepository() {
    _goals = MockData.getInitialGoals();
    _consistencyHistory = MockData.getConsistencyHistory();
  }

  @override
  Future<List<Goal>> getGoals() async {
    return List.unmodifiable(_goals);
  }

  @override
  Future<Goal?> getGoalById(String id) async {
    try {
      return _goals.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveGoal(Goal goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index >= 0) {
      _goals[index] = goal;
    } else {
      _goals.add(goal);
    }
  }

  @override
  Future<void> deleteGoal(String id) async {
    _goals.removeWhere((g) => g.id == id);
  }

  @override
  Future<void> toggleActionStatus(
      String goalId, String milestoneId, String actionId) async {
    final goalIndex = _goals.indexWhere((g) => g.id == goalId);
    if (goalIndex == -1) return;

    final goal = _goals[goalIndex];
    final updatedMilestones = goal.milestones.map((milestone) {
      if (milestone.id != milestoneId) return milestone;

      final updatedActions = milestone.actions.map((action) {
        if (action.id != actionId) return action;

        final newStatus = action.isCompleted
            ? ActionStatus.upcoming
            : ActionStatus.completed;
        return action.copyWith(
          status: newStatus,
          completedAt: newStatus == ActionStatus.completed ? DateTime.now() : null,
        );
      }).toList();

      final allActionsDone = updatedActions.isNotEmpty &&
          updatedActions.every((a) => a.isCompleted);

      return milestone.copyWith(
        actions: updatedActions,
        isCompleted: allActionsDone,
      );
    }).toList();

    _goals[goalIndex] = goal.copyWith(milestones: updatedMilestones);

    // Update today's consistency log
    if (_consistencyHistory.isNotEmpty) {
      final todayIndex = _consistencyHistory.length - 1;
      final today = _consistencyHistory[todayIndex];
      final currentCompleted = await getTodayActions();
      final completedCount = currentCompleted.where((a) => a.isCompleted).length;

      _consistencyHistory[todayIndex] = ConsistencyDay(
        date: today.date,
        completedActions: completedCount,
        plannedActions: currentCompleted.length,
        totalMinutesSpent: completedCount * 30,
      );
    }
  }

  @override
  Future<void> addMilestone(String goalId, Milestone milestone) async {
    final goalIndex = _goals.indexWhere((g) => g.id == goalId);
    if (goalIndex == -1) return;

    final goal = _goals[goalIndex];
    final updatedMilestones = [...goal.milestones, milestone];
    _goals[goalIndex] = goal.copyWith(milestones: updatedMilestones);
  }

  @override
  Future<void> addAction(
      String goalId, String milestoneId, ActionItem action) async {
    final goalIndex = _goals.indexWhere((g) => g.id == goalId);
    if (goalIndex == -1) return;

    final goal = _goals[goalIndex];
    final updatedMilestones = goal.milestones.map((milestone) {
      if (milestone.id != milestoneId) return milestone;
      return milestone.copyWith(actions: [...milestone.actions, action]);
    }).toList();

    _goals[goalIndex] = goal.copyWith(milestones: updatedMilestones);
  }

  @override
  Future<List<ConsistencyDay>> getConsistencyHistory() async {
    return List.unmodifiable(_consistencyHistory);
  }

  @override
  Future<List<ActionItem>> getTodayActions() async {
    final List<ActionItem> todayActions = [];
    for (final goal in _goals) {
      for (final milestone in goal.milestones) {
        for (final action in milestone.actions) {
          // Include actions due today or upcoming active actions
          todayActions.add(action);
        }
      }
    }
    return todayActions;
  }
}

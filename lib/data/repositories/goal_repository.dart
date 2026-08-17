import '../../domain/models/action_item.dart';
import '../../domain/models/consistency_day.dart';
import '../../domain/models/goal.dart';
import '../../domain/models/milestone.dart';
import 'mock_data.dart';

abstract class IGoalRepository {
  void setActiveUser(String userId, {bool isDemo = false});
  Future<List<Goal>> getGoals();
  Future<Goal?> getGoalById(String id);
  Future<void> saveGoal(Goal goal);
  Future<void> deleteGoal(String id);
  Future<void> toggleActionStatus(String goalId, String milestoneId, String actionId);
  Future<void> addMilestone(String goalId, Milestone milestone);
  Future<void> addAction(String goalId, String milestoneId, ActionItem action);
  Future<List<ConsistencyDay>> getConsistencyHistory();
  Future<List<ConsistencyDay>> getGoalConsistencyHistory(String goalId);
  Future<List<ActionItem>> getTodayActions();
}

class GoalRepository implements IGoalRepository {
  String _activeUserId = 'demo-user';
  bool _isDemoUser = true;

  final Map<String, List<Goal>> _userGoals = {};
  final Map<String, List<ConsistencyDay>> _userConsistency = {};

  GoalRepository() {
    // Seed demo user with sample data
    _userGoals['demo-user'] = MockData.getInitialGoals();
    _userConsistency['demo-user'] = MockData.getConsistencyHistory();
  }

  @override
  void setActiveUser(String userId, {bool isDemo = false}) {
    _activeUserId = userId;
    _isDemoUser = isDemo;
    if (isDemo && !_userGoals.containsKey(userId)) {
      _userGoals[userId] = MockData.getInitialGoals();
      _userConsistency[userId] = MockData.getConsistencyHistory();
    } else if (!_userGoals.containsKey(userId)) {
      // New registered user starts with clean empty slate
      _userGoals[userId] = [];
      _userConsistency[userId] = _generateEmptyConsistencyHistory();
    }
  }

  List<ConsistencyDay> _generateEmptyConsistencyHistory() {
    final now = DateTime.now();
    return List.generate(28, (i) {
      final date = now.subtract(Duration(days: 27 - i));
      return ConsistencyDay(
        date: DateTime(date.year, date.month, date.day),
        completedActions: 0,
        plannedActions: 0,
        totalMinutesSpent: 0,
      );
    });
  }

  List<Goal> get _currentGoals => _userGoals[_activeUserId] ?? [];

  @override
  Future<List<Goal>> getGoals() async {
    return List.unmodifiable(_currentGoals);
  }

  @override
  Future<Goal?> getGoalById(String id) async {
    try {
      return _currentGoals.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveGoal(Goal goal) async {
    final goals = _userGoals[_activeUserId] ?? [];
    final index = goals.indexWhere((g) => g.id == goal.id);
    if (index >= 0) {
      goals[index] = goal;
    } else {
      goals.insert(0, goal);
    }
    _userGoals[_activeUserId] = goals;
  }

  @override
  Future<void> deleteGoal(String id) async {
    final goals = _userGoals[_activeUserId] ?? [];
    goals.removeWhere((g) => g.id == id);
    _userGoals[_activeUserId] = goals;
  }

  @override
  Future<void> toggleActionStatus(
      String goalId, String milestoneId, String actionId) async {
    final goals = _userGoals[_activeUserId] ?? [];
    final goalIndex = goals.indexWhere((g) => g.id == goalId);
    if (goalIndex == -1) return;

    final goal = goals[goalIndex];
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

    goals[goalIndex] = goal.copyWith(milestones: updatedMilestones);
    _userGoals[_activeUserId] = goals;

    // Update consistency history
    final history = _userConsistency[_activeUserId] ?? _generateEmptyConsistencyHistory();
    if (history.isNotEmpty) {
      final todayIndex = history.length - 1;
      final today = history[todayIndex];
      final currentTodayActions = await getTodayActions();
      final completedCount = currentTodayActions.where((a) => a.isCompleted).length;

      history[todayIndex] = ConsistencyDay(
        date: today.date,
        completedActions: completedCount,
        plannedActions: currentTodayActions.length,
        totalMinutesSpent: completedCount * 30,
      );
      _userConsistency[_activeUserId] = history;
    }
  }

  @override
  Future<void> addMilestone(String goalId, Milestone milestone) async {
    final goals = _userGoals[_activeUserId] ?? [];
    final goalIndex = goals.indexWhere((g) => g.id == goalId);
    if (goalIndex == -1) return;

    final goal = goals[goalIndex];
    final updatedMilestones = [...goal.milestones, milestone];
    goals[goalIndex] = goal.copyWith(milestones: updatedMilestones);
    _userGoals[_activeUserId] = goals;
  }

  @override
  Future<void> addAction(
      String goalId, String milestoneId, ActionItem action) async {
    final goals = _userGoals[_activeUserId] ?? [];
    final goalIndex = goals.indexWhere((g) => g.id == goalId);
    if (goalIndex == -1) return;

    final goal = goals[goalIndex];
    final updatedMilestones = goal.milestones.map((milestone) {
      if (milestone.id != milestoneId) return milestone;
      return milestone.copyWith(actions: [...milestone.actions, action]);
    }).toList();

    goals[goalIndex] = goal.copyWith(milestones: updatedMilestones);
    _userGoals[_activeUserId] = goals;
  }

  @override
  Future<List<ConsistencyDay>> getConsistencyHistory() async {
    return List.unmodifiable(_userConsistency[_activeUserId] ?? _generateEmptyConsistencyHistory());
  }

  @override
  Future<List<ConsistencyDay>> getGoalConsistencyHistory(String goalId) async {
    final goal = await getGoalById(goalId);
    final now = DateTime.now();

    // Create 28-day history strictly based on this goal's completed actions
    final List<ConsistencyDay> goalDays = [];

    // Collect all action completion dates for this goal
    final Map<String, int> completedDates = {};
    if (goal != null) {
      for (final m in goal.milestones) {
        for (final a in m.actions) {
          if (a.isCompleted && a.completedAt != null) {
            final dateStr = '${a.completedAt!.year}-${a.completedAt!.month}-${a.completedAt!.day}';
            completedDates[dateStr] = (completedDates[dateStr] ?? 0) + 1;
          }
        }
      }
    }

    // For demo goals, if no explicit completedAt is set, generate mock rhythm matching goal's routine
    final isDemoGoal = _isDemoUser && (goalId == 'goal-1' || goalId == 'goal-2' || goalId == 'goal-3');

    for (int i = 27; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final dateStr = '${d.year}-${d.month}-${d.day}';
      int count = completedDates[dateStr] ?? 0;

      if (count == 0 && isDemoGoal) {
        // Goal-specific sample cadence
        final isGoalDay = goal?.routine.preferredDays.contains(d.weekday) ?? false;
        if (isGoalDay && i % 3 != 1) {
          count = 1;
        }
      }

      goalDays.add(ConsistencyDay(
        date: DateTime(d.year, d.month, d.day),
        completedActions: count,
        plannedActions: (goal?.routine.preferredDays.contains(d.weekday) ?? false) ? 1 : 0,
        totalMinutesSpent: count * (goal?.routine.targetDurationMinutes ?? 30),
      ));
    }

    return goalDays;
  }

  @override
  Future<List<ActionItem>> getTodayActions() async {
    final List<ActionItem> todayActions = [];
    for (final goal in _currentGoals) {
      for (final milestone in goal.milestones) {
        for (final action in milestone.actions) {
          todayActions.add(action);
        }
      }
    }
    return todayActions;
  }
}

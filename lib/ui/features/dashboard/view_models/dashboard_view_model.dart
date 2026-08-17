import 'package:flutter/foundation.dart';
import '../../../../data/repositories/goal_repository.dart';
import '../../../../domain/models/action_item.dart';
import '../../../../domain/models/consistency_day.dart';
import '../../../../domain/models/goal.dart';
import '../../../../domain/use_cases/consistency_evaluator.dart';
import '../../../../domain/use_cases/progress_calculator.dart';

class DashboardViewModel extends ChangeNotifier {
  final IGoalRepository _repository;
  final ProgressCalculator _progressCalculator;
  final ConsistencyEvaluator _consistencyEvaluator;

  List<Goal> _goals = [];
  List<ActionItem> _todayActions = [];
  List<ConsistencyDay> _consistencyDays = [];
  bool _isLoading = false;

  DashboardViewModel({
    required IGoalRepository repository,
    ProgressCalculator progressCalculator = const ProgressCalculator(),
    ConsistencyEvaluator consistencyEvaluator = const ConsistencyEvaluator(),
  })  : _repository = repository,
        _progressCalculator = progressCalculator,
        _consistencyEvaluator = consistencyEvaluator {
    loadDashboard();
  }

  List<Goal> get goals => _goals;
  List<ActionItem> get todayActions => _todayActions;
  List<ConsistencyDay> get consistencyDays => _consistencyDays;
  bool get isLoading => _isLoading;

  int get completedTodayCount =>
      _todayActions.where((a) => a.isCompleted).length;

  int get totalTodayCount => _todayActions.length;

  double get todayProgress => totalTodayCount == 0
      ? 0.0
      : (completedTodayCount / totalTodayCount).clamp(0.0, 1.0);

  int get currentStreak =>
      _consistencyEvaluator.calculateCurrentStreak(_consistencyDays);

  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();

    try {
      _goals = await _repository.getGoals();
      _todayActions = await _repository.getTodayActions();
      _consistencyDays = await _repository.getConsistencyHistory();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleAction(ActionItem action) async {
    await _repository.toggleActionStatus(
        action.goalId, action.milestoneId, action.id);
    await loadDashboard();
  }

  String getGoalTitle(String goalId) {
    try {
      return _goals.firstWhere((g) => g.id == goalId).title;
    } catch (_) {
      return 'Personal Goal';
    }
  }

  String getGoalEmoji(String goalId) {
    try {
      return _goals.firstWhere((g) => g.id == goalId).iconEmoji;
    } catch (_) {
      return '🎯';
    }
  }
}

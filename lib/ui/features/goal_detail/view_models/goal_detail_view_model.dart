import 'package:flutter/foundation.dart';
import '../../../../data/repositories/goal_repository.dart';
import '../../../../domain/models/action_item.dart';
import '../../../../domain/models/consistency_day.dart';
import '../../../../domain/models/goal.dart';
import '../../../../domain/models/milestone.dart';

class GoalDetailViewModel extends ChangeNotifier {
  final IGoalRepository _repository;
  final String goalId;

  Goal? _goal;
  List<ConsistencyDay> _consistencyDays = [];
  bool _isLoading = false;

  GoalDetailViewModel({
    required IGoalRepository repository,
    required this.goalId,
  }) : _repository = repository {
    loadGoalDetail();
  }

  Goal? get goal => _goal;
  List<ConsistencyDay> get consistencyDays => _consistencyDays;
  bool get isLoading => _isLoading;

  Future<void> loadGoalDetail() async {
    _isLoading = true;
    notifyListeners();

    try {
      _goal = await _repository.getGoalById(goalId);
      // Fetch consistency strictly for this goal
      _consistencyDays = await _repository.getGoalConsistencyHistory(goalId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleAction(String milestoneId, String actionId) async {
    await _repository.toggleActionStatus(goalId, milestoneId, actionId);
    await loadGoalDetail();
  }

  Future<void> addMilestone(String title, String description) async {
    if (_goal == null) return;
    final newMilestone = Milestone(
      id: 'm-${DateTime.now().millisecondsSinceEpoch}',
      goalId: goalId,
      title: title,
      description: description,
      order: _goal!.milestones.length + 1,
      actions: [],
    );
    await _repository.addMilestone(goalId, newMilestone);
    await loadGoalDetail();
  }

  Future<void> addAction(String milestoneId, String title, int duration, String time) async {
    if (_goal == null) return;
    final newAction = ActionItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      milestoneId: milestoneId,
      goalId: goalId,
      title: title,
      estimatedMinutes: duration,
      preferredTime: time,
      status: ActionStatus.upcoming,
      dueDate: DateTime.now(),
    );
    await _repository.addAction(goalId, milestoneId, newAction);
    await loadGoalDetail();
  }
}

class ConsistencyDay {
  final DateTime date;
  final int completedActions;
  final int plannedActions;
  final int totalMinutesSpent;

  const ConsistencyDay({
    required this.date,
    required this.completedActions,
    required this.plannedActions,
    this.totalMinutesSpent = 0,
  });

  bool get wasActive => completedActions > 0;
  bool get wasPerfect => plannedActions > 0 && completedActions >= plannedActions;

  double get completionRate =>
      plannedActions == 0 ? (completedActions > 0 ? 1.0 : 0.0) : (completedActions / plannedActions).clamp(0.0, 1.0);
}

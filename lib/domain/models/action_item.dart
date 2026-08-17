enum ActionStatus {
  upcoming,
  inProgress,
  completed,
  missed,
  skipped,
}

enum ActionPriority {
  low,
  medium,
  high,
}

class ActionItem {
  final String id;
  final String milestoneId;
  final String goalId;
  final String title;
  final String description;
  final int estimatedMinutes;
  final String preferredTime; // e.g. "08:00 AM" or "Evening"
  final ActionPriority priority;
  final ActionStatus status;
  final DateTime? dueDate;
  final DateTime? completedAt;

  const ActionItem({
    required this.id,
    required this.milestoneId,
    required this.goalId,
    required this.title,
    this.description = '',
    this.estimatedMinutes = 30,
    this.preferredTime = '08:00 AM',
    this.priority = ActionPriority.medium,
    this.status = ActionStatus.upcoming,
    this.dueDate,
    this.completedAt,
  });

  bool get isCompleted => status == ActionStatus.completed;

  ActionItem copyWith({
    String? id,
    String? milestoneId,
    String? goalId,
    String? title,
    String? description,
    int? estimatedMinutes,
    String? preferredTime,
    ActionPriority? priority,
    ActionStatus? status,
    DateTime? dueDate,
    DateTime? completedAt,
  }) {
    return ActionItem(
      id: id ?? this.id,
      milestoneId: milestoneId ?? this.milestoneId,
      goalId: goalId ?? this.goalId,
      title: title ?? this.title,
      description: description ?? this.description,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      preferredTime: preferredTime ?? this.preferredTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

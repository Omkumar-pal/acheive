import 'action_item.dart';

class Milestone {
  final String id;
  final String goalId;
  final String title;
  final String description;
  final int order;
  final DateTime? targetDate;
  final bool isCompleted;
  final List<ActionItem> actions;

  const Milestone({
    required this.id,
    required this.goalId,
    required this.title,
    this.description = '',
    required this.order,
    this.targetDate,
    this.isCompleted = false,
    this.actions = const [],
  });

  int get completedActionsCount =>
      actions.where((a) => a.isCompleted).length;

  double get progress =>
      actions.isEmpty ? (isCompleted ? 1.0 : 0.0) : (completedActionsCount / actions.length);

  Milestone copyWith({
    String? id,
    String? goalId,
    String? title,
    String? description,
    int? order,
    DateTime? targetDate,
    bool? isCompleted,
    List<ActionItem>? actions,
  }) {
    return Milestone(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      targetDate: targetDate ?? this.targetDate,
      isCompleted: isCompleted ?? this.isCompleted,
      actions: actions ?? this.actions,
    );
  }
}

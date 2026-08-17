import 'milestone.dart';
import 'routine.dart';

enum GoalCategory {
  health,
  learning,
  career,
  personal,
  finance,
  relationships,
  productivity,
  custom,
}

enum GoalStatus {
  active,
  paused,
  completed,
  archived,
}

enum GoalProgressStatus {
  ahead,
  onTrack,
  needsAttention,
  behind,
  completed,
}

class Goal {
  final String id;
  final String title;
  final String description;
  final String whyItMatters;
  final GoalCategory category;
  final String? customCategoryName;
  final GoalStatus status;
  final DateTime startDate;
  final DateTime targetDate;
  final Routine routine;
  final List<Milestone> milestones;
  final String iconEmoji;

  const Goal({
    required this.id,
    required this.title,
    this.description = '',
    this.whyItMatters = '',
    this.category = GoalCategory.personal,
    this.customCategoryName,
    this.status = GoalStatus.active,
    required this.startDate,
    required this.targetDate,
    this.routine = const Routine(),
    this.milestones = const [],
    this.iconEmoji = '🎯',
  });

  String get categoryDisplay {
    if (category == GoalCategory.custom && customCategoryName != null) {
      return customCategoryName!;
    }
    switch (category) {
      case GoalCategory.health:
        return 'Health';
      case GoalCategory.learning:
        return 'Learning';
      case GoalCategory.career:
        return 'Career';
      case GoalCategory.personal:
        return 'Personal';
      case GoalCategory.finance:
        return 'Finance';
      case GoalCategory.relationships:
        return 'Relationships';
      case GoalCategory.productivity:
        return 'Productivity';
      case GoalCategory.custom:
        return 'Custom';
    }
  }

  int get totalActionsCount {
    int count = 0;
    for (final m in milestones) {
      count += m.actions.length;
    }
    return count;
  }

  int get completedActionsCount {
    int count = 0;
    for (final m in milestones) {
      count += m.completedActionsCount;
    }
    return count;
  }

  double get progressPercentage {
    if (milestones.isEmpty) return 0.0;
    int total = totalActionsCount;
    if (total == 0) {
      int completedM = milestones.where((m) => m.isCompleted).length;
      return completedM / milestones.length;
    }
    return completedActionsCount / total;
  }

  GoalProgressStatus get progressStatus {
    if (status == GoalStatus.completed || progressPercentage >= 1.0) {
      return GoalProgressStatus.completed;
    }
    final now = DateTime.now();
    if (now.isAfter(targetDate)) {
      return GoalProgressStatus.behind;
    }
    final totalDuration = targetDate.difference(startDate).inDays;
    final elapsedDays = now.difference(startDate).inDays;
    if (totalDuration <= 0) return GoalProgressStatus.onTrack;

    final expectedProgress = (elapsedDays / totalDuration).clamp(0.0, 1.0);
    final diff = progressPercentage - expectedProgress;

    if (diff > 0.1) return GoalProgressStatus.ahead;
    if (diff < -0.15) return GoalProgressStatus.needsAttention;
    return GoalProgressStatus.onTrack;
  }

  String get progressStatusMessage {
    switch (progressStatus) {
      case GoalProgressStatus.ahead:
        return 'Ahead of schedule';
      case GoalProgressStatus.onTrack:
        return 'On track';
      case GoalProgressStatus.needsAttention:
        return 'Needs attention';
      case GoalProgressStatus.behind:
        return 'Behind schedule';
      case GoalProgressStatus.completed:
        return 'Goal Achieved';
    }
  }

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    String? whyItMatters,
    GoalCategory? category,
    String? customCategoryName,
    GoalStatus? status,
    DateTime? startDate,
    DateTime? targetDate,
    Routine? routine,
    List<Milestone>? milestones,
    String? iconEmoji,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      whyItMatters: whyItMatters ?? this.whyItMatters,
      category: category ?? this.category,
      customCategoryName: customCategoryName ?? this.customCategoryName,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      routine: routine ?? this.routine,
      milestones: milestones ?? this.milestones,
      iconEmoji: iconEmoji ?? this.iconEmoji,
    );
  }
}

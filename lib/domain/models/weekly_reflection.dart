class WeeklyReflection {
  final String id;
  final DateTime weekStartDate;
  final DateTime weekEndDate;
  final String whatWentWell;
  final String whatWasDifficult;
  final String nextWeekFocus;
  final int totalActionsCompleted;
  final int totalActionsPlanned;
  final double consistencyScore;
  final String strongestCategory;
  final DateTime createdAt;

  const WeeklyReflection({
    required this.id,
    required this.weekStartDate,
    required this.weekEndDate,
    this.whatWentWell = '',
    this.whatWasDifficult = '',
    this.nextWeekFocus = '',
    this.totalActionsCompleted = 0,
    this.totalActionsPlanned = 0,
    this.consistencyScore = 0.0,
    this.strongestCategory = 'General',
    required this.createdAt,
  });

  WeeklyReflection copyWith({
    String? id,
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? whatWentWell,
    String? whatWasDifficult,
    String? nextWeekFocus,
    int? totalActionsCompleted,
    int? totalActionsPlanned,
    double? consistencyScore,
    String? strongestCategory,
    DateTime? createdAt,
  }) {
    return WeeklyReflection(
      id: id ?? this.id,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      weekEndDate: weekEndDate ?? this.weekEndDate,
      whatWentWell: whatWentWell ?? this.whatWentWell,
      whatWasDifficult: whatWasDifficult ?? this.whatWasDifficult,
      nextWeekFocus: nextWeekFocus ?? this.nextWeekFocus,
      totalActionsCompleted: totalActionsCompleted ?? this.totalActionsCompleted,
      totalActionsPlanned: totalActionsPlanned ?? this.totalActionsPlanned,
      consistencyScore: consistencyScore ?? this.consistencyScore,
      strongestCategory: strongestCategory ?? this.strongestCategory,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

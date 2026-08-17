enum RoutineFrequency {
  daily,
  customDays,
  timesPerWeek,
}

class Routine {
  final RoutineFrequency frequency;
  final List<int> preferredDays; // 1 = Monday, 7 = Sunday
  final String preferredTime; // e.g. "07:30 AM", "Evening"
  final int targetDurationMinutes;
  final int targetSessionsPerWeek;

  const Routine({
    this.frequency = RoutineFrequency.customDays,
    this.preferredDays = const [1, 3, 5], // Mon, Wed, Fri
    this.preferredTime = '08:00 AM',
    this.targetDurationMinutes = 45,
    this.targetSessionsPerWeek = 3,
  });

  String get daysFormatted {
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (preferredDays.length == 7) return 'Every day';
    if (preferredDays.isEmpty) return '$targetSessionsPerWeek times / week';
    return preferredDays.map((d) => dayNames[(d - 1) % 7]).join(', ');
  }

  Routine copyWith({
    RoutineFrequency? frequency,
    List<int>? preferredDays,
    String? preferredTime,
    int? targetDurationMinutes,
    int? targetSessionsPerWeek,
  }) {
    return Routine(
      frequency: frequency ?? this.frequency,
      preferredDays: preferredDays ?? this.preferredDays,
      preferredTime: preferredTime ?? this.preferredTime,
      targetDurationMinutes: targetDurationMinutes ?? this.targetDurationMinutes,
      targetSessionsPerWeek: targetSessionsPerWeek ?? this.targetSessionsPerWeek,
    );
  }
}

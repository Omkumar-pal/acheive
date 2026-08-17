import '../models/consistency_day.dart';

class ConsistencyEvaluator {
  const ConsistencyEvaluator();

  int calculateCurrentStreak(List<ConsistencyDay> history) {
    if (history.isEmpty) return 0;
    int streak = 0;
    // Sort descending by date
    final sorted = List<ConsistencyDay>.from(history)
      ..sort((a, b) => b.date.compareTo(a.date));

    for (final day in sorted) {
      if (day.wasActive) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  double calculateWeeklyConsistencyScore(List<ConsistencyDay> last7Days) {
    if (last7Days.isEmpty) return 0.0;
    int activeDays = last7Days.where((d) => d.wasActive).length;
    return (activeDays / 7.0).clamp(0.0, 1.0);
  }

  int calculateTotalActionsCompleted(List<ConsistencyDay> days) {
    return days.fold(0, (sum, day) => sum + day.completedActions);
  }
}

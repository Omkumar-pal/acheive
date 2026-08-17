import '../models/consistency_day.dart';
import '../models/goal.dart';
import '../models/weekly_reflection.dart';

class AiReflectionResult {
  final String whatWentWell;
  final String whatWasDifficult;
  final String nextWeekFocus;
  final String keyInsight;

  const AiReflectionResult({
    required this.whatWentWell,
    required this.whatWasDifficult,
    required this.nextWeekFocus,
    required this.keyInsight,
  });
}

class AiReflectionService {
  const AiReflectionService();

  Future<AiReflectionResult> generateReflection({
    required List<Goal> goals,
    required List<ConsistencyDay> recentDays,
    required WeeklyReflection currentReflection,
  }) async {
    // Artificial slight delay for realistic AI generation feel in UI
    await Future.delayed(const Duration(milliseconds: 650));

    int totalCompleted = 0;
    int totalPlanned = 0;
    final Map<String, int> categoryCounts = {};
    final List<String> topGoalTitles = [];

    for (final goal in goals) {
      final completedInGoal = goal.completedActionsCount;
      if (completedInGoal > 0) {
        topGoalTitles.add(goal.title);
        final cat = goal.categoryDisplay;
        categoryCounts[cat] = (categoryCounts[cat] ?? 0) + completedInGoal;
      }
      totalCompleted += goal.completedActionsCount;
      totalPlanned += goal.totalActionsCount;
    }

    String topCategory = 'General';
    int maxCount = 0;
    categoryCounts.forEach((cat, count) {
      if (count > maxCount) {
        maxCount = count;
        topCategory = cat;
      }
    });

    final activeDaysCount = recentDays.where((d) => d.wasActive).length;
    final streak = activeDaysCount;
    final consistencyRate = recentDays.isEmpty
        ? 0.85
        : (activeDaysCount / recentDays.length.clamp(1, 28));

    // Synthesize structured AI analysis
    String well;
    String difficult;
    String focus;
    String insight;

    if (consistencyRate >= 0.75) {
      well =
          'Maintained high consistency ($totalCompleted actions logged) with stellar execution in $topCategory. Key momentum was built on ${topGoalTitles.take(2).join(" and ")}.';
      difficult =
          'Slight friction during mid-week transitions between high-effort sessions, but overall consistency buffer remained strong.';
      focus =
          'Advance to next milestone stages in ${topGoalTitles.isNotEmpty ? topGoalTitles.first : "core goals"}, and lock in morning focus blocks for uninterrupted deep work.';
      insight =
          'Your execution momentum is in the top tier (over ${(consistencyRate * 100).toInt()}% consistency). Prioritize milestone quality over raw volume.';
    } else {
      well =
          'Made valuable initial progress across ${topGoalTitles.take(2).join(" and ")}, successfully logging key foundational actions.';
      difficult =
          'Schedule fragmentation and fatigue caused missed routine sessions later in the week.';
      focus =
          'Reduce target daily session duration by 15 minutes to guarantee habit consistency before expanding difficulty.';
      insight =
          'Consistency precedes intensity. Aim for 3 unbreakable 20-minute sessions next week.';
    }

    return AiReflectionResult(
      whatWentWell: well,
      whatWasDifficult: difficult,
      nextWeekFocus: focus,
      keyInsight: insight,
    );
  }
}

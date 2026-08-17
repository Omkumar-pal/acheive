import 'package:flutter_test/flutter_test.dart';
import 'package:achieve/domain/models/consistency_day.dart';
import 'package:achieve/domain/use_cases/consistency_evaluator.dart';

void main() {
  group('ConsistencyEvaluator', () {
    const evaluator = ConsistencyEvaluator();

    test('calculates active streak correctly', () {
      final now = DateTime.now();
      final history = [
        ConsistencyDay(date: now, completedActions: 2, plannedActions: 2),
        ConsistencyDay(
            date: now.subtract(const Duration(days: 1)),
            completedActions: 1,
            plannedActions: 2),
        ConsistencyDay(
            date: now.subtract(const Duration(days: 2)),
            completedActions: 3,
            plannedActions: 3),
        ConsistencyDay(
            date: now.subtract(const Duration(days: 3)),
            completedActions: 0,
            plannedActions: 2),
      ];

      final streak = evaluator.calculateCurrentStreak(history);
      expect(streak, 3);
    });

    test('calculates weekly consistency score', () {
      final now = DateTime.now();
      final week = List.generate(7, (i) {
        return ConsistencyDay(
          date: now.subtract(Duration(days: i)),
          completedActions: i < 5 ? 2 : 0,
          plannedActions: 2,
        );
      });

      final score = evaluator.calculateWeeklyConsistencyScore(week);
      expect(score, closeTo(5 / 7.0, 0.01));
    });
  });
}

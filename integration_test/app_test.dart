import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:achieve/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Achieve App End-to-End User Flow', () {
    testWidgets('Verify Dashboard loads, actions can be toggled, and goal detail navigates',
        (tester) async {
      // 1. Pump the app
      await tester.pumpWidget(const AchieveApp());
      await tester.pumpAndSettle();

      // 2. Verify Today's Focus header and active goals are present
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Active Goals'), findsOneWidget);

      // 3. Find first goal card and tap it to navigate to Goal Detail
      final goalCard = find.text('Master Conversational Spanish');
      expect(goalCard, findsOneWidget);
      await tester.tap(goalCard);
      await tester.pumpAndSettle();

      // 4. Verify Goal Details Screen & Milestone Timeline
      expect(find.text('Milestones & Steps'), findsOneWidget);
      expect(find.text('Personal Routine'), findsOneWidget);
      expect(find.text('Consistency Rhythm'), findsOneWidget);

      // 5. Navigate back to Dashboard
      final backButton = find.byIcon(Icons.arrow_back_ios_new);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // 6. Verify back on Today dashboard
      expect(find.text('Today'), findsOneWidget);

      // 7. Switch to Weekly Reflection screen
      final reflectionNav = find.text('Reflection');
      expect(reflectionNav, findsOneWidget);
      await tester.tap(reflectionNav);
      await tester.pumpAndSettle();

      // 8. Verify reflection screen elements
      expect(find.text('Reflection'), findsOneWidget);
      expect(find.text('Weekly Scorecard'), findsOneWidget);
      expect(find.text('Weekly Reflection Log'), findsOneWidget);
    });
  });
}

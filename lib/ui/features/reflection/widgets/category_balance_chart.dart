import 'package:flutter/material.dart';
import '../../../../domain/models/goal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_card.dart';

class CategoryBalanceChart extends StatelessWidget {
  final List<Goal> goals;

  const CategoryBalanceChart({
    super.key,
    required this.goals,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, int> categoryActions = {};
    for (final goal in goals) {
      final cat = goal.categoryDisplay;
      categoryActions[cat] =
          (categoryActions[cat] ?? 0) + goal.completedActionsCount;
    }

    final totalCompleted = categoryActions.values.fold(0, (a, b) => a + b);

    return AppleCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Focus Distribution', style: AppTypography.tagline),
          const SizedBox(height: 16),
          if (categoryActions.isEmpty || totalCompleted == 0)
            Center(
              child: Text(
                'Complete actions across your goals to see distribution.',
                style: AppTypography.caption.copyWith(color: AppColors.textMuted),
              ),
            )
          else ...[
            ...categoryActions.entries.map((entry) {
              final pct = totalCompleted == 0 ? 0.0 : entry.value / totalCompleted;
              final pctInt = (pct * 100).toInt();

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: AppTypography.bodyStrong.copyWith(fontSize: 14)),
                        Text('$pctInt% (${entry.value} acts)',
                            style: AppTypography.micro.copyWith(color: AppColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: AppRadius.roundedSm,
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 6,
                        backgroundColor: AppColors.hairline,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

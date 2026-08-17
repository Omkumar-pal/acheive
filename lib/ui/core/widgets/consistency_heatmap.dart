import 'package:flutter/material.dart';
import '../../../domain/models/consistency_day.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

class ConsistencyHeatmap extends StatelessWidget {
  final List<ConsistencyDay> days;

  const ConsistencyHeatmap({
    super.key,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Consistency Rhythm', style: AppTypography.tagline),
            Text(
              'Last 4 Weeks',
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Day name headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: dayLabels.map((l) {
            return Expanded(
              child: Center(
                child: Text(
                  l,
                  style: AppTypography.micro.copyWith(color: AppColors.textMuted),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // Grid of days (4 weeks x 7 days)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1.0,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];
            return _buildDayCell(day);
          },
        ),
        const SizedBox(height: 12),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Less', style: AppTypography.micro),
            const SizedBox(width: 6),
            _buildLegendBox(AppColors.canvasParchment),
            const SizedBox(width: 4),
            _buildLegendBox(AppColors.primary.withOpacity(0.35)),
            const SizedBox(width: 4),
            _buildLegendBox(AppColors.primary.withOpacity(0.70)),
            const SizedBox(width: 4),
            _buildLegendBox(AppColors.primary),
            const SizedBox(width: 6),
            Text('More', style: AppTypography.micro),
          ],
        ),
      ],
    );
  }

  Widget _buildDayCell(ConsistencyDay day) {
    Color bg;
    Border? border;

    if (day.completedActions == 0) {
      bg = AppColors.canvasParchment;
      border = Border.all(color: AppColors.hairline, width: 0.8);
    } else if (day.completedActions == 1) {
      bg = AppColors.primary.withOpacity(0.35);
    } else if (day.completedActions == 2) {
      bg = AppColors.primary.withOpacity(0.70);
    } else {
      bg = AppColors.primary;
    }

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.roundedSm,
        border: border,
      ),
      child: Center(
        child: day.completedActions > 0
            ? Text(
                '${day.completedActions}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: day.completedActions >= 2 ? Colors.white : AppColors.ink,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: AppColors.hairline, width: 0.5),
      ),
    );
  }
}

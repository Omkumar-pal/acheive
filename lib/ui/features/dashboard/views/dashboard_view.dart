import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/models/goal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_pill_button.dart';
import '../../../core/widgets/responsive_container.dart';
import '../view_models/dashboard_view_model.dart';
import '../widgets/active_goals_carousel.dart';
import '../widgets/momentum_card.dart';
import '../widgets/today_actions_list.dart';

class DashboardView extends StatelessWidget {
  final DashboardViewModel viewModel;
  final Function(Goal) onGoalSelected;
  final VoidCallback onNewGoalTap;

  const DashboardView({
    super.key,
    required this.viewModel,
    required this.onGoalSelected,
    required this.onNewGoalTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateString = DateFormat('EEEE, MMMM d').format(now);

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: viewModel.loadDashboard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ResponsiveContainer(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateString.toUpperCase(),
                                style: AppTypography.micro.copyWith(
                                  letterSpacing: 1.0,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text('Today', style: AppTypography.heroDisplay),
                            ],
                          ),
                          ApplePillButton(
                            text: '+ Goal',
                            icon: Icons.add,
                            onPressed: onNewGoalTap,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Momentum Card
                      MomentumCard(
                        progress: viewModel.todayProgress,
                        completedActions: viewModel.completedTodayCount,
                        totalActions: viewModel.totalTodayCount,
                        streakDays: viewModel.currentStreak,
                      ),
                      const SizedBox(height: 28),

                      // Active Goals Carousel
                      ActiveGoalsCarousel(
                        goals: viewModel.goals,
                        onGoalTap: onGoalSelected,
                      ),
                      const SizedBox(height: 28),

                      // Today's Scheduled Actions
                      TodayActionsList(
                        actions: viewModel.todayActions,
                        onToggleAction: viewModel.toggleAction,
                        getGoalTitle: viewModel.getGoalTitle,
                        getGoalEmoji: viewModel.getGoalEmoji,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_card.dart';
import '../../../core/widgets/apple_pill_button.dart';
import '../../../core/widgets/responsive_container.dart';
import '../view_models/reflection_view_model.dart';
import '../widgets/category_balance_chart.dart';
import '../widgets/reflection_prompt_card.dart';
import '../widgets/weekly_metrics_scorecard.dart';

class ReflectionView extends StatefulWidget {
  final ReflectionViewModel viewModel;

  const ReflectionView({
    super.key,
    required this.viewModel,
  });

  @override
  State<ReflectionView> createState() => _ReflectionViewState();
}

class _ReflectionViewState extends State<ReflectionView> {
  late TextEditingController _wellController;
  late TextEditingController _difficultController;
  late TextEditingController _focusController;

  @override
  void initState() {
    super.initState();
    _wellController = TextEditingController();
    _difficultController = TextEditingController();
    _focusController = TextEditingController();
    _syncControllers();
  }

  void _syncControllers() {
    final r = widget.viewModel.reflection;
    if (r != null) {
      if (_wellController.text != r.whatWentWell) {
        _wellController.text = r.whatWentWell;
      }
      if (_difficultController.text != r.whatWasDifficult) {
        _difficultController.text = r.whatWasDifficult;
      }
      if (_focusController.text != r.nextWeekFocus) {
        _focusController.text = r.nextWeekFocus;
      }
    }
  }

  @override
  void dispose() {
    _wellController.dispose();
    _difficultController.dispose();
    _focusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        _syncControllers();

        if (widget.viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final reflection = widget.viewModel.reflection;
        if (reflection == null) {
          return const Center(child: Text('No reflection data available'));
        }

        final startFormatted =
            DateFormat('MMM d').format(reflection.weekStartDate);
        final endFormatted =
            DateFormat('MMM d, yyyy').format(reflection.weekEndDate);

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: ResponsiveContainer(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$startFormatted – $endFormatted'.toUpperCase(),
                              style: AppTypography.micro.copyWith(
                                letterSpacing: 1.0,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text('Reflection', style: AppTypography.heroDisplay),
                          ],
                        ),
                        // AI Synthesis Button
                        ApplePillButton(
                          text: widget.viewModel.isGeneratingAi
                              ? 'Analyzing...'
                              : '✨ AI Reflection',
                          icon: widget.viewModel.isGeneratingAi
                              ? Icons.hourglass_top_outlined
                              : Icons.auto_awesome,
                          onPressed: widget.viewModel.isGeneratingAi
                              ? null
                              : () => widget.viewModel.generateWithAi(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // AI Insight Banner (if generated)
                    if (widget.viewModel.lastAiInsight != null) ...[
                      AppleCard(
                        backgroundColor: AppColors.primary.withOpacity(0.08),
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('✨', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AI Momentum Insight',
                                    style: AppTypography.captionStrong.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.viewModel.lastAiInsight!,
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Weekly Scorecard
                    WeeklyMetricsScorecard(reflection: reflection),
                    const SizedBox(height: 24),

                    // Category Balance
                    CategoryBalanceChart(goals: widget.viewModel.goals),
                    const SizedBox(height: 28),

                    // Reflection Prompts Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Weekly Reflection Log', style: AppTypography.tagline),
                        if (widget.viewModel.isSaving)
                          const Text('Auto-saved', style: AppTypography.micro),
                      ],
                    ),
                    const SizedBox(height: 14),

                    ReflectionPromptCard(
                      question: 'What went well this week?',
                      hint: 'e.g. Kept up with all running workouts, made steady progress on Spanish...',
                      controller: _wellController,
                      onSave: (val) => widget.viewModel.updateReflection(whatWentWell: val),
                    ),
                    const SizedBox(height: 14),

                    ReflectionPromptCard(
                      question: 'What made things difficult?',
                      hint: 'e.g. Work deadlines made evening coding sessions tough...',
                      controller: _difficultController,
                      onSave: (val) => widget.viewModel.updateReflection(whatWasDifficult: val),
                    ),
                    const SizedBox(height: 14),

                    ReflectionPromptCard(
                      question: 'What is your focus for next week?',
                      hint: 'e.g. Shift SaaS coding to morning, start Spanish conversational milestone...',
                      controller: _focusController,
                      onSave: (val) => widget.viewModel.updateReflection(nextWeekFocus: val),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

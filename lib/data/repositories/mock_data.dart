import '../../domain/models/action_item.dart';
import '../../domain/models/consistency_day.dart';
import '../../domain/models/goal.dart';
import '../../domain/models/milestone.dart';
import '../../domain/models/routine.dart';
import '../../domain/models/weekly_reflection.dart';

class MockData {
  static List<Goal> getInitialGoals() {
    final now = DateTime.now();

    return [
      Goal(
        id: 'goal-1',
        title: 'Master Conversational Spanish',
        description: 'Achieve B2 conversational fluency for immersion travel in South America.',
        whyItMatters: 'To connect deeply with locals, understand cultural nuances, and unlock new professional horizons.',
        category: GoalCategory.learning,
        status: GoalStatus.active,
        iconEmoji: '🇪🇸',
        startDate: now.subtract(const Duration(days: 45)),
        targetDate: now.add(const Duration(days: 120)),
        routine: const Routine(
          frequency: RoutineFrequency.customDays,
          preferredDays: [1, 2, 4, 6], // Mon, Tue, Thu, Sat
          preferredTime: '08:00 AM',
          targetDurationMinutes: 30,
          targetSessionsPerWeek: 4,
        ),
        milestones: [
          Milestone(
            id: 'm1-1',
            goalId: 'goal-1',
            title: 'Foundational 500 Words & Core Grammar',
            description: 'Master top 500 frequent vocabulary words and present/past tense conjugations.',
            order: 1,
            isCompleted: true,
            actions: [
              ActionItem(
                id: 'act-1',
                milestoneId: 'm1-1',
                goalId: 'goal-1',
                title: 'Review 50 flashcards (Anki)',
                estimatedMinutes: 20,
                preferredTime: '08:00 AM',
                priority: ActionPriority.high,
                status: ActionStatus.completed,
                completedAt: now.subtract(const Duration(days: 20)),
              ),
              ActionItem(
                id: 'act-2',
                milestoneId: 'm1-1',
                goalId: 'goal-1',
                title: 'Complete Subjunctive Verb workbook',
                estimatedMinutes: 30,
                preferredTime: '08:30 AM',
                priority: ActionPriority.medium,
                status: ActionStatus.completed,
                completedAt: now.subtract(const Duration(days: 15)),
              ),
            ],
          ),
          Milestone(
            id: 'm1-2',
            goalId: 'goal-1',
            title: 'Conversational Fluency & Listening Sprint',
            description: 'Listen to native podcasts and practice 1-on-1 speaking twice a week.',
            order: 2,
            isCompleted: false,
            actions: [
              ActionItem(
                id: 'act-3',
                milestoneId: 'm1-2',
                goalId: 'goal-1',
                title: '30m iTalki tutor conversation',
                estimatedMinutes: 30,
                preferredTime: '08:00 AM',
                priority: ActionPriority.high,
                status: ActionStatus.upcoming,
                dueDate: now,
              ),
              ActionItem(
                id: 'act-4',
                milestoneId: 'm1-2',
                goalId: 'goal-1',
                title: 'Listen to Radio Ambulante podcast episode',
                estimatedMinutes: 25,
                preferredTime: '06:00 PM',
                priority: ActionPriority.medium,
                status: ActionStatus.upcoming,
                dueDate: now,
              ),
              ActionItem(
                id: 'act-5',
                milestoneId: 'm1-2',
                goalId: 'goal-1',
                title: 'Shadowing speech technique practice',
                estimatedMinutes: 15,
                preferredTime: '09:00 PM',
                priority: ActionPriority.low,
                status: ActionStatus.upcoming,
              ),
            ],
          ),
          Milestone(
            id: 'm1-3',
            goalId: 'goal-1',
            title: 'Native Immersion & Novel Reading',
            description: 'Read first full novel in Spanish (Cien Años de Soledad simplified).',
            order: 3,
            isCompleted: false,
            actions: [
              ActionItem(
                id: 'act-6',
                milestoneId: 'm1-3',
                goalId: 'goal-1',
                title: 'Read chapter 1 & underline unknown idioms',
                estimatedMinutes: 30,
                preferredTime: '08:00 PM',
                priority: ActionPriority.medium,
                status: ActionStatus.upcoming,
              ),
            ],
          ),
        ],
      ),
      Goal(
        id: 'goal-2',
        title: 'Run First Sub-4-Hour Marathon',
        description: 'Complete 42.2km marathon in under 4 hours with sustained 5:40 min/km pace.',
        whyItMatters: 'Build peak cardiovascular fitness, mental resilience, and lifelong discipline.',
        category: GoalCategory.health,
        status: GoalStatus.active,
        iconEmoji: '🏃‍♂️',
        startDate: now.subtract(const Duration(days: 60)),
        targetDate: now.add(const Duration(days: 90)),
        routine: const Routine(
          frequency: RoutineFrequency.customDays,
          preferredDays: [1, 3, 5, 7], // Mon, Wed, Fri, Sun
          preferredTime: '06:30 AM',
          targetDurationMinutes: 60,
          targetSessionsPerWeek: 4,
        ),
        milestones: [
          Milestone(
            id: 'm2-1',
            goalId: 'goal-2',
            title: 'Base Aerobic Capacity (15km Long Runs)',
            description: 'Consistently log 40km weekly volume with comfortable zone 2 heart rate.',
            order: 1,
            isCompleted: true,
            actions: [
              ActionItem(
                id: 'act-7',
                milestoneId: 'm2-1',
                goalId: 'goal-2',
                title: '15km Sunday endurance run',
                estimatedMinutes: 85,
                preferredTime: '06:30 AM',
                priority: ActionPriority.high,
                status: ActionStatus.completed,
                completedAt: now.subtract(const Duration(days: 10)),
              ),
            ],
          ),
          Milestone(
            id: 'm2-2',
            goalId: 'goal-2',
            title: 'Speed-Endurance & Tempo Building',
            description: 'Incorporate 8km tempo runs and 800m interval repeats.',
            order: 2,
            isCompleted: false,
            actions: [
              ActionItem(
                id: 'act-8',
                milestoneId: 'm2-2',
                goalId: 'goal-2',
                title: '8km Tempo Pace (5:30/km)',
                estimatedMinutes: 45,
                preferredTime: '06:30 AM',
                priority: ActionPriority.high,
                status: ActionStatus.completed,
                completedAt: now,
              ),
              ActionItem(
                id: 'act-9',
                milestoneId: 'm2-2',
                goalId: 'goal-2',
                title: 'Leg strengthening & mobility drills',
                estimatedMinutes: 20,
                preferredTime: '07:30 PM',
                priority: ActionPriority.medium,
                status: ActionStatus.upcoming,
                dueDate: now,
              ),
            ],
          ),
          Milestone(
            id: 'm2-3',
            goalId: 'goal-2',
            title: 'Peak 32km Simulation & Taper',
            description: 'Complete official 32km dress rehearsal run with hydration strategy.',
            order: 3,
            isCompleted: false,
            actions: [],
          ),
        ],
      ),
      Goal(
        id: 'goal-3',
        title: 'Launch Indie SaaS Product',
        description: 'Build, validate, and launch a profitable micro-SaaS with first 10 paying customers.',
        whyItMatters: 'Achieve financial autonomy and create enduring value for real human problems.',
        category: GoalCategory.career,
        status: GoalStatus.active,
        iconEmoji: '🚀',
        startDate: now.subtract(const Duration(days: 30)),
        targetDate: now.add(const Duration(days: 60)),
        routine: const Routine(
          frequency: RoutineFrequency.customDays,
          preferredDays: [2, 4, 6],
          preferredTime: '07:00 PM',
          targetDurationMinutes: 90,
          targetSessionsPerWeek: 3,
        ),
        milestones: [
          Milestone(
            id: 'm3-1',
            goalId: 'goal-3',
            title: 'User Problem Validation & Prototype',
            description: 'Interview 15 target users and design high-fidelity Figma prototype.',
            order: 1,
            isCompleted: true,
            actions: [
              ActionItem(
                id: 'act-10',
                milestoneId: 'm3-1',
                goalId: 'goal-3',
                title: '5 customer discovery calls',
                estimatedMinutes: 60,
                preferredTime: '05:00 PM',
                priority: ActionPriority.high,
                status: ActionStatus.completed,
              ),
            ],
          ),
          Milestone(
            id: 'm3-2',
            goalId: 'goal-3',
            title: 'Core MVP Architecture & Payment Gateway',
            description: 'Implement auth, stripe integration, and the core utility dashboard.',
            order: 2,
            isCompleted: false,
            actions: [
              ActionItem(
                id: 'act-11',
                milestoneId: 'm3-2',
                goalId: 'goal-3',
                title: 'Build Stripe webhook handler',
                estimatedMinutes: 60,
                preferredTime: '07:00 PM',
                priority: ActionPriority.high,
                status: ActionStatus.upcoming,
                dueDate: now,
              ),
            ],
          ),
        ],
      ),
    ];
  }

  static List<ConsistencyDay> getConsistencyHistory() {
    final now = DateTime.now();
    final List<ConsistencyDay> days = [];

    // Generate last 28 days of history with realistic rhythm
    for (int i = 27; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final weekday = date.weekday;
      final isWeekend = weekday == 6 || weekday == 7;
      final planned = isWeekend ? 1 : 3;
      // High consistency rate
      final completed = (i % 7 == 3 || i % 5 == 4) ? (planned - 1).clamp(0, 3) : planned;
      final minutes = completed * 35;

      days.add(ConsistencyDay(
        date: DateTime(date.year, date.month, date.day),
        completedActions: completed,
        plannedActions: planned,
        totalMinutesSpent: minutes,
      ));
    }
    return days;
  }

  static WeeklyReflection getLatestReflection() {
    final now = DateTime.now();
    return WeeklyReflection(
      id: 'refl-1',
      weekStartDate: now.subtract(const Duration(days: 7)),
      weekEndDate: now,
      whatWentWell: 'Completed all marathon tempo runs on schedule and maintained morning Spanish practice without skipping.',
      whatWasDifficult: 'Midweek fatigue made late evening SaaS coding sessions harder to focus on.',
      nextWeekFocus: 'Shift SaaS deep work to early Saturday morning and complete Stripe checkout flow.',
      totalActionsCompleted: 16,
      totalActionsPlanned: 18,
      consistencyScore: 0.89,
      strongestCategory: 'Health & Fitness',
      createdAt: now,
    );
  }
}

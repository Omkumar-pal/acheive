import bcrypt from 'bcryptjs';

export interface UserEntity {
  id: string;
  name: string;
  email: string;
  passwordHash: string;
  createdAt: string;
}

export interface ActionEntity {
  id: string;
  milestoneId: string;
  goalId: string;
  title: string;
  estimatedMinutes: number;
  preferredTime: string;
  priority: 'low' | 'medium' | 'high';
  status: 'upcoming' | 'inProgress' | 'completed' | 'missed' | 'skipped';
  dueDate?: string;
  completedAt?: string;
}

export interface MilestoneEntity {
  id: string;
  goalId: string;
  title: string;
  description: string;
  order: number;
  isCompleted: boolean;
  actions: ActionEntity[];
}

export interface RoutineEntity {
  frequency: string;
  preferredDays: number[];
  preferredTime: string;
  targetDurationMinutes: number;
  targetSessionsPerWeek: number;
}

export interface GoalEntity {
  id: string;
  userId: string;
  title: string;
  description: string;
  whyItMatters: string;
  category: string;
  status: 'active' | 'paused' | 'completed' | 'archived';
  iconEmoji: string;
  startDate: string;
  targetDate: string;
  routine: RoutineEntity;
  milestones: MilestoneEntity[];
  createdAt: string;
  updatedAt: string;
}

export interface ConsistencyDayEntity {
  date: string; // YYYY-MM-DD
  completedActions: number;
  plannedActions: number;
  totalMinutesSpent: number;
}

export interface ReflectionEntity {
  id: string;
  userId: string;
  weekStartDate: string;
  weekEndDate: string;
  whatWentWell: string;
  whatWasDifficult: string;
  nextWeekFocus: string;
  consistencyScore: number;
  strongestCategory: string;
  createdAt: string;
}

class DatabaseStore {
  users: UserEntity[] = [];
  goals: GoalEntity[] = [];
  consistency: ConsistencyDayEntity[] = [];
  reflections: ReflectionEntity[] = [];

  constructor() {
    this.seed();
  }

  private seed() {
    const demoUser: UserEntity = {
      id: 'usr-demo-1',
      name: 'Alex Rivera',
      email: 'alex@achieve.app',
      passwordHash: bcrypt.hashSync('password123', 8),
      createdAt: new Date().toISOString(),
    };
    this.users.push(demoUser);

    const now = new Date();
    const g1: GoalEntity = {
      id: 'goal-1',
      userId: demoUser.id,
      title: 'Master Conversational Spanish',
      description: 'Achieve B2 conversational fluency for immersion travel.',
      whyItMatters: 'To connect deeply with locals, understand cultural nuances, and unlock new professional horizons.',
      category: 'learning',
      status: 'active',
      iconEmoji: '🇪🇸',
      startDate: new Date(Date.now() - 45 * 86400000).toISOString(),
      targetDate: new Date(Date.now() + 120 * 86400000).toISOString(),
      routine: {
        frequency: 'customDays',
        preferredDays: [1, 2, 4, 6],
        preferredTime: '08:00 AM',
        targetDurationMinutes: 30,
        targetSessionsPerWeek: 4,
      },
      milestones: [
        {
          id: 'm1-1',
          goalId: 'goal-1',
          title: 'Foundational 500 Words & Core Grammar',
          description: 'Master top 500 frequent vocabulary words.',
          order: 1,
          isCompleted: true,
          actions: [
            {
              id: 'act-1',
              milestoneId: 'm1-1',
              goalId: 'goal-1',
              title: 'Review 50 flashcards (Anki)',
              estimatedMinutes: 20,
              preferredTime: '08:00 AM',
              priority: 'high',
              status: 'completed',
              completedAt: new Date(Date.now() - 15 * 86400000).toISOString(),
            },
            {
              id: 'act-2',
              milestoneId: 'm1-1',
              goalId: 'goal-1',
              title: 'Complete Subjunctive Verb workbook',
              estimatedMinutes: 30,
              preferredTime: '08:30 AM',
              priority: 'medium',
              status: 'completed',
              completedAt: new Date(Date.now() - 10 * 86400000).toISOString(),
            },
          ],
        },
        {
          id: 'm1-2',
          goalId: 'goal-1',
          title: 'Conversational Fluency & Listening Sprint',
          description: 'Listen to native podcasts and practice 1-on-1 speaking twice a week.',
          order: 2,
          isCompleted: false,
          actions: [
            {
              id: 'act-3',
              milestoneId: 'm1-2',
              goalId: 'goal-1',
              title: '30m iTalki tutor conversation',
              estimatedMinutes: 30,
              preferredTime: '08:00 AM',
              priority: 'high',
              status: 'upcoming',
            },
            {
              id: 'act-4',
              milestoneId: 'm1-2',
              goalId: 'goal-1',
              title: 'Listen to Radio Ambulante podcast episode',
              estimatedMinutes: 25,
              preferredTime: '06:00 PM',
              priority: 'medium',
              status: 'upcoming',
            },
          ],
        },
      ],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    const g2: GoalEntity = {
      id: 'goal-2',
      userId: demoUser.id,
      title: 'Run First Sub-4-Hour Marathon',
      description: 'Complete 42.2km marathon with sustained 5:40 min/km pace.',
      whyItMatters: 'Build peak cardiovascular fitness, mental resilience, and lifelong discipline.',
      category: 'health',
      status: 'active',
      iconEmoji: '🏃‍♂️',
      startDate: new Date(Date.now() - 60 * 86400000).toISOString(),
      targetDate: new Date(Date.now() + 90 * 86400000).toISOString(),
      routine: {
        frequency: 'customDays',
        preferredDays: [1, 3, 5, 7],
        preferredTime: '06:30 AM',
        targetDurationMinutes: 60,
        targetSessionsPerWeek: 4,
      },
      milestones: [
        {
          id: 'm2-1',
          goalId: 'goal-2',
          title: 'Base Aerobic Capacity (15km Long Runs)',
          description: 'Consistently log 40km weekly volume.',
          order: 1,
          isCompleted: true,
          actions: [
            {
              id: 'act-7',
              milestoneId: 'm2-1',
              goalId: 'goal-2',
              title: '15km Sunday endurance run',
              estimatedMinutes: 85,
              preferredTime: '06:30 AM',
              priority: 'high',
              status: 'completed',
            },
          ],
        },
      ],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    this.goals.push(g1, g2);

    // Consistency seed
    for (let i = 27; i >= 0; i--) {
      const d = new Date(Date.now() - i * 86400000);
      const isWeekend = d.getDay() === 0 || d.getDay() === 6;
      const planned = isWeekend ? 1 : 3;
      const completed = (i % 7 === 3) ? 1 : planned;
      this.consistency.push({
        date: d.toISOString().split('T')[0],
        completedActions: completed,
        plannedActions: planned,
        totalMinutesSpent: completed * 35,
      });
    }

    // Reflection seed
    this.reflections.push({
      id: 'refl-1',
      userId: demoUser.id,
      weekStartDate: new Date(Date.now() - 7 * 86400000).toISOString(),
      weekEndDate: new Date().toISOString(),
      whatWentWell: 'Completed all marathon tempo runs on schedule and maintained morning Spanish practice without skipping.',
      whatWasDifficult: 'Midweek fatigue made late evening SaaS coding sessions harder to focus on.',
      nextWeekFocus: 'Shift SaaS deep work to early Saturday morning and complete Stripe checkout flow.',
      consistencyScore: 0.88,
      strongestCategory: 'Health & Fitness',
      createdAt: new Date().toISOString(),
    });
  }
}

export const db = new DatabaseStore();

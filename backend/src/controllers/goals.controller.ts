import { Response } from 'express';
import { db, GoalEntity, MilestoneEntity, ActionEntity } from '../db';
import { AuthRequest } from '../middleware/auth.middleware';

export class GoalsController {
  static async getGoals(req: AuthRequest, res: Response) {
    const userGoals = db.goals.filter((g) => g.userId === req.userId || g.userId === 'usr-demo-1');
    return res.json(userGoals);
  }

  static async getGoalById(req: AuthRequest, res: Response) {
    const goal = db.goals.find((g) => g.id === req.params.id);
    if (!goal) return res.status(404).json({ error: 'Goal not found' });
    return res.json(goal);
  }

  static async createGoal(req: AuthRequest, res: Response) {
    const { title, description, whyItMatters, category, iconEmoji, targetDate, routine, initialMilestone, initialAction } = req.body;
    if (!title) return res.status(400).json({ error: 'Goal title is required' });

    const goalId = `goal-${Date.now()}`;
    const milestoneId = `m-${Date.now()}`;
    const actionId = `act-${Date.now()}`;

    const newGoal: GoalEntity = {
      id: goalId,
      userId: req.userId || 'usr-demo-1',
      title,
      description: description || '',
      whyItMatters: whyItMatters || '',
      category: category || 'personal',
      status: 'active',
      iconEmoji: iconEmoji || '🎯',
      startDate: new Date().toISOString(),
      targetDate: targetDate || new Date(Date.now() + 180 * 86400000).toISOString(),
      routine: routine || {
        frequency: 'customDays',
        preferredDays: [1, 3, 5],
        preferredTime: '08:00 AM',
        targetDurationMinutes: 45,
        targetSessionsPerWeek: 3,
      },
      milestones: [
        {
          id: milestoneId,
          goalId,
          title: initialMilestone || 'Foundational Stage 1',
          description: 'Establish foundational routines and milestones.',
          order: 1,
          isCompleted: false,
          actions: [
            {
              id: actionId,
              milestoneId,
              goalId,
              title: initialAction || 'First step towards goal',
              estimatedMinutes: 30,
              preferredTime: '08:00 AM',
              priority: 'high',
              status: 'upcoming',
            },
          ],
        },
      ],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    db.goals.unshift(newGoal);
    return res.status(201).json(newGoal);
  }

  static async deleteGoal(req: AuthRequest, res: Response) {
    const idx = db.goals.findIndex((g) => g.id === req.params.id);
    if (idx === -1) return res.status(404).json({ error: 'Goal not found' });
    db.goals.splice(idx, 1);
    return res.json({ message: 'Goal deleted successfully' });
  }

  static async addMilestone(req: AuthRequest, res: Response) {
    const goal = db.goals.find((g) => g.id === req.params.id);
    if (!goal) return res.status(404).json({ error: 'Goal not found' });

    const { title, description } = req.body;
    if (!title) return res.status(400).json({ error: 'Milestone title is required' });

    const newMilestone: MilestoneEntity = {
      id: `m-${Date.now()}`,
      goalId: goal.id,
      title,
      description: description || '',
      order: goal.milestones.length + 1,
      isCompleted: false,
      actions: [],
    };
    goal.milestones.push(newMilestone);
    return res.status(201).json(newMilestone);
  }

  static async addAction(req: AuthRequest, res: Response) {
    const { goalId, milestoneId } = req.params;
    const goal = db.goals.find((g) => g.id === goalId);
    if (!goal) return res.status(404).json({ error: 'Goal not found' });

    const milestone = goal.milestones.find((m) => m.id === milestoneId);
    if (!milestone) return res.status(404).json({ error: 'Milestone not found' });

    const { title, estimatedMinutes, preferredTime, priority } = req.body;
    if (!title) return res.status(400).json({ error: 'Action title is required' });

    const newAction: ActionEntity = {
      id: `act-${Date.now()}`,
      milestoneId,
      goalId,
      title,
      estimatedMinutes: estimatedMinutes || 30,
      preferredTime: preferredTime || '08:00 AM',
      priority: priority || 'medium',
      status: 'upcoming',
    };
    milestone.actions.push(newAction);
    return res.status(201).json(newAction);
  }

  static async toggleAction(req: AuthRequest, res: Response) {
    const { actionId } = req.params;
    let targetAction: ActionEntity | null = null;
    let parentMilestone: MilestoneEntity | null = null;

    for (const g of db.goals) {
      for (const m of g.milestones) {
        for (const a of m.actions) {
          if (a.id === actionId) {
            targetAction = a;
            parentMilestone = m;
            break;
          }
        }
      }
    }

    if (!targetAction || !parentMilestone) {
      return res.status(404).json({ error: 'Action not found' });
    }

    targetAction.status = targetAction.status === 'completed' ? 'upcoming' : 'completed';
    targetAction.completedAt = targetAction.status === 'completed' ? new Date().toISOString() : undefined;

    // Check if milestone is completed
    const allDone = parentMilestone.actions.length > 0 && parentMilestone.actions.every((a) => a.status === 'completed');
    parentMilestone.isCompleted = allDone;

    return res.json({ action: targetAction, milestone: parentMilestone });
  }

  static async getTodayActions(req: AuthRequest, res: Response) {
    const userGoals = db.goals.filter((g) => g.userId === req.userId || g.userId === 'usr-demo-1');
    const actions: ActionEntity[] = [];
    userGoals.forEach((g) => {
      g.milestones.forEach((m) => {
        m.actions.forEach((a) => actions.push(a));
      });
    });
    return res.json(actions);
  }
}

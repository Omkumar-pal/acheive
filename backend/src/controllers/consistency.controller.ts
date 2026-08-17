import { Response } from 'express';
import { db } from '../db';
import { AuthRequest } from '../middleware/auth.middleware';

export class ConsistencyController {
  static async getHistory(req: AuthRequest, res: Response) {
    return res.json(db.consistency);
  }

  static async logToday(req: AuthRequest, res: Response) {
    const { completedActions, plannedActions, minutesSpent } = req.body;
    const todayStr = new Date().toISOString().split('T')[0];

    let todayEntry = db.consistency.find((d) => d.date === todayStr);
    if (todayEntry) {
      todayEntry.completedActions = completedActions ?? todayEntry.completedActions;
      todayEntry.plannedActions = plannedActions ?? todayEntry.plannedActions;
      todayEntry.totalMinutesSpent = minutesSpent ?? todayEntry.totalMinutesSpent;
    } else {
      todayEntry = {
        date: todayStr,
        completedActions: completedActions || 0,
        plannedActions: plannedActions || 3,
        totalMinutesSpent: minutesSpent || 0,
      };
      db.consistency.push(todayEntry);
    }
    return res.json(todayEntry);
  }
}

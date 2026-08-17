import { Response } from 'express';
import { db, ReflectionEntity } from '../db';
import { AuthRequest } from '../middleware/auth.middleware';

export class ReflectionController {
  static async getLatest(req: AuthRequest, res: Response) {
    const latest = db.reflections[db.reflections.length - 1];
    if (!latest) {
      return res.json({
        id: 'refl-empty',
        userId: req.userId || 'usr-demo-1',
        weekStartDate: new Date(Date.now() - 7 * 86400000).toISOString(),
        weekEndDate: new Date().toISOString(),
        whatWentWell: '',
        whatWasDifficult: '',
        nextWeekFocus: '',
        consistencyScore: 0.85,
        strongestCategory: 'Personal',
        createdAt: new Date().toISOString(),
      });
    }
    return res.json(latest);
  }

  static async saveReflection(req: AuthRequest, res: Response) {
    const { whatWentWell, whatWasDifficult, nextWeekFocus } = req.body;
    const latest = db.reflections[db.reflections.length - 1];

    if (latest) {
      latest.whatWentWell = whatWentWell ?? latest.whatWentWell;
      latest.whatWasDifficult = whatWasDifficult ?? latest.whatWasDifficult;
      latest.nextWeekFocus = nextWeekFocus ?? latest.nextWeekFocus;
      return res.json(latest);
    }

    const newRefl: ReflectionEntity = {
      id: `refl-${Date.now()}`,
      userId: req.userId || 'usr-demo-1',
      weekStartDate: new Date(Date.now() - 7 * 86400000).toISOString(),
      weekEndDate: new Date().toISOString(),
      whatWentWell: whatWentWell || '',
      whatWasDifficult: whatWasDifficult || '',
      nextWeekFocus: nextWeekFocus || '',
      consistencyScore: 0.88,
      strongestCategory: 'Health & Fitness',
      createdAt: new Date().toISOString(),
    };
    db.reflections.push(newRefl);
    return res.json(newRefl);
  }
}

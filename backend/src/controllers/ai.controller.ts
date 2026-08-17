import { Response } from 'express';
import { db } from '../db';
import { AuthRequest } from '../middleware/auth.middleware';
import { AiSynthesisService } from '../services/ai_synthesis.service';

export class AiController {
  static async generateReflection(req: AuthRequest, res: Response) {
    try {
      const userGoals = db.goals.filter((g) => g.userId === req.userId || g.userId === 'usr-demo-1');
      const consistency = db.consistency;

      const aiResult = await AiSynthesisService.synthesizeReflection(userGoals, consistency);

      // Optionally persist to reflections
      const latest = db.reflections[db.reflections.length - 1];
      if (latest) {
        latest.whatWentWell = aiResult.whatWentWell;
        latest.whatWasDifficult = aiResult.whatWasDifficult;
        latest.nextWeekFocus = aiResult.nextWeekFocus;
      }

      return res.json(aiResult);
    } catch (err: any) {
      return res.status(500).json({ error: 'Failed to generate AI reflection', details: err.message });
    }
  }
}

import { GoalEntity, ConsistencyDayEntity } from '../db';

export interface AiReflectionPayload {
  whatWentWell: string;
  whatWasDifficult: string;
  nextWeekFocus: string;
  momentumScore: number;
  keyInsight: string;
}

export class AiSynthesisService {
  static async synthesizeReflection(
    goals: GoalEntity[],
    consistency: ConsistencyDayEntity[]
  ): Promise<AiReflectionPayload> {
    let totalCompleted = 0;
    let totalActions = 0;
    const catMap: Record<string, number> = {};
    const topGoals: string[] = [];

    goals.forEach((g) => {
      let gDone = 0;
      g.milestones.forEach((m) => {
        m.actions.forEach((a) => {
          totalActions++;
          if (a.status === 'completed') {
            gDone++;
            totalCompleted++;
          }
        });
      });
      if (gDone > 0) {
        topGoals.push(g.title);
        catMap[g.category] = (catMap[g.category] || 0) + gDone;
      }
    });

    let topCategory = 'Personal Development';
    let maxCat = 0;
    for (const [cat, count] of Object.entries(catMap)) {
      if (count > maxCat) {
        maxCat = count;
        topCategory = cat.charAt(0).toUpperCase() + cat.slice(1);
      }
    }

    const activeDays = consistency.filter((d) => d.completedActions > 0).length;
    const score = consistency.length === 0 ? 0.85 : Math.round((activeDays / consistency.length) * 100) / 100;

    let well = '';
    let diff = '';
    let focus = '';
    let insight = '';

    if (score >= 0.75) {
      well = `Maintained steady discipline with ${totalCompleted} actions completed across ${topGoals.slice(0, 2).join(' and ')}. Consistency in ${topCategory} was exceptional.`;
      diff = `Managing energy dips during midweek late sessions required extra willpower.`;
      focus = `Unlock the next milestone in ${topGoals[0] || 'primary goal'} by batching routines into morning peak focus windows.`;
      insight = `You are executing at ${Math.round(score * 100)}% consistency. The habit foundation is locked in; focus on deepening milestone impact.`;
    } else {
      well = `Completed foundational steps for ${topGoals.slice(0, 2).join(' and ')}.`;
      diff = `Inconsistent scheduling and fatigue caused missed planned actions during the latter half of the week.`;
      focus = `Simplify daily actions to 20-minute micro-sessions to reinforce the baseline routine before scaling difficulty.`;
      insight = `Momentum comes from lowering starting friction. Aim for 3 uninterrupted 20-minute sessions next week.`;
    }

    return {
      whatWentWell: well,
      whatWasDifficult: diff,
      nextWeekFocus: focus,
      momentumScore: score,
      keyInsight: insight,
    };
  }
}

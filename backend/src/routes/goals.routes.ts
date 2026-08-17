import { Router } from 'express';
import { GoalsController } from '../controllers/goals.controller';
import { authMiddleware } from '../middleware/auth.middleware';

const router = Router();

router.use(authMiddleware);

router.get('/', GoalsController.getGoals);
router.post('/', GoalsController.createGoal);
router.get('/today-actions', GoalsController.getTodayActions);
router.get('/:id', GoalsController.getGoalById);
router.delete('/:id', GoalsController.deleteGoal);

router.post('/:id/milestones', GoalsController.addMilestone);
router.post('/:goalId/milestones/:milestoneId/actions', GoalsController.addAction);
router.patch('/actions/:actionId/toggle', GoalsController.toggleAction);

export default router;

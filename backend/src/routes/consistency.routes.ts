import { Router } from 'express';
import { ConsistencyController } from '../controllers/consistency.controller';
import { authMiddleware } from '../middleware/auth.middleware';

const router = Router();
router.use(authMiddleware);

router.get('/history', ConsistencyController.getHistory);
router.post('/today', ConsistencyController.logToday);

export default router;

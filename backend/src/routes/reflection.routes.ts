import { Router } from 'express';
import { ReflectionController } from '../controllers/reflection.controller';
import { authMiddleware } from '../middleware/auth.middleware';

const router = Router();
router.use(authMiddleware);

router.get('/latest', ReflectionController.getLatest);
router.post('/save', ReflectionController.saveReflection);

export default router;

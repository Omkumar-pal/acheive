import { Router } from 'express';
import authRoutes from './auth.routes';
import goalsRoutes from './goals.routes';
import consistencyRoutes from './consistency.routes';
import reflectionRoutes from './reflection.routes';
import aiRoutes from './ai.routes';

const router = Router();

router.get('/health', (req, res) => {
  res.json({ status: 'ok', time: new Date().toISOString(), service: 'Achieve Backend API' });
});

router.use('/auth', authRoutes);
router.use('/goals', goalsRoutes);
router.use('/consistency', consistencyRoutes);
router.use('/reflections', reflectionRoutes);
router.use('/ai', aiRoutes);

export default router;

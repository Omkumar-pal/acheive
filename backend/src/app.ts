import express from 'express';
import cors from 'cors';
import routes from './routes';

export function createApp() {
  const app = express();

  app.use(cors());
  app.use(express.json());

  // Mount API routes
  app.use('/api', routes);

  // Global Error Handler
  app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
    console.error('Unhandled Server Error:', err);
    res.status(500).json({ error: 'Internal Server Error', message: err.message });
  });

  return app;
}

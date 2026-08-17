import { createApp } from './app';

const PORT = process.env.PORT || 5088;
const app = createApp();

app.listen(PORT, () => {
  console.log(`🚀 Achieve Backend API running on http://localhost:${PORT}/api`);
  console.log(`Health check: http://localhost:${PORT}/api/health`);
});

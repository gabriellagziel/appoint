export default function handler(req, res) {
  res.status(200).json({
    status: 'ok',
    app: 'marketing',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    env: process.env.NODE_ENV
  });
}

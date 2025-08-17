export default function handler(req, res) {
  res.status(200).json({
    status: 'ok',
    app: 'business',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    env: process.env.NODE_ENV
  });
}

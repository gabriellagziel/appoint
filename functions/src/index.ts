import express from 'express';

// Create Express app
const app = express();
const port = process.env.PORT || 8080;

// Add error handling middleware
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error('Error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

// Health check endpoints
app.get('/health/liveness', (req, res) => {
  res.status(200).json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    service: 'appoint-functions',
    type: 'liveness'
  });
});

app.get('/health/readiness', (req, res) => {
  res.status(200).json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    service: 'appoint-functions',
    type: 'readiness'
  });
});

// API routes
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    service: 'appoint-functions',
    message: 'API is running'
  });
});

// Default route
app.get('/', (req, res) => {
  res.json({
    status: 'ok',
    service: 'appoint-functions',
    message: 'API is running'
  });
});

// Start server with error handling
const server = app.listen(port, () => {
  console.log(`Server running on port ${port}`);
}).on('error', (err) => {
  console.error('Server error:', err);
  process.exit(1);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  server.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});

// Export for compatibility
export { app };

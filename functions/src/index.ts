import * as admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';

// Ensure admin sdk is initialised safely
if (!admin.apps.length) {
  admin.initializeApp();
}

// Simple health check function
export const healthCheck = onRequest((req, res) => {
  res.status(200).json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    service: 'firebase-functions'
  });
});

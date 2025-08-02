import * as admin from 'firebase-admin';
import app from './minimal-server';

// Ensure admin sdk is initialised safely
if (!admin.apps.length) {
  admin.initializeApp();
}

// Export the Express app for DigitalOcean App Platform
export default app;

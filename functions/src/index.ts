import * as admin from 'firebase-admin';

// Initialize Firebase Admin only once
if (!admin.apps.length) {
  admin.initializeApp();
}

// Import from modular structure
export * from './ambassadors';
export * from './stripe';
export * from './validation';

// Re-export for backward compatibility
export { ambassadorQuotas } from './ambassadors'; 
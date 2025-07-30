import * as admin from 'firebase-admin';

// Initialize Firebase Admin only once
if (!admin.apps.length) {
  admin.initializeApp();
}

// Import from modular structure
export * from './ambassadors';
export * from './stripe';
export * from './validation';
export * from './businessApi';
export * from './billingEngine';
export * from './analytics';
export * from './ics';
export * from './webhooks';
export * from './oauth';
export * from './alerts';
export * from './health';

// Re-export for backward compatibility
export { ambassadorQuotas } from './ambassadors'; 
import * as admin from 'firebase-admin';

// Ensure admin sdk is initialised safely
if (!admin.apps.length) {
  admin.initializeApp();
}

// Export all Enterprise API functions
export { generateMapOverageInvoice, importBankPayments, monthlyBillingJob, monthlyMapOverageBilling, resetMapUsageForNewPeriod } from './billingEngine';
export { businessApi, registerBusiness, resetMonthlyQuotas } from './businessApi';
export { sendApiKeyEmail, sendInvoiceEmail, sendWelcomeEmail } from './emailService';
export { icsFeed, rotateIcsToken } from './ics';
export { oauth } from './oauth';
export { confirmSession, createCheckoutSession } from './stripe';

// Health check functions
export { liveness, readiness } from './health';

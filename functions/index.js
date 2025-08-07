// Import from modular TypeScript structure
const { 
  onNewBooking,
  createCheckoutSession,
  cancelSubscription,
  sendNotificationToStudio,
  stripeWebhook,
  registerBusiness,
  businessApi,
  resetMonthlyQuotas,
  monthlyBillingJob,
  importBankPayments,
  getUsageStats,
  downloadUsageCSV,
  adminAnalyticsSummary,
  exportYearlyTax,
  icsFeed,
  rotateIcsToken,
  onAppointmentWrite,
  processWebhookRetries,
  oauth,
  hourlyAlerts,
} = require('./src/index');

const {
  autoAssignAmbassadors,
  getQuotaStats,
  assignAmbassador,
  scheduledAutoAssign,
  dailyQuotaReport,
  checkAmbassadorEligibility,
  handleAmbassadorRemoval,
  ambassadorQuotas,
} = require('./src/ambassadors');

const {
  createCheckoutSession: stripeCreateCheckoutSession,
} = require('./src/stripe');

const functions = require('firebase-functions');

// Health check endpoint
const health = functions.https.onRequest((req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'app-oint-api'
  });
});

// Export all functions
module.exports = {
  // Health check
  health,
  
  // FCM and Booking functions
  onNewBooking,
  
  // Stripe functions
  createCheckoutSession,
  stripeCreateCheckoutSession,
  stripeWebhook,
  cancelSubscription,
  
  // Ambassador functions
  autoAssignAmbassadors,
  getQuotaStats,
  assignAmbassador,
  scheduledAutoAssign,
  dailyQuotaReport,
  checkAmbassadorEligibility,
  handleAmbassadorRemoval,
  ambassadorQuotas,
  
  // Notification functions
  sendNotificationToStudio,

  // Business API
  registerBusiness,
  businessApi,
  resetMonthlyQuotas,
  monthlyBillingJob,
  importBankPayments,
  getUsageStats,
  downloadUsageCSV,
  adminAnalyticsSummary,
  exportYearlyTax,
  icsFeed,
  rotateIcsToken,
  onAppointmentWrite,
  processWebhookRetries,
  oauth,
  hourlyAlerts,
}; 
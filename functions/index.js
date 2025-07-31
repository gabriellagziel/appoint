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

// Import enhanced health endpoints
const { health, liveness, readiness, status } = require('./src/health');

// Import metrics endpoints
const { metrics, metricsJson } = require('./src/metrics');

// Export all functions
module.exports = {
  // Health check endpoints
  health,
  liveness,
  readiness,
  status,
  
  // Metrics endpoints
  metrics,
  metricsJson,
  
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
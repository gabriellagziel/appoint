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

// Export all functions
module.exports = {
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
}; 
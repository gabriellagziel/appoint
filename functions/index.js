#!/usr/bin/env node

// Check if we're running in Firebase Functions environment
const isFirebaseFunctions = process.env.FUNCTIONS_EMULATOR || process.env.GCLOUD_PROJECT;

if (isFirebaseFunctions) {
  // Firebase Functions mode - use the original Firebase Functions exports
  const functions = require('firebase-functions');
  
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
    dailyAmbassadorEligibilityCheck,
    monthlyAmbassadorReview,
    trackUserReferral,
    getAmbassadorDashboard,
  } = require('./src/ambassador-automation');

  const {
    createCheckoutSession: stripeCreateCheckoutSession,
  } = require('./src/stripe');

  // Health check endpoint for Firebase Functions
  const health = functions.https.onRequest((req, res) => {
    res.status(200).json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      service: 'app-oint-api'
    });
  });

  // Export all Firebase Functions
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
    
    // Ambassador automation functions
    dailyAmbassadorEligibilityCheck,
    monthlyAmbassadorReview,
    trackUserReferral,
    getAmbassadorDashboard,
    
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
} else {
  // Containerized mode - use Express.js server
  console.log('Starting Functions API in containerized mode...');
  require('./dist/server.js');
} 
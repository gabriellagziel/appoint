"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.readiness = exports.liveness = exports.createCheckoutSession = exports.confirmSession = exports.oauth = exports.rotateIcsToken = exports.icsFeed = exports.resetMonthlyQuotas = exports.registerBusiness = exports.businessApi = exports.resetMapUsageForNewPeriod = exports.monthlyMapOverageBilling = exports.monthlyBillingJob = exports.importBankPayments = exports.generateMapOverageInvoice = void 0;
const admin = __importStar(require("firebase-admin"));
// Ensure admin sdk is initialised safely
if (!admin.apps.length) {
    admin.initializeApp();
}
// Export all Enterprise API functions
var billingEngine_1 = require("./billingEngine");
Object.defineProperty(exports, "generateMapOverageInvoice", { enumerable: true, get: function () { return billingEngine_1.generateMapOverageInvoice; } });
Object.defineProperty(exports, "importBankPayments", { enumerable: true, get: function () { return billingEngine_1.importBankPayments; } });
Object.defineProperty(exports, "monthlyBillingJob", { enumerable: true, get: function () { return billingEngine_1.monthlyBillingJob; } });
Object.defineProperty(exports, "monthlyMapOverageBilling", { enumerable: true, get: function () { return billingEngine_1.monthlyMapOverageBilling; } });
Object.defineProperty(exports, "resetMapUsageForNewPeriod", { enumerable: true, get: function () { return billingEngine_1.resetMapUsageForNewPeriod; } });
var businessApi_1 = require("./businessApi");
Object.defineProperty(exports, "businessApi", { enumerable: true, get: function () { return businessApi_1.businessApi; } });
Object.defineProperty(exports, "registerBusiness", { enumerable: true, get: function () { return businessApi_1.registerBusiness; } });
Object.defineProperty(exports, "resetMonthlyQuotas", { enumerable: true, get: function () { return businessApi_1.resetMonthlyQuotas; } });
var ics_1 = require("./ics");
Object.defineProperty(exports, "icsFeed", { enumerable: true, get: function () { return ics_1.icsFeed; } });
Object.defineProperty(exports, "rotateIcsToken", { enumerable: true, get: function () { return ics_1.rotateIcsToken; } });
var oauth_1 = require("./oauth");
Object.defineProperty(exports, "oauth", { enumerable: true, get: function () { return oauth_1.oauth; } });
var stripe_1 = require("./stripe");
Object.defineProperty(exports, "confirmSession", { enumerable: true, get: function () { return stripe_1.confirmSession; } });
Object.defineProperty(exports, "createCheckoutSession", { enumerable: true, get: function () { return stripe_1.createCheckoutSession; } });
// Health check functions
var health_1 = require("./health");
Object.defineProperty(exports, "liveness", { enumerable: true, get: function () { return health_1.liveness; } });
Object.defineProperty(exports, "readiness", { enumerable: true, get: function () { return health_1.readiness; } });

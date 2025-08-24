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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.hourlyAlerts = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
const node_fetch_1 = __importDefault(require("node-fetch"));
if (!admin.apps.length) {
    admin.initializeApp();
}
const db = admin.firestore();
const BUSINESS_COLLECTION = 'business_accounts';
const USAGE_COLLECTION = 'usage_logs';
const INVOICE_COLLECTION = 'invoices';
const SLACK_URL = process.env.SLACK_ALERTS_URL;
function sendAlert(message) {
    if (SLACK_URL) {
        return (0, node_fetch_1.default)(SLACK_URL, { method: 'POST', body: JSON.stringify({ text: message }), headers: { 'Content-Type': 'application/json' } });
    }
    console.log('ALERT:', message);
}
exports.hourlyAlerts = functions.pubsub.schedule('every 60 minutes').onRun(async () => {
    const now = admin.firestore.Timestamp.now();
    // Quota near limit
    const bizSnap = await db.collection(BUSINESS_COLLECTION).get();
    for (const doc of bizSnap.docs) {
        const data = doc.data();
        if (data.monthlyQuota && data.usageThisMonth >= data.monthlyQuota * 0.9 && !data.quotaAlertSent) {
            await sendAlert(`Business ${data.name} is over 90% of quota.`);
            await doc.ref.update({ quotaAlertSent: true });
        }
    }
    // Overdue invoices
    const overdueSnap = await db.collection(INVOICE_COLLECTION).where('status', '==', 'pending').where('dueDate', '<=', new Date()).get();
    overdueSnap.forEach((d) => sendAlert(`Invoice ${d.id} is overdue.`));
});

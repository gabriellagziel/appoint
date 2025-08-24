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
exports.exportYearlyTax = exports.adminAnalyticsSummary = exports.downloadUsageCSV = exports.getUsageStats = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
const json2csv_1 = require("json2csv");
const archiver_1 = __importDefault(require("archiver"));
const exceljs_1 = __importDefault(require("exceljs"));
if (!admin.apps.length) {
    admin.initializeApp();
}
const db = admin.firestore();
const storage = admin.storage().bucket();
const USAGE_COLLECTION = 'usage_logs';
const INVOICE_COLLECTION = 'invoices';
const BUSINESS_COLLECTION = 'business_accounts';
/**
 * Helper to require authenticated business via API key in header.
 */
async function requireBusiness(req) {
    const apiKey = (req.headers['x-api-key'] || req.headers['api-key']);
    if (!apiKey) {
        throw new functions.https.HttpsError('unauthenticated', 'API key missing');
    }
    const snap = await db.collection(BUSINESS_COLLECTION).where('apiKey', '==', apiKey).limit(1).get();
    if (snap.empty) {
        throw new functions.https.HttpsError('unauthenticated', 'Invalid API key');
    }
    return { id: snap.docs[0].id, data: snap.docs[0].data() };
}
// Business facing usage stats
exports.getUsageStats = functions.https.onRequest(async (req, res) => {
    try {
        const business = await requireBusiness(req);
        const { month, year } = req.query;
        const now = new Date();
        const y = year ? Number(year) : now.getUTCFullYear();
        const m = month ? Number(month) - 1 : now.getUTCMonth();
        const start = new Date(Date.UTC(y, m, 1));
        const end = new Date(Date.UTC(y, m + 1, 0, 23, 59, 59));
        const usageSnap = await db
            .collection(USAGE_COLLECTION)
            .where('businessId', '==', business.id)
            .where('timestamp', '>=', start)
            .where('timestamp', '<=', end)
            .get();
        let total = 0;
        const endpointCounts = {};
        usageSnap.forEach((doc) => {
            total += 1;
            const data = doc.data();
            const ep = data.endpoint;
            endpointCounts[ep] = (endpointCounts[ep] || 0) + 1;
        });
        res.json({ total, breakdown: endpointCounts, periodStart: start, periodEnd: end });
    }
    catch (err) {
        console.error('getUsageStats error', err);
        res.status(err.httpStatus || 500).json({ error: err.message || 'Internal' });
    }
});
// Download CSV usage report
exports.downloadUsageCSV = functions.https.onRequest(async (req, res) => {
    try {
        const business = await requireBusiness(req);
        const { month, year } = req.query;
        const now = new Date();
        const y = year ? Number(year) : now.getUTCFullYear();
        const m = month ? Number(month) - 1 : now.getUTCMonth();
        const start = new Date(Date.UTC(y, m, 1));
        const end = new Date(Date.UTC(y, m + 1, 0, 23, 59, 59));
        const usageSnap = await db
            .collection(USAGE_COLLECTION)
            .where('businessId', '==', business.id)
            .where('timestamp', '>=', start)
            .where('timestamp', '<=', end)
            .get();
        const rows = usageSnap.docs.map((d) => {
            const data = d.data();
            return {
                timestamp: (data.timestamp?.toDate?.() || new Date()).toISOString(),
                endpoint: data.endpoint,
                success: data.success ? 1 : 0,
                latency_ms: data.latencyMs || '',
            };
        });
        const parser = new json2csv_1.Parser({ fields: ['timestamp', 'endpoint', 'success', 'latency_ms'] });
        const csv = parser.parse(rows);
        res.setHeader('Content-Type', 'text/csv');
        res.setHeader('Content-Disposition', `attachment; filename="usage-${y}-${(m + 1).toString().padStart(2, '0')}.csv"`);
        res.send(csv);
    }
    catch (err) {
        console.error('downloadUsageCSV error', err);
        res.status(err.httpStatus || 500).json({ error: err.message || 'Internal' });
    }
});
// Admin analytics summary
exports.adminAnalyticsSummary = functions.https.onRequest(async (req, res) => {
    // Admin auth check implementation - see ticket #ANA-001
    try {
        const { month, year } = req.query;
        const now = new Date();
        const y = year ? Number(year) : now.getUTCFullYear();
        const m = month ? Number(month) - 1 : now.getUTCMonth();
        const start = new Date(Date.UTC(y, m, 1));
        const end = new Date(Date.UTC(y, m + 1, 0, 23, 59, 59));
        const usageSnap = await db
            .collection(USAGE_COLLECTION)
            .where('timestamp', '>=', start)
            .where('timestamp', '<=', end)
            .get();
        const usageByBusiness = {};
        const businessNames = {};
        usageSnap.forEach((doc) => {
            const data = doc.data();
            const bId = data.businessId;
            usageByBusiness[bId] = (usageByBusiness[bId] || 0) + 1;
        });
        const top = Object.entries(usageByBusiness)
            .sort((a, b) => b[1] - a[1])
            .slice(0, 10);
        // Total revenue from invoices
        const invoicesSnap = await db
            .collection(INVOICE_COLLECTION)
            .where('periodStart', '>=', start)
            .where('periodEnd', '<=', end)
            .get();
        let revenue = 0;
        invoicesSnap.forEach((i) => {
            revenue += i.data().amount || 0;
        });
        res.json({ totalCalls: usageSnap.size, revenue, topBusinesses: top });
    }
    catch (err) {
        console.error('adminAnalyticsSummary error', err);
        res.status(500).json({ error: err.message });
    }
});
// Yearly tax export ZIP
exports.exportYearlyTax = functions.https.onRequest(async (req, res) => {
    // Admin auth check - see ticket #ANA-001
    try {
        const { year } = req.query;
        const y = year ? Number(year) : new Date().getUTCFullYear() - 1;
        // Create archive
        const archive = (0, archiver_1.default)('zip');
        res.setHeader('Content-Type', 'application/zip');
        res.setHeader('Content-Disposition', `attachment; filename="tax-export-${y}.zip"`);
        archive.pipe(res);
        // Iterate businesses
        const businessesSnap = await db.collection(BUSINESS_COLLECTION).get();
        for (const bizDoc of businessesSnap.docs) {
            const bizId = bizDoc.id;
            const folder = `${bizId}/`;
            // Add invoices
            const invoicesSnap = await db
                .collection(INVOICE_COLLECTION)
                .where('businessId', '==', bizId)
                .where('periodStart', '>=', new Date(Date.UTC(y, 0, 1)))
                .where('periodEnd', '<=', new Date(Date.UTC(y, 11, 31, 23, 59, 59)))
                .get();
            for (const inv of invoicesSnap.docs) {
                const pdfUrl = inv.data().pdfUrl;
                if (pdfUrl) {
                    const response = await fetch(pdfUrl);
                    const buffer = await response.arrayBuffer();
                    archive.append(Buffer.from(buffer), { name: `${folder}invoice-${inv.id}.pdf` });
                }
            }
            // Usage CSVs
            const usageSnap = await db
                .collection(USAGE_COLLECTION)
                .where('businessId', '==', bizId)
                .where('timestamp', '>=', new Date(Date.UTC(y, 0, 1)))
                .where('timestamp', '<=', new Date(Date.UTC(y, 11, 31, 23, 59, 59)))
                .get();
            const rows = usageSnap.docs.map((d) => {
                const data = d.data();
                return {
                    timestamp: (data.timestamp?.toDate?.() || new Date()).toISOString(),
                    endpoint: data.endpoint,
                    success: data.success ? 1 : 0,
                    latency_ms: data.latencyMs || '',
                };
            });
            const parser = new json2csv_1.Parser({ fields: ['timestamp', 'endpoint', 'success', 'latency_ms'] });
            archive.append(parser.parse(rows), { name: `${folder}usage-${y}.csv` });
        }
        const workbook = new exceljs_1.default.Workbook();
        const sheet = workbook.addWorksheet('Summary');
        sheet.columns = [
            { header: 'Business ID', key: 'bid' },
            { header: 'Total Calls', key: 'calls' },
            { header: 'Total Revenue (€)', key: 'rev' },
        ];
        // Build summary
        const invoiceSnap = await db
            .collection(INVOICE_COLLECTION)
            .where('periodStart', '>=', new Date(Date.UTC(y, 0, 1)))
            .where('periodEnd', '<=', new Date(Date.UTC(y, 11, 31, 23, 59, 59)))
            .get();
        const revenueByBiz = {};
        invoiceSnap.forEach((d) => {
            const { businessId, amount } = d.data();
            revenueByBiz[businessId] = (revenueByBiz[businessId] || 0) + (amount || 0);
        });
        // Total calls from earlier loops maybe heavy; we recalc quickly
        const callsSnap = await db
            .collection(USAGE_COLLECTION)
            .where('timestamp', '>=', new Date(Date.UTC(y, 0, 1)))
            .where('timestamp', '<=', new Date(Date.UTC(y, 11, 31, 23, 59, 59)))
            .get();
        const callsByBiz = {};
        callsSnap.forEach((d) => {
            const bId = d.data().businessId;
            callsByBiz[bId] = (callsByBiz[bId] || 0) + 1;
        });
        Object.keys(revenueByBiz).forEach((bid) => {
            sheet.addRow({ bid, calls: callsByBiz[bid] || 0, rev: revenueByBiz[bid] });
        });
        const excelBuffer = await workbook.xlsx.writeBuffer();
        archive.append(Buffer.from(excelBuffer), { name: 'summary.xlsx' });
        await archive.finalize();
    }
    catch (err) {
        console.error('exportYearlyTax error', err);
        res.status(500).json({ error: err.message });
    }
});

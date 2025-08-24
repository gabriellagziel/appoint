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
exports.rotateIcsToken = exports.icsFeed = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
const ical_generator_1 = __importDefault(require("ical-generator"));
const uuid_1 = require("uuid");
if (!admin.apps.length) {
    admin.initializeApp();
}
const db = admin.firestore();
const BUSINESS_COLLECTION = 'business_accounts';
const APPOINTMENTS_COLLECTION = 'appointments';
/**
 * Generates an ICS calendar for a business identified by token.
 * URL example: https://<region>-<project>.cloudfunctions.net/icsFeed?token=abc123
 */
exports.icsFeed = functions.https.onRequest(async (req, res) => {
    try {
        const { token } = req.query;
        if (!token) {
            res.status(400).send('Missing token');
            return;
        }
        // Find business by token
        const snap = await db
            .collection(BUSINESS_COLLECTION)
            .where('icsToken', '==', token)
            .limit(1)
            .get();
        if (snap.empty) {
            res.status(404).send('Invalid token');
            return;
        }
        const businessId = snap.docs[0].id;
        // Fetch upcoming appointments (next 6 months)
        const now = new Date();
        const sixMonthsLater = new Date();
        sixMonthsLater.setMonth(now.getMonth() + 6);
        const apptSnap = await db
            .collection(APPOINTMENTS_COLLECTION)
            .where('businessId', '==', businessId)
            .where('start', '>=', now)
            .where('start', '<=', sixMonthsLater)
            .get();
        const cal = (0, ical_generator_1.default)({ name: 'App-Oint Appointments' });
        apptSnap.forEach((doc) => {
            const data = doc.data();
            cal.createEvent({
                id: doc.id,
                start: data.start.toDate ? data.start.toDate() : new Date(data.start),
                end: data.end ? (data.end.toDate ? data.end.toDate() : new Date(data.end)) : undefined,
                summary: data.title || 'Appointment',
                description: data.description || '',
                location: data.location || '',
            });
        });
        res.setHeader('Content-Type', 'text/calendar');
        res.send(cal.toString());
    }
    catch (err) {
        console.error('icsFeed error', err);
        res.status(500).send('Internal Server Error');
    }
});
/**
 * Callable HTTPS function (or REST) to rotate the ICS token for a business.
 * Expects { businessId } in body (admin) OR uses API key auth for business.
 */
exports.rotateIcsToken = functions.https.onRequest(async (req, res) => {
    try {
        if (req.method !== 'POST') {
            res.status(405).send('Method Not Allowed');
            return;
        }
        const { businessId } = req.body || {};
        let targetBusinessId = businessId;
        // If not provided, try API key auth
        if (!targetBusinessId) {
            const apiKey = (req.headers['x-api-key'] || req.headers['api-key']);
            if (!apiKey) {
                res.status(400).send('Missing businessId or API key');
                return;
            }
            const snap = await db.collection(BUSINESS_COLLECTION).where('apiKey', '==', apiKey).limit(1).get();
            if (snap.empty) {
                res.status(404).send('Business not found');
                return;
            }
            targetBusinessId = snap.docs[0].id;
        }
        const newToken = (0, uuid_1.v4)();
        await db.collection(BUSINESS_COLLECTION).doc(targetBusinessId).update({ icsToken: newToken });
        res.json({ token: newToken });
    }
    catch (err) {
        console.error('rotateIcsToken error', err);
        res.status(500).send('Internal');
    }
});

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
exports.analyticsToBigQuery = void 0;
const functions = __importStar(require("firebase-functions"));
const bigquery_1 = require("@google-cloud/bigquery");
const bq = new bigquery_1.BigQuery();
const DATASET = process.env.BQ_DATASET || 'app_oint';
const TABLE = process.env.BQ_TABLE || 'analytics_events';
exports.analyticsToBigQuery = functions.firestore
    .document('analytics_events/{uid}/events/{eventId}')
    .onCreate(async (snap, ctx) => {
    const { uid, eventId } = ctx.params;
    const data = snap.data() || {};
    const row = {
        event_id: eventId,
        uid: uid === '_anon' ? null : uid,
        name: data.name || null,
        ts: data.ts && typeof data.ts.toDate === 'function' ? data.ts.toDate() : new Date(),
        props_json: JSON.stringify(data.props || {}),
    };
    await bq.dataset(DATASET).table(TABLE).insert([row]);
});

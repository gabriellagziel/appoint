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
exports.oauth = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
const express_1 = __importDefault(require("express"));
const uuid_1 = require("uuid");
if (!admin.apps.length) {
    admin.initializeApp();
}
const db = admin.firestore();
const app = (0, express_1.default)();
app.use(express_1.default.urlencoded({ extended: true }));
app.use(express_1.default.json());
/* Helper to fetch client */
async function getClient(clientId) {
    const snap = await db.collection('oauth_clients').doc(clientId).get();
    if (!snap.exists)
        throw new Error('invalid_client');
    return { id: snap.id, ...snap.data() };
}
/* /oauth/authorize */
app.get('/authorize', async (req, res) => {
    const { client_id, redirect_uri, state, response_type } = req.query;
    try {
        const client = await getClient(client_id);
        if (client.redirectUri !== redirect_uri)
            throw new Error('invalid_redirect');
        // For demo – auto-approve and skip login (assumes user already authenticated)
        const code = (0, uuid_1.v4)();
        await db.collection('oauth_codes').doc(code).set({ clientId: client_id, createdAt: admin.firestore.FieldValue.serverTimestamp() });
        const url = new URL(redirect_uri);
        url.searchParams.set('code', code);
        if (state)
            url.searchParams.set('state', state);
        res.redirect(url.toString());
    }
    catch (err) {
        res.status(400).json({ error: err.message });
    }
});
/* /oauth/token */
app.post('/token', async (req, res) => {
    const { grant_type } = req.body;
    try {
        if (grant_type === 'authorization_code') {
            const { code, client_id, client_secret } = req.body;
            const client = await getClient(client_id);
            if (client.secret !== client_secret)
                throw new Error('invalid_client');
            const codeSnap = await db.collection('oauth_codes').doc(code).get();
            if (!codeSnap.exists)
                throw new Error('invalid_code');
            const accessToken = (0, uuid_1.v4)();
            const refreshToken = (0, uuid_1.v4)();
            await db.collection('oauth_tokens').doc(accessToken).set({ clientId: client_id, refreshToken, createdAt: admin.firestore.FieldValue.serverTimestamp() });
            res.json({ access_token: accessToken, refresh_token: refreshToken, token_type: 'bearer', expires_in: 3600 });
        }
        else if (grant_type === 'client_credentials') {
            const { client_id, client_secret } = req.body;
            const client = await getClient(client_id);
            if (client.secret !== client_secret)
                throw new Error('invalid_client');
            const accessToken = (0, uuid_1.v4)();
            await db.collection('oauth_tokens').doc(accessToken).set({ clientId: client_id, createdAt: admin.firestore.FieldValue.serverTimestamp() });
            res.json({ access_token: accessToken, token_type: 'bearer', expires_in: 3600 });
        }
        else if (grant_type === 'refresh_token') {
            const { refresh_token } = req.body;
            // Simple implementation – issue new access token
            const accessToken = (0, uuid_1.v4)();
            await db.collection('oauth_tokens').doc(accessToken).set({ refreshToken: refresh_token, createdAt: admin.firestore.FieldValue.serverTimestamp() });
            res.json({ access_token: accessToken, token_type: 'bearer', expires_in: 3600 });
        }
        else {
            throw new Error('unsupported_grant_type');
        }
    }
    catch (err) {
        res.status(400).json({ error: err.message });
    }
});
/* /oauth/revoke */
app.post('/revoke', async (req, res) => {
    const { token } = req.body;
    await db.collection('oauth_tokens').doc(token).delete();
    res.status(200).json({ success: true });
});
exports.oauth = functions.https.onRequest(app);

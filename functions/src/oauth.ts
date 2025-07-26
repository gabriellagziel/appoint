import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import express from 'express';
import { v4 as uuidv4 } from 'uuid';

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

const app = express();
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

/* Helper to fetch client */
async function getClient(clientId: string) {
  const snap = await db.collection('oauth_clients').doc(clientId).get();
  if (!snap.exists) throw new Error('invalid_client');
  return { id: snap.id, ...snap.data() } as any;
}

/* /oauth/authorize */
app.get('/authorize', async (req, res) => {
  const { client_id, redirect_uri, state, response_type } = req.query as any;

  try {
    const client = await getClient(client_id);
    if (client.redirectUri !== redirect_uri) throw new Error('invalid_redirect');

    // For demo – auto-approve and skip login (assumes user already authenticated)
    const code = uuidv4();
    await db.collection('oauth_codes').doc(code).set({ clientId: client_id, createdAt: admin.firestore.FieldValue.serverTimestamp() });

    const url = new URL(redirect_uri);
    url.searchParams.set('code', code);
    if (state) url.searchParams.set('state', state);
    res.redirect(url.toString());
  } catch (err) {
    res.status(400).json({ error: err instanceof Error ? err.message : String(err) });
  }
});

/* /oauth/token */
app.post('/token', async (req, res) => {
  const { grant_type } = req.body;
  try {
    if (grant_type === 'authorization_code') {
      const { code, client_id, client_secret } = req.body;
      const client = await getClient(client_id);
      if (client.secret !== client_secret) throw new Error('invalid_client');
      const codeSnap = await db.collection('oauth_codes').doc(code).get();
      if (!codeSnap.exists) throw new Error('invalid_code');

      const accessToken = uuidv4();
      const refreshToken = uuidv4();
      await db.collection('oauth_tokens').doc(accessToken).set({ clientId: client_id, refreshToken, createdAt: admin.firestore.FieldValue.serverTimestamp() });
      res.json({ access_token: accessToken, refresh_token: refreshToken, token_type: 'bearer', expires_in: 3600 });
    } else if (grant_type === 'client_credentials') {
      const { client_id, client_secret } = req.body;
      const client = await getClient(client_id);
      if (client.secret !== client_secret) throw new Error('invalid_client');
      const accessToken = uuidv4();
      await db.collection('oauth_tokens').doc(accessToken).set({ clientId: client_id, createdAt: admin.firestore.FieldValue.serverTimestamp() });
      res.json({ access_token: accessToken, token_type: 'bearer', expires_in: 3600 });
    } else if (grant_type === 'refresh_token') {
      const { refresh_token } = req.body;
      // Simple implementation – issue new access token
      const accessToken = uuidv4();
      await db.collection('oauth_tokens').doc(accessToken).set({ refreshToken: refresh_token, createdAt: admin.firestore.FieldValue.serverTimestamp() });
      res.json({ access_token: accessToken, token_type: 'bearer', expires_in: 3600 });
    } else {
      throw new Error('unsupported_grant_type');
    }
  } catch (err) {
    res.status(400).json({ error: err instanceof Error ? err.message : String(err) });
  }
});

/* /oauth/revoke */
app.post('/revoke', async (req, res) => {
  const { token } = req.body;
  await db.collection('oauth_tokens').doc(token).delete();
  res.status(200).json({ success: true });
});

export const oauth = functions.https.onRequest(app);
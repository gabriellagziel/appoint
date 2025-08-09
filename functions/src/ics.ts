import * as admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import ical from 'ical-generator';
import { v4 as uuidv4 } from 'uuid';
import { withRateLimit } from './middleware/rateLimit';

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
export const icsFeed = onRequest(async (req, res) => {
  try {
    const ip = (req.headers['x-forwarded-for'] as string) || req.ip || 'unknown';
    await withRateLimit(`ip:${ip}`, async () => Promise.resolve());
    const { token } = req.query as any;
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

    const cal = ical({ name: 'App-Oint Appointments' });

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
  } catch (err) {
    console.error('icsFeed error', err);
    res.status(500).send('Internal Server Error');
  }
});

/**
 * Callable HTTPS function (or REST) to rotate the ICS token for a business.
 * Expects { businessId } in body (admin) OR uses API key auth for business.
 */
export const rotateIcsToken = onRequest(async (req, res) => {
  try {
    if (req.method !== 'POST') {
      res.status(405).send('Method Not Allowed');
      return;
    }

    const { businessId } = req.body || {};

    // Rate limit per IP
    const ip = (req.headers['x-forwarded-for'] as string) || req.ip || 'unknown';
    await withRateLimit(`ip:${ip}`, async () => Promise.resolve());
    let targetBusinessId = businessId;

    // If not provided, try API key auth
    if (!targetBusinessId) {
      const apiKey = (req.headers['x-api-key'] || req.headers['api-key']) as string | undefined;
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

    const newToken = uuidv4();
    await db.collection(BUSINESS_COLLECTION).doc(targetBusinessId).update({ icsToken: newToken });
    res.json({ token: newToken });
  } catch (err) {
    console.error('rotateIcsToken error', err);
    res.status(500).send('Internal');
  }
});
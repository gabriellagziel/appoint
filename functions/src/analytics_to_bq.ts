import * as functions from 'firebase-functions';
import { BigQuery } from '@google-cloud/bigquery';

const bq = new BigQuery();
const DATASET = process.env.BQ_DATASET || 'app_oint';
const TABLE = process.env.BQ_TABLE || 'analytics_events';

export const analyticsToBigQuery = functions.firestore
  .document('analytics_events/{uid}/events/{eventId}')
  .onCreate(async (snap, ctx) => {
    const { uid, eventId } = ctx.params as { uid: string; eventId: string };
    const data = snap.data() || {} as any;

    const row = {
      event_id: eventId,
      uid: uid === '_anon' ? null : uid,
      name: data.name || null,
      ts: data.ts && typeof data.ts.toDate === 'function' ? data.ts.toDate() : new Date(),
      props_json: JSON.stringify(data.props || {}),
    } as any;

    await bq.dataset(DATASET).table(TABLE).insert([row]);
  });


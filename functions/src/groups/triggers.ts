import * as admin from 'firebase-admin';
import { onDocumentWritten } from 'firebase-functions/v2/firestore';
import { calculateUsageScore } from './usageScore';
import { Group } from './groupTypes';
import { notifyDashboardIfNeeded } from './monitoring';

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

export const onGroupActivity = onDocumentWritten('groups/{groupId}', async (event) => {
  const groupId = event.params.groupId as string;
  const after = event.data?.after?.data();
  if (!after) return;
  const group = { id: groupId, ...after } as Group;
  const score = calculateUsageScore(group);
  await db.collection('groups').doc(groupId).update({ usageScore: score });

  if (score >= 70 && group.type === 'community') {
    await db.collection('upsell_queue').add({
      groupId,
      score,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }

  if (score > 90) {
    const slackUrl = process.env.SLACK_ALERTS_URL;
    const payload = {
      text: `High usage alert: Group ${group.name} (${groupId}) scored ${score}`,
    };
    try {
      if (slackUrl) {
        await fetch(slackUrl, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload),
        } as any);
      } else {
        console.log('Slack alert (simulated):', payload.text);
      }
    } catch (e) {
      console.error('Failed to send Slack alert', e);
    }
  }
  await notifyDashboardIfNeeded({ ...group, usageScore: score });
});



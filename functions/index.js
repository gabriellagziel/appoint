const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.onInviteCreated = functions.firestore
  .document('invites/{inviteId}')
  .onCreate(async (snap, context) => {
    const invite = snap.data();
    if (!invite) return null;
    const payload = {
      notification: {
        title: 'New Invite',
        body: `You have a new invite from ${invite.inviteeContact?.displayName ?? ''}`,
      },
    };
    if (invite.inviteeId) {
      return admin.messaging().sendToTopic(invite.inviteeId, payload);
    }
    return null;
  });

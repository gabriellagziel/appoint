// tools/admin_access_review.ts
// Usage: GOOGLE_APPLICATION_CREDENTIALS=./sa.json npx ts-node tools/admin_access_review.ts > admin_access_review.csv
import * as admin from 'firebase-admin';

function csvEscape(s: string | undefined | null) {
  if (s == null) return '';
  const str = String(s);
  return /[",\n]/.test(str) ? `"${str.replace(/"/g, '""')}"` : str;
}

(async () => {
  if (admin.apps.length === 0) admin.initializeApp();
  const auth = admin.auth();
  const firestore = admin.firestore();
  let nextPageToken: string | undefined;

  console.log([
    'uid',
    'email',
    'displayName',
    'isAdmin',
    'isSuperAdmin',
    'disabled',
    'mfaEnrolledFactors',
    'lastSignIn',
    'createdAt',
    'lastAdminAction',
    'adminActionCount',
    'suspiciousActivity',
    'notes'
  ].join(','));

  do {
    const page = await auth.listUsers(1000, nextPageToken);
    for (const u of page.users) {
      const claims = (u.customClaims ?? {}) as Record<string, unknown>;
      const mfa = (u.multiFactor?.enrolledFactors ?? []).map(f => f.factorId).join('|');
      
      // Get admin activity from Firestore
      let lastAdminAction = '';
      let adminActionCount = 0;
      let suspiciousActivity = 'false';
      
      try {
        const adminLogs = await firestore
          .collection('admin_logs')
          .where('adminId', '==', u.uid)
          .orderBy('timestamp', 'desc')
          .limit(1)
          .get();
        
        if (!adminLogs.empty) {
          const lastLog = adminLogs.docs[0];
          lastAdminAction = lastLog.data().timestamp?.toDate?.()?.toISOString() || '';
          
          // Count total admin actions
          const totalActions = await firestore
            .collection('admin_logs')
            .where('adminId', '==', u.uid)
            .count()
            .get();
          
          adminActionCount = totalActions.data().count || 0;
          
          // Check for suspicious activity (high action count, unusual times, etc.)
          const oneDayAgo = new Date(Date.now() - 24 * 60 * 60 * 1000);
          const recentActions = await firestore
            .collection('admin_logs')
            .where('adminId', '==', u.uid)
            .where('timestamp', '>', oneDayAgo)
            .count()
            .get();
          
          const recentCount = recentActions.data().count || 0;
          if (recentCount > 50) { // More than 50 actions in 24h
            suspiciousActivity = 'high_activity';
          }
        }
      } catch (error) {
        console.error(`Error fetching admin logs for ${u.uid}:`, error);
      }
      
      // Generate notes based on risk factors
      const notes = [];
      if (claims['isAdmin'] && !mfa) notes.push('ADMIN_NO_MFA');
      if (claims['isSuperAdmin'] && !mfa) notes.push('SUPER_ADMIN_NO_MFA');
      if (u.disabled) notes.push('DISABLED_ACCOUNT');
      if (suspiciousActivity !== 'false') notes.push('SUSPICIOUS_ACTIVITY');
      if (adminActionCount === 0 && claims['isAdmin']) notes.push('INACTIVE_ADMIN');
      
      const row = [
        u.uid,
        csvEscape(u.email),
        csvEscape(u.displayName),
        claims['isAdmin'] ? 'true' : 'false',
        claims['isSuperAdmin'] ? 'true' : 'false',
        u.disabled ? 'true' : 'false',
        csvEscape(mfa),
        u.metadata.lastSignInTime ?? '',
        u.metadata.creationTime ?? '',
        csvEscape(lastAdminAction),
        adminActionCount,
        suspiciousActivity,
        csvEscape(notes.join('|'))
      ].join(',');
      
      console.log(row);
    }
    nextPageToken = page.pageToken;
  } while (nextPageToken);
  
  console.error('✅ Admin access review completed');
})();


import * as admin from 'firebase-admin';

let cachedApp: admin.app.App | null = null;

export function getAdminApp(): admin.app.App {
  if (cachedApp) return cachedApp;
  if (admin.apps.length) cachedApp = admin.app();
  else cachedApp = admin.initializeApp();
  return cachedApp;
}

export const db = () => getAdminApp().firestore();
export const auth = () => getAdminApp().auth();



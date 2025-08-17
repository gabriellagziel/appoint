import 'server-only';
import * as admin from 'firebase-admin';

let app: admin.app.App | null = null;

function initialize(): admin.app.App {
  if (app) return app;
  if (admin.apps.length) return (app = admin.app());
  
  app = admin.initializeApp({
    credential: admin.credential.applicationDefault()
  });
  return app;
}

export const getAdminApp = (): admin.app.App => initialize();
export const getAdminAuth = (): admin.auth.Auth => initialize().auth();
export const getAdminDb = (): admin.firestore.Firestore => initialize().firestore();

// New simplified exports
export const firestore = getAdminDb();
export const auth = getAdminAuth();



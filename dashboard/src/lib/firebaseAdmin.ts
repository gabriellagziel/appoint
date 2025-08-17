// Server-side Firebase Admin initialization (Dashboard app)
import * as admin from 'firebase-admin'

let app: admin.app.App | null = null

function initialize(): admin.app.App {
  if (app) return app
  if (admin.apps.length) {
    app = admin.app()
    return app
  }
  const base64 = process.env.FIREBASE_SERVICE_ACCOUNT_BASE64
  if (base64) {
    const json = Buffer.from(base64, 'base64').toString('utf8')
    const cred = JSON.parse(json)
    app = admin.initializeApp({ credential: admin.credential.cert(cred as admin.ServiceAccount) })
    return app
  }
  app = admin.initializeApp()
  return app
}

export const getAdminApp = (): admin.app.App => initialize()
export const getAdminAuth = (): admin.auth.Auth => initialize().auth()
export const getAdminDb = (): admin.firestore.Firestore => initialize().firestore()



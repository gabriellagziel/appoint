import { initializeApp, getApps, getApp } from "firebase/app"
import { getAuth, connectAuthEmulator } from "firebase/auth"
import { getFirestore, connectFirestoreEmulator } from "firebase/firestore"
import { getStorage, connectStorageEmulator } from "firebase/storage"

const env = (k: string, d?: string) => process.env[k] ?? d ?? ""
const useEmulators = env("NEXT_PUBLIC_FIREBASE_EMULATORS") === "1" || process.env.NODE_ENV !== "production"

const devConfig = {
  apiKey: env("NEXT_PUBLIC_FIREBASE_API_KEY", "dev-api-key"),
  authDomain: env("REDACTED_TOKEN", "dev.firebaseapp.com"),
  projectId: env("NEXT_PUBLIC_FIREBASE_PROJECT_ID", "dev-project"),
  storageBucket: env("REDACTED_TOKEN", "dev.appspot.com"),
  messagingSenderId: env("REDACTED_TOKEN", "1234567890"),
  appId: env("NEXT_PUBLIC_FIREBASE_APP_ID", "1:123:web:dev"),
}

const hasAll = ["NEXT_PUBLIC_FIREBASE_API_KEY", "NEXT_PUBLIC_FIREBASE_PROJECT_ID", "NEXT_PUBLIC_FIREBASE_APP_ID"].every(
  (k) => !!env(k)
)

const firebaseConfig = hasAll
  ? {
      apiKey: env("NEXT_PUBLIC_FIREBASE_API_KEY")!,
      authDomain: env("REDACTED_TOKEN", ""),
      projectId: env("NEXT_PUBLIC_FIREBASE_PROJECT_ID")!,
      storageBucket: env("REDACTED_TOKEN", ""),
      messagingSenderId: env("REDACTED_TOKEN", ""),
      appId: env("NEXT_PUBLIC_FIREBASE_APP_ID")!,
      measurementId: env("REDACTED_TOKEN", ""),
    }
  : devConfig

const app = getApps().length ? getApp() : initializeApp(firebaseConfig)
const db = getFirestore(app)
const auth = getAuth(app)
const storage = getStorage(app)

if (useEmulators) {
  try {
    connectFirestoreEmulator(db, "localhost", 8080)
  } catch {}
  try {
    connectAuthEmulator(auth, "http://localhost:9099", { disableWarnings: true })
  } catch {}
  try {
    connectStorageEmulator(storage, "localhost", 9199)
  } catch {}
}

export { auth, db, storage }
export default app
import { initializeApp, getApps } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth } from 'firebase/auth';
import { getStorage } from 'firebase/storage';

const env = (k: string, d?: string) => process.env[k] ?? d ?? '';
const required = [
  'NEXT_PUBLIC_FIREBASE_API_KEY',
  'NEXT_PUBLIC_FIREBASE_PROJECT_ID',
  'NEXT_PUBLIC_FIREBASE_APP_ID',
];
const hasAll = required.every((k) => !!env(k));

const devConfig = {
  apiKey: 'dev-api-key',
  authDomain: 'dev.firebaseapp.com',
  projectId: 'dev-project',
  appId: '1:123:web:dev',
  storageBucket: 'dev.appspot.com',
};

const firebaseConfig = hasAll
  ? {
      apiKey: env('NEXT_PUBLIC_FIREBASE_API_KEY')!,
      authDomain: env('REDACTED_TOKEN', ''),
      projectId: env('NEXT_PUBLIC_FIREBASE_PROJECT_ID')!,
      appId: env('NEXT_PUBLIC_FIREBASE_APP_ID')!,
      storageBucket: env('REDACTED_TOKEN', ''),
      messagingSenderId: env('REDACTED_TOKEN', ''),
      measurementId: env('REDACTED_TOKEN', ''),
    }
  : devConfig;

const app = getApps().length ? getApps()[0] : initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);
export const storage = getStorage(app);

export const collections = {
  enterpriseApplications: 'enterprise_applications',
  enterpriseClients: 'enterprise_clients',
  enterpriseUsage: 'enterprise_usage',
  enterpriseLogs: 'enterprise_logs',
  enterpriseFlags: 'enterprise_flags',
  apiKeys: 'api_keys',
  invoices: 'invoices',
  usageLogs: 'usage_logs',
};

export default app;


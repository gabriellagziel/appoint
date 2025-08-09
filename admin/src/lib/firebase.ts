import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { getStorage } from "firebase/storage";

// Development mode flag
const DEV_MODE = !process.env.NEXT_PUBLIC_FIREBASE_API_KEY;

// Mock configuration for development when env vars are not set
const mockConfig = {
    apiKey: "mock-api-key",
    authDomain: "mock-project.firebaseapp.com",
    projectId: "mock-project",
    storageBucket: "mock-project.appspot.com",
    messagingSenderId: "123456789",
    appId: "mock-app-id",
};

const firebaseConfig = {
    apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY || mockConfig.apiKey,
    authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN || mockConfig.authDomain,
    projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID || mockConfig.projectId,
    storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET || mockConfig.storageBucket,
    messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID || mockConfig.messagingSenderId,
    appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID || mockConfig.appId,
};

// Initialize Firebase only if we have real config or in development mode
let app: any;
let db: any;
let auth: any;
let storage: any;

if (DEV_MODE) {
    console.log('🔧 DEV MODE: Using mock Firebase configuration');
    // In development mode, create mock instances
    app = { name: 'mock-app' };
    db = {};
    auth = {};
    storage = {};
} else {
    // Initialize real Firebase
    app = initializeApp(firebaseConfig);
    db = getFirestore(app);
    auth = getAuth(app);
    storage = getStorage(app);
}

// Export instances
export { auth, db, storage };
export default app; 
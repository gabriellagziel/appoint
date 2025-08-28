import { cfg } from "@/config/runtime";

type Exports = {
    available: boolean;
    auth?: import("firebase/auth").Auth;
    db?: import("firebase/firestore").Firestore;
    Auth: {
        ensureAnon: () => Promise<any>;
        google: () => Promise<any>;
        onChange: (fn: (u: any) => void) => () => void;
        signOut: () => Promise<void>;
    };
};

let state: Exports = {
    available: typeof window !== "undefined" && cfg.flags.HAS_FIREBASE,
    Auth: {
        ensureAnon: async () => null,
        google: async () => null,
        onChange: () => () => { },
        signOut: async () => { },
    },
};

(async () => {
    if (typeof window === "undefined") return;
    if (!cfg.flags.HAS_FIREBASE) return;

    const { initializeApp, getApps } = await import("firebase/app");
    const { getAuth, GoogleAuthProvider, signInAnonymously, signInWithPopup, onAuthStateChanged, signOut } =
        await import("firebase/auth");
    const { getFirestore, enableIndexedDbPersistence } = await import("firebase/firestore");

    const app = getApps().length ? getApps()[0] : initializeApp(cfg.firebase);
    const auth = getAuth(app);
    const db = getFirestore(app);
    enableIndexedDbPersistence(db).catch(() => { });

    state = {
        available: true,
        auth,
        db,
        Auth: {
            ensureAnon: async () => auth.currentUser ?? (await signInAnonymously(auth)).user,
            google: async () => (await signInWithPopup(auth, new GoogleAuthProvider())).user,
            onChange: (fn) => onAuthStateChanged(auth, fn),
            signOut: () => signOut(auth),
        },
    };
})();

// 👉 Use getters so consumers see the latest state
export const isFirebaseAvailable = () => state.available;
export const getDb = () => state.db;
export const getAuthApi = () => state.Auth;
export const getAuth = () => state.auth;

// Legacy exports for backward compatibility (deprecated)
export const available = state.available;
export const Auth = state.Auth;
export const auth = state.auth;
export const db = state.db;

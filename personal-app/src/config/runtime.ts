// Safe runtime helpers (no throws during render)
const get = (k: string) => process.env[k] || "";

export const cfg = {
    firebase: {
        apiKey: get("NEXT_PUBLIC_FIREBASE_API_KEY"),
        authDomain: get("REDACTED_TOKEN"),
        projectId: get("NEXT_PUBLIC_FIREBASE_PROJECT_ID"),
        storageBucket: get("REDACTED_TOKEN"),
        messagingSenderId: get("REDACTED_TOKEN"),
        appId: get("NEXT_PUBLIC_FIREBASE_APP_ID"),
    },
    flags: {
        HAS_FIREBASE: [
            "NEXT_PUBLIC_FIREBASE_API_KEY",
            "REDACTED_TOKEN",
            "NEXT_PUBLIC_FIREBASE_PROJECT_ID",
            "NEXT_PUBLIC_FIREBASE_APP_ID",
        ].every((k) => !!process.env[k]),
    },
};

"use client";
import { getAuthApi, isFirebaseAvailable } from "@/lib/firebase";
import { migrateLocalToCloud } from "@/lib/migrate";
import { useEffect } from "react";

export default function AuthHydrator() {
    useEffect(() => {
        if (!isFirebaseAvailable()) return;
        const Auth = getAuthApi();
        const unsub = Auth.onChange(async (u) => {
            const user = u ?? (await Auth.ensureAnon());
            if (user?.uid) await migrateLocalToCloud(user.uid);
        });
        // ensure anon on mount
        Auth.ensureAnon().then((u) => u?.uid && migrateLocalToCloud(u.uid));
        return () => unsub?.();
    }, []);
    return null;
}

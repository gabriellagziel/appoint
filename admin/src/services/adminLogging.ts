interface AdminLogEntry {
    uid: string
    action: string
    route: string
    params?: Record<string, any>
    timestamp: string
    ipAddress?: string
    userAgent?: string
}

class AdminLoggingService {
    private logs: AdminLogEntry[] = []
    private isProduction = process.env.NODE_ENV === 'production'

    async logAction(
        uid: string,
        action: string,
        route: string,
        params?: Record<string, any>,
        ipAddress?: string,
        userAgent?: string
    ): Promise<void> {
        const logEntry: AdminLogEntry = {
            uid,
            action,
            route,
            params,
            timestamp: new Date().toISOString(),
            ipAddress,
            userAgent
        }

        if (this.isProduction) {
            try {
                // Production: Write to Firestore
                const { initializeApp } = await import('firebase/app')
                const { getFirestore, collection, addDoc } = await import('firebase/firestore')

                const firebaseConfig = {
                    apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
                    authDomain: process.env.REDACTED_TOKEN,
                    projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
                    storageBucket: process.env.REDACTED_TOKEN,
                    messagingSenderId: process.env.REDACTED_TOKEN,
                    appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID
                }

                const app = initializeApp(firebaseConfig)
                const db = getFirestore(app)

                await addDoc(collection(db, 'logs', 'admin', uid), logEntry)
                console.log('Admin Action Logged to Firestore:', logEntry)
            } catch (error) {
                console.error('Failed to log to Firestore:', error)
                // Fallback to local logging
                this.logs.push(logEntry)
            }
        } else {
            // Development: Use local logs
            this.logs.push(logEntry)
            console.log('Admin Action Logged (Development):', logEntry)
        }
    }

    async getLogs(uid?: string, limit: number = 100): Promise<AdminLogEntry[]> {
        if (this.isProduction) {
            try {
                // Production: Query Firestore
                const { initializeApp } = await import('firebase/app')
                const { getFirestore, collection, query, orderBy, limit: firestoreLimit, getDocs } = await import('firebase/firestore')

                const firebaseConfig = {
                    apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
                    authDomain: process.env.REDACTED_TOKEN,
                    projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
                    storageBucket: process.env.REDACTED_TOKEN,
                    messagingSenderId: process.env.REDACTED_TOKEN,
                    appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID
                }

                const app = initializeApp(firebaseConfig)
                const db = getFirestore(app)

                let logsQuery = query(
                    collection(db, 'logs', 'admin', uid || 'all'),
                    orderBy('timestamp', 'desc'),
                    firestoreLimit(limit)
                )

                const querySnapshot = await getDocs(logsQuery)
                return querySnapshot.docs.map(doc => doc.data() as AdminLogEntry)
            } catch (error) {
                console.error('Failed to get logs from Firestore:', error)
                return []
            }
        } else {
            // Development: Use local logs
            let filteredLogs = this.logs
            if (uid) {
                filteredLogs = this.logs.filter(log => log.uid === uid)
            }

            return filteredLogs
                .sort((a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime())
                .slice(0, limit)
        }
    }

    async logDestructiveAction(
        uid: string,
        action: string,
        route: string,
        targetId: string,
        targetType: string,
        params?: Record<string, any>
    ): Promise<void> {
        await this.logAction(uid, action, route, {
            ...params,
            targetId,
            targetType,
            destructive: true
        })
    }
}

export const adminLogging = new AdminLoggingService() 
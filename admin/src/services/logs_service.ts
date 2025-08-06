import { db } from "@/lib/firebase";
import {
    addDoc,
    collection,
    DocumentData,
    getDocs,
    limit,
    orderBy,
    query,
    QueryDocumentSnapshot,
    serverTimestamp,
    startAfter,
    where
} from "firebase/firestore";

export interface SystemLog {
    id: string;
    timestamp: Date;
    action: string;
    actorUid?: string;
    actorEmail?: string;
    targetUid?: string;
    targetEmail?: string;
    context?: any;
    metadata?: any;
    ipAddress?: string;
    userAgent?: string;
    severity: 'info' | 'warning' | 'error' | 'critical';
}

export interface LogFilters {
    action?: string;
    actorUid?: string;
    targetUid?: string;
    severity?: string;
    dateFrom?: Date;
    dateTo?: Date;
    search?: string;
}

export interface LogResponse {
    logs: SystemLog[];
    total: number;
    hasMore: boolean;
    lastDoc?: QueryDocumentSnapshot<DocumentData>;
}

// Fetch system logs with pagination and filters
export async function fetchLogs(
    filters: LogFilters = {},
    pageSize: number = 50,
    lastDoc?: QueryDocumentSnapshot<DocumentData>
): Promise<LogResponse> {
    try {
        let q = collection(db, "system_logs");
        const constraints: any[] = [];

        // Apply filters
        if (filters.action && filters.action !== 'all') {
            constraints.push(where("action", "==", filters.action));
        }
        if (filters.actorUid) {
            constraints.push(where("actorUid", "==", filters.actorUid));
        }
        if (filters.targetUid) {
            constraints.push(where("targetUid", "==", filters.targetUid));
        }
        if (filters.severity && filters.severity !== 'all') {
            constraints.push(where("severity", "==", filters.severity));
        }
        if (filters.dateFrom) {
            constraints.push(where("timestamp", ">=", filters.dateFrom));
        }
        if (filters.dateTo) {
            constraints.push(where("timestamp", "<=", filters.dateTo));
        }

        // Add ordering and pagination
        constraints.push(orderBy("timestamp", "desc"));
        constraints.push(limit(pageSize));

        if (lastDoc) {
            constraints.push(startAfter(lastDoc));
        }

        const querySnapshot = await getDocs(query(q, ...constraints));

        const logs: SystemLog[] = querySnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            timestamp: doc.data().timestamp?.toDate() || new Date(),
        })) as SystemLog[];

        // If search filter is applied, filter client-side
        let filteredLogs = logs;
        if (filters.search) {
            const searchLower = filters.search.toLowerCase();
            filteredLogs = logs.filter(log =>
                log.action.toLowerCase().includes(searchLower) ||
                log.actorEmail?.toLowerCase().includes(searchLower) ||
                log.targetEmail?.toLowerCase().includes(searchLower) ||
                JSON.stringify(log.context || {}).toLowerCase().includes(searchLower)
            );
        }

        return {
            logs: filteredLogs,
            total: filteredLogs.length,
            hasMore: querySnapshot.docs.length === pageSize,
            lastDoc: querySnapshot.docs[querySnapshot.docs.length - 1],
        };
    } catch (error) {
        console.error("Error fetching logs:", error);
        throw new Error("Failed to fetch logs");
    }
}

// Create a new system log entry
export async function createLog(
    action: string,
    metadata: {
        actorUid?: string;
        actorEmail?: string;
        targetUid?: string;
        targetEmail?: string;
        context?: any;
        ipAddress?: string;
        userAgent?: string;
        severity?: 'info' | 'warning' | 'error' | 'critical';
    }
): Promise<void> {
    try {
        const logData = {
            action,
            timestamp: serverTimestamp(),
            severity: metadata.severity || 'info',
            ...metadata
        };

        await addDoc(collection(db, "system_logs"), logData);
    } catch (error) {
        console.error("Error creating log:", error);
        // Don't throw error for logging failures to avoid breaking main functionality
    }
}

// Get log statistics
export async function getLogStats(): Promise<{
    total: number;
    today: number;
    thisWeek: number;
    thisMonth: number;
    bySeverity: { [key: string]: number };
    byAction: { [key: string]: number };
}> {
    try {
        const logsQuery = query(collection(db, "system_logs"));
        const querySnapshot = await getDocs(logsQuery);

        const logs = querySnapshot.docs.map(doc => ({
            ...doc.data(),
            timestamp: doc.data().timestamp?.toDate() || new Date(),
        })) as SystemLog[];

        const now = new Date();
        const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const thisWeek = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
        const thisMonth = new Date(now.getFullYear(), now.getMonth(), 1);

        const bySeverity: { [key: string]: number } = {};
        const byAction: { [key: string]: number } = {};

        logs.forEach(log => {
            bySeverity[log.severity] = (bySeverity[log.severity] || 0) + 1;
            byAction[log.action] = (byAction[log.action] || 0) + 1;
        });

        return {
            total: logs.length,
            today: logs.filter(log => log.timestamp >= today).length,
            thisWeek: logs.filter(log => log.timestamp >= thisWeek).length,
            thisMonth: logs.filter(log => log.timestamp >= thisMonth).length,
            bySeverity,
            byAction,
        };
    } catch (error) {
        console.error("Error fetching log stats:", error);
        throw new Error("Failed to fetch log statistics");
    }
}

// Get logs for a specific user
export async function getUserLogs(userId: string, limitCount: number = 20): Promise<SystemLog[]> {
    try {
        const q = query(
            collection(db, "system_logs"),
            where("targetUid", "==", userId),
            orderBy("timestamp", "desc"),
            limit(limitCount)
        );

        const querySnapshot = await getDocs(q);
        return querySnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            timestamp: doc.data().timestamp?.toDate() || new Date(),
        })) as SystemLog[];
    } catch (error) {
        console.error("Error fetching user logs:", error);
        throw new Error("Failed to fetch user logs");
    }
}

// Get logs by actor (admin actions)
export async function getActorLogs(actorUid: string, limitCount: number = 20): Promise<SystemLog[]> {
    try {
        const q = query(
            collection(db, "system_logs"),
            where("actorUid", "==", actorUid),
            orderBy("timestamp", "desc"),
            limit(limitCount)
        );

        const querySnapshot = await getDocs(q);
        return querySnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            timestamp: doc.data().timestamp?.toDate() || new Date(),
        })) as SystemLog[];
    } catch (error) {
        console.error("Error fetching actor logs:", error);
        throw new Error("Failed to fetch actor logs");
    }
}

// Export logs to CSV format
export async function exportLogs(filters: LogFilters = {}): Promise<string> {
    try {
        const logs = await fetchLogs(filters, 1000); // Get up to 1000 logs for export

        const csvHeaders = [
            'Timestamp',
            'Action',
            'Severity',
            'Actor UID',
            'Actor Email',
            'Target UID',
            'Target Email',
            'IP Address',
            'User Agent',
            'Context'
        ];

        const csvRows = logs.logs.map(log => [
            log.timestamp.toISOString(),
            log.action,
            log.severity,
            log.actorUid || '',
            log.actorEmail || '',
            log.targetUid || '',
            log.targetEmail || '',
            log.ipAddress || '',
            log.userAgent || '',
            JSON.stringify(log.context || {})
        ]);

        const csvContent = [csvHeaders, ...csvRows]
            .map(row => row.map(cell => `"${cell}"`).join(','))
            .join('\n');

        return csvContent;
    } catch (error) {
        console.error("Error exporting logs:", error);
        throw new Error("Failed to export logs");
    }
} 
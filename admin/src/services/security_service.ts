import { db } from "@/lib/firebase";
import {
    collection,
    doc,
    DocumentData,
    getDocs,
    limit,
    orderBy,
    query,
    QueryDocumentSnapshot,
    startAfter,
    updateDoc,
    where
} from "firebase/firestore";

export interface SecurityEvent {
    id: string;
    type: 'suspicious_login' | 'spam_detected' | 'data_breach_attempt' | 'unauthorized_access' | 'rate_limit_exceeded';
    severity: 'low' | 'medium' | 'high' | 'critical';
    user: string;
    description: string;
    timestamp: Date;
    status: 'investigating' | 'resolved' | 'blocked' | 'false_positive';
    location: string;
    ipAddress?: string;
    userAgent?: string;
    actionTaken?: string;
}

export interface AbuseReport {
    id: string;
    reporter: string;
    reportedUser: string;
    reason: 'harassment' | 'fraud' | 'spam' | 'inappropriate_content' | 'other';
    description: string;
    timestamp: Date;
    status: 'pending' | 'investigating' | 'resolved' | 'dismissed';
    priority: 'low' | 'medium' | 'high' | 'critical';
    evidence?: string[];
    adminNotes?: string;
}

export interface SecurityFilters {
    severity?: string;
    status?: string;
    type?: string;
    search?: string;
}

export interface SecurityResponse {
    events: SecurityEvent[];
    reports: AbuseReport[];
    total: number;
    hasMore: boolean;
    lastDoc?: QueryDocumentSnapshot<DocumentData>;
}

// Fetch security events with pagination and filters
export async function fetchSecurityEvents(
    filters: SecurityFilters = {},
    pageSize: number = 20,
    lastDoc?: QueryDocumentSnapshot<DocumentData>
): Promise<SecurityResponse> {
    try {
        let q = collection(db, "security_events");
        const constraints: any[] = [];

        // Apply filters
        if (filters.severity && filters.severity !== 'all') {
            constraints.push(where("severity", "==", filters.severity));
        }
        if (filters.status && filters.status !== 'all') {
            constraints.push(where("status", "==", filters.status));
        }
        if (filters.type && filters.type !== 'all') {
            constraints.push(where("type", "==", filters.type));
        }

        // Add ordering and pagination
        constraints.push(orderBy("timestamp", "desc"));
        constraints.push(limit(pageSize));

        if (lastDoc) {
            constraints.push(startAfter(lastDoc));
        }

        const querySnapshot = await getDocs(query(q, ...constraints));

        const events: SecurityEvent[] = querySnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            timestamp: doc.data().timestamp?.toDate() || new Date(),
        })) as SecurityEvent[];

        // If search filter is applied, filter client-side
        let filteredEvents = events;
        if (filters.search) {
            const searchLower = filters.search.toLowerCase();
            filteredEvents = events.filter(event =>
                event.user.toLowerCase().includes(searchLower) ||
                event.description.toLowerCase().includes(searchLower) ||
                event.location.toLowerCase().includes(searchLower)
            );
        }

        return {
            events: filteredEvents,
            reports: [], // Will be fetched separately
            total: filteredEvents.length,
            hasMore: querySnapshot.docs.length === pageSize,
            lastDoc: querySnapshot.docs[querySnapshot.docs.length - 1],
        };
    } catch (error) {
        console.error("Error fetching security events:", error);
        throw new Error("Failed to fetch security events");
    }
}

// Fetch abuse reports
export async function fetchAbuseReports(
    filters: SecurityFilters = {},
    pageSize: number = 20,
    lastDoc?: QueryDocumentSnapshot<DocumentData>
): Promise<AbuseReport[]> {
    try {
        let q = collection(db, "abuse_reports");
        const constraints: any[] = [];

        // Apply filters
        if (filters.status && filters.status !== 'all') {
            constraints.push(where("status", "==", filters.status));
        }
        if (filters.severity && filters.severity !== 'all') {
            constraints.push(where("priority", "==", filters.severity));
        }

        // Add ordering and pagination
        constraints.push(orderBy("timestamp", "desc"));
        constraints.push(limit(pageSize));

        if (lastDoc) {
            constraints.push(startAfter(lastDoc));
        }

        const querySnapshot = await getDocs(query(q, ...constraints));

        const reports: AbuseReport[] = querySnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            timestamp: doc.data().timestamp?.toDate() || new Date(),
        })) as AbuseReport[];

        // If search filter is applied, filter client-side
        let filteredReports = reports;
        if (filters.search) {
            const searchLower = filters.search.toLowerCase();
            filteredReports = reports.filter(report =>
                report.reporter.toLowerCase().includes(searchLower) ||
                report.reportedUser.toLowerCase().includes(searchLower) ||
                report.description.toLowerCase().includes(searchLower)
            );
        }

        return filteredReports;
    } catch (error) {
        console.error("Error fetching abuse reports:", error);
        throw new Error("Failed to fetch abuse reports");
    }
}

// Update security event status
export async function updateSecurityEventStatus(eventId: string, status: string): Promise<void> {
    try {
        const eventRef = doc(db, "security_events", eventId);
        await updateDoc(eventRef, {
            status,
            updatedAt: new Date(),
        });
    } catch (error) {
        console.error("Error updating security event status:", error);
        throw new Error("Failed to update security event status");
    }
}

// Update abuse report status
export async function updateAbuseReportStatus(reportId: string, status: string, adminNotes?: string): Promise<void> {
    try {
        const reportRef = doc(db, "abuse_reports", reportId);
        await updateDoc(reportRef, {
            status,
            adminNotes,
            updatedAt: new Date(),
        });
    } catch (error) {
        console.error("Error updating abuse report status:", error);
        throw new Error("Failed to update abuse report status");
    }
}

// Block user (create security event)
export async function blockUser(userId: string, reason: string): Promise<void> {
    try {
        const eventRef = doc(collection(db, "security_events"));
        await updateDoc(eventRef, {
            type: "unauthorized_access",
            severity: "high",
            user: userId,
            description: `User blocked: ${reason}`,
            timestamp: new Date(),
            status: "resolved",
            actionTaken: "User blocked",
        });
    } catch (error) {
        console.error("Error blocking user:", error);
        throw new Error("Failed to block user");
    }
}

// Get security statistics
export async function getSecurityStats(): Promise<{
    totalEvents: number;
    activeThreats: number;
    resolvedEvents: number;
    criticalEvents: number;
    totalReports: number;
    pendingReports: number;
    resolvedReports: number;
}> {
    try {
        const eventsSnapshot = await getDocs(collection(db, "security_events"));
        const reportsSnapshot = await getDocs(collection(db, "abuse_reports"));

        const events = eventsSnapshot.docs.map(doc => doc.data());
        const reports = reportsSnapshot.docs.map(doc => doc.data());

        return {
            totalEvents: events.length,
            activeThreats: events.filter((e: any) => e.status === 'investigating').length,
            resolvedEvents: events.filter((e: any) => e.status === 'resolved').length,
            criticalEvents: events.filter((e: any) => e.severity === 'critical').length,
            totalReports: reports.length,
            pendingReports: reports.filter((r: any) => r.status === 'pending').length,
            resolvedReports: reports.filter((r: any) => r.status === 'resolved').length,
        };
    } catch (error) {
        console.error("Error fetching security stats:", error);
        throw new Error("Failed to fetch security statistics");
    }
} 
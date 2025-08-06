import { db } from "@/lib/firebase";
import {
    addDoc,
    collection,
    doc,
    DocumentData,
    getDoc,
    getDocs,
    limit,
    orderBy,
    query,
    QueryDocumentSnapshot,
    serverTimestamp,
    startAfter,
    updateDoc,
    where,
    writeBatch
} from "firebase/firestore";

export interface UserFlag {
    id: string;
    userId: string;
    userEmail?: string;
    userName?: string;
    reason: string;
    category: 'spam' | 'inappropriate' | 'harassment' | 'fake_account' | 'other';
    flaggedBy: string;
    flaggedByEmail?: string;
    status: 'pending' | 'reviewed' | 'ignored' | 'resolved';
    createdAt: Date;
    reviewedAt?: Date;
    reviewedBy?: string;
    reviewedByEmail?: string;
    adminNotes?: string;
    actionTaken?: 'none' | 'warning' | 'suspension' | 'ban';
    severity: 'low' | 'medium' | 'high' | 'critical';
    evidence?: string;
    context?: any;
}

export interface FlagFilters {
    status?: string;
    category?: string;
    severity?: string;
    userId?: string;
    flaggedBy?: string;
    dateFrom?: Date;
    dateTo?: Date;
    search?: string;
}

export interface FlagResponse {
    flags: UserFlag[];
    total: number;
    hasMore: boolean;
    lastDoc?: QueryDocumentSnapshot<DocumentData>;
}

// Fetch flags with pagination and filters
export async function fetchFlags(
    filters: FlagFilters = {},
    pageSize: number = 20,
    lastDoc?: QueryDocumentSnapshot<DocumentData>
): Promise<FlagResponse> {
    try {
        let q = collection(db, "user_flags");
        const constraints: any[] = [];

        // Apply filters
        if (filters.status && filters.status !== 'all') {
            constraints.push(where("status", "==", filters.status));
        }
        if (filters.category && filters.category !== 'all') {
            constraints.push(where("category", "==", filters.category));
        }
        if (filters.severity && filters.severity !== 'all') {
            constraints.push(where("severity", "==", filters.severity));
        }
        if (filters.userId) {
            constraints.push(where("userId", "==", filters.userId));
        }
        if (filters.flaggedBy) {
            constraints.push(where("flaggedBy", "==", filters.flaggedBy));
        }
        if (filters.dateFrom) {
            constraints.push(where("createdAt", ">=", filters.dateFrom));
        }
        if (filters.dateTo) {
            constraints.push(where("createdAt", "<=", filters.dateTo));
        }

        // Add ordering and pagination
        constraints.push(orderBy("createdAt", "desc"));
        constraints.push(limit(pageSize));

        if (lastDoc) {
            constraints.push(startAfter(lastDoc));
        }

        const querySnapshot = await getDocs(query(q, ...constraints));

        const flags: UserFlag[] = querySnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            createdAt: doc.data().createdAt?.toDate() || new Date(),
            reviewedAt: doc.data().reviewedAt?.toDate(),
        })) as UserFlag[];

        // If search filter is applied, filter client-side
        let filteredFlags = flags;
        if (filters.search) {
            const searchLower = filters.search.toLowerCase();
            filteredFlags = flags.filter(flag =>
                flag.userEmail?.toLowerCase().includes(searchLower) ||
                flag.userName?.toLowerCase().includes(searchLower) ||
                flag.reason.toLowerCase().includes(searchLower) ||
                flag.adminNotes?.toLowerCase().includes(searchLower)
            );
        }

        return {
            flags: filteredFlags,
            total: filteredFlags.length,
            hasMore: querySnapshot.docs.length === pageSize,
            lastDoc: querySnapshot.docs[querySnapshot.docs.length - 1],
        };
    } catch (error) {
        console.error("Error fetching flags:", error);
        throw new Error("Failed to fetch flags");
    }
}

// Create a new flag
export async function createFlag(
    userId: string,
    reason: string,
    category: UserFlag['category'],
    severity: UserFlag['severity'],
    metadata: {
        userEmail?: string;
        userName?: string;
        flaggedBy: string;
        flaggedByEmail?: string;
        evidence?: string;
        context?: any;
    }
): Promise<string> {
    try {
        const flagData = {
            userId,
            reason,
            category,
            severity,
            status: 'pending' as const,
            createdAt: serverTimestamp(),
            ...metadata
        };

        const docRef = await addDoc(collection(db, "user_flags"), flagData);
        return docRef.id;
    } catch (error) {
        console.error("Error creating flag:", error);
        throw new Error("Failed to create flag");
    }
}

// Update flag status
export async function updateFlagStatus(
    flagId: string,
    status: UserFlag['status'],
    metadata: {
        reviewedBy: string;
        reviewedByEmail?: string;
        adminNotes?: string;
        actionTaken?: UserFlag['actionTaken'];
    }
): Promise<void> {
    try {
        const flagRef = doc(db, "user_flags", flagId);
        const updateData: any = {
            status,
            reviewedAt: serverTimestamp(),
            ...metadata
        };

        await updateDoc(flagRef, updateData);
    } catch (error) {
        console.error("Error updating flag status:", error);
        throw new Error("Failed to update flag status");
    }
}

// Get flag by ID
export async function getFlagById(flagId: string): Promise<UserFlag | null> {
    try {
        const flagDoc = await getDoc(doc(db, "user_flags", flagId));
        if (!flagDoc.exists()) {
            return null;
        }

        return {
            id: flagDoc.id,
            ...flagDoc.data(),
            createdAt: flagDoc.data().createdAt?.toDate() || new Date(),
            reviewedAt: flagDoc.data().reviewedAt?.toDate(),
        } as UserFlag;
    } catch (error) {
        console.error("Error fetching flag:", error);
        throw new Error("Failed to fetch flag");
    }
}

// Get flags for a specific user
export async function getUserFlags(userId: string, limitCount: number = 20): Promise<UserFlag[]> {
    try {
        const q = query(
            collection(db, "user_flags"),
            where("userId", "==", userId),
            orderBy("createdAt", "desc"),
            limit(limitCount)
        );

        const querySnapshot = await getDocs(q);
        return querySnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            createdAt: doc.data().createdAt?.toDate() || new Date(),
            reviewedAt: doc.data().reviewedAt?.toDate(),
        })) as UserFlag[];
    } catch (error) {
        console.error("Error fetching user flags:", error);
        throw new Error("Failed to fetch user flags");
    }
}

// Bulk update flag statuses
export async function bulkUpdateFlagStatus(
    flagIds: string[],
    status: UserFlag['status'],
    metadata: {
        reviewedBy: string;
        reviewedByEmail?: string;
        adminNotes?: string;
        actionTaken?: UserFlag['actionTaken'];
    }
): Promise<void> {
    try {
        const batch = writeBatch(db);

        flagIds.forEach(flagId => {
            const flagRef = doc(db, "user_flags", flagId);
            const updateData: any = {
                status,
                reviewedAt: serverTimestamp(),
                ...metadata
            };

            batch.update(flagRef, updateData);
        });

        await batch.commit();
    } catch (error) {
        console.error("Error bulk updating flag statuses:", error);
        throw new Error("Failed to bulk update flag statuses");
    }
}

// Get flag statistics
export async function getFlagStats(): Promise<{
    total: number;
    pending: number;
    reviewed: number;
    ignored: number;
    resolved: number;
    byCategory: { [key: string]: number };
    bySeverity: { [key: string]: number };
    today: number;
    thisWeek: number;
    thisMonth: number;
}> {
    try {
        const flagsQuery = query(collection(db, "user_flags"));
        const querySnapshot = await getDocs(flagsQuery);

        const flags = querySnapshot.docs.map(doc => ({
            ...doc.data(),
            createdAt: doc.data().createdAt?.toDate() || new Date(),
        })) as UserFlag[];

        const now = new Date();
        const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const thisWeek = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
        const thisMonth = new Date(now.getFullYear(), now.getMonth(), 1);

        const byCategory: { [key: string]: number } = {};
        const bySeverity: { [key: string]: number } = {};

        flags.forEach(flag => {
            byCategory[flag.category] = (byCategory[flag.category] || 0) + 1;
            bySeverity[flag.severity] = (bySeverity[flag.severity] || 0) + 1;
        });

        return {
            total: flags.length,
            pending: flags.filter(f => f.status === 'pending').length,
            reviewed: flags.filter(f => f.status === 'reviewed').length,
            ignored: flags.filter(f => f.status === 'ignored').length,
            resolved: flags.filter(f => f.status === 'resolved').length,
            byCategory,
            bySeverity,
            today: flags.filter(f => f.createdAt >= today).length,
            thisWeek: flags.filter(f => f.createdAt >= thisWeek).length,
            thisMonth: flags.filter(f => f.createdAt >= thisMonth).length,
        };
    } catch (error) {
        console.error("Error fetching flag stats:", error);
        throw new Error("Failed to fetch flag statistics");
    }
}

// Export flags to CSV format
export async function exportFlags(filters: FlagFilters = {}): Promise<string> {
    try {
        const flags = await fetchFlags(filters, 1000); // Get up to 1000 flags for export

        const csvHeaders = [
            'ID',
            'User ID',
            'User Email',
            'User Name',
            'Reason',
            'Category',
            'Severity',
            'Status',
            'Flagged By',
            'Flagged By Email',
            'Created At',
            'Reviewed At',
            'Reviewed By',
            'Reviewed By Email',
            'Admin Notes',
            'Action Taken'
        ];

        const csvRows = flags.flags.map(flag => [
            flag.id,
            flag.userId,
            flag.userEmail || '',
            flag.userName || '',
            flag.reason,
            flag.category,
            flag.severity,
            flag.status,
            flag.flaggedBy,
            flag.flaggedByEmail || '',
            flag.createdAt.toISOString(),
            flag.reviewedAt?.toISOString() || '',
            flag.reviewedBy || '',
            flag.reviewedByEmail || '',
            flag.adminNotes || '',
            flag.actionTaken || ''
        ]);

        const csvContent = [csvHeaders, ...csvRows]
            .map(row => row.map(cell => `"${cell}"`).join(','))
            .join('\n');

        return csvContent;
    } catch (error) {
        console.error("Error exporting flags:", error);
        throw new Error("Failed to export flags");
    }
} 
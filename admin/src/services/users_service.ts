import { db } from "@/lib/firebase";
import {
    collection,
    doc,
    DocumentData,
    getDoc,
    getDocs,
    limit,
    orderBy,
    query,
    QueryDocumentSnapshot,
    startAfter,
    updateDoc,
    where,
    writeBatch
} from "firebase/firestore";

// Development mode flag
const DEV_MODE = !process.env.NEXT_PUBLIC_FIREBASE_API_KEY;

// Mock data for development
const MOCK_USERS: User[] = [
    {
        id: 'user-1',
        email: 'john.doe@example.com',
        displayName: 'John Doe',
        photoURL: 'https://via.placeholder.com/40',
        status: 'active',
        role: 'user',
        createdAt: new Date('2024-01-15'),
        lastActive: new Date('2024-08-05'),
        phoneNumber: '+1234567890',
        emailVerified: true,
        totalAppointments: 12,
        totalSpent: 450.00
    },
    {
        id: 'user-2',
        email: 'jane.smith@example.com',
        displayName: 'Jane Smith',
        photoURL: 'https://via.placeholder.com/40',
        status: 'active',
        role: 'business',
        createdAt: new Date('2024-02-20'),
        lastActive: new Date('2024-08-04'),
        phoneNumber: '+1987654321',
        emailVerified: true,
        totalAppointments: 8,
        totalSpent: 320.00
    },
    {
        id: 'user-3',
        email: 'bob.wilson@example.com',
        displayName: 'Bob Wilson',
        photoURL: 'https://via.placeholder.com/40',
        status: 'suspended',
        role: 'user',
        createdAt: new Date('2024-03-10'),
        lastActive: new Date('2024-08-01'),
        phoneNumber: '+1555123456',
        emailVerified: true,
        moderationNotes: 'Suspended for inappropriate behavior',
        suspendedUntil: new Date('2024-09-01'),
        totalAppointments: 5,
        totalSpent: 180.00
    },
    {
        id: 'user-4',
        email: 'alice.brown@example.com',
        displayName: 'Alice Brown',
        photoURL: 'https://via.placeholder.com/40',
        status: 'banned',
        role: 'user',
        createdAt: new Date('2024-01-05'),
        lastActive: new Date('2024-07-20'),
        phoneNumber: '+1444123456',
        emailVerified: true,
        moderationNotes: 'Permanently banned for repeated violations',
        banReason: 'Multiple policy violations',
        flags: 3,
        totalAppointments: 2,
        totalSpent: 75.00
    }
];

export interface User {
    id: string;
    email: string;
    displayName?: string;
    photoURL?: string;
    status: 'active' | 'suspended' | 'banned';
    role: 'user' | 'admin' | 'moderator' | 'business';
    createdAt: Date;
    lastActive?: Date;
    phoneNumber?: string;
    emailVerified: boolean;
    moderationNotes?: string;
    suspendedUntil?: Date;
    banReason?: string;
    flags?: number;
    totalAppointments?: number;
    totalSpent?: number;
}

export interface UserFilters {
    status?: string;
    role?: string;
    search?: string;
    dateFrom?: Date;
    dateTo?: Date;
    hasFlags?: boolean;
}

export interface UserResponse {
    users: User[];
    total: number;
    hasMore: boolean;
    lastDoc?: QueryDocumentSnapshot<DocumentData>;
}

// Fetch users with pagination and filters
export async function fetchUsers(
    filters: UserFilters = {},
    pageSize: number = 20,
    lastDoc?: QueryDocumentSnapshot<DocumentData>
): Promise<UserResponse> {
    if (DEV_MODE) {
        console.log('🔧 DEV MODE: Returning mock users data');

        // Filter mock data based on filters
        let filteredUsers = [...MOCK_USERS];

        if (filters.status && filters.status !== 'all') {
            filteredUsers = filteredUsers.filter(user => user.status === filters.status);
        }

        if (filters.role && filters.role !== 'all') {
            filteredUsers = filteredUsers.filter(user => user.role === filters.role);
        }

        if (filters.search) {
            const searchTerm = filters.search.toLowerCase();
            filteredUsers = filteredUsers.filter(user =>
                user.email.toLowerCase().includes(searchTerm) ||
                user.displayName?.toLowerCase().includes(searchTerm)
            );
        }

        if (filters.hasFlags) {
            filteredUsers = filteredUsers.filter(user => (user.flags || 0) > 0);
        }

        return {
            users: filteredUsers.slice(0, pageSize),
            total: filteredUsers.length,
            hasMore: false,
            lastDoc: undefined
        };
    }

    try {
        let q = collection(db, "users");
        const constraints: any[] = [];

        // Apply filters
        if (filters.status && filters.status !== 'all') {
            constraints.push(where("status", "==", filters.status));
        }
        if (filters.role && filters.role !== 'all') {
            constraints.push(where("role", "==", filters.role));
        }
        if (filters.dateFrom) {
            constraints.push(where("createdAt", ">=", filters.dateFrom));
        }
        if (filters.dateTo) {
            constraints.push(where("createdAt", "<=", filters.dateTo));
        }
        if (filters.hasFlags) {
            constraints.push(where("flags", ">", 0));
        }

        // Add ordering and pagination
        constraints.push(orderBy("createdAt", "desc"));
        constraints.push(limit(pageSize));

        if (lastDoc) {
            constraints.push(startAfter(lastDoc));
        }

        const querySnapshot = await getDocs(query(q, ...constraints));

        const users: User[] = querySnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            createdAt: doc.data().createdAt?.toDate() || new Date(),
            lastActive: doc.data().lastActive?.toDate(),
            suspendedUntil: doc.data().suspendedUntil?.toDate(),
        })) as User[];

        // If search filter is applied, filter client-side
        let filteredUsers = users;
        if (filters.search) {
            const searchLower = filters.search.toLowerCase();
            filteredUsers = users.filter(user =>
                user.email.toLowerCase().includes(searchLower) ||
                user.displayName?.toLowerCase().includes(searchLower) ||
                user.phoneNumber?.toLowerCase().includes(searchLower)
            );
        }

        return {
            users: filteredUsers,
            total: filteredUsers.length,
            hasMore: querySnapshot.docs.length === pageSize,
            lastDoc: querySnapshot.docs[querySnapshot.docs.length - 1],
        };
    } catch (error) {
        console.error("Error fetching users:", error);
        throw new Error("Failed to fetch users");
    }
}

// Get user by ID
export async function getUserById(userId: string): Promise<User | null> {
    if (DEV_MODE) {
        console.log('🔧 DEV MODE: Getting mock user by ID');
        return MOCK_USERS.find(user => user.id === userId) || null;
    }

    try {
        const userRef = doc(db, "users", userId);
        const userDoc = await getDoc(userRef);

        if (!userDoc.exists()) {
            throw new Error("User not found");
        }

        const userData = userDoc.data();
        return {
            id: userDoc.id,
            ...userData,
            createdAt: userData.createdAt?.toDate() || new Date(),
            lastActive: userData.lastActive?.toDate(),
            suspendedUntil: userData.suspendedUntil?.toDate(),
        } as User;
    } catch (error) {
        console.error('Error getting user by ID:', error);
        throw error;
    }
}

// Update user status
export async function updateUserStatus(
    userId: string,
    status: 'active' | 'suspended' | 'banned',
    reason?: string,
    suspendedUntil?: Date
): Promise<void> {
    if (DEV_MODE) {
        console.log('🔧 DEV MODE: Mock user status update');
        return;
    }

    try {
        const userRef = doc(db, "users", userId);
        const userDoc = await getDoc(userRef);

        if (!userDoc.exists()) {
            throw new Error("User not found");
        }

        const updateData: any = {
            status,
            updatedAt: new Date()
        };

        if (status === 'suspended') {
            updateData.suspendedUntil = suspendedUntil;
            updateData.suspensionReason = reason;
        } else if (status === 'banned') {
            updateData.banReason = reason;
            updateData.bannedAt = new Date();
        } else if (status === 'active') {
            updateData.suspendedUntil = null;
            updateData.suspensionReason = null;
            updateData.banReason = null;
            updateData.bannedAt = null;
        }

        await updateDoc(userRef, updateData);

        // Log the action
        await logAction('user_status_updated', {
            userId,
            status,
            reason,
            suspendedUntil
        });
    } catch (error) {
        console.error('Error updating user status:', error);
        throw error;
    }
}

// Add moderation note to user
export async function addModerationNote(userId: string, note: string): Promise<void> {
    if (DEV_MODE) {
        console.log('🔧 DEV MODE: Mock moderation note added');
        return;
    }

    try {
        const userRef = doc(db, "users", userId);
        const userDoc = await getDoc(userRef);

        if (!userDoc.exists()) {
            throw new Error("User not found");
        }

        const currentNotes = userDoc.data().moderationNotes || '';
        const newNotes = currentNotes ? `${currentNotes}\n\n${new Date().toISOString()}: ${note}` : `${new Date().toISOString()}: ${note}`;

        await updateDoc(userRef, {
            moderationNotes: newNotes,
            updatedAt: new Date()
        });

        // Log the action
        await logAction('moderation_note_added', {
            userId,
            note
        });
    } catch (error) {
        console.error('Error adding moderation note:', error);
        throw error;
    }
}

// Bulk update user statuses
export async function bulkUpdateUserStatus(
    userIds: string[],
    status: 'active' | 'suspended' | 'banned',
    reason?: string
): Promise<void> {
    if (DEV_MODE) {
        console.log('🔧 DEV MODE: Mock bulk user status update');
        return;
    }

    try {
        const batch = writeBatch(db);

        for (const userId of userIds) {
            const userRef = doc(db, "users", userId);
            const updateData: any = {
                status,
                updatedAt: new Date()
            };

            if (status === 'banned') {
                updateData.banReason = reason;
                updateData.bannedAt = new Date();
            } else if (status === 'active') {
                updateData.suspendedUntil = null;
                updateData.suspensionReason = null;
                updateData.banReason = null;
                updateData.bannedAt = null;
            }

            batch.update(userRef, updateData);
        }

        await batch.commit();

        // Log the action
        await logAction('bulk_user_status_updated', {
            userIds,
            status,
            reason
        });
    } catch (error) {
        console.error('Error bulk updating user statuses:', error);
        throw error;
    }
}

// Get user statistics
export async function getUserStats(): Promise<{
    total: number;
    active: number;
    suspended: number;
    banned: number;
    withFlags: number;
    newThisMonth: number;
}> {
    if (DEV_MODE) {
        console.log('🔧 DEV MODE: Returning mock user stats');
        return {
            total: MOCK_USERS.length,
            active: MOCK_USERS.filter(u => u.status === 'active').length,
            suspended: MOCK_USERS.filter(u => u.status === 'suspended').length,
            banned: MOCK_USERS.filter(u => u.status === 'banned').length,
            withFlags: MOCK_USERS.filter(u => (u.flags || 0) > 0).length,
            newThisMonth: MOCK_USERS.filter(u => u.createdAt.getMonth() === new Date().getMonth()).length
        };
    }

    try {
        const usersRef = collection(db, "users");
        const querySnapshot = await getDocs(usersRef);

        const users = querySnapshot.docs.map(doc => ({
            ...doc.data(),
            createdAt: doc.data().createdAt?.toDate() || new Date(),
            status: doc.data().status || 'active',
        })) as User[];

        const now = new Date();
        const thisMonth = new Date(now.getFullYear(), now.getMonth(), 1);

        return {
            total: users.length,
            active: users.filter(u => u.status === 'active').length,
            suspended: users.filter(u => u.status === 'suspended').length,
            banned: users.filter(u => u.status === 'banned').length,
            withFlags: users.filter(u => (u.flags || 0) > 0).length,
            newThisMonth: users.filter(u => u.createdAt >= thisMonth).length
        };
    } catch (error) {
        console.error('Error getting user stats:', error);
        throw error;
    }
}

// Helper function to log actions
async function logAction(action: string, metadata: any): Promise<void> {
    try {
        const { createLog } = await import('./logs_service');
        await createLog(action, {
            ...metadata,
            severity: 'info'
        });
    } catch (error) {
        console.error('Failed to log action:', error);
        // Don't throw error for logging failures
    }
}
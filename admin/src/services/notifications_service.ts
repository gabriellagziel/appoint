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
    writeBatch,
    addDoc,
    deleteDoc,
    serverTimestamp
} from "firebase/firestore";

// Development mode flag
const DEV_MODE = !process.env.NEXT_PUBLIC_FIREBASE_API_KEY;

// Mock data for development
const MOCK_NOTIFICATIONS: AdminNotification[] = [
    {
        id: '1',
        type: 'push',
        title: 'New appointment confirmed',
        message: 'Your appointment with Downtown Dental has been confirmed for tomorrow at 10:00 AM.',
        recipient: 'user123',
        recipientEmail: 'user123@example.com',
        status: 'sent',
        timestamp: new Date('2024-01-15T14:30:00Z'),
        read: true,
        priority: 'normal',
        category: 'appointment',
        metadata: {
            appointmentId: 'apt-123',
            businessId: 'business-456'
        }
    },
    {
        id: '2',
        type: 'email',
        title: 'Payment received',
        message: 'Payment of $150.00 has been received for your dental appointment.',
        recipient: 'user456',
        recipientEmail: 'user456@example.com',
        status: 'delivered',
        timestamp: new Date('2024-01-15T13:45:00Z'),
        read: false,
        priority: 'high',
        category: 'payment',
        metadata: {
            paymentId: 'pay-789',
            amount: 150.00
        }
    },
    {
        id: '3',
        type: 'sms',
        title: 'Appointment reminder',
        message: 'Reminder: You have an appointment tomorrow at 2:30 PM with City Spa.',
        recipient: 'user789',
        recipientEmail: 'user789@example.com',
        status: 'failed',
        timestamp: new Date('2024-01-15T12:20:00Z'),
        read: false,
        priority: 'normal',
        category: 'reminder',
        metadata: {
            appointmentId: 'apt-456',
            businessId: 'business-789'
        }
    }
];

export interface AdminNotification {
    id: string;
    type: 'push' | 'email' | 'sms' | 'in_app';
    title: string;
    message: string;
    recipient: string;
    recipientEmail?: string;
    status: 'pending' | 'sent' | 'delivered' | 'failed' | 'read';
    timestamp: Date;
    read: boolean;
    priority: 'low' | 'normal' | 'high' | 'critical';
    category: 'appointment' | 'payment' | 'reminder' | 'system' | 'marketing';
    metadata?: any;
    errorMessage?: string;
    retryCount?: number;
    scheduledFor?: Date;
}

export interface NotificationFilters {
    type?: string;
    status?: string;
    priority?: string;
    category?: string;
    recipient?: string;
    dateFrom?: Date;
    dateTo?: Date;
    search?: string;
}

export interface NotificationResponse {
    notifications: AdminNotification[];
    total: number;
    hasMore: boolean;
    lastDoc?: QueryDocumentSnapshot<DocumentData>;
}

// Fetch notifications with pagination and filters
export async function fetchNotifications(
    filters: NotificationFilters = {},
    pageSize: number = 20,
    lastDoc?: QueryDocumentSnapshot<DocumentData>
): Promise<NotificationResponse> {
    try {
        if (DEV_MODE) {
            // Return mock data in development
            let filteredNotifications = MOCK_NOTIFICATIONS;

            // Apply filters
            if (filters.type && filters.type !== 'all') {
                filteredNotifications = filteredNotifications.filter(n => n.type === filters.type);
            }
            if (filters.status && filters.status !== 'all') {
                filteredNotifications = filteredNotifications.filter(n => n.status === filters.status);
            }
            if (filters.priority && filters.priority !== 'all') {
                filteredNotifications = filteredNotifications.filter(n => n.priority === filters.priority);
            }
            if (filters.category && filters.category !== 'all') {
                filteredNotifications = filteredNotifications.filter(n => n.category === filters.category);
            }
            if (filters.recipient) {
                filteredNotifications = filteredNotifications.filter(n => 
                    n.recipient.includes(filters.recipient!) || 
                    n.recipientEmail?.includes(filters.recipient!)
                );
            }
            if (filters.search) {
                const searchLower = filters.search.toLowerCase();
                filteredNotifications = filteredNotifications.filter(n =>
                    n.title.toLowerCase().includes(searchLower) ||
                    n.message.toLowerCase().includes(searchLower)
                );
            }

            return {
                notifications: filteredNotifications,
                total: filteredNotifications.length,
                hasMore: false
            };
        }

        let q = collection(db, "admin_notifications");
        const constraints: any[] = [];

        // Apply filters
        if (filters.type && filters.type !== 'all') {
            constraints.push(where("type", "==", filters.type));
        }
        if (filters.status && filters.status !== 'all') {
            constraints.push(where("status", "==", filters.status));
        }
        if (filters.priority && filters.priority !== 'all') {
            constraints.push(where("priority", "==", filters.priority));
        }
        if (filters.category && filters.category !== 'all') {
            constraints.push(where("category", "==", filters.category));
        }
        if (filters.recipient) {
            constraints.push(where("recipient", "==", filters.recipient));
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
        const notifications = querySnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            timestamp: doc.data().timestamp?.toDate() || new Date(),
        })) as AdminNotification[];

        return {
            notifications,
            total: notifications.length,
            hasMore: querySnapshot.docs.length === pageSize,
            lastDoc: querySnapshot.docs[querySnapshot.docs.length - 1]
        };
    } catch (error) {
        console.error('Error fetching notifications:', error);
        throw error;
    }
}

// Create a new notification
export async function createNotification(
    notification: Omit<AdminNotification, 'id' | 'timestamp'>
): Promise<string> {
    try {
        if (DEV_MODE) {
            const newNotification: AdminNotification = {
                ...notification,
                id: Date.now().toString(),
                timestamp: new Date()
            };
            MOCK_NOTIFICATIONS.unshift(newNotification);
            return newNotification.id;
        }

        const docRef = await addDoc(collection(db, "admin_notifications"), {
            ...notification,
            timestamp: serverTimestamp()
        });

        // Log the action
        await logAction('notification_created', {
            notificationId: docRef.id,
            type: notification.type,
            recipient: notification.recipient,
            priority: notification.priority
        });

        return docRef.id;
    } catch (error) {
        console.error('Error creating notification:', error);
        throw error;
    }
}

// Update notification status
export async function updateNotificationStatus(
    notificationId: string,
    status: AdminNotification['status'],
    metadata?: {
        errorMessage?: string;
        retryCount?: number;
    }
): Promise<void> {
    try {
        if (DEV_MODE) {
            const notification = MOCK_NOTIFICATIONS.find(n => n.id === notificationId);
            if (notification) {
                notification.status = status;
                if (metadata) {
                    notification.errorMessage = metadata.errorMessage;
                    notification.retryCount = metadata.retryCount;
                }
            }
            return;
        }

        const notificationRef = doc(db, "admin_notifications", notificationId);
        await updateDoc(notificationRef, {
            status,
            ...metadata,
            updatedAt: serverTimestamp()
        });

        // Log the action
        await logAction('notification_status_updated', {
            notificationId,
            status,
            metadata
        });
    } catch (error) {
        console.error('Error updating notification status:', error);
        throw error;
    }
}

// Mark notification as read
export async function markNotificationAsRead(notificationId: string): Promise<void> {
    try {
        if (DEV_MODE) {
            const notification = MOCK_NOTIFICATIONS.find(n => n.id === notificationId);
            if (notification) {
                notification.read = true;
            }
            return;
        }

        const notificationRef = doc(db, "admin_notifications", notificationId);
        await updateDoc(notificationRef, {
            read: true,
            readAt: serverTimestamp()
        });
    } catch (error) {
        console.error('Error marking notification as read:', error);
        throw error;
    }
}

// Delete notification
export async function deleteNotification(notificationId: string): Promise<void> {
    try {
        if (DEV_MODE) {
            const index = MOCK_NOTIFICATIONS.findIndex(n => n.id === notificationId);
            if (index > -1) {
                MOCK_NOTIFICATIONS.splice(index, 1);
            }
            return;
        }

        const notificationRef = doc(db, "admin_notifications", notificationId);
        await deleteDoc(notificationRef);

        // Log the action
        await logAction('notification_deleted', {
            notificationId
        });
    } catch (error) {
        console.error('Error deleting notification:', error);
        throw error;
    }
}

// Get notification statistics
export async function getNotificationStats(): Promise<{
    total: number;
    sent: number;
    delivered: number;
    failed: number;
    pending: number;
    byType: { [key: string]: number };
    byPriority: { [key: string]: number };
    byCategory: { [key: string]: number };
    today: number;
    thisWeek: number;
    thisMonth: number;
}> {
    try {
        if (DEV_MODE) {
            const now = new Date();
            const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
            const thisWeek = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
            const thisMonth = new Date(now.getFullYear(), now.getMonth(), 1);

            const todayNotifications = MOCK_NOTIFICATIONS.filter(n => n.timestamp >= today);
            const thisWeekNotifications = MOCK_NOTIFICATIONS.filter(n => n.timestamp >= thisWeek);
            const thisMonthNotifications = MOCK_NOTIFICATIONS.filter(n => n.timestamp >= thisMonth);

            const byType = MOCK_NOTIFICATIONS.reduce((acc, n) => {
                acc[n.type] = (acc[n.type] || 0) + 1;
                return acc;
            }, {} as { [key: string]: number });

            const byPriority = MOCK_NOTIFICATIONS.reduce((acc, n) => {
                acc[n.priority] = (acc[n.priority] || 0) + 1;
                return acc;
            }, {} as { [key: string]: number });

            const byCategory = MOCK_NOTIFICATIONS.reduce((acc, n) => {
                acc[n.category] = (acc[n.category] || 0) + 1;
                return acc;
            }, {} as { [key: string]: number });

            return {
                total: MOCK_NOTIFICATIONS.length,
                sent: MOCK_NOTIFICATIONS.filter(n => n.status === 'sent').length,
                delivered: MOCK_NOTIFICATIONS.filter(n => n.status === 'delivered').length,
                failed: MOCK_NOTIFICATIONS.filter(n => n.status === 'failed').length,
                pending: MOCK_NOTIFICATIONS.filter(n => n.status === 'pending').length,
                byType,
                byPriority,
                byCategory,
                today: todayNotifications.length,
                thisWeek: thisWeekNotifications.length,
                thisMonth: thisMonthNotifications.length
            };
        }

        // Real implementation would query Firestore for statistics
        const notificationsSnapshot = await getDocs(collection(db, "admin_notifications"));
        const notifications = notificationsSnapshot.docs.map(doc => ({
            ...doc.data(),
            timestamp: doc.data().timestamp?.toDate() || new Date(),
        })) as AdminNotification[];

        const now = new Date();
        const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const thisWeek = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
        const thisMonth = new Date(now.getFullYear(), now.getMonth(), 1);

        const todayNotifications = notifications.filter(n => n.timestamp >= today);
        const thisWeekNotifications = notifications.filter(n => n.timestamp >= thisWeek);
        const thisMonthNotifications = notifications.filter(n => n.timestamp >= thisMonth);

        const byType = notifications.reduce((acc, n) => {
            acc[n.type] = (acc[n.type] || 0) + 1;
            return acc;
        }, {} as { [key: string]: number });

        const byPriority = notifications.reduce((acc, n) => {
            acc[n.priority] = (acc[n.priority] || 0) + 1;
            return acc;
        }, {} as { [key: string]: number });

        const byCategory = notifications.reduce((acc, n) => {
            acc[n.category] = (acc[n.category] || 0) + 1;
            return acc;
        }, {} as { [key: string]: number });

        return {
            total: notifications.length,
            sent: notifications.filter(n => n.status === 'sent').length,
            delivered: notifications.filter(n => n.status === 'delivered').length,
            failed: notifications.filter(n => n.status === 'failed').length,
            pending: notifications.filter(n => n.status === 'pending').length,
            byType,
            byPriority,
            byCategory,
            today: todayNotifications.length,
            thisWeek: thisWeekNotifications.length,
            thisMonth: thisMonthNotifications.length
        };
    } catch (error) {
        console.error('Error getting notification stats:', error);
        throw error;
    }
}

// Retry failed notification
export async function retryNotification(notificationId: string): Promise<void> {
    try {
        if (DEV_MODE) {
            const notification = MOCK_NOTIFICATIONS.find(n => n.id === notificationId);
            if (notification && notification.status === 'failed') {
                notification.status = 'pending';
                notification.retryCount = (notification.retryCount || 0) + 1;
            }
            return;
        }

        const notificationRef = doc(db, "admin_notifications", notificationId);
        await updateDoc(notificationRef, {
            status: 'pending',
            retryCount: (await getDoc(notificationRef)).data()?.retryCount + 1 || 1,
            updatedAt: serverTimestamp()
        });

        // Log the action
        await logAction('notification_retry', {
            notificationId
        });
    } catch (error) {
        console.error('Error retrying notification:', error);
        throw error;
    }
}

// Log action for audit trail
async function logAction(action: string, metadata: any): Promise<void> {
    try {
        if (!DEV_MODE) {
            await addDoc(collection(db, "system_logs"), {
                action,
                metadata,
                timestamp: serverTimestamp(),
                type: 'notification'
            });
        }
    } catch (error) {
        console.error('Error logging action:', error);
    }
}






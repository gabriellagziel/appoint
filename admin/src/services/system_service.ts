import { db } from "@/lib/firebase";
import {
    collection,
    doc,
    getDoc,
    getDocs,
    query,
    where,
    orderBy,
    limit,
    serverTimestamp,
    addDoc,
    updateDoc
} from "firebase/firestore";

// Development mode flag
const DEV_MODE = !process.env.NEXT_PUBLIC_FIREBASE_API_KEY;

export interface SystemMetrics {
    cpuUsage: number;
    memoryUsage: number;
    diskUsage: number;
    networkLatency: number;
    activeConnections: number;
    requestsPerSecond: number;
    errorRate: number;
    timestamp: Date;
}

export interface ServiceHealth {
    name: string;
    status: 'healthy' | 'warning' | 'error' | 'offline';
    responseTime: number;
    uptime: string;
    lastCheck: Date;
    endpoint: string;
    version: string;
}

export interface SystemAlert {
    id: string;
    type: 'info' | 'warning' | 'error' | 'critical';
    message: string;
    timestamp: Date;
    resolved: boolean;
    resolvedAt?: Date;
    severity: 'low' | 'medium' | 'high' | 'critical';
    service?: string;
    metadata?: any;
}

export interface SystemStatus {
    overall: 'healthy' | 'warning' | 'error' | 'critical';
    uptime: string;
    lastIncident?: Date;
    activeUsers: number;
    totalRequests: number;
    errorRate: number;
    lastUpdated: Date;
}

// Mock data for development
const MOCK_SYSTEM_STATUS: SystemStatus = {
    overall: "healthy",
    uptime: "99.9%",
    lastIncident: new Date('2024-01-10T14:30:00Z'),
    activeUsers: 1247,
    totalRequests: 45678,
    errorRate: 0.02,
    lastUpdated: new Date()
};

const MOCK_SYSTEM_METRICS: SystemMetrics = {
    cpuUsage: 45,
    memoryUsage: 62,
    diskUsage: 78,
    networkLatency: 120,
    activeConnections: 234,
    requestsPerSecond: 156,
    errorRate: 0.02,
    timestamp: new Date()
};

const MOCK_SERVICES: ServiceHealth[] = [
    {
        name: "API Gateway",
        status: "healthy",
        responseTime: 45,
        uptime: "99.9%",
        lastCheck: new Date(),
        endpoint: "/api/health",
        version: "1.2.3"
    },
    {
        name: "Database",
        status: "healthy",
        responseTime: 12,
        uptime: "99.8%",
        lastCheck: new Date(),
        endpoint: "/db/health",
        version: "2.1.0"
    },
    {
        name: "Authentication",
        status: "healthy",
        responseTime: 23,
        uptime: "99.9%",
        lastCheck: new Date(),
        endpoint: "/auth/health",
        version: "1.0.5"
    },
    {
        name: "File Storage",
        status: "warning",
        responseTime: 156,
        uptime: "98.5%",
        lastCheck: new Date(),
        endpoint: "/storage/health",
        version: "1.1.2"
    },
    {
        name: "Email Service",
        status: "healthy",
        responseTime: 89,
        uptime: "99.7%",
        lastCheck: new Date(),
        endpoint: "/email/health",
        version: "1.0.8"
    },
    {
        name: "Analytics",
        status: "healthy",
        responseTime: 34,
        uptime: "99.6%",
        lastCheck: new Date(),
        endpoint: "/analytics/health",
        version: "2.0.1"
    }
];

const MOCK_ALERTS: SystemAlert[] = [
    {
        id: '1',
        type: 'warning',
        message: 'High disk usage on server-03',
        timestamp: new Date('2024-01-15T10:30:00Z'),
        resolved: false,
        severity: 'medium',
        service: 'File Storage',
        metadata: { diskUsage: 85 }
    },
    {
        id: '2',
        type: 'info',
        message: 'Scheduled maintenance completed',
        timestamp: new Date('2024-01-15T09:00:00Z'),
        resolved: true,
        resolvedAt: new Date('2024-01-15T09:30:00Z'),
        severity: 'low',
        service: 'System'
    },
    {
        id: '3',
        type: 'error',
        message: 'Database connection timeout',
        timestamp: new Date('2024-01-15T08:45:00Z'),
        resolved: true,
        resolvedAt: new Date('2024-01-15T09:15:00Z'),
        severity: 'high',
        service: 'Database'
    }
];

// Get current system status
export async function getSystemStatus(): Promise<SystemStatus> {
    try {
        if (DEV_MODE) {
            return MOCK_SYSTEM_STATUS;
        }

        // In production, this would fetch from a real monitoring system
        const statusDoc = await getDoc(doc(db, "system_metrics", "current_status"));
        if (statusDoc.exists()) {
            const data = statusDoc.data();
            return {
                ...data,
                lastUpdated: data.lastUpdated?.toDate() || new Date(),
                lastIncident: data.lastIncident?.toDate()
            } as SystemStatus;
        }

        // Fallback to calculated status
        return await calculateSystemStatus();
    } catch (error) {
        console.error('Error getting system status:', error);
        throw error;
    }
}

// Get current system metrics
export async function getSystemMetrics(): Promise<SystemMetrics> {
    try {
        if (DEV_MODE) {
            return MOCK_SYSTEM_METRICS;
        }

        const metricsDoc = await getDoc(doc(db, "system_metrics", "current_metrics"));
        if (metricsDoc.exists()) {
            const data = metricsDoc.data();
            return {
                ...data,
                timestamp: data.timestamp?.toDate() || new Date()
            } as SystemMetrics;
        }

        // Fallback to default metrics
        return {
            cpuUsage: 0,
            memoryUsage: 0,
            diskUsage: 0,
            networkLatency: 0,
            activeConnections: 0,
            requestsPerSecond: 0,
            errorRate: 0,
            timestamp: new Date()
        };
    } catch (error) {
        console.error('Error getting system metrics:', error);
        throw error;
    }
}

// Get service health status
export async function getServiceHealth(): Promise<ServiceHealth[]> {
    try {
        if (DEV_MODE) {
            return MOCK_SERVICES;
        }

        const servicesSnapshot = await getDocs(collection(db, "system_services"));
        const services = servicesSnapshot.docs.map((doc: any) => ({
            id: doc.id,
            ...doc.data(),
            lastCheck: doc.data().lastCheck?.toDate() || new Date()
        })) as ServiceHealth[];

        return services;
    } catch (error) {
        console.error('Error getting service health:', error);
        throw error;
    }
}

// Get system alerts
export async function getSystemAlerts(limitCount: number = 50): Promise<SystemAlert[]> {
    try {
        if (DEV_MODE) {
            return MOCK_ALERTS.slice(0, limitCount);
        }

        const alertsQuery = query(
            collection(db, "system_alerts"),
            orderBy("timestamp", "desc"),
            limit(limitCount)
        );
        
        const alertsSnapshot = await getDocs(alertsQuery);
        const alerts = alertsSnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            timestamp: doc.data().timestamp?.toDate() || new Date(),
            resolvedAt: doc.data().resolvedAt?.toDate()
        })) as SystemAlert[];

        return alerts;
    } catch (error) {
        console.error('Error getting system alerts:', error);
        throw error;
    }
}

// Create a new system alert
export async function createSystemAlert(alert: Omit<SystemAlert, 'id' | 'timestamp'>): Promise<string> {
    try {
        if (DEV_MODE) {
            const newAlert: SystemAlert = {
                ...alert,
                id: Date.now().toString(),
                timestamp: new Date()
            };
            MOCK_ALERTS.unshift(newAlert);
            return newAlert.id;
        }

        const docRef = await addDoc(collection(db, "system_alerts"), {
            ...alert,
            timestamp: serverTimestamp()
        });

        return docRef.id;
    } catch (error) {
        console.error('Error creating system alert:', error);
        throw error;
    }
}

// Resolve a system alert
export async function resolveSystemAlert(alertId: string): Promise<void> {
    try {
        if (DEV_MODE) {
            const alert = MOCK_ALERTS.find(a => a.id === alertId);
            if (alert) {
                alert.resolved = true;
                alert.resolvedAt = new Date();
            }
            return;
        }

        const alertRef = doc(db, "system_alerts", alertId);
        await updateDoc(alertRef, {
            resolved: true,
            resolvedAt: serverTimestamp()
        });
    } catch (error) {
        console.error('Error resolving system alert:', error);
        throw error;
    }
}

// Update system metrics
export async function updateSystemMetrics(metrics: Partial<SystemMetrics>): Promise<void> {
    try {
        if (DEV_MODE) {
            Object.assign(MOCK_SYSTEM_METRICS, metrics);
            MOCK_SYSTEM_METRICS.timestamp = new Date();
            return;
        }

        const metricsRef = doc(db, "system_metrics", "current_metrics");
        await updateDoc(metricsRef, {
            ...metrics,
            timestamp: serverTimestamp()
        });
    } catch (error) {
        console.error('Error updating system metrics:', error);
        throw error;
    }
}

// Update system status
export async function updateSystemStatus(status: Partial<SystemStatus>): Promise<void> {
    try {
        if (DEV_MODE) {
            Object.assign(MOCK_SYSTEM_STATUS, status);
            MOCK_SYSTEM_STATUS.lastUpdated = new Date();
            return;
        }

        const statusRef = doc(db, "system_metrics", "current_status");
        await updateDoc(statusRef, {
            ...status,
            lastUpdated: serverTimestamp()
        });
    } catch (error) {
        console.error('Error updating system status:', error);
        throw error;
    }
}

// Calculate system status based on metrics
async function calculateSystemStatus(): Promise<SystemStatus> {
    try {
        const metrics = await getSystemMetrics();
        const services = await getServiceHealth();
        const alerts = await getSystemAlerts(10);

        // Calculate overall status
        let overall: SystemStatus['overall'] = 'healthy';
        const errorServices = services.filter(s => s.status === 'error').length;
        const warningServices = services.filter(s => s.status === 'warning').length;
        const criticalAlerts = alerts.filter(a => a.severity === 'critical' && !a.resolved).length;

        if (criticalAlerts > 0 || errorServices > 0) {
            overall = 'critical';
        } else if (warningServices > 0 || metrics.cpuUsage > 80 || metrics.memoryUsage > 85) {
            overall = 'warning';
        }

        // Calculate uptime (simplified)
        const uptime = "99.9%"; // This would be calculated from actual uptime data

        // Get active users from users collection
        const usersSnapshot = await getDocs(collection(db, "users"));
        const activeUsers = usersSnapshot.size;

        return {
            overall,
            uptime,
            activeUsers,
            totalRequests: metrics.requestsPerSecond * 3600, // Estimate daily requests
            errorRate: metrics.errorRate,
            lastUpdated: new Date()
        };
    } catch (error) {
        console.error('Error calculating system status:', error);
        throw error;
    }
}

// Get system statistics
export async function getSystemStats(): Promise<{
    totalAlerts: number;
    activeAlerts: number;
    resolvedAlerts: number;
    healthyServices: number;
    totalServices: number;
    averageResponseTime: number;
    uptimePercentage: number;
}> {
    try {
        if (DEV_MODE) {
            const services = MOCK_SERVICES;
            const alerts = MOCK_ALERTS;
            
            return {
                totalAlerts: alerts.length,
                activeAlerts: alerts.filter(a => !a.resolved).length,
                resolvedAlerts: alerts.filter(a => a.resolved).length,
                healthyServices: services.filter(s => s.status === 'healthy').length,
                totalServices: services.length,
                averageResponseTime: services.reduce((sum, s) => sum + s.responseTime, 0) / services.length,
                uptimePercentage: 99.9
            };
        }

        const [services, alerts] = await Promise.all([
            getServiceHealth(),
            getSystemAlerts()
        ]);

        return {
            totalAlerts: alerts.length,
            activeAlerts: alerts.filter(a => !a.resolved).length,
            resolvedAlerts: alerts.filter(a => a.resolved).length,
            healthyServices: services.filter(s => s.status === 'healthy').length,
            totalServices: services.length,
            averageResponseTime: services.reduce((sum, s) => sum + s.responseTime, 0) / services.length,
            uptimePercentage: 99.9 // This would be calculated from actual uptime data
        };
    } catch (error) {
        console.error('Error getting system stats:', error);
        throw error;
    }
}






import { db } from '@/lib/firebase';
import {
    collection,
    getDocs,
    orderBy,
    query,
    where
} from 'firebase/firestore';

export interface AnalyticsData {
    totalAppointments: number;
    confirmedAppointments: number;
    cancelledAppointments: number;
    pendingAppointments: number;
    totalCustomers: number;
    activeCustomers: number;
    totalRevenue: number;
    averageMeetingDuration: number;
    topServices: Array<{ service: string; count: number }>;
    topStaff: Array<{ staffId: string; name: string; appointments: number }>;
    monthlyStats: Array<{ month: string; appointments: number; revenue: number }>;
    usageStats: {
        mapLoads: number;
        meetingsCreated: number;
        customersAdded: number;
        staffMembers: number;
    };
}

export interface RevenueData {
    id: string;
    businessId: string;
    amount: number;
    source: 'stripeReported' | 'cash' | 'other';
    description: string;
    date: Date;
    serviceId?: string;
    customerId?: string;
    staffId?: string;
    createdAt: Date;
}

export interface MonthlyReport {
    month: string;
    totalAppointments: number;
    totalRevenue: number;
    totalCustomers: number;
    averageRating: number;
    topPerformingService: string;
    topPerformingStaff: string;
}

const COLLECTION_NAME = 'analytics';

/**
 * Get analytics data for a business
 */
export const getAnalyticsData = async (businessId: string): Promise<AnalyticsData> => {
    try {
        // Get appointments data
        const appointmentsQuery = query(
            collection(db, 'appointments'),
            where('businessId', '==', businessId)
        );
        const appointmentsSnapshot = await getDocs(appointmentsQuery);

        const appointments = appointmentsSnapshot.docs.map(doc => doc.data());

        // Calculate appointment stats
        const totalAppointments = appointments.length;
        const confirmedAppointments = appointments.filter(a => a.status === 'confirmed').length;
        const cancelledAppointments = appointments.filter(a => a.status === 'cancelled').length;
        const pendingAppointments = appointments.filter(a => a.status === 'pending').length;

        // Get customers data
        const customersQuery = query(
            collection(db, 'customers'),
            where('businessId', '==', businessId)
        );
        const customersSnapshot = await getDocs(customersQuery);
        const customers = customersSnapshot.docs.map(doc => doc.data());

        // Calculate customer stats
        const totalCustomers = customers.length;
        const activeCustomers = customers.filter(c => c.status === 'active').length;

        // Get revenue data
        const revenueQuery = query(
            collection(db, 'revenue'),
            where('businessId', '==', businessId)
        );
        const revenueSnapshot = await getDocs(revenueQuery);
        const revenueData = revenueSnapshot.docs.map(doc => doc.data());

        // Calculate revenue
        const totalRevenue = revenueData.reduce((sum, r) => sum + (r.amount || 0), 0);

        // Calculate average meeting duration
        const totalDuration = appointments.reduce((sum, a) => sum + (a.duration || 0), 0);
        const averageMeetingDuration = totalAppointments > 0 ? totalDuration / totalAppointments : 0;

        // Calculate top services
        const serviceCounts: { [key: string]: number } = {};
        appointments.forEach(appointment => {
            const service = appointment.service;
            serviceCounts[service] = (serviceCounts[service] || 0) + 1;
        });

        const topServices = Object.entries(serviceCounts)
            .map(([service, count]) => ({ service, count }))
            .sort((a, b) => b.count - a.count)
            .slice(0, 5);

        // Calculate monthly stats (last 6 months)
        const monthlyStats = [];
        const now = new Date();
        for (let i = 5; i >= 0; i--) {
            const month = new Date(now.getFullYear(), now.getMonth() - i, 1);
            const monthStr = month.toLocaleDateString('en-US', { month: 'short', year: 'numeric' });

            const monthAppointments = appointments.filter(a => {
                const appointmentDate = new Date(a.date);
                return appointmentDate.getMonth() === month.getMonth() &&
                    appointmentDate.getFullYear() === month.getFullYear();
            }).length;

            const monthRevenue = revenueData.filter(r => {
                const revenueDate = new Date(r.date);
                return revenueDate.getMonth() === month.getMonth() &&
                    revenueDate.getFullYear() === month.getFullYear();
            }).reduce((sum, r) => sum + (r.amount || 0), 0);

            monthlyStats.push({
                month: monthStr,
                appointments: monthAppointments,
                revenue: monthRevenue
            });
        }

        // Mock usage stats (in real app, this would come from usage tracking)
        const usageStats = {
            mapLoads: Math.floor(Math.random() * 100) + 50,
            meetingsCreated: totalAppointments,
            customersAdded: totalCustomers,
            staffMembers: Math.floor(Math.random() * 10) + 1
        };

        return {
            totalAppointments,
            confirmedAppointments,
            cancelledAppointments,
            pendingAppointments,
            totalCustomers,
            activeCustomers,
            totalRevenue,
            averageMeetingDuration,
            topServices,
            topStaff: [], // Would be calculated from staff data
            monthlyStats,
            usageStats
        };
    } catch (error) {
        console.error('Error fetching analytics data:', error);
        throw new Error('Failed to fetch analytics data');
    }
};

/**
 * Get revenue data for a business
 */
export const getRevenueData = async (businessId: string): Promise<RevenueData[]> => {
    try {
        const q = query(
            collection(db, 'revenue'),
            where('businessId', '==', businessId),
            orderBy('date', 'desc')
        );

        const querySnapshot = await getDocs(q);
        const revenueData: RevenueData[] = [];

        querySnapshot.forEach((doc) => {
            revenueData.push({
                id: doc.id,
                ...doc.data()
            } as RevenueData);
        });

        return revenueData;
    } catch (error) {
        console.error('Error fetching revenue data:', error);
        throw new Error('Failed to fetch revenue data');
    }
};

/**
 * Get monthly report
 */
export const getMonthlyReport = async (businessId: string, month: string): Promise<MonthlyReport> => {
    try {
        const analyticsData = await getAnalyticsData(businessId);

        // Filter data for specific month
        const monthData = analyticsData.monthlyStats.find(m => m.month === month);

        return {
            month,
            totalAppointments: monthData?.appointments || 0,
            totalRevenue: monthData?.revenue || 0,
            totalCustomers: analyticsData.totalCustomers,
            averageRating: 4.5, // Mock data
            topPerformingService: analyticsData.topServices[0]?.service || 'N/A',
            topPerformingStaff: 'John Doe', // Mock data
        };
    } catch (error) {
        console.error('Error fetching monthly report:', error);
        throw new Error('Failed to fetch monthly report');
    }
};

/**
 * Get revenue by source
 */
export const getRevenueBySource = async (businessId: string): Promise<{ source: string; amount: number }[]> => {
    try {
        const revenueData = await getRevenueData(businessId);

        const sourceTotals: { [key: string]: number } = {};
        revenueData.forEach(revenue => {
            sourceTotals[revenue.source] = (sourceTotals[revenue.source] || 0) + revenue.amount;
        });

        return Object.entries(sourceTotals).map(([source, amount]) => ({
            source,
            amount
        }));
    } catch (error) {
        console.error('Error fetching revenue by source:', error);
        throw new Error('Failed to fetch revenue by source');
    }
}; 
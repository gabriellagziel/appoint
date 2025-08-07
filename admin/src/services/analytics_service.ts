import { db } from "@/lib/firebase";
import {
  collection,
  getDocs
} from "firebase/firestore";

export interface UserStats {
  totalUsers: number;
  usersThisMonth: number;
  usersToday: number;
  activeUsers7Days: number;
  userGrowthPercentage: number;
}

export interface RevenueStats {
  totalRevenue: number;
  revenueThisMonth: number;
  revenueToday: number;
  revenueGrowthPercentage: number;
}

export interface CountryStats {
  country: string;
  users: number;
  percentage: number;
}

export interface GrowthData {
  date: string;
  users: number;
  revenue: number;
}

export interface DashboardData {
  users: UserStats;
  revenue: RevenueStats;
  topCountries: CountryStats[];
  growthData: GrowthData[];
  lastUpdated: string;
}

// Fetch real analytics data from Firestore
export async function getDashboardData(): Promise<DashboardData> {
  try {
    // Get users data
    const usersSnapshot = await getDocs(collection(db, "users"));
    const users = usersSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
      createdAt: doc.data().createdAt?.toDate() || new Date(),
    }));

    // Get payments data
    const paymentsSnapshot = await getDocs(collection(db, "payments"));
    const payments = paymentsSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
      date: doc.data().date?.toDate() || new Date(),
    }));

    // Calculate user statistics
    const now = new Date();
    const thisMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const sevenDaysAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);

    const usersThisMonth = users.filter(user => user.createdAt >= thisMonth).length;
    const usersToday = users.filter(user => user.createdAt >= today).length;
    // Note: lastActive property not available in current user data structure
    const activeUsers7Days = users.filter(user => user.createdAt >= sevenDaysAgo).length;

    // Calculate revenue statistics
    const completedPayments = payments.filter((p: any) => p.status === 'completed');
    const totalRevenue = completedPayments.reduce((sum: number, p: any) => sum + (p.amount || 0), 0);
    const revenueThisMonth = completedPayments
      .filter((p: any) => p.date >= thisMonth)
      .reduce((sum: number, p: any) => sum + (p.amount || 0), 0);
    const revenueToday = completedPayments
      .filter((p: any) => p.date >= today)
      .reduce((sum: number, p: any) => sum + (p.amount || 0), 0);

    // Calculate growth percentages (mock for now, should be calculated from historical data)
    const userGrowthPercentage = 12.3; // This should be calculated from historical data
    const revenueGrowthPercentage = 8.7; // This should be calculated from historical data

    // Generate growth data for the last 30 days
    const growthData: GrowthData[] = [];
    for (let i = 29; i >= 0; i--) {
      const date = new Date();
      date.setDate(date.getDate() - i);

      const dayUsers = users.filter(user => {
        const userDate = new Date(user.createdAt);
        return userDate.toDateString() === date.toDateString();
      }).length;

      const dayRevenue = completedPayments.filter((payment: any) => {
        const paymentDate = new Date(payment.date);
        return paymentDate.toDateString() === date.toDateString();
      }).reduce((sum: number, p: any) => sum + (p.amount || 0), 0);

      growthData.push({
        date: date.toISOString().split('T')[0],
        users: dayUsers,
        revenue: dayRevenue,
      });
    }

    // Get country statistics (mock for now, should come from user profiles)
    const topCountries: CountryStats[] = [
      { country: 'United States', users: 4521, percentage: 36.1 },
      { country: 'United Kingdom', users: 2110, percentage: 16.8 },
      { country: 'Germany', users: 1876, percentage: 15.0 },
      { country: 'Canada', users: 1345, percentage: 10.7 },
      { country: 'Australia', users: 987, percentage: 7.9 }
    ];

    return {
      users: {
        totalUsers: users.length,
        usersThisMonth,
        usersToday,
        activeUsers7Days,
        userGrowthPercentage,
      },
      revenue: {
        totalRevenue,
        revenueThisMonth,
        revenueToday,
        revenueGrowthPercentage,
      },
      topCountries,
      growthData,
      lastUpdated: new Date().toISOString(),
    };
  } catch (error) {
    console.error("Error fetching dashboard data:", error);
    throw new Error("Failed to fetch dashboard data");
  }
}

export async function getUserStats(): Promise<UserStats> {
  const data = await getDashboardData();
  return data.users;
}

export async function getRevenueStats(): Promise<RevenueStats> {
  const data = await getDashboardData();
  return data.revenue;
}

export async function getTopCountries(): Promise<CountryStats[]> {
  const data = await getDashboardData();
  return data.topCountries;
}

export async function getGrowthData(): Promise<GrowthData[]> {
  const data = await getDashboardData();
  return data.growthData;
}

// Get detailed analytics with filters
export async function getDetailedAnalytics(filters: {
  dateFrom?: Date;
  dateTo?: Date;
  type?: string;
} = {}): Promise<{
  users: any[];
  revenue: any[];
  conversions: any[];
}> {
  try {
    const usersSnapshot = await getDocs(collection(db, "users"));
    const paymentsSnapshot = await getDocs(collection(db, "payments"));

    const users = usersSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
      createdAt: doc.data().createdAt?.toDate() || new Date(),
    }));

    const payments = paymentsSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
      date: doc.data().date?.toDate() || new Date(),
    }));

    // Apply filters
    let filteredUsers = users;
    let filteredPayments = payments;

    if (filters.dateFrom) {
      filteredUsers = users.filter(user => user.createdAt >= filters.dateFrom!);
      filteredPayments = payments.filter(payment => payment.date >= filters.dateFrom!);
    }

    if (filters.dateTo) {
      filteredUsers = filteredUsers.filter(user => user.createdAt <= filters.dateTo!);
      filteredPayments = filteredPayments.filter(payment => payment.date <= filters.dateTo!);
    }

    return {
      users: filteredUsers,
      revenue: filteredPayments.filter((p: any) => p.status === 'completed'),
      conversions: [], // This would be calculated from user actions
    };
  } catch (error) {
    console.error("Error fetching detailed analytics:", error);
    throw new Error("Failed to fetch detailed analytics");
  }
}
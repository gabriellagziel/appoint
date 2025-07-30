export interface UserStats {
  totalUsers: number
  usersThisMonth: number
  usersToday: number
  activeUsers7Days: number
  userGrowthPercentage: number
}

export interface RevenueStats {
  totalRevenue: number
  revenueThisMonth: number
  revenueToday: number
  revenueGrowthPercentage: number
}

export interface CountryStats {
  country: string
  users: number
  percentage: number
}

export interface GrowthData {
  date: string
  users: number
  revenue: number
}

export interface DashboardData {
  users: UserStats
  revenue: RevenueStats
  topCountries: CountryStats[]
  growthData: GrowthData[]
  lastUpdated: string
}

// Mock data for demonstration - replace with actual API calls
export async function getDashboardData(): Promise<DashboardData> {
  // Simulate API delay
  await new Promise(resolve => setTimeout(resolve, 1000))

  // Generate mock data with realistic patterns
  const currentDate = new Date()
  const lastMonth = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1)
  
  // Generate growth data for the last 30 days
  const growthData: GrowthData[] = []
  for (let i = 29; i >= 0; i--) {
    const date = new Date()
    date.setDate(date.getDate() - i)
    
    const baseUsers = 1000 + Math.random() * 100
    const baseRevenue = 2000 + Math.random() * 500
    const trend = Math.sin((i / 30) * Math.PI) * 50 // Creates a growth trend
    
    growthData.push({
      date: date.toISOString().split('T')[0],
      users: Math.round(baseUsers + trend),
      revenue: Math.round(baseRevenue + trend * 10)
    })
  }

  return {
    users: {
      totalUsers: 12543,
      usersThisMonth: 1247,
      usersToday: 89,
      activeUsers7Days: 3421,
      userGrowthPercentage: 12.3
    },
    revenue: {
      totalRevenue: 285420,
      revenueThisMonth: 28945,
      revenueToday: 1250,
      revenueGrowthPercentage: 8.7
    },
    topCountries: [
      { country: 'United States', users: 4521, percentage: 36.1 },
      { country: 'United Kingdom', users: 2110, percentage: 16.8 },
      { country: 'Germany', users: 1876, percentage: 15.0 },
      { country: 'Canada', users: 1345, percentage: 10.7 },
      { country: 'Australia', users: 987, percentage: 7.9 }
    ],
    growthData,
    lastUpdated: new Date().toISOString()
  }
}

export async function getUserStats(): Promise<UserStats> {
  const data = await getDashboardData()
  return data.users
}

export async function getRevenueStats(): Promise<RevenueStats> {
  const data = await getDashboardData()
  return data.revenue
}

export async function getTopCountries(): Promise<CountryStats[]> {
  const data = await getDashboardData()
  return data.topCountries
}

export async function getGrowthData(): Promise<GrowthData[]> {
  const data = await getDashboardData()
  return data.growthData
}
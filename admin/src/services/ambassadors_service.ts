import { getFunctions, httpsCallable } from 'firebase/functions'

const functions = getFunctions()

export interface AmbassadorProfile {
  id: string
  userId: string
  countryCode: string
  languageCode: string
  status: 'pending' | 'approved' | 'inactive' | 'suspended' | 'pending_ambassador'
  tier: 'basic' | 'premium' | 'lifetime'
  assignedAt: string
  lastActivityDate: string
  totalReferrals: number
  activeReferrals: number
  monthlyReferrals: number
  lastMonthlyResetAt: string
  nextMonthlyReviewAt: string
  earnedRewards: any[]
  shareLink?: string
  shareCode?: string
  pendingSince?: string
  rejectionReason?: string
}

export interface PendingAmbassador {
  userId: string
  pendingSince: string
  referralCount: number
  countryCode: string
  languageCode: string
}

export interface AmbassadorFlag {
  userId: string
  flagType: 'suspicious_ip' | 'suspicious_device' | 'suspicious_email_domain' | 'rapid_referrals'
  reason: string
  flaggedAt: string
  reviewed: boolean
  reviewedBy?: string
  reviewedAt?: string
}

export interface AmbassadorQuota {
  userId: string
  totalReferrals: number
  eligibleForAmbassador: number
  lastUpdated: string
}

export interface AmbassadorStats {
  totalAmbassadors: number
  activeAmbassadors: number
  pendingAmbassadors: number
  totalReferrals: number
  monthlyReferrals: number
  averageReferrals: number
  tierDistribution: {
    basic: number
    premium: number
    lifetime: number
  }
}

export class AmbassadorsService {
  private static instance: AmbassadorsService

  public static getInstance(): AmbassadorsService {
    if (!AmbassadorsService.instance) {
      AmbassadorsService.instance = new AmbassadorsService()
    }
    return AmbassadorsService.instance
  }

  // Get all ambassadors with filters
  async getAmbassadors(filters?: {
    status?: string
    tier?: string
    country?: string
    language?: string
  }): Promise<AmbassadorProfile[]> {
    try {
      const getAmbassadorsFunction = httpsCallable(functions, 'getAmbassadors')
      const result = await getAmbassadorsFunction({ filters })
      return result.data as AmbassadorProfile[]
    } catch (error) {
      console.error('Error fetching ambassadors:', error)
      throw error
    }
  }

  // Get pending ambassadors
  async getPendingAmbassadors(): Promise<PendingAmbassador[]> {
    try {
      const getPendingAmbassadorsFunction = httpsCallable(functions, 'getPendingAmbassadors')
      const result = await getPendingAmbassadorsFunction()
      return result.data as PendingAmbassador[]
    } catch (error) {
      console.error('Error fetching pending ambassadors:', error)
      throw error
    }
  }

  // Get ambassador flags
  async getAmbassadorFlags(): Promise<AmbassadorFlag[]> {
    try {
      const getFlagsFunction = httpsCallable(functions, 'getAmbassadorFlags')
      const result = await getFlagsFunction()
      return result.data as AmbassadorFlag[]
    } catch (error) {
      console.error('Error fetching ambassador flags:', error)
      throw error
    }
  }

  // Approve pending ambassador
  async approvePendingAmbassador(userId: string): Promise<{ success: boolean; message: string }> {
    try {
      const approveFunction = httpsCallable(functions, 'approvePendingAmbassador')
      const result = await approveFunction({ userId })
      return result.data as { success: boolean; message: string }
    } catch (error) {
      console.error('Error approving ambassador:', error)
      throw error
    }
  }

  // Reject pending ambassador
  async rejectPendingAmbassador(userId: string, reason: string): Promise<{ success: boolean; message: string }> {
    try {
      const rejectFunction = httpsCallable(functions, 'rejectPendingAmbassador')
      const result = await rejectFunction({ userId, reason })
      return result.data as { success: boolean; message: string }
    } catch (error) {
      console.error('Error rejecting ambassador:', error)
      throw error
    }
  }

  // Promote ambassador tier
  async promoteAmbassadorTier(userId: string, newTier: string): Promise<{ success: boolean; message: string }> {
    try {
      const promoteFunction = httpsCallable(functions, 'promoteAmbassadorTier')
      const result = await promoteFunction({ userId, newTier })
      return result.data as { success: boolean; message: string }
    } catch (error) {
      console.error('Error promoting ambassador tier:', error)
      throw error
    }
  }

  // Demote ambassador
  async demoteAmbassador(userId: string, reason: string): Promise<{ success: boolean; message: string }> {
    try {
      const demoteFunction = httpsCallable(functions, 'demoteAmbassador')
      const result = await demoteFunction({ userId, reason })
      return result.data as { success: boolean; message: string }
    } catch (error) {
      console.error('Error demoting ambassador:', error)
      throw error
    }
  }

  // Review ambassador flag
  async reviewAmbassadorFlag(userId: string, reviewedBy: string): Promise<{ success: boolean; message: string }> {
    try {
      const reviewFlagFunction = httpsCallable(functions, 'reviewAmbassadorFlag')
      const result = await reviewFlagFunction({ userId, reviewedBy })
      return result.data as { success: boolean; message: string }
    } catch (error) {
      console.error('Error reviewing ambassador flag:', error)
      throw error
    }
  }

  // Get ambassador statistics
  async getAmbassadorStats(): Promise<AmbassadorStats> {
    try {
      const getStatsFunction = httpsCallable(functions, 'getAmbassadorStats')
      const result = await getStatsFunction()
      return result.data as AmbassadorStats
    } catch (error) {
      console.error('Error fetching ambassador stats:', error)
      throw error
    }
  }

  // Get ambassador quotas
  async getAmbassadorQuotas(): Promise<AmbassadorQuota[]> {
    try {
      const getQuotasFunction = httpsCallable(functions, 'getAmbassadorQuotas')
      const result = await getQuotasFunction()
      return result.data as AmbassadorQuota[]
    } catch (error) {
      console.error('Error fetching ambassador quotas:', error)
      throw error
    }
  }

  // Send mass message to ambassadors
  async sendMassMessage(message: string, filters?: {
    status?: string
    tier?: string
    country?: string
  }): Promise<{ success: boolean; message: string }> {
    try {
      const sendMessageFunction = httpsCallable(functions, 'sendAmbassadorMassMessage')
      const result = await sendMessageFunction({ message, filters })
      return result.data as { success: boolean; message: string }
    } catch (error) {
      console.error('Error sending mass message:', error)
      throw error
    }
  }

  // Get automation logs
  async getAutomationLogs(limit: number = 100): Promise<any[]> {
    try {
      const getLogsFunction = httpsCallable(functions, 'getAmbassadorAutomationLogs')
      const result = await getLogsFunction({ limit })
      return result.data as any[]
    } catch (error) {
      console.error('Error fetching automation logs:', error)
      throw error
    }
  }

  // Get tier upgrade logs
  async getTierUpgradeLogs(limit: number = 100): Promise<any[]> {
    try {
      const getLogsFunction = httpsCallable(functions, 'getAmbassadorTierUpgradeLogs')
      const result = await getLogsFunction({ limit })
      return result.data as any[]
    } catch (error) {
      console.error('Error fetching tier upgrade logs:', error)
      throw error
    }
  }

  // Get fraud logs
  async getFraudLogs(limit: number = 100): Promise<any[]> {
    try {
      const getLogsFunction = httpsCallable(functions, 'getAmbassadorFraudLogs')
      const result = await getLogsFunction({ limit })
      return result.data as any[]
    } catch (error) {
      console.error('Error fetching fraud logs:', error)
      throw error
    }
  }

  // Export ambassadors to CSV
  async exportAmbassadorsToCSV(filters?: {
    status?: string
    tier?: string
    country?: string
    language?: string
  }): Promise<string> {
    try {
      const exportFunction = httpsCallable(functions, 'exportAmbassadorsToCSV')
      const result = await exportFunction({ filters })
      return result.data as string
    } catch (error) {
      console.error('Error exporting ambassadors:', error)
      throw error
    }
  }

  // Get ambassador details
  async getAmbassadorDetails(userId: string): Promise<AmbassadorProfile> {
    try {
      const getDetailsFunction = httpsCallable(functions, 'getAmbassadorDetails')
      const result = await getDetailsFunction({ userId })
      return result.data as AmbassadorProfile
    } catch (error) {
      console.error('Error fetching ambassador details:', error)
      throw error
    }
  }

  // Update ambassador settings
  async updateAmbassadorSettings(userId: string, settings: {
    status?: string
    tier?: string
    quota?: number
  }): Promise<{ success: boolean; message: string }> {
    try {
      const updateFunction = httpsCallable(functions, 'updateAmbassadorSettings')
      const result = await updateFunction({ userId, settings })
      return result.data as { success: boolean; message: string }
    } catch (error) {
      console.error('Error updating ambassador settings:', error)
      throw error
    }
  }

  // Get ambassador performance metrics
  async getAmbassadorPerformance(userId: string): Promise<{
    totalReferrals: number
    monthlyReferrals: number
    conversionRate: number
    averageReferralsPerMonth: number
    tierProgress: {
      current: number
      required: number
      progress: number
    }
  }> {
    try {
      const getPerformanceFunction = httpsCallable(functions, 'getAmbassadorPerformance')
      const result = await getPerformanceFunction({ userId })
      return result.data as any
    } catch (error) {
      console.error('Error fetching ambassador performance:', error)
      throw error
    }
  }

  // Flag ambassador for review
  async flagAmbassador(userId: string, flagType: string, reason: string): Promise<{ success: boolean; message: string }> {
    try {
      const flagFunction = httpsCallable(functions, 'flagAmbassador')
      const result = await flagFunction({ userId, flagType, reason })
      return result.data as { success: boolean; message: string }
    } catch (error) {
      console.error('Error flagging ambassador:', error)
      throw error
    }
  }

  // Get ambassador rewards
  async getAmbassadorRewards(userId: string): Promise<any[]> {
    try {
      const getRewardsFunction = httpsCallable(functions, 'getAmbassadorRewards')
      const result = await getRewardsFunction({ userId })
      return result.data as any[]
    } catch (error) {
      console.error('Error fetching ambassador rewards:', error)
      throw error
    }
  }

  // Award reward to ambassador
  async awardReward(userId: string, rewardType: string, description?: string): Promise<{ success: boolean; message: string }> {
    try {
      const awardFunction = httpsCallable(functions, 'awardAmbassadorReward')
      const result = await awardFunction({ userId, rewardType, description })
      return result.data as { success: boolean; message: string }
    } catch (error) {
      console.error('Error awarding reward:', error)
      throw error
    }
  }

  // Revoke ambassador reward
  async revokeReward(userId: string, rewardId: string): Promise<{ success: boolean; message: string }> {
    try {
      const revokeFunction = httpsCallable(functions, 'revokeAmbassadorReward')
      const result = await revokeFunction({ userId, rewardId })
      return result.data as { success: boolean; message: string }
    } catch (error) {
      console.error('Error revoking reward:', error)
      throw error
    }
  }
}

export default AmbassadorsService.getInstance()

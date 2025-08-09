import { db } from '@/lib/firebase'

export interface AuditLogEntry {
  id: string
  type: 'admin_action' | 'access_attempt' | 'data_export' | 'system_change' | 'security_event'
  action: string
  userId?: string
  userEmail?: string
  userRole?: string
  targetResource?: string
  details?: Record<string, any>
  ipAddress?: string
  userAgent?: string
  success: boolean
  error?: string
  timestamp: Date
  metadata?: Record<string, any>
}

export class AuditLogger {
  private static instance: AuditLogger
  private isDevMode = process.env.NODE_ENV === 'development'

  static getInstance(): AuditLogger {
    if (!AuditLogger.instance) {
      AuditLogger.instance = new AuditLogger()
    }
    return AuditLogger.instance
  }

  async logAccessAttempt(
    action: string,
    success: boolean,
    userId?: string,
    userEmail?: string,
    userRole?: string,
    details?: Record<string, any>,
    ipAddress?: string,
    userAgent?: string,
    error?: string
  ): Promise<void> {
    const entry: AuditLogEntry = {
      id: `audit-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
      type: 'access_attempt',
      action,
      userId,
      userEmail,
      userRole,
      details,
      ipAddress,
      userAgent,
      success,
      error,
      timestamp: new Date()
    }

    await this.writeLog(entry)
  }

  async logAdminAction(
    action: string,
    userId: string,
    userEmail: string,
    userRole: string,
    targetResource?: string,
    details?: Record<string, any>,
    success = true,
    error?: string
  ): Promise<void> {
    const entry: AuditLogEntry = {
      id: `audit-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
      type: 'admin_action',
      action,
      userId,
      userEmail,
      userRole,
      targetResource,
      details,
      success,
      error,
      timestamp: new Date()
    }

    await this.writeLog(entry)
  }

  async logDataExport(
    exportType: string,
    userId: string,
    userEmail: string,
    userRole: string,
    recordCount?: number,
    fileSize?: number,
    success = true,
    error?: string
  ): Promise<void> {
    const entry: AuditLogEntry = {
      id: `audit-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
      type: 'data_export',
      action: `export_${exportType}`,
      userId,
      userEmail,
      userRole,
      details: {
        exportType,
        recordCount,
        fileSize
      },
      success,
      error,
      timestamp: new Date()
    }

    await this.writeLog(entry)
  }

  async logSystemChange(
    action: string,
    userId: string,
    userEmail: string,
    userRole: string,
    targetResource: string,
    details?: Record<string, any>,
    success = true,
    error?: string
  ): Promise<void> {
    const entry: AuditLogEntry = {
      id: `audit-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
      type: 'system_change',
      action,
      userId,
      userEmail,
      userRole,
      targetResource,
      details,
      success,
      error,
      timestamp: new Date()
    }

    await this.writeLog(entry)
  }

  async logSecurityEvent(
    event: string,
    severity: 'low' | 'medium' | 'high' | 'critical',
    details?: Record<string, any>,
    userId?: string,
    userEmail?: string,
    ipAddress?: string
  ): Promise<void> {
    const entry: AuditLogEntry = {
      id: `audit-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
      type: 'security_event',
      action: event,
      userId,
      userEmail,
      details: {
        ...details,
        severity
      },
      ipAddress,
      success: true,
      timestamp: new Date()
    }

    await this.writeLog(entry)
  }

  private async writeLog(entry: AuditLogEntry): Promise<void> {
    if (this.isDevMode) {
      console.log('[AUDIT LOG]', entry)
      return
    }

    try {
      await db.collection('audit_logs').doc(entry.id).set(entry)
    } catch (error) {
      console.error('Failed to write audit log:', error)
      // Don't throw - audit logging should not break the main functionality
    }
  }

  // Utility methods for common audit scenarios
  async logPrivateLandingAccess(
    success: boolean,
    userId?: string,
    userEmail?: string,
    userRole?: string,
    ipAddress?: string,
    userAgent?: string,
    error?: string
  ): Promise<void> {
    await this.logAccessAttempt(
      'private_landing_access',
      success,
      userId,
      userEmail,
      userRole,
      { page: '/admin/surveys/landing' },
      ipAddress,
      userAgent,
      error
    )
  }

  async logDataExportJob(
    exportType: string,
    userId: string,
    userEmail: string,
    userRole: string,
    jobId: string,
    success = true,
    error?: string
  ): Promise<void> {
    await this.logDataExport(
      exportType,
      userId,
      userEmail,
      userRole,
      undefined,
      undefined,
      success,
      error
    )
  }

  async logContentAction(
    action: 'create' | 'update' | 'delete' | 'view',
    contentId: string,
    contentType: string,
    userId: string,
    userEmail: string,
    userRole: string,
    success = true,
    error?: string
  ): Promise<void> {
    await this.logAdminAction(
      `content_${action}`,
      userId,
      userEmail,
      userRole,
      `${contentType}:${contentId}`,
      { contentType, contentId },
      success,
      error
    )
  }

  async logSurveyAction(
    action: 'create' | 'update' | 'delete' | 'publish' | 'close',
    surveyId: string,
    userId: string,
    userEmail: string,
    userRole: string,
    success = true,
    error?: string
  ): Promise<void> {
    await this.logAdminAction(
      `survey_${action}`,
      userId,
      userEmail,
      userRole,
      `survey:${surveyId}`,
      { surveyId },
      success,
      error
    )
  }
}

export const auditLogger = AuditLogger.getInstance()




import { db } from '@/lib/firebase'
import { collection, query, getDocs, where, orderBy, limit, startAfter, QueryDocumentSnapshot, DocumentData } from 'firebase/firestore'
import { ref, uploadBytes, getDownloadURL } from 'firebase/storage'
import { storage } from '@/lib/firebase'

export interface ExportJob {
  id: string
  type: 'users' | 'surveys' | 'payments' | 'analytics' | 'logs' | 'content'
  format: 'csv' | 'xlsx' | 'json'
  status: 'pending' | 'processing' | 'completed' | 'failed'
  filters?: Record<string, any>
  requestedBy: string
  requestedByEmail?: string
  createdAt: Date
  completedAt?: Date
  fileUrl?: string
  fileName?: string
  fileSize?: number
  error?: string
  totalRecords?: number
  progress?: number
}

export interface ExportOptions {
  format: 'csv' | 'xlsx' | 'json'
  filters?: Record<string, any>
  includeHeaders?: boolean
  dateRange?: { start: Date; end: Date }
  limit?: number
  fields?: string[]
}

// Mock data for DEV_MODE
const MOCK_EXPORT_JOBS: ExportJob[] = [
  {
    id: 'export-1',
    type: 'users',
    format: 'csv',
    status: 'completed',
    requestedBy: 'admin@example.com',
    requestedByEmail: 'admin@example.com',
    createdAt: new Date(Date.now() - 3600000),
    completedAt: new Date(Date.now() - 3500000),
    fileUrl: 'https://example.com/exports/users-2024-01-15.csv',
    fileName: 'users-2024-01-15.csv',
    fileSize: 245760,
    totalRecords: 1250
  },
  {
    id: 'export-2',
    type: 'surveys',
    format: 'xlsx',
    status: 'processing',
    requestedBy: 'admin@example.com',
    requestedByEmail: 'admin@example.com',
    createdAt: new Date(Date.now() - 1800000),
    progress: 65,
    totalRecords: 450
  },
  {
    id: 'export-3',
    type: 'payments',
    format: 'json',
    status: 'failed',
    requestedBy: 'admin@example.com',
    requestedByEmail: 'admin@example.com',
    createdAt: new Date(Date.now() - 900000),
    error: 'Database connection timeout'
  }
]

export class ExportsService {
  private static instance: ExportsService
  private isDevMode = process.env.NODE_ENV === 'development'

  static getInstance(): ExportsService {
    if (!ExportsService.instance) {
      ExportsService.instance = new ExportsService()
    }
    return ExportsService.instance
  }

  async createExportJob(type: ExportJob['type'], options: ExportOptions, userId: string, userEmail?: string): Promise<ExportJob> {
    if (this.isDevMode) {
      const job: ExportJob = {
        id: `export-${Date.now()}`,
        type,
        format: options.format,
        status: 'pending',
        filters: options.filters,
        requestedBy: userId,
        requestedByEmail: userEmail,
        createdAt: new Date()
      }
      
      // Simulate processing
      setTimeout(() => {
        this.processExportJob(job)
      }, 2000)
      
      return job
    }

    try {
      const job: ExportJob = {
        id: `export-${Date.now()}`,
        type,
        format: options.format,
        status: 'pending',
        filters: options.filters,
        requestedBy: userId,
        requestedByEmail: userEmail,
        createdAt: new Date()
      }

      // Store in Firestore
      await db.collection('export_jobs').doc(job.id).set(job)
      
      // Start background processing
      this.processExportJob(job)
      
      return job
    } catch (error) {
      console.error('Error creating export job:', error)
      throw new Error('Failed to create export job')
    }
  }

  async getExportJobs(userId?: string, limit = 20): Promise<ExportJob[]> {
    if (this.isDevMode) {
      return MOCK_EXPORT_JOBS.slice(0, limit)
    }

    try {
      let q = db.collection('export_jobs').orderBy('createdAt', 'desc')
      
      if (userId) {
        q = q.where('requestedBy', '==', userId)
      }
      
      const snapshot = await q.limit(limit).get()
      return snapshot.docs.map((doc: any) => ({ id: doc.id, ...doc.data() } as ExportJob))
    } catch (error) {
      console.error('Error fetching export jobs:', error)
      return []
    }
  }

  async getExportJob(jobId: string): Promise<ExportJob | null> {
    if (this.isDevMode) {
      return MOCK_EXPORT_JOBS.find(job => job.id === jobId) || null
    }

    try {
      const doc = await db.collection('export_jobs').doc(jobId).get()
      if (doc.exists) {
        return { id: doc.id, ...doc.data() } as ExportJob
      }
      return null
    } catch (error) {
      console.error('Error fetching export job:', error)
      return null
    }
  }

  async deleteExportJob(jobId: string): Promise<void> {
    if (this.isDevMode) {
      // Remove from mock data
      const index = MOCK_EXPORT_JOBS.findIndex(job => job.id === jobId)
      if (index > -1) {
        MOCK_EXPORT_JOBS.splice(index, 1)
      }
      return
    }

    try {
      await db.collection('export_jobs').doc(jobId).delete()
    } catch (error) {
      console.error('Error deleting export job:', error)
      throw new Error('Failed to delete export job')
    }
  }

  private async processExportJob(job: ExportJob): Promise<void> {
    try {
      // Update status to processing
      await this.updateJobStatus(job.id, 'processing', { progress: 0 })

      // Fetch data based on type
      const data = await this.fetchDataForExport(job.type, job.filters)
      
      // Update progress
      await this.updateJobStatus(job.id, 'processing', { progress: 50, totalRecords: data.length })

      // Generate file
      const fileContent = await this.generateFileContent(data, job.format)
      const fileName = `${job.type}-${new Date().toISOString().split('T')[0]}.${job.format}`
      
      // Upload to Firebase Storage
      const fileUrl = await this.uploadFile(fileContent, fileName, job.format)
      
      // Update job as completed
      await this.updateJobStatus(job.id, 'completed', {
        fileUrl,
        fileName,
        fileSize: fileContent.length,
        completedAt: new Date(),
        progress: 100
      })

      // Send email notification if configured
      if (job.requestedByEmail) {
        await this.sendCompletionEmail(job)
      }

    } catch (error) {
      console.error('Error processing export job:', error)
      await this.updateJobStatus(job.id, 'failed', {
        error: error instanceof Error ? error.message : 'Unknown error'
      })
    }
  }

  private async fetchDataForExport(type: ExportJob['type'], filters?: Record<string, any>): Promise<any[]> {
    if (this.isDevMode) {
      // Return mock data based on type
      switch (type) {
        case 'users':
          return Array.from({ length: 100 }, (_, i) => ({
            id: `user-${i}`,
            email: `user${i}@example.com`,
            name: `User ${i}`,
            role: i % 3 === 0 ? 'admin' : 'user',
            createdAt: new Date(Date.now() - i * 86400000)
          }))
        case 'surveys':
          return Array.from({ length: 50 }, (_, i) => ({
            id: `survey-${i}`,
            title: `Survey ${i}`,
            status: i % 4 === 0 ? 'draft' : 'active',
            responses: Math.floor(Math.random() * 1000),
            createdAt: new Date(Date.now() - i * 86400000)
          }))
        case 'payments':
          return Array.from({ length: 200 }, (_, i) => ({
            id: `payment-${i}`,
            amount: Math.floor(Math.random() * 1000) + 10,
            status: i % 5 === 0 ? 'failed' : 'completed',
            userId: `user-${i % 10}`,
            createdAt: new Date(Date.now() - i * 86400000)
          }))
        default:
          return []
      }
    }

    // Real Firestore queries
    const collectionRef = db.collection(type)
    let q = collectionRef.orderBy('createdAt', 'desc')

    if (filters) {
      Object.entries(filters).forEach(([key, value]) => {
        q = q.where(key, '==', value)
      })
    }

    const snapshot = await q.limit(10000).get()
    return snapshot.docs.map((doc: any) => ({ id: doc.id, ...doc.data() }))
  }

  private async generateFileContent(data: any[], format: ExportJob['format']): Promise<string | Buffer> {
    switch (format) {
      case 'csv':
        return this.generateCSV(data)
      case 'xlsx':
        return this.generateXLSX(data)
      case 'json':
        return JSON.stringify(data, null, 2)
      default:
        throw new Error(`Unsupported format: ${format}`)
    }
  }

  private generateCSV(data: any[]): string {
    if (data.length === 0) return ''
    
    const headers = Object.keys(data[0])
    const csvRows = [headers.join(',')]
    
    data.forEach(row => {
      const values = headers.map(header => {
        const value = row[header]
        return typeof value === 'string' ? `"${value.replace(/"/g, '""')}"` : value
      })
      csvRows.push(values.join(','))
    })
    
    return csvRows.join('\n')
  }

  private generateXLSX(data: any[]): Buffer {
    // For now, return CSV as buffer (in production, use a proper XLSX library)
    const csv = this.generateCSV(data)
    return Buffer.from(csv, 'utf-8')
  }

  private async uploadFile(content: string | Buffer, fileName: string, format: string): Promise<string> {
    if (this.isDevMode) {
      return `https://example.com/exports/${fileName}`
    }

    try {
      const storageRef = ref(storage, `exports/${fileName}`)
      const buffer = typeof content === 'string' ? Buffer.from(content, 'utf-8') : content
      
      await uploadBytes(storageRef, buffer, {
        contentType: format === 'csv' ? 'text/csv' : format === 'xlsx' ? 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' : 'application/json'
      })
      
      return await getDownloadURL(storageRef)
    } catch (error) {
      console.error('Error uploading file:', error)
      throw new Error('Failed to upload export file')
    }
  }

  private async updateJobStatus(jobId: string, status: ExportJob['status'], updates: Partial<ExportJob>): Promise<void> {
    if (this.isDevMode) {
      const job = MOCK_EXPORT_JOBS.find(j => j.id === jobId)
      if (job) {
        Object.assign(job, { status, ...updates })
      }
      return
    }

    try {
      await db.collection('export_jobs').doc(jobId).update({
        status,
        ...updates,
        updatedAt: new Date()
      })
    } catch (error) {
      console.error('Error updating job status:', error)
    }
  }

  private async sendCompletionEmail(job: ExportJob): Promise<void> {
    if (this.isDevMode) {
      console.log(`[DEV] Would send completion email to ${job.requestedByEmail} for job ${job.id}`)
      return
    }

    // Implement email sending logic here
    // This would integrate with your email service
    console.log(`Sending completion email for job ${job.id}`)
  }

  // Utility methods for different export types
  async exportUsers(options: ExportOptions, userId: string, userEmail?: string): Promise<ExportJob> {
    return this.createExportJob('users', options, userId, userEmail)
  }

  async exportSurveys(options: ExportOptions, userId: string, userEmail?: string): Promise<ExportJob> {
    return this.createExportJob('surveys', options, userId, userEmail)
  }

  async exportPayments(options: ExportOptions, userId: string, userEmail?: string): Promise<ExportJob> {
    return this.createExportJob('payments', options, userId, userEmail)
  }

  async exportAnalytics(options: ExportOptions, userId: string, userEmail?: string): Promise<ExportJob> {
    return this.createExportJob('analytics', options, userId, userEmail)
  }

  async exportLogs(options: ExportOptions, userId: string, userEmail?: string): Promise<ExportJob> {
    return this.createExportJob('logs', options, userId, userEmail)
  }

  async exportContent(options: ExportOptions, userId: string, userEmail?: string): Promise<ExportJob> {
    return this.createExportJob('content', options, userId, userEmail)
  }
}

export const exportsService = ExportsService.getInstance()




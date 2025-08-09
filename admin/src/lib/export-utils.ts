import { ExportJob, ExportOptions } from '@/services/exports_service'

export interface ExportField {
  key: string
  label: string
  type: 'string' | 'number' | 'date' | 'boolean' | 'array'
  transform?: (value: any) => any
}

export interface ExportTemplate {
  id: string
  name: string
  description: string
  type: ExportJob['type']
  fields: ExportField[]
  defaultFormat: ExportJob['format']
  filters?: Record<string, any>
}

// Predefined export templates
export const EXPORT_TEMPLATES: ExportTemplate[] = [
  {
    id: 'users-basic',
    name: 'Users - Basic Info',
    description: 'Export basic user information including email, name, role, and registration date',
    type: 'users',
    fields: [
      { key: 'id', label: 'User ID', type: 'string' },
      { key: 'email', label: 'Email', type: 'string' },
      { key: 'name', label: 'Name', type: 'string' },
      { key: 'role', label: 'Role', type: 'string' },
      { key: 'createdAt', label: 'Registration Date', type: 'date' }
    ],
    defaultFormat: 'csv'
  },
  {
    id: 'users-detailed',
    name: 'Users - Detailed',
    description: 'Export comprehensive user data including profile, preferences, and activity',
    type: 'users',
    fields: [
      { key: 'id', label: 'User ID', type: 'string' },
      { key: 'email', label: 'Email', type: 'string' },
      { key: 'name', label: 'Name', type: 'string' },
      { key: 'role', label: 'Role', type: 'string' },
      { key: 'phone', label: 'Phone', type: 'string' },
      { key: 'location', label: 'Location', type: 'string' },
      { key: 'createdAt', label: 'Registration Date', type: 'date' },
      { key: 'lastLoginAt', label: 'Last Login', type: 'date' },
      { key: 'isActive', label: 'Active Status', type: 'boolean' }
    ],
    defaultFormat: 'xlsx'
  },
  {
    id: 'surveys-overview',
    name: 'Surveys - Overview',
    description: 'Export survey metadata and response statistics',
    type: 'surveys',
    fields: [
      { key: 'id', label: 'Survey ID', type: 'string' },
      { key: 'title', label: 'Title', type: 'string' },
      { key: 'status', label: 'Status', type: 'string' },
      { key: 'responses', label: 'Response Count', type: 'number' },
      { key: 'createdAt', label: 'Created Date', type: 'date' },
      { key: 'updatedAt', label: 'Updated Date', type: 'date' }
    ],
    defaultFormat: 'csv'
  },
  {
    id: 'payments-summary',
    name: 'Payments - Summary',
    description: 'Export payment transactions with amounts and status',
    type: 'payments',
    fields: [
      { key: 'id', label: 'Payment ID', type: 'string' },
      { key: 'amount', label: 'Amount', type: 'number' },
      { key: 'currency', label: 'Currency', type: 'string' },
      { key: 'status', label: 'Status', type: 'string' },
      { key: 'userId', label: 'User ID', type: 'string' },
      { key: 'createdAt', label: 'Transaction Date', type: 'date' }
    ],
    defaultFormat: 'csv'
  }
]

export function formatFileSize(bytes: number): string {
  if (bytes === 0) return '0 Bytes'
  
  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

export function formatDate(date: Date | string): string {
  const d = typeof date === 'string' ? new Date(date) : date
  return d.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

export function getExportStatusColor(status: ExportJob['status']): string {
  switch (status) {
    case 'pending':
      return 'text-yellow-600 bg-yellow-100'
    case 'processing':
      return 'text-blue-600 bg-blue-100'
    case 'completed':
      return 'text-green-600 bg-green-100'
    case 'failed':
      return 'text-red-600 bg-red-100'
    default:
      return 'text-gray-600 bg-gray-100'
  }
}

export function getExportStatusIcon(status: ExportJob['status']): string {
  switch (status) {
    case 'pending':
      return '⏳'
    case 'processing':
      return '🔄'
    case 'completed':
      return '✅'
    case 'failed':
      return '❌'
    default:
      return '❓'
  }
}

export function validateExportOptions(options: ExportOptions): string[] {
  const errors: string[] = []
  
  if (!options.format) {
    errors.push('Export format is required')
  }
  
  if (options.limit && (options.limit < 1 || options.limit > 100000)) {
    errors.push('Export limit must be between 1 and 100,000')
  }
  
  if (options.dateRange) {
    if (options.dateRange.start > options.dateRange.end) {
      errors.push('Start date must be before end date')
    }
  }
  
  return errors
}

export function createExportFileName(type: ExportJob['type'], format: ExportJob['format'], filters?: Record<string, any>): string {
  const timestamp = new Date().toISOString().split('T')[0]
  const filterSuffix = filters ? '-filtered' : ''
  return `${type}-export-${timestamp}${filterSuffix}.${format}`
}

export function transformDataForExport(data: any[], fields: ExportField[]): any[] {
  return data.map(item => {
    const transformed: any = {}
    
    fields.forEach(field => {
      let value = item[field.key]
      
      // Apply field-specific transformation
      if (field.transform) {
        value = field.transform(value)
      }
      
      // Apply type-specific formatting
      switch (field.type) {
        case 'date':
          value = value ? formatDate(value) : ''
          break
        case 'boolean':
          value = value ? 'Yes' : 'No'
          break
        case 'array':
          value = Array.isArray(value) ? value.join(', ') : value
          break
        case 'number':
          value = typeof value === 'number' ? value : parseFloat(value) || 0
          break
      }
      
      transformed[field.label] = value
    })
    
    return transformed
  })
}

export function generateCSVFromData(data: any[], includeHeaders = true): string {
  if (data.length === 0) return ''
  
  const headers = Object.keys(data[0])
  const csvRows: string[] = []
  
  // Add headers
  if (includeHeaders) {
    csvRows.push(headers.map(header => `"${header}"`).join(','))
  }
  
  // Add data rows
  data.forEach(row => {
    const values = headers.map(header => {
      const value = row[header]
      if (value === null || value === undefined) {
        return '""'
      }
      const stringValue = String(value)
      return `"${stringValue.replace(/"/g, '""')}"`
    })
    csvRows.push(values.join(','))
  })
  
  return csvRows.join('\n')
}

export function downloadFile(url: string, filename: string): void {
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

export function copyToClipboard(text: string): Promise<void> {
  return navigator.clipboard.writeText(text)
}

export function getExportProgressText(job: ExportJob): string {
  switch (job.status) {
    case 'pending':
      return 'Queued for processing...'
    case 'processing':
      return job.progress ? `Processing... ${job.progress}%` : 'Processing...'
    case 'completed':
      return `Completed - ${job.totalRecords || 0} records exported`
    case 'failed':
      return `Failed - ${job.error || 'Unknown error'}`
    default:
      return 'Unknown status'
  }
}

export function canRetryExport(job: ExportJob): boolean {
  return job.status === 'failed'
}

export function getExportTypeLabel(type: ExportJob['type']): string {
  switch (type) {
    case 'users':
      return 'Users'
    case 'surveys':
      return 'Surveys'
    case 'payments':
      return 'Payments'
    case 'analytics':
      return 'Analytics'
    case 'logs':
      return 'System Logs'
    case 'content':
      return 'Content'
    default:
      return type
  }
}

export function getExportFormatLabel(format: ExportJob['format']): string {
  switch (format) {
    case 'csv':
      return 'CSV'
    case 'xlsx':
      return 'Excel'
    case 'json':
      return 'JSON'
    default:
      return String(format).toUpperCase()
  }
}




/**
 * Convert data to CSV format
 */
export const convertToCSV = (data: any[], headers: string[]): string => {
  if (!data.length) return ''
  
  const csvHeaders = headers.join(',')
  const csvRows = data.map(row => 
    headers.map(header => {
      const value = row[header]
      // Escape commas and quotes
      if (typeof value === 'string' && (value.includes(',') || value.includes('"'))) {
        return `"${value.replace(/"/g, '""')}"`
      }
      return value || ''
    }).join(',')
  )
  
  return [csvHeaders, ...csvRows].join('\n')
}

/**
 * Download CSV file
 */
export const downloadCSV = (csvContent: string, filename: string): void => {
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
  const link = document.createElement('a')
  
  if (link.download !== undefined) {
    const url = URL.createObjectURL(blob)
    link.setAttribute('href', url)
    link.setAttribute('download', `${filename}.csv`)
    link.style.visibility = 'hidden'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
  }
}

/**
 * Export analytics data to CSV
 */
export const exportAnalyticsToCSV = (data: any[], filename: string): void => {
  const headers = Object.keys(data[0] || {})
  const csvContent = convertToCSV(data, headers)
  downloadCSV(csvContent, filename)
}

/**
 * Export revenue data to CSV
 */
export const exportRevenueToCSV = (revenueData: any[]): void => {
  const headers = ['Date', 'Amount', 'Source', 'Description', 'Service', 'Customer']
  const formattedData = revenueData.map(item => ({
    Date: new Date(item.date).toLocaleDateString(),
    Amount: `$${item.amount.toFixed(2)}`,
    Source: item.source,
    Description: item.description,
    Service: item.serviceId || 'N/A',
    Customer: item.customerId || 'N/A'
  }))
  
  const csvContent = convertToCSV(formattedData, headers)
  downloadCSV(csvContent, 'revenue-report')
}

/**
 * Export appointments data to CSV
 */
export const exportAppointmentsToCSV = (appointmentsData: any[]): void => {
  const headers = ['Date', 'Time', 'Customer', 'Service', 'Status', 'Duration']
  const formattedData = appointmentsData.map(item => ({
    Date: new Date(item.date).toLocaleDateString(),
    Time: item.time,
    Customer: item.customerName,
    Service: item.service,
    Status: item.status,
    Duration: `${item.duration} minutes`
  }))
  
  const csvContent = convertToCSV(formattedData, headers)
  downloadCSV(csvContent, 'appointments-report')
}

/**
 * Export usage data to CSV
 */
export const exportUsageToCSV = (usageData: any): void => {
  const headers = ['Metric', 'Current', 'Limit', 'Percentage']
  const formattedData = [
    {
      Metric: 'Meetings Created',
      Current: usageData.meetingsCreated,
      Limit: usageData.meetingLimit || 'Unlimited',
      Percentage: `${Math.round((usageData.meetingsCreated / (usageData.meetingLimit || 1)) * 100)}%`
    },
    {
      Metric: 'Map Loads',
      Current: usageData.mapLoads,
      Limit: usageData.mapLimit,
      Percentage: `${Math.round((usageData.mapLoads / usageData.mapLimit) * 100)}%`
    },
    {
      Metric: 'Customers Added',
      Current: usageData.customersAdded,
      Limit: usageData.customerLimit,
      Percentage: `${Math.round((usageData.customersAdded / usageData.customerLimit) * 100)}%`
    },
    {
      Metric: 'Staff Members',
      Current: usageData.staffMembers,
      Limit: usageData.staffLimit,
      Percentage: `${Math.round((usageData.staffMembers / usageData.staffLimit) * 100)}%`
    }
  ]
  
  const csvContent = convertToCSV(formattedData, headers)
  downloadCSV(csvContent, 'usage-report')
} 
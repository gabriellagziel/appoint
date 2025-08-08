import { UsageRecord } from '../hooks/useEnterpriseUsage';

export const exportUsageToCSV = (records: UsageRecord[]): string => {
  const headers = ['Date', 'Endpoint', 'Total Calls', 'Successful Calls', 'Errors', 'Avg Response Time (ms)'];
  const csvContent = [
    headers.join(','),
    ...records.map(record => [
      record.date,
      record.endpoint,
      record.calls,
      record.success,
      record.errors,
      record.avgResponseTime
    ].join(','))
  ].join('\n');
  
  return csvContent;
};

export const exportUsageToJSON = (records: UsageRecord[]): string => {
  return JSON.stringify(records, null, 2);
};

export const downloadFile = (content: string, filename: string, mimeType: string): void => {
  const blob = new Blob([content], { type: mimeType });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
};

export const exportUsageData = (records: UsageRecord[], format: 'csv' | 'json'): void => {
  const timestamp = new Date().toISOString().slice(0, 10);
  
  if (format === 'csv') {
    const csvContent = exportUsageToCSV(records);
    downloadFile(csvContent, `usage-export-${timestamp}.csv`, 'text/csv');
  } else {
    const jsonContent = exportUsageToJSON(records);
    downloadFile(jsonContent, `usage-export-${timestamp}.json`, 'application/json');
  }
};

export const generateUsageReport = (records: UsageRecord[]) => {
  const totalCalls = records.reduce((sum, record) => sum + record.calls, 0);
  const totalSuccess = records.reduce((sum, record) => sum + record.success, 0);
  const totalErrors = records.reduce((sum, record) => sum + record.errors, 0);
  const avgResponseTime = records.reduce((sum, record) => sum + record.avgResponseTime, 0) / records.length;
  
  return {
    summary: {
      totalCalls,
      totalSuccess,
      totalErrors,
      successRate: totalCalls > 0 ? (totalSuccess / totalCalls) * 100 : 0,
      avgResponseTime: avgResponseTime || 0,
      dateRange: {
        start: records.length > 0 ? records[0].date : '',
        end: records.length > 0 ? records[records.length - 1].date : ''
      }
    },
    records
  };
};

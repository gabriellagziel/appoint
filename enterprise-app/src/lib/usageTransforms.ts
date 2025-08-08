import { UsageRecord } from './hooks/useEnterpriseUsage';

export const groupByDay = (records: UsageRecord[]) => {
  const grouped = records.reduce((acc, record) => {
    const date = record.date;
    acc[date] = (acc[date] || 0) + record.calls;
    return acc;
  }, {} as Record<string, number>);

  return Object.entries(grouped)
    .map(([date, total]) => ({ date, total }))
    .sort((a, b) => a.date.localeCompare(b.date));
};

export const groupByEndpoint = (records: UsageRecord[]) => {
  return records.reduce((acc, record) => {
    acc[record.endpoint] = (acc[record.endpoint] || 0) + record.calls;
    return acc;
  }, {} as Record<string, number>);
};

export const groupByError = (records: UsageRecord[]) => {
  return records.reduce((acc, record) => {
    const errorCount = record.errors;
    if (errorCount > 0) {
      acc['API Errors'] = (acc['API Errors'] || 0) + errorCount;
    }
    return acc;
  }, {} as Record<string, number>);
};

export const calculateSuccessRate = (records: UsageRecord[]) => {
  const totalCalls = records.reduce((sum, record) => sum + record.calls, 0);
  const totalSuccess = records.reduce((sum, record) => sum + record.success, 0);
  
  return totalCalls > 0 ? (totalSuccess / totalCalls) * 100 : 0;
};

export const calculateAverageResponseTime = (records: UsageRecord[]) => {
  const totalResponseTime = records.reduce((sum, record) => sum + record.avgResponseTime, 0);
  const recordCount = records.length;
  
  return recordCount > 0 ? totalResponseTime / recordCount : 0;
};

export const formatDateForChart = (dateString: string) => {
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', { 
    month: 'short', 
    day: 'numeric' 
  });
};

export const getChartColors = (count: number) => {
  const colors = [
    '#3B82F6', '#EF4444', '#10B981', '#F59E0B', '#8B5CF6',
    '#06B6D4', '#84CC16', '#F97316', '#EC4899', '#6366F1'
  ];
  
  return colors.slice(0, count);
};

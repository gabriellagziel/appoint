import { useState, useEffect } from 'react';
import { onSnapshot, collection, query, where, orderBy, limit, getDocs } from 'firebase/firestore';
import { db } from '../firebase';

export interface UsageRecord {
  date: string;
  endpoint: string;
  calls: number;
  success: number;
  errors: number;
  avgResponseTime: number;
  timestamp: Date;
}

export interface UsageData {
  loading: boolean;
  error: string | null;
  byDay: Array<{ date: string; total: number }>;
  byEndpoint: Record<string, number>;
  byError: Record<string, number>;
  raw: UsageRecord[];
}

type DateRange = '7d' | '30d' | '90d';

export const useEnterpriseUsage = (clientId: string, dateRange: DateRange): UsageData => {
  const [data, setData] = useState<UsageData>({
    loading: true,
    error: null,
    byDay: [],
    byEndpoint: {},
    byError: {},
    raw: [],
  });

  useEffect(() => {
    if (!clientId) {
      setData(prev => ({ ...prev, loading: false }));
      return;
    }

    const unsubscribe = onSnapshot(
      collection(db, 'enterprise_usage'),
      (snapshot) => {
        try {
          const records: UsageRecord[] = [];
          
          snapshot.forEach((doc) => {
            const docData = doc.data();
            if (docData.clientId === clientId) {
              records.push({
                date: docData.date || new Date().toISOString().split('T')[0],
                endpoint: docData.endpoint || 'unknown',
                calls: docData.calls || 0,
                success: docData.success || 0,
                errors: docData.errors || 0,
                avgResponseTime: docData.avgResponseTime || 0,
                timestamp: docData.timestamp?.toDate() || new Date(),
              });
            }
          });

          // Transform data based on date range
          const filteredRecords = filterByDateRange(records, dateRange);
          const transformedData = transformUsageData(filteredRecords);

          setData({
            loading: false,
            error: null,
            ...transformedData,
            raw: filteredRecords,
          });
        } catch (error) {
          console.error('Error processing usage data:', error);
          setData({
            loading: false,
            error: 'Failed to load usage data',
            byDay: [],
            byEndpoint: {},
            byError: {},
            raw: [],
          });
        }
      },
      (error) => {
        console.error('Usage data listener error:', error);
        setData({
          loading: false,
          error: 'Failed to connect to usage data',
          byDay: [],
          byEndpoint: {},
          byError: {},
          raw: [],
        });
      }
    );

    return () => unsubscribe();
  }, [clientId, dateRange]);

  return data;
};

const filterByDateRange = (records: UsageRecord[], dateRange: DateRange): UsageRecord[] => {
  const now = new Date();
  const daysAgo = dateRange === '7d' ? 7 : dateRange === '30d' ? 30 : 90;
  const cutoffDate = new Date(now.getTime() - daysAgo * 24 * 60 * 60 * 1000);

  return records.filter(record => record.timestamp >= cutoffDate);
};

const transformUsageData = (records: UsageRecord[]) => {
  const byDay = groupByDay(records);
  const byEndpoint = groupByEndpoint(records);
  const byError = groupByError(records);

  return { byDay, byEndpoint, byError };
};

const groupByDay = (records: UsageRecord[]) => {
  const grouped = records.reduce((acc, record) => {
    const date = record.date;
    acc[date] = (acc[date] || 0) + record.calls;
    return acc;
  }, {} as Record<string, number>);

  return Object.entries(grouped)
    .map(([date, total]) => ({ date, total }))
    .sort((a, b) => a.date.localeCompare(b.date));
};

const groupByEndpoint = (records: UsageRecord[]) => {
  return records.reduce((acc, record) => {
    acc[record.endpoint] = (acc[record.endpoint] || 0) + record.calls;
    return acc;
  }, {} as Record<string, number>);
};

const groupByError = (records: UsageRecord[]) => {
  return records.reduce((acc, record) => {
    const errorCount = record.errors;
    if (errorCount > 0) {
      acc['API Errors'] = (acc['API Errors'] || 0) + errorCount;
    }
    return acc;
  }, {} as Record<string, number>);
};

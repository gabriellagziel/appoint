import { test, expect, describe, beforeAll, afterAll } from '@jest/globals';
import admin from 'firebase-admin';
import { AppOintAPI, AppOintRegistry, AppOintAPIError } from '../../../sdks/nodejs/src/index';

// Test configuration
const TEST_CONFIG = {
  baseURL: 'http://localhost:5001/app-oint-core/us-central1',
  timeout: 10000
};

let testBusinessId: string;
let testApiKey: string;
let testAppointmentId: string;

describe('App-Oint Enterprise API Integration Tests', () => {
  beforeAll(async () => {
    // Initialize Firebase Admin for testing
    if (!admin.apps.length) {
      admin.initializeApp({
        projectId: 'app-oint-core',
        databaseURL: 'https://app-oint-core.firebaseio.com'
      });
    }
  });

  afterAll(async () => {
    // Cleanup test data
    if (testBusinessId) {
      await admin.firestore().collection('business_accounts').doc(testBusinessId).delete();
    }
    if (testAppointmentId) {
      await admin.firestore().collection('appointments').doc(testAppointmentId).delete();
    }
  });

  describe('Business Registration', () => {
    test('should register new business successfully', async () => {
      const registrationData = {
        name: 'Test Healthcare Clinic',
        email: 'test@example.com',
        industry: 'Healthcare'
      };

      const response = await AppOintRegistry.registerBusiness(registrationData);

      expect(response).toMatchObject({
        id: expect.any(String),
        apiKey: expect.any(String),
        quota: 1000,
        scopes: expect.arrayContaining(['appointments:read', 'appointments:write', 'billing:read'])
      });

      testBusinessId = response.id;
      testApiKey = response.apiKey;
    });

    test('should reject registration with missing fields', async () => {
      await expect(AppOintRegistry.registerBusiness({
        name: '',
        email: 'test@example.com'
      })).rejects.toThrow(AppOintAPIError);
    });

    test('should reject registration with invalid email', async () => {
      await expect(AppOintRegistry.registerBusiness({
        name: 'Test Clinic',
        email: 'invalid-email'
      })).rejects.toThrow(AppOintAPIError);
    });
  });

  describe('API Authentication', () => {
    let api: AppOintAPI;

    beforeAll(() => {
      api = new AppOintAPI({
        apiKey: testApiKey,
        ...TEST_CONFIG
      });
    });

    test('should authenticate with valid API key', async () => {
      const stats = await api.analytics.getUsageStats();
      expect(stats).toMatchObject({
        totalCalls: expect.any(Number),
        quota: expect.any(Number),
        remaining: expect.any(Number)
      });
    });

    test('should reject invalid API key', async () => {
      const invalidApi = new AppOintAPI({
        apiKey: 'invalid-key',
        ...TEST_CONFIG
      });

      await expect(invalidApi.analytics.getUsageStats()).rejects.toThrow(AppOintAPIError);
    });
  });

  describe('Appointment Management', () => {
    let api: AppOintAPI;

    beforeAll(() => {
      api = new AppOintAPI({
        apiKey: testApiKey,
        ...TEST_CONFIG
      });
    });

    test('should create appointment successfully', async () => {
      const appointmentData = {
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        start: '2024-06-15T10:00:00Z',
        duration: 60,
        description: 'Annual checkup',
        location: 'Room 101'
      };

      const response = await api.appointments.create(appointmentData);

      expect(response).toMatchObject({
        appointmentId: expect.any(String),
        status: 'confirmed',
        start: appointmentData.start,
        customerName: appointmentData.customerName,
        duration: appointmentData.duration
      });

      testAppointmentId = response.appointmentId;
    });

    test('should reject appointment with missing required fields', async () => {
      await expect(api.appointments.create({
        customerName: '',
        start: '2024-06-15T10:00:00Z',
        duration: 60
      })).rejects.toThrow(AppOintAPIError);
    });

    test('should reject appointment with invalid date format', async () => {
      await expect(api.appointments.create({
        customerName: 'John Doe',
        start: 'invalid-date',
        duration: 60
      })).rejects.toThrow(AppOintAPIError);
    });

    test('should list appointments', async () => {
      const response = await api.appointments.list({
        status: 'confirmed',
        limit: 10
      });

      expect(response).toMatchObject({
        appointments: expect.any(Array),
        count: expect.any(Number),
        hasMore: expect.any(Boolean)
      });

      expect(response.appointments.length).toBeGreaterThan(0);
      expect(response.appointments[0]).toMatchObject({
        appointmentId: expect.any(String),
        status: expect.any(String),
        customerName: expect.any(String)
      });
    });

    test('should filter appointments by date range', async () => {
      const start = '2024-06-01T00:00:00Z';
      const end = '2024-06-30T23:59:59Z';

      const response = await api.appointments.list({ start, end });

      expect(response.appointments.every(apt => {
        const aptStart = new Date(apt.start);
        return aptStart >= new Date(start) && aptStart <= new Date(end);
      })).toBe(true);
    });

    test('should cancel appointment successfully', async () => {
      const response = await api.appointments.cancel({
        appointmentId: testAppointmentId
      });

      expect(response).toMatchObject({
        cancelled: true,
        appointmentId: testAppointmentId,
        status: 'cancelled',
        cancelledAt: expect.any(String)
      });
    });

    test('should reject cancelling non-existent appointment', async () => {
      await expect(api.appointments.cancel({
        appointmentId: 'non-existent-id'
      })).rejects.toThrow(AppOintAPIError);
    });

    test('should reject cancelling already cancelled appointment', async () => {
      await expect(api.appointments.cancel({
        appointmentId: testAppointmentId
      })).rejects.toThrow(AppOintAPIError);
    });
  });

  describe('Calendar Integration', () => {
    let api: AppOintAPI;

    beforeAll(() => {
      api = new AppOintAPI({
        apiKey: testApiKey,
        ...TEST_CONFIG
      });
    });

    test('should generate ICS feed URL', () => {
      const token = 'test-token';
      const url = api.calendar.getIcsFeedUrl(token);
      
      expect(url).toContain('/icsFeed');
      expect(url).toContain(`token=${token}`);
    });

    test('should rotate ICS token', async () => {
      const response = await api.calendar.rotateIcsToken();
      
      expect(response).toMatchObject({
        token: expect.any(String)
      });
      expect(response.token).toHaveLength(expect.any(Number));
    });
  });

  describe('Analytics & Usage', () => {
    let api: AppOintAPI;

    beforeAll(() => {
      api = new AppOintAPI({
        apiKey: testApiKey,
        ...TEST_CONFIG
      });
    });

    test('should get current month usage stats', async () => {
      const response = await api.analytics.getUsageStats();

      expect(response).toMatchObject({
        month: expect.any(Number),
        year: expect.any(Number),
        totalCalls: expect.any(Number),
        quota: expect.any(Number),
        remaining: expect.any(Number),
        endpoints: expect.any(Object)
      });

      expect(response.month).toBeGreaterThanOrEqual(1);
      expect(response.month).toBeLessThanOrEqual(12);
      expect(response.year).toBeGreaterThanOrEqual(2024);
      expect(response.totalCalls).toBeGreaterThanOrEqual(0);
      expect(response.remaining).toBeLessThanOrEqual(response.quota);
    });

    test('should get specific month usage stats', async () => {
      const month = 6;
      const year = 2024;
      const response = await api.analytics.getUsageStats(month, year);

      expect(response.month).toBe(month);
      expect(response.year).toBe(year);
    });

    test('should download usage CSV', async () => {
      const csvData = await api.analytics.downloadUsageCSV();
      
      expect(typeof csvData).toBe('string');
      expect(csvData).toContain('date,endpoint,calls'); // CSV header
    });
  });

  describe('Rate Limiting', () => {
    let api: AppOintAPI;

    beforeAll(() => {
      api = new AppOintAPI({
        apiKey: testApiKey,
        ...TEST_CONFIG
      });
    });

    test('should handle rate limiting gracefully', async () => {
      // Make multiple rapid requests to trigger rate limiting
      const promises = Array.from({ length: 70 }, () => 
        api.analytics.getUsageStats().catch(err => err)
      );

      const results = await Promise.all(promises);
      
      // Should have some rate limit errors
      const rateLimitErrors = results.filter(result => 
        result instanceof AppOintAPIError && result.status === 429
      );

      expect(rateLimitErrors.length).toBeGreaterThan(0);
    }, 15000);
  });

  describe('Error Handling', () => {
    test('should handle network timeouts', async () => {
      const api = new AppOintAPI({
        apiKey: testApiKey,
        baseURL: 'http://localhost:9999', // Non-existent server
        timeout: 1000
      });

      await expect(api.analytics.getUsageStats()).rejects.toThrow(AppOintAPIError);
    });

    test('should handle malformed responses', async () => {
      const api = new AppOintAPI({
        apiKey: testApiKey,
        baseURL: 'https://httpbin.org/json', // Returns different format
        ...TEST_CONFIG
      });

      await expect(api.analytics.getUsageStats()).rejects.toThrow();
    });
  });

  describe('Scope Validation', () => {
    let limitedApi: AppOintAPI;

    beforeAll(async () => {
      // Create a business with limited scopes for testing
      const limitedBusiness = await AppOintRegistry.registerBusiness({
        name: 'Limited Test Business',
        email: 'limited@example.com'
      });

      // Manually update scopes to be read-only
      await admin.firestore()
        .collection('business_accounts')
        .doc(limitedBusiness.id)
        .update({
          scopes: ['appointments:read'] // Only read permission
        });

      limitedApi = new AppOintAPI({
        apiKey: limitedBusiness.apiKey,
        ...TEST_CONFIG
      });
    });

    test('should allow read operations with read scope', async () => {
      const response = await limitedApi.appointments.list();
      expect(response).toMatchObject({
        appointments: expect.any(Array)
      });
    });

    test('should reject write operations without write scope', async () => {
      await expect(limitedApi.appointments.create({
        customerName: 'John Doe',
        start: '2024-06-15T10:00:00Z',
        duration: 60
      })).rejects.toThrow(AppOintAPIError);
    });
  });

  describe('Utility Functions', () => {
    let api: AppOintAPI;

    beforeAll(() => {
      api = new AppOintAPI({
        apiKey: testApiKey,
        ...TEST_CONFIG
      });
    });

    test('should validate appointment times correctly', () => {
      expect(api.utils.validateAppointmentTime('2024-06-15T10:00:00Z', 60)).toBe(true);
      expect(api.utils.validateAppointmentTime('invalid-date', 60)).toBe(false);
      expect(api.utils.validateAppointmentTime('2024-06-15T10:00:00Z', 0)).toBe(false);
      expect(api.utils.validateAppointmentTime('2024-06-15T10:00:00Z', 1500)).toBe(false); // > 24 hours
    });

    test('should calculate end time correctly', () => {
      const start = '2024-06-15T10:00:00Z';
      const duration = 60;
      const endTime = api.utils.calculateEndTime(start, duration);
      
      expect(endTime).toBe('2024-06-15T11:00:00.000Z');
    });

    test('should format appointments for display', () => {
      const appointment = {
        appointmentId: 'test-123',
        customerName: 'John Doe',
        start: '2024-06-15T10:00:00Z',
        end: '2024-06-15T11:00:00Z',
        duration: 60,
        status: 'confirmed' as const
      };

      const formatted = api.utils.formatAppointment(appointment);
      expect(formatted).toContain('John Doe');
      expect(formatted).toContain('60min');
    });
  });

  describe('Quota Management', () => {
    test('should track usage correctly', async () => {
      const api = new AppOintAPI({
        apiKey: testApiKey,
        ...TEST_CONFIG
      });

      const statsBefore = await api.analytics.getUsageStats();
      
      // Make a tracked API call
      await api.appointments.list({ limit: 1 });
      
      const statsAfter = await api.analytics.getUsageStats();
      
      expect(statsAfter.totalCalls).toBeGreaterThan(statsBefore.totalCalls);
      expect(statsAfter.remaining).toBeLessThan(statsBefore.remaining);
    });

    test('should handle quota exceeded scenarios', async () => {
      // This test would require setting up a business with exhausted quota
      // In a real test environment, you'd manually set usageThisMonth >= monthlyQuota
      // Then verify the API returns 429 status codes
    });
  });
});
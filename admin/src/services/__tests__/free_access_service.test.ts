import { freeAccessService } from '../free_access_service';
import { db } from '@/lib/firebase';

// Mock Firebase
jest.mock('@/lib/firebase', () => ({
  db: {
    collection: jest.fn(),
    doc: jest.fn(),
    writeBatch: jest.fn(),
    serverTimestamp: jest.fn(() => ({ toDate: () => new Date() }))
  }
}));

// Mock logs service
jest.mock('../logs_service', () => ({
  logAdminAction: jest.fn()
}));

describe('FreeAccessService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('grantFreeAccess', () => {
    it('should grant free access successfully', async () => {
      const mockBatch = {
        set: jest.fn(),
        update: jest.fn(),
        commit: jest.fn()
      };
      const mockCollection = jest.fn();
      const mockDoc = jest.fn();
      const mockGetDoc = jest.fn();

      (db as any).writeBatch.mockReturnValue(mockBatch);
      (db as any).collection.mockReturnValue(mockCollection);
      (db as any).doc.mockReturnValue(mockDoc);
      mockGetDoc.mockResolvedValue({ exists: () => true });

      const request = {
        targetType: 'personal' as const,
        targetId: 'user123',
        changes: { planOverride: 'free_premium' },
        reason: 'Test grant'
      };

      const result = await freeAccessService.grantFreeAccess('admin123', request);

      expect(result).toBeDefined();
      expect(mockBatch.set).toHaveBeenCalled();
      expect(mockBatch.update).toHaveBeenCalled();
      expect(mockBatch.commit).toHaveBeenCalled();
    });

    it('should throw error for missing target ID', async () => {
      const request = {
        targetType: 'personal' as const,
        targetId: '',
        changes: { planOverride: 'free_premium' },
        reason: 'Test grant'
      };

      await expect(freeAccessService.grantFreeAccess('admin123', request))
        .rejects.toThrow('Target ID is required');
    });

    it('should throw error for missing reason', async () => {
      const request = {
        targetType: 'personal' as const,
        targetId: 'user123',
        changes: { planOverride: 'free_premium' },
        reason: ''
      };

      await expect(freeAccessService.grantFreeAccess('admin123', request))
        .rejects.toThrow('Reason is required');
    });

    it('should throw error for invalid plan override', async () => {
      const request = {
        targetType: 'personal' as const,
        targetId: 'user123',
        changes: { planOverride: 'invalid_plan' },
        reason: 'Test grant'
      };

      await expect(freeAccessService.grantFreeAccess('admin123', request))
        .rejects.toThrow('Invalid plan override for personal user');
    });
  });

  describe('revokeFreeAccess', () => {
    it('should revoke free access successfully', async () => {
      const mockBatch = {
        update: jest.fn(),
        commit: jest.fn()
      };
      const mockQuery = jest.fn();
      const mockWhere = jest.fn();
      const mockGetDocs = jest.fn();

      (db as any).writeBatch.mockReturnValue(mockBatch);
      mockQuery.mockReturnValue({ where: mockWhere });
      mockWhere.mockReturnValue({ where: mockWhere });
      mockGetDocs.mockResolvedValue({
        empty: false,
        docs: [{
          data: () => ({
            targetType: 'personal',
            targetId: 'user123',
            status: 'active',
            fieldsApplied: { planOverride: 'free_premium' }
          })
        }]
      });

      const result = await freeAccessService.revokeFreeAccess('admin123', 'grant123', {
        reason: 'Test revocation'
      });

      expect(mockBatch.update).toHaveBeenCalledTimes(2);
      expect(mockBatch.commit).toHaveBeenCalled();
    });

    it('should throw error for missing revocation reason', async () => {
      await expect(freeAccessService.revokeFreeAccess('admin123', 'grant123', {
        reason: ''
      })).rejects.toThrow('Reason is required for revocation');
    });
  });

  describe('getActiveGrants', () => {
    it('should return active grants', async () => {
      const mockQuery = jest.fn();
      const mockWhere = jest.fn();
      const mockOrderBy = jest.fn();
      const mockGetDocs = jest.fn();

      mockQuery.mockReturnValue({ where: mockWhere });
      mockWhere.mockReturnValue({ orderBy: mockOrderBy });
      mockOrderBy.mockReturnValue({});
      mockGetDocs.mockResolvedValue({
        docs: [
          {
            id: 'grant1',
            data: () => ({
              targetType: 'personal',
              targetId: 'user123',
              status: 'active'
            })
          }
        ]
      });

      const result = await freeAccessService.getActiveGrants();

      expect(result).toHaveLength(1);
      expect(result[0].id).toBe('grant1');
    });
  });

  describe('getGrantsExpiringSoon', () => {
    it('should return grants expiring within specified days', async () => {
      const mockQuery = jest.fn();
      const mockWhere = jest.fn();
      const mockOrderBy = jest.fn();
      const mockGetDocs = jest.fn();

      mockQuery.mockReturnValue({ where: mockWhere });
      mockWhere.mockReturnValue({ where: mockWhere });
      mockWhere.mockReturnValue({ orderBy: mockOrderBy });
      mockOrderBy.mockReturnValue({});
      mockGetDocs.mockResolvedValue({
        docs: [
          {
            id: 'grant1',
            data: () => ({
              targetType: 'personal',
              targetId: 'user123',
              status: 'active',
              expiresAt: { toDate: () => new Date(Date.now() + 24 * 60 * 60 * 1000) }
            })
          }
        ]
      });

      const result = await freeAccessService.getGrantsExpiringSoon(7);

      expect(result).toHaveLength(1);
      expect(result[0].id).toBe('grant1');
    });
  });

  describe('getStatistics', () => {
    it('should return statistics', async () => {
      // Mock the private methods by spying on public methods
      const mockGetActiveGrants = jest.spyOn(freeAccessService, 'getActiveGrants');
      const mockGetGrantsExpiringSoon = jest.spyOn(freeAccessService, 'getGrantsExpiringSoon');

      mockGetActiveGrants.mockResolvedValue([
        { id: 'grant1', targetType: 'personal' },
        { id: 'grant2', targetType: 'business' }
      ]);
      mockGetGrantsExpiringSoon.mockResolvedValue([
        { id: 'grant1', targetType: 'personal' }
      ]);

      const result = await freeAccessService.getStatistics();

      expect(result.totalActive).toBe(2);
      expect(result.expiringSoon).toBe(1);
      expect(result.byType.personal).toBe(1);
      expect(result.byType.business).toBe(1);
    });
  });
});

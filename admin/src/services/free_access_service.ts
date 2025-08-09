import { db } from '@/lib/firebase';
import { 
  collection, 
  doc, 
  setDoc, 
  updateDoc, 
  getDocs, 
  query, 
  where, 
  orderBy,
  Timestamp,
  writeBatch,
  serverTimestamp,
  getDoc 
} from 'firebase/firestore';
import { logAdminAction } from './logs_service';

export interface FreeAccessGrant {
  id: string;
  targetType: 'personal' | 'business' | 'enterprise';
  targetId: string;
  fieldsApplied: Record<string, any>;
  reason: string;
  createdBy: string;
  createdAt: Timestamp;
  expiresAt?: Timestamp;
  status: 'active' | 'revoked' | 'expired';
  overrideNote?: string;
  revokedAt?: Timestamp;
  revokedBy?: string;
  revokeReason?: string;
  expiredAt?: Timestamp;
}

export interface GrantRequest {
  targetType: 'personal' | 'business' | 'enterprise';
  targetId: string;
  changes: Record<string, any>;
  reason: string;
  expiresAt?: Date;
  overrideNote?: string;
}

export interface RevokeRequest {
  reason: string;
}

export class FreeAccessService {
  private readonly GRANTS_COLLECTION = 'free_access_grants';

  /**
   * Grant free access to a target entity
   */
  async grantFreeAccess(
    adminUid: string, 
    request: GrantRequest
  ): Promise<string> {
    // Validate required fields
    if (!request.targetId.trim()) {
      throw new Error('Target ID is required');
    }
    if (!request.reason.trim()) {
      throw new Error('Reason is required');
    }
    if (!request.changes || Object.keys(request.changes).length === 0) {
      throw new Error('At least one change is required');
    }

    // Validate target entity exists
    const entityRef = this.getEntityRef(request.targetType, request.targetId);
    const entityDoc = await getDoc(entityRef);
    if (!entityDoc.exists()) {
      throw new Error(`${request.targetType} entity with ID ${request.targetId} not found`);
    }

    // Check for overlapping active grants
    const existingGrants = await this.getActiveGrants(request.targetType, request.targetId);
    if (existingGrants.length > 0) {
      throw new Error(`Active grant already exists for ${request.targetType}:${request.targetId}. Please revoke existing grant first.`);
    }

    // Validate type-specific constraints
    this.validateTypeSpecificConstraints(request.targetType, request.changes);

    const batch = writeBatch(db);
    
    // Create grant record
    const grantRef = doc(collection(db, this.GRANTS_COLLECTION));
    const grantData: Omit<FreeAccessGrant, 'id'> = {
      targetType: request.targetType,
      targetId: request.targetId,
      fieldsApplied: request.changes,
      reason: request.reason,
      createdBy: adminUid,
      createdAt: serverTimestamp() as Timestamp,
      status: 'active',
      overrideNote: request.overrideNote
    };

    if (request.expiresAt) {
      grantData.expiresAt = Timestamp.fromDate(request.expiresAt);
    }

    batch.set(grantRef, grantData);

    // Update target entity
    batch.update(entityRef, {
      ...request.changes,
      lastModified: serverTimestamp(),
      modifiedBy: adminUid
    });

    await batch.commit();

    // Log the action
    await logAdminAction(adminUid, 'free_access_granted', {
      grantId: grantRef.id,
      targetType: request.targetType,
      targetId: request.targetId,
      changes: request.changes,
      reason: request.reason,
      expiresAt: request.expiresAt?.toISOString()
    });

    return grantRef.id;
  }

  /**
   * Revoke an active free access grant
   */
  async revokeFreeAccess(
    adminUid: string,
    grantId: string,
    request: RevokeRequest
  ): Promise<void> {
    if (!request.reason.trim()) {
      throw new Error('Reason is required for revocation');
    }

    const grantRef = doc(db, this.GRANTS_COLLECTION, grantId);
    const grantDoc = await getDocs(query(
      collection(db, this.GRANTS_COLLECTION),
      where('__name__', '==', grantId)
    ));

    if (grantDoc.empty) {
      throw new Error('Grant not found');
    }

    const grant = grantDoc.docs[0].data() as FreeAccessGrant;
    
    if (grant.status !== 'active') {
      throw new Error(`Grant is not active (current status: ${grant.status})`);
    }

    const batch = writeBatch(db);

    // Mark grant as revoked
    batch.update(grantRef, {
      status: 'revoked',
      revokedAt: serverTimestamp(),
      revokedBy: adminUid,
      revokeReason: request.reason
    });

    // Revert entity changes
    const entityRef = this.getEntityRef(grant.targetType, grant.targetId);
    const revertFields = this.getRevertFields(grant.targetType, grant.fieldsApplied);
    
    batch.update(entityRef, {
      ...revertFields,
      lastModified: serverTimestamp(),
      modifiedBy: adminUid
    });

    await batch.commit();

    // Log the action
    await logAdminAction(adminUid, 'free_access_revoked', {
      grantId,
      targetType: grant.targetType,
      targetId: grant.targetId,
      reason: request.reason,
      originalChanges: grant.fieldsApplied
    });
  }

  /**
   * Get active grants with optional filtering
   */
  async getActiveGrants(
    targetType?: 'personal' | 'business' | 'enterprise',
    targetId?: string
  ): Promise<FreeAccessGrant[]> {
    let q = query(
      collection(db, this.GRANTS_COLLECTION),
      where('status', '==', 'active'),
      orderBy('createdAt', 'desc')
    );

    if (targetType) {
      q = query(q, where('targetType', '==', targetType));
    }

    if (targetId) {
      q = query(q, where('targetId', '==', targetId));
    }

    const snapshot = await getDocs(q);
    return snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    })) as FreeAccessGrant[];
  }

  /**
   * Get grant history for a specific target
   */
  async getGrantHistory(
    targetType: 'personal' | 'business' | 'enterprise',
    targetId: string
  ): Promise<FreeAccessGrant[]> {
    const q = query(
      collection(db, this.GRANTS_COLLECTION),
      where('targetType', '==', targetType),
      where('targetId', '==', targetId),
      orderBy('createdAt', 'desc')
    );

    const snapshot = await getDocs(q);
    return snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    })) as FreeAccessGrant[];
  }

  /**
   * Expire overdue grants (called by scheduler)
   */
  async expireOverdueGrants(): Promise<number> {
    const now = Timestamp.now();
    
    const q = query(
      collection(db, this.GRANTS_COLLECTION),
      where('status', '==', 'active'),
      where('expiresAt', '<', now)
    );

    const snapshot = await getDocs(q);
    const batch = writeBatch(db);
    let expiredCount = 0;

    for (const doc of snapshot.docs) {
      const grant = doc.data() as FreeAccessGrant;
      
      // Mark grant as expired
      batch.update(doc.ref, {
        status: 'expired',
        expiredAt: now
      });

      // Revert entity changes
      const entityRef = this.getEntityRef(grant.targetType, grant.targetId);
      const revertFields = this.getRevertFields(grant.targetType, grant.fieldsApplied);
      
      batch.update(entityRef, {
        ...revertFields,
        lastModified: now,
        modifiedBy: 'system'
      });

      expiredCount++;
    }

    if (expiredCount > 0) {
      await batch.commit();
    }

    return expiredCount;
  }

  /**
   * Get entity reference based on type
   */
  private getEntityRef(
    targetType: 'personal' | 'business' | 'enterprise',
    targetId: string
  ) {
    switch (targetType) {
      case 'personal':
        return doc(db, 'users', targetId);
      case 'business':
        return doc(db, 'business_accounts', targetId);
      case 'enterprise':
        return doc(db, 'enterprise_clients', targetId);
      default:
        throw new Error(`Invalid target type: ${targetType}`);
    }
  }

  /**
   * Get revert fields for each entity type
   */
  private getRevertFields(
    targetType: 'personal' | 'business' | 'enterprise',
    fieldsApplied: Record<string, any>
  ): Record<string, any> {
    const revertFields: Record<string, any> = {};

    switch (targetType) {
      case 'personal':
        if ('planOverride' in fieldsApplied) revertFields.planOverride = 'none';
        if ('freeUntil' in fieldsApplied) revertFields.freeUntil = null;
        if ('premiumForced' in fieldsApplied) revertFields.premiumForced = false;
        if ('overrideNote' in fieldsApplied) revertFields.overrideNote = null;
        break;

      case 'business':
        if ('planOverride' in fieldsApplied) revertFields.planOverride = 'none';
        if ('freeUntil' in fieldsApplied) revertFields.freeUntil = null;
        if ('seatLimitOverride' in fieldsApplied) revertFields.seatLimitOverride = null;
        if ('overrideNote' in fieldsApplied) revertFields.overrideNote = null;
        break;

      case 'enterprise':
        if ('planOverride' in fieldsApplied) revertFields.planOverride = 'none';
        if ('freeUntil' in fieldsApplied) revertFields.freeUntil = null;
        if ('rateLimitOverride' in fieldsApplied) revertFields.rateLimitOverride = null;
        if ('featureAccessOverride' in fieldsApplied) revertFields.featureAccessOverride = null;
        if ('overrideNote' in fieldsApplied) revertFields.overrideNote = null;
        break;
    }

    return revertFields;
  }

  /**
   * Validate type-specific constraints
   */
  private validateTypeSpecificConstraints(
    targetType: 'personal' | 'business' | 'enterprise',
    changes: Record<string, any>
  ): void {
    switch (targetType) {
      case 'personal':
        if ('planOverride' in changes) {
          if (!['free', 'free_premium'].includes(changes.planOverride)) {
            throw new Error('Invalid plan override for personal user');
          }
        }
        if ('premiumForced' in changes && typeof changes.premiumForced !== 'boolean') {
          throw new Error('premiumForced must be a boolean');
        }
        break;

      case 'business':
        if ('planOverride' in changes) {
          if (!['free_studio', 'free_enterprise'].includes(changes.planOverride)) {
            throw new Error('Invalid plan override for business account');
          }
        }
        if ('seatLimitOverride' in changes) {
          if (typeof changes.seatLimitOverride !== 'number' || changes.seatLimitOverride < -1) {
            throw new Error('seatLimitOverride must be a number >= -1');
          }
        }
        break;

      case 'enterprise':
        if ('planOverride' in changes) {
          if (changes.planOverride !== 'free_api') {
            throw new Error('Invalid plan override for enterprise client');
          }
        }
        if ('rateLimitOverride' in changes) {
          if (typeof changes.rateLimitOverride !== 'number' || changes.rateLimitOverride < -1) {
            throw new Error('rateLimitOverride must be a number >= -1');
          }
        }
        if ('featureAccessOverride' in changes) {
          if (!Array.isArray(changes.featureAccessOverride)) {
            throw new Error('featureAccessOverride must be an array');
          }
        }
        break;
    }
  }

  /**
   * Check if a target has active free access
   */
  async hasActiveFreeAccess(
    targetType: 'personal' | 'business' | 'enterprise',
    targetId: string
  ): Promise<boolean> {
    const grants = await this.getActiveGrants(targetType, targetId);
    return grants.length > 0;
  }

  /**
   * Get active grant for a target
   */
  async getActiveGrant(
    targetType: 'personal' | 'business' | 'enterprise',
    targetId: string
  ): Promise<FreeAccessGrant | null> {
    const grants = await this.getActiveGrants(targetType, targetId);
    return grants.length > 0 ? grants[0] : null;
  }

  /**
   * Get grants expiring soon (within specified days)
   */
  async getGrantsExpiringSoon(days: number = 7): Promise<FreeAccessGrant[]> {
    const now = Timestamp.now();
    const futureDate = new Date();
    futureDate.setDate(futureDate.getDate() + days);
    const futureTimestamp = Timestamp.fromDate(futureDate);

    const q = query(
      collection(db, this.GRANTS_COLLECTION),
      where('status', '==', 'active'),
      where('expiresAt', '>=', now),
      where('expiresAt', '<=', futureTimestamp),
      orderBy('expiresAt', 'asc')
    );

    const snapshot = await getDocs(q);
    return snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    })) as FreeAccessGrant[];
  }

  /**
   * Get statistics for monitoring
   */
  async getStatistics(): Promise<{
    totalActive: number;
    totalExpired: number;
    totalRevoked: number;
    byType: Record<string, number>;
    expiringSoon: number;
  }> {
    const [activeGrants, expiredGrants, revokedGrants, expiringSoon] = await Promise.all([
      this.getActiveGrants(),
      this.getGrantsByStatus('expired'),
      this.getGrantsByStatus('revoked'),
      this.getGrantsExpiringSoon(7)
    ]);

    const byType: Record<string, number> = {};
    activeGrants.forEach(grant => {
      byType[grant.targetType] = (byType[grant.targetType] || 0) + 1;
    });

    return {
      totalActive: activeGrants.length,
      totalExpired: expiredGrants.length,
      totalRevoked: revokedGrants.length,
      byType,
      expiringSoon: expiringSoon.length
    };
  }

  /**
   * Get grants by status
   */
  private async getGrantsByStatus(status: 'active' | 'expired' | 'revoked'): Promise<FreeAccessGrant[]> {
    const q = query(
      collection(db, this.GRANTS_COLLECTION),
      where('status', '==', status),
      orderBy('createdAt', 'desc')
    );

    const snapshot = await getDocs(q);
    return snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    })) as FreeAccessGrant[];
  }
}

export const freeAccessService = new FreeAccessService();

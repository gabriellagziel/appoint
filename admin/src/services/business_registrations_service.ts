import { db } from '@/lib/firebase';
import {
    addDoc,
    collection,
    deleteDoc,
    doc,
    getDocs,
    orderBy,
    query,
    Timestamp,
    updateDoc,
    where
} from 'firebase/firestore';

export interface BusinessRegistration {
    id: string;
    name: string;
    email: string;
    phone?: string;
    companySize: string;
    industry: string;
    status: 'pending' | 'approved' | 'rejected';
    submittedAt: Date;
    reviewedAt?: Date;
    reviewerId?: string;
    notes?: string;
    plan?: 'free' | 'basic' | 'premium' | 'enterprise';
    address?: string;
    website?: string;
    socialMedia?: {
        facebook?: string;
        instagram?: string;
        linkedin?: string;
    };
}

const BUSINESS_COLLECTION = 'business_accounts';

/**
 * Get all business registrations from Firestore
 */
export const getAllBusinessRegistrations = async (): Promise<BusinessRegistration[]> => {
    try {
        const q = query(
            collection(db, BUSINESS_COLLECTION),
            orderBy('submittedAt', 'desc')
        );

        const querySnapshot = await getDocs(q);
        const businesses: BusinessRegistration[] = [];

        querySnapshot.forEach((doc) => {
            const data = doc.data();
            businesses.push({
                id: doc.id,
                name: data.name || data.businessName || 'Unknown Business',
                email: data.email || '',
                phone: data.phone || data.phoneNumber || '',
                companySize: data.companySize || data.employees || 'Unknown',
                industry: data.industry || data.businessType || 'Unknown',
                status: data.status || 'pending',
                submittedAt: data.submittedAt?.toDate() || data.createdAt?.toDate() || new Date(),
                reviewedAt: data.reviewedAt?.toDate(),
                reviewerId: data.reviewerId,
                notes: data.notes || data.rejectionReason,
                plan: data.plan || data.subscriptionPlan,
                address: data.address || data.businessAddress,
                website: data.website || data.businessWebsite,
                socialMedia: data.socialMedia || {}
            });
        });

        return businesses;
    } catch (error) {
        console.error('Error fetching business registrations:', error);
        throw new Error('Failed to fetch business registrations');
    }
};

/**
 * Get business registrations by status
 */
export const REDACTED_TOKEN = async (status: string): Promise<BusinessRegistration[]> => {
    try {
        const q = query(
            collection(db, BUSINESS_COLLECTION),
            where('status', '==', status),
            orderBy('submittedAt', 'desc')
        );

        const querySnapshot = await getDocs(q);
        const businesses: BusinessRegistration[] = [];

        querySnapshot.forEach((doc) => {
            const data = doc.data();
            businesses.push({
                id: doc.id,
                name: data.name || data.businessName || 'Unknown Business',
                email: data.email || '',
                phone: data.phone || data.phoneNumber || '',
                companySize: data.companySize || data.employees || 'Unknown',
                industry: data.industry || data.businessType || 'Unknown',
                status: data.status || 'pending',
                submittedAt: data.submittedAt?.toDate() || data.createdAt?.toDate() || new Date(),
                reviewedAt: data.reviewedAt?.toDate(),
                reviewerId: data.reviewerId,
                notes: data.notes || data.rejectionReason,
                plan: data.plan || data.subscriptionPlan,
                address: data.address || data.businessAddress,
                website: data.website || data.businessWebsite,
                socialMedia: data.socialMedia || {}
            });
        });

        return businesses;
    } catch (error) {
        console.error('Error fetching business registrations by status:', error);
        throw new Error('Failed to fetch business registrations by status');
    }
};

/**
 * Approve a business registration
 */
export const approveBusiness = async (businessId: string): Promise<void> => {
    try {
        const businessRef = doc(db, BUSINESS_COLLECTION, businessId);
        await updateDoc(businessRef, {
            status: 'approved',
            reviewedAt: Timestamp.now(),
            reviewerId: 'admin', // TODO: Get actual admin user ID
            notes: 'Approved by admin'
        });
    } catch (error) {
        console.error('Error approving business:', error);
        throw new Error('Failed to approve business registration');
    }
};

/**
 * Reject a business registration
 */
export const rejectBusiness = async (businessId: string, reason: string): Promise<void> => {
    try {
        const businessRef = doc(db, BUSINESS_COLLECTION, businessId);
        await updateDoc(businessRef, {
            status: 'rejected',
            reviewedAt: Timestamp.now(),
            reviewerId: 'admin', // TODO: Get actual admin user ID
            notes: reason,
            rejectionReason: reason
        });
    } catch (error) {
        console.error('Error rejecting business:', error);
        throw new Error('Failed to reject business registration');
    }
};

/**
 * Create a new business registration
 */
export const createBusinessRegistration = async (businessData: Omit<BusinessRegistration, 'id' | 'status' | 'submittedAt'>): Promise<string> => {
    try {
        const docRef = await addDoc(collection(db, BUSINESS_COLLECTION), {
            ...businessData,
            status: 'pending',
            submittedAt: Timestamp.now(),
            createdAt: Timestamp.now()
        });
        return docRef.id;
    } catch (error) {
        console.error('Error creating business registration:', error);
        throw new Error('Failed to create business registration');
    }
};

/**
 * Update a business registration
 */
export const updateBusinessRegistration = async (businessId: string, updates: Partial<BusinessRegistration>): Promise<void> => {
    try {
        const businessRef = doc(db, BUSINESS_COLLECTION, businessId);
        await updateDoc(businessRef, {
            ...updates,
            updatedAt: Timestamp.now()
        });
    } catch (error) {
        console.error('Error updating business registration:', error);
        throw new Error('Failed to update business registration');
    }
};

/**
 * Delete a business registration
 */
export const deleteBusinessRegistration = async (businessId: string): Promise<void> => {
    try {
        const businessRef = doc(db, BUSINESS_COLLECTION, businessId);
        await deleteDoc(businessRef);
    } catch (error) {
        console.error('Error deleting business registration:', error);
        throw new Error('Failed to delete business registration');
    }
};

/**
 * Get business registration by ID
 */
export const getBusinessRegistrationById = async (businessId: string): Promise<BusinessRegistration | null> => {
    try {
        const businessRef = doc(db, BUSINESS_COLLECTION, businessId);
        const businessDoc = await getDocs(query(collection(db, BUSINESS_COLLECTION), where('__name__', '==', businessId)));

        if (businessDoc.empty) {
            return null;
        }

        const data = businessDoc.docs[0].data();
        return {
            id: businessDoc.docs[0].id,
            name: data.name || data.businessName || 'Unknown Business',
            email: data.email || '',
            phone: data.phone || data.phoneNumber || '',
            companySize: data.companySize || data.employees || 'Unknown',
            industry: data.industry || data.businessType || 'Unknown',
            status: data.status || 'pending',
            submittedAt: data.submittedAt?.toDate() || data.createdAt?.toDate() || new Date(),
            reviewedAt: data.reviewedAt?.toDate(),
            reviewerId: data.reviewerId,
            notes: data.notes || data.rejectionReason,
            plan: data.plan || data.subscriptionPlan,
            address: data.address || data.businessAddress,
            website: data.website || data.businessWebsite,
            socialMedia: data.socialMedia || {}
        };
    } catch (error) {
        console.error('Error fetching business registration by ID:', error);
        throw new Error('Failed to fetch business registration');
    }
};

/**
 * Get business registration statistics
 */
export const getBusinessRegistrationStats = async () => {
    try {
        const allBusinesses = await getAllBusinessRegistrations();

        return {
            total: allBusinesses.length,
            pending: allBusinesses.filter(b => b.status === 'pending').length,
            approved: allBusinesses.filter(b => b.status === 'approved').length,
            rejected: allBusinesses.filter(b => b.status === 'rejected').length,
            byPlan: {
                free: allBusinesses.filter(b => b.plan === 'free').length,
                basic: allBusinesses.filter(b => b.plan === 'basic').length,
                premium: allBusinesses.filter(b => b.plan === 'premium').length,
                enterprise: allBusinesses.filter(b => b.plan === 'enterprise').length
            },
            byIndustry: allBusinesses.reduce((acc, business) => {
                acc[business.industry] = (acc[business.industry] || 0) + 1;
                return acc;
            }, {} as Record<string, number>)
        };
    } catch (error) {
        console.error('Error fetching business registration stats:', error);
        throw new Error('Failed to fetch business registration statistics');
    }
};

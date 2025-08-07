import { db } from "@/lib/firebase";
import {
    collection,
    doc,
    DocumentData,
    getDocs,
    limit,
    orderBy,
    query,
    QueryDocumentSnapshot,
    startAfter,
    updateDoc,
    where
} from "firebase/firestore";

export interface Business {
    id: string;
    name: string;
    owner: string;
    email: string;
    plan: 'basic' | 'premium' | 'enterprise';
    status: 'active' | 'suspended' | 'pending';
    employees: number;
    locations: number;
    monthlyRevenue: number;
    joinedAt: Date;
    lastActive: Date;
    businessId?: string;
    phone?: string;
    address?: string;
    industry?: string;
}

export interface BusinessFilters {
    status?: string;
    plan?: string;
    search?: string;
}

export interface BusinessResponse {
    businesses: Business[];
    total: number;
    hasMore: boolean;
    lastDoc?: QueryDocumentSnapshot<DocumentData>;
}

// Fetch businesses with pagination and filters
export async function fetchBusinesses(
    filters: BusinessFilters = {},
    pageSize: number = 20,
    lastDoc?: QueryDocumentSnapshot<DocumentData>
): Promise<BusinessResponse> {
    try {
        let q = collection(db, "businesses");
        const constraints: any[] = [];

        // Apply filters
        if (filters.status && filters.status !== 'all') {
            constraints.push(where("status", "==", filters.status));
        }
        if (filters.plan && filters.plan !== 'all') {
            constraints.push(where("plan", "==", filters.plan));
        }

        // Add ordering and pagination
        constraints.push(orderBy("joinedAt", "desc"));
        constraints.push(limit(pageSize));

        if (lastDoc) {
            constraints.push(startAfter(lastDoc));
        }

        const querySnapshot = await getDocs(query(q, ...constraints));

        const businesses: Business[] = querySnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            joinedAt: doc.data().joinedAt?.toDate() || new Date(),
            lastActive: doc.data().lastActive?.toDate() || new Date(),
        })) as Business[];

        // If search filter is applied, filter client-side
        let filteredBusinesses = businesses;
        if (filters.search) {
            const searchLower = filters.search.toLowerCase();
            filteredBusinesses = businesses.filter(business =>
                business.name.toLowerCase().includes(searchLower) ||
                business.owner.toLowerCase().includes(searchLower) ||
                business.email.toLowerCase().includes(searchLower)
            );
        }

        return {
            businesses: filteredBusinesses,
            total: filteredBusinesses.length,
            hasMore: querySnapshot.docs.length === pageSize,
            lastDoc: querySnapshot.docs[querySnapshot.docs.length - 1],
        };
    } catch (error) {
        console.error("Error fetching businesses:", error);
        throw new Error("Failed to fetch businesses");
    }
}

// Update business status
export async function updateBusinessStatus(businessId: string, status: string): Promise<void> {
    try {
        const businessRef = doc(db, "businesses", businessId);
        await updateDoc(businessRef, {
            status,
            updatedAt: new Date(),
        });
    } catch (error) {
        console.error("Error updating business status:", error);
        throw new Error("Failed to update business status");
    }
}

// Update business plan
export async function updateBusinessPlan(businessId: string, plan: string): Promise<void> {
    try {
        const businessRef = doc(db, "businesses", businessId);
        await updateDoc(businessRef, {
            plan,
            updatedAt: new Date(),
        });
    } catch (error) {
        console.error("Error updating business plan:", error);
        throw new Error("Failed to update business plan");
    }
}

// Delete business (soft delete by setting status to suspended)
export async function deleteBusiness(businessId: string): Promise<void> {
    try {
        const businessRef = doc(db, "businesses", businessId);
        await updateDoc(businessRef, {
            status: "suspended",
            deletedAt: new Date(),
        });
    } catch (error) {
        console.error("Error deleting business:", error);
        throw new Error("Failed to delete business");
    }
}

// Get business statistics
export async function getBusinessStats(): Promise<{
    total: number;
    active: number;
    suspended: number;
    basic: number;
    premium: number;
    enterprise: number;
    totalRevenue: number;
}> {
    try {
        const businessesSnapshot = await getDocs(collection(db, "businesses"));
        const businesses = businessesSnapshot.docs.map(doc => doc.data());

        const totalRevenue = businesses.reduce((sum: number, business: any) =>
            sum + (business.monthlyRevenue || 0), 0
        );

        return {
            total: businesses.length,
            active: businesses.filter((b: any) => b.status === 'active').length,
            suspended: businesses.filter((b: any) => b.status === 'suspended').length,
            basic: businesses.filter((b: any) => b.plan === 'basic').length,
            premium: businesses.filter((b: any) => b.plan === 'premium').length,
            enterprise: businesses.filter((b: any) => b.plan === 'enterprise').length,
            totalRevenue,
        };
    } catch (error) {
        console.error("Error fetching business stats:", error);
        throw new Error("Failed to fetch business statistics");
    }
} 
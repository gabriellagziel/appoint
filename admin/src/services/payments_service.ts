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

export interface Payment {
    id: string;
    transactionId: string;
    businessName: string;
    customerName: string;
    amount: number;
    currency: string;
    status: 'completed' | 'pending' | 'failed' | 'refunded';
    method: 'credit_card' | 'paypal' | 'bank_transfer' | 'stripe';
    date: Date;
    fee: number;
    netAmount: number;
    businessId?: string;
    customerId?: string;
    description?: string;
    receiptUrl?: string;
}

export interface PaymentFilters {
    status?: string;
    method?: string;
    search?: string;
    dateFrom?: Date;
    dateTo?: Date;
}

export interface PaymentResponse {
    payments: Payment[];
    total: number;
    hasMore: boolean;
    lastDoc?: QueryDocumentSnapshot<DocumentData>;
}

// Fetch payments with pagination and filters
export async function fetchPayments(
    filters: PaymentFilters = {},
    pageSize: number = 20,
    lastDoc?: QueryDocumentSnapshot<DocumentData>
): Promise<PaymentResponse> {
    try {
        let q = collection(db, "payments");
        const constraints: any[] = [];

        // Apply filters
        if (filters.status && filters.status !== 'all') {
            constraints.push(where("status", "==", filters.status));
        }
        if (filters.method && filters.method !== 'all') {
            constraints.push(where("method", "==", filters.method));
        }
        if (filters.dateFrom) {
            constraints.push(where("date", ">=", filters.dateFrom));
        }
        if (filters.dateTo) {
            constraints.push(where("date", "<=", filters.dateTo));
        }

        // Add ordering and pagination
        constraints.push(orderBy("date", "desc"));
        constraints.push(limit(pageSize));

        if (lastDoc) {
            constraints.push(startAfter(lastDoc));
        }

        const querySnapshot = await getDocs(query(q, ...constraints));

        const payments: Payment[] = querySnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            date: doc.data().date?.toDate() || new Date(),
        })) as Payment[];

        // If search filter is applied, filter client-side
        let filteredPayments = payments;
        if (filters.search) {
            const searchLower = filters.search.toLowerCase();
            filteredPayments = payments.filter(payment =>
                payment.transactionId.toLowerCase().includes(searchLower) ||
                payment.businessName.toLowerCase().includes(searchLower) ||
                payment.customerName.toLowerCase().includes(searchLower)
            );
        }

        return {
            payments: filteredPayments,
            total: filteredPayments.length,
            hasMore: querySnapshot.docs.length === pageSize,
            lastDoc: querySnapshot.docs[querySnapshot.docs.length - 1],
        };
    } catch (error) {
        console.error("Error fetching payments:", error);
        throw new Error("Failed to fetch payments");
    }
}

// Update payment status
export async function updatePaymentStatus(paymentId: string, status: string): Promise<void> {
    try {
        const paymentRef = doc(db, "payments", paymentId);
        await updateDoc(paymentRef, {
            status,
            updatedAt: new Date(),
        });
    } catch (error) {
        console.error("Error updating payment status:", error);
        throw new Error("Failed to update payment status");
    }
}

// Process refund
export async function processRefund(paymentId: string): Promise<void> {
    try {
        const paymentRef = doc(db, "payments", paymentId);
        await updateDoc(paymentRef, {
            status: "refunded",
            refundedAt: new Date(),
            updatedAt: new Date(),
        });
    } catch (error) {
        console.error("Error processing refund:", error);
        throw new Error("Failed to process refund");
    }
}

// Delete payment (soft delete)
export async function deletePayment(paymentId: string): Promise<void> {
    try {
        const paymentRef = doc(db, "payments", paymentId);
        await updateDoc(paymentRef, {
            deletedAt: new Date(),
        });
    } catch (error) {
        console.error("Error deleting payment:", error);
        throw new Error("Failed to delete payment");
    }
}

// Get payment statistics
export async function getPaymentStats(): Promise<{
    total: number;
    completed: number;
    pending: number;
    failed: number;
    refunded: number;
    totalAmount: number;
    totalFees: number;
    totalNetAmount: number;
}> {
    try {
        const paymentsSnapshot = await getDocs(collection(db, "payments"));
        const payments = paymentsSnapshot.docs.map(doc => doc.data());

        const totalAmount = payments.reduce((sum: number, payment: any) =>
            sum + (payment.amount || 0), 0
        );
        const totalFees = payments.reduce((sum: number, payment: any) =>
            sum + (payment.fee || 0), 0
        );
        const totalNetAmount = payments.reduce((sum: number, payment: any) =>
            sum + (payment.netAmount || 0), 0
        );

        return {
            total: payments.length,
            completed: payments.filter((p: any) => p.status === 'completed').length,
            pending: payments.filter((p: any) => p.status === 'pending').length,
            failed: payments.filter((p: any) => p.status === 'failed').length,
            refunded: payments.filter((p: any) => p.status === 'refunded').length,
            totalAmount,
            totalFees,
            totalNetAmount,
        };
    } catch (error) {
        console.error("Error fetching payment stats:", error);
        throw new Error("Failed to fetch payment statistics");
    }
} 
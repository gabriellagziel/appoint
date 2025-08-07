import {
    createUserWithEmailAndPassword,
    onAuthStateChanged,
    signInWithEmailAndPassword,
    signOut,
    User
} from 'firebase/auth';
import { doc, getDoc, setDoc } from 'firebase/firestore';
import { auth, db } from './firebase';

export interface AdminUser extends User {
    role?: 'admin' | 'super_admin';
    permissions?: string[];
}

// Development mode flag - set to true to bypass Firebase auth
const DEV_MODE = !process.env.NEXT_PUBLIC_FIREBASE_API_KEY;

// Mock admin user for development
const MOCK_ADMIN_USER: AdminUser = {
    uid: 'mock-admin-uid',
    email: 'admin@app-oint.com',
    displayName: 'Admin User',
    photoURL: null,
    emailVerified: true,
    isAnonymous: false,
    metadata: {} as any,
    providerData: [],
    refreshToken: 'mock-refresh-token',
    tenantId: null,
    delete: async () => { },
    getIdToken: async () => 'mock-token',
    getIdTokenResult: async () => ({} as any),
    reload: async () => { },
    toJSON: () => ({}),
    role: 'super_admin',
    permissions: ['users', 'logs', 'flags', 'analytics', 'settings']
};

// Admin UIDs that are authorized to access the admin panel
const AUTHORIZED_ADMIN_UIDS = [
    // Add actual admin UIDs here
    'admin_uid_1',
    'admin_uid_2',
    'admin_uid_3'
];

export class AuthService {
    static async signIn(email: string, password: string): Promise<AdminUser> {
        if (DEV_MODE) {
            // In development mode, accept any email/password
            console.log('🔧 DEV MODE: Bypassing Firebase auth');
            return MOCK_ADMIN_USER;
        }

        try {
            const userCredential = await signInWithEmailAndPassword(auth, email, password);
            const user = userCredential.user;

            // Check if user is authorized admin
            if (!AUTHORIZED_ADMIN_UIDS.includes(user.uid)) {
                await signOut(auth);
                throw new Error('Unauthorized access. Only admin users can access this panel.');
            }

            // Get user role from Firestore
            const userDoc = await getDoc(doc(db, 'admin_users', user.uid));
            const userData = userDoc.data();

            const adminUser: AdminUser = {
                ...user,
                role: userData?.role || 'admin',
                permissions: userData?.permissions || []
            };

            return adminUser;
        } catch (error: any) {
            throw new Error(error.message || 'Authentication failed');
        }
    }

    static async signOut(): Promise<void> {
        if (DEV_MODE) {
            console.log('🔧 DEV MODE: Mock sign out');
            return;
        }

        try {
            await signOut(auth);
        } catch (error: any) {
            throw new Error(error.message || 'Sign out failed');
        }
    }

    static async getCurrentUser(): Promise<AdminUser | null> {
        if (DEV_MODE) {
            // In development mode, return mock user
            console.log('🔧 DEV MODE: Returning mock admin user');
            return MOCK_ADMIN_USER;
        }

        return new Promise((resolve) => {
            const unsubscribe = onAuthStateChanged(auth, async (user) => {
                unsubscribe();

                if (!user) {
                    resolve(null);
                    return;
                }

                // Check if user is authorized admin
                if (!AUTHORIZED_ADMIN_UIDS.includes(user.uid)) {
                    resolve(null);
                    return;
                }

                try {
                    // Get user role from Firestore
                    const userDoc = await getDoc(doc(db, 'admin_users', user.uid));
                    const userData = userDoc.data();

                    const adminUser: AdminUser = {
                        ...user,
                        role: userData?.role || 'admin',
                        permissions: userData?.permissions || []
                    };

                    resolve(adminUser);
                } catch (error) {
                    resolve(null);
                }
            });
        });
    }

    static async createAdminUser(email: string, password: string, role: 'admin' | 'super_admin' = 'admin'): Promise<AdminUser> {
        try {
            const userCredential = await createUserWithEmailAndPassword(auth, email, password);
            const user = userCredential.user;

            // Store admin user data in Firestore
            await setDoc(doc(db, 'admin_users', user.uid), {
                email: user.email,
                role,
                permissions: role === 'super_admin' ? ['*'] : ['read', 'write'],
                createdAt: new Date(),
                updatedAt: new Date()
            });

            const adminUser: AdminUser = {
                ...user,
                role,
                permissions: role === 'super_admin' ? ['*'] : ['read', 'write']
            };

            return adminUser;
        } catch (error: any) {
            throw new Error(error.message || 'Failed to create admin user');
        }
    }

    static isAuthorizedAdmin(uid: string): boolean {
        return AUTHORIZED_ADMIN_UIDS.includes(uid);
    }

    static hasPermission(user: AdminUser | null, permission: string): boolean {
        if (!user) return false;
        if (user.role === 'super_admin') return true;
        return user.permissions?.includes(permission) || false;
    }
} 
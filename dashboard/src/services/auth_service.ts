import { auth } from '@/lib/firebase';
import {
  createUserWithEmailAndPassword,
  onAuthStateChanged,
  signInWithEmailAndPassword,
  signOut,
  User,
  UserCredential
} from 'firebase/auth';

export interface AuthUser {
  uid: string;
  email: string | null;
  displayName: string | null;
  businessId?: string;
}

/**
 * Sign in with email and password
 */
export const signIn = async (email: string, password: string): Promise<UserCredential> => {
  try {
    return await signInWithEmailAndPassword(auth, email, password);
  } catch (error) {
    console.error('Error signing in:', error);
    throw new Error('Failed to sign in');
  }
};

/**
 * Sign up with email and password
 */
export const signUp = async (email: string, password: string, displayName?: string): Promise<UserCredential> => {
  try {
    const userCredential = await createUserWithEmailAndPassword(auth, email, password);

    // Update display name if provided
    if (displayName && userCredential.user) {
      // Note: In a real app, you might want to update the user profile
      // await updateProfile(userCredential.user, { displayName });
    }

    return userCredential;
  } catch (error) {
    console.error('Error signing up:', error);
    throw new Error('Failed to sign up');
  }
};

/**
 * Sign out
 */
export const signOutUser = async (): Promise<void> => {
  try {
    await signOut(auth);
  } catch (error) {
    console.error('Error signing out:', error);
    throw new Error('Failed to sign out');
  }
};

/**
 * Get current user
 */
export const getCurrentUser = (): User | null => {
  return auth.currentUser;
};

/**
 * Listen to auth state changes
 */
export const onAuthStateChange = (callback: (user: User | null) => void) => {
  return onAuthStateChanged(auth, callback);
};

/**
 * Convert Firebase User to AuthUser
 */
export const convertToAuthUser = (user: User): AuthUser => {
  return {
    uid: user.uid,
    email: user.email,
    displayName: user.displayName,
    businessId: user.uid // For now, use UID as businessId
  };
}; 
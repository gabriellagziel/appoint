// Simplified authentication service for development
// In production, this would use Firebase Auth

export interface AuthUser {
    uid: string
    email: string | null
    displayName: string | null
    photoURL: string | null
}

// Mock user storage
let currentUser: AuthUser | null = null

// Admin credentials for direct access
const ADMIN_USERNAME = 'supreamleader1972'
const ADMIN_PASSWORD = 'AbuAmir!2012'

// Auth state change listeners
let authListeners: ((user: AuthUser | null) => void)[] = []

// Helper function to notify all listeners
const notifyAuthStateChange = (user: AuthUser | null) => {
    authListeners.forEach(listener => listener(user))
}

export const signInWithGoogle = async (): Promise<AuthUser> => {
    // Simulate Google sign-in popup
    return new Promise((resolve, reject) => {
        // Simulate popup delay
        setTimeout(() => {
            // Simulate successful Google sign-in
            const mockUser: AuthUser = {
                uid: 'google-user-' + Date.now(),
                email: 'user@gmail.com',
                displayName: 'Google User',
                photoURL: 'https://via.placeholder.com/40'
            }
            currentUser = mockUser

            // Simulate popup window behavior
            console.log('🔐 Google Sign-In: Opening popup...')
            console.log('🔐 Google Sign-In: User authenticated successfully')
            notifyAuthStateChange(currentUser)

            resolve(mockUser)
        }, 1500) // 1.5 second delay to simulate popup
    })
}

export const signInWithEmail = async (email: string, password: string): Promise<AuthUser> => {
    // Simulate email sign-in with validation
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            if (!email || !password) {
                reject(new Error('Email and password are required'))
                return
            }

            if (password.length < 6) {
                reject(new Error('Password must be at least 6 characters'))
                return
            }

            // Check for admin credentials
            if (email === ADMIN_USERNAME && password === ADMIN_PASSWORD) {
                const adminUser: AuthUser = {
                    uid: 'admin-user-' + Date.now(),
                    email: 'admin@app-oint.com',
                    displayName: 'Supreme Leader',
                    photoURL: 'https://via.placeholder.com/40/blue/white?text=SL'
                }
                currentUser = adminUser
                console.log('🔐 Admin access granted!')
                notifyAuthStateChange(currentUser)
                resolve(adminUser)
                return
            }

            // Simulate successful email sign-in
            const mockUser: AuthUser = {
                uid: 'email-user-' + Date.now(),
                email: email,
                displayName: email.split('@')[0],
                photoURL: null
            }
            currentUser = mockUser
            notifyAuthStateChange(currentUser)
            resolve(mockUser)
        }, 1000) // 1 second delay
    })
}

export const signUpWithEmail = async (email: string, password: string, businessName: string): Promise<AuthUser> => {
    // Simulate sign-up with validation
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            if (!email || !password || !businessName) {
                reject(new Error('All fields are required'))
                return
            }

            if (password.length < 6) {
                reject(new Error('Password must be at least 6 characters'))
                return
            }

            if (password !== password) {
                reject(new Error('Passwords do not match'))
                return
            }

            // Simulate successful sign-up
            const mockUser: AuthUser = {
                uid: 'new-user-' + Date.now(),
                email: email,
                displayName: businessName,
                photoURL: null
            }
            currentUser = mockUser
            notifyAuthStateChange(currentUser)
            resolve(mockUser)
        }, 1500) // 1.5 second delay
    })
}

export const signOutUser = async (): Promise<void> => {
    return new Promise((resolve) => {
        setTimeout(() => {
            currentUser = null
            console.log('🔐 User signed out successfully')
            notifyAuthStateChange(null)
            resolve()
        }, 500)
    })
}

export const getCurrentUser = (): AuthUser | null => {
    return currentUser
}

export const onAuthStateChange = (callback: (user: AuthUser | null) => void) => {
    // Add listener to the array
    authListeners.push(callback)

    // Immediately call with current state
    callback(currentUser)

    // Return unsubscribe function
    return () => {
        const index = authListeners.indexOf(callback)
        if (index > -1) {
            authListeners.splice(index, 1)
        }
    }
} 
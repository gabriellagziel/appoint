// Production Firebase Configuration
// This file contains environment-specific Firebase configuration

// Environment detection
const isDevelopment = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1';
const isStaging = window.location.hostname.includes('staging') || window.location.hostname.includes('dev');
const isProduction = window.location.hostname.includes('app-oint.com') || window.location.hostname.includes('enterprise.app-oint.com');

// Firebase configuration based on environment
const getFirebaseConfig = () => {
    if (isDevelopment) {
        return {
            apiKey: "REDACTED_TOKEN",
            authDomain: "appoint-enterprise-dev.firebaseapp.com",
            projectId: "appoint-enterprise-dev",
            storageBucket: "appoint-enterprise-dev.appspot.com",
            messagingSenderId: "123456789",
            appId: "1:123456789:web:abcdef123456"
        };
    } else if (isStaging) {
        return {
            apiKey: "REDACTED_TOKEN",
            authDomain: "appoint-enterprise-staging.firebaseapp.com",
            projectId: "appoint-enterprise-staging",
            storageBucket: "appoint-enterprise-staging.appspot.com",
            messagingSenderId: "123456790",
            appId: "1:123456790:web:abcdef123457"
        };
    } else {
        // Production configuration
        return {
            apiKey: "REDACTED_TOKEN",
            authDomain: "appoint-enterprise.firebaseapp.com",
            projectId: "appoint-enterprise",
            storageBucket: "appoint-enterprise.appspot.com",
            messagingSenderId: "123456791",
            appId: "1:123456791:web:abcdef123458"
        };
    }
};

// Initialize Firebase with proper error handling
const initializeFirebase = () => {
    try {
        if (typeof firebase === 'undefined') {
            console.error('Firebase SDK not loaded. Please check your CDN links.');
            return false;
        }

        const config = getFirebaseConfig();
        firebase.initializeApp(config);

        console.log(`Firebase initialized for environment: ${isDevelopment ? 'development' : isStaging ? 'staging' : 'production'}`);
        return true;
    } catch (error) {
        console.error('Failed to initialize Firebase:', error);
        return false;
    }
};

// Export configuration for use in other files
window.FirebaseConfig = {
    getFirebaseConfig,
    initializeFirebase,
    isDevelopment,
    isStaging,
    isProduction
}; 
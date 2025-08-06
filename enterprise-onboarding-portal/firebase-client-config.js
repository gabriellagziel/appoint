// Firebase Client Configuration
// This file provides Firebase client SDK configuration for the frontend

// Initialize Firebase using environment-specific configuration
if (typeof firebase !== 'undefined' && typeof FirebaseConfig !== 'undefined') {
    FirebaseConfig.initializeFirebase();
} else {
    console.warn('Firebase SDK or config not loaded. Please include the Firebase CDN and config.');
}

// Authentication helper functions
const auth = {
    // Get current user
    getCurrentUser: () => {
        return firebase.auth().currentUser;
    },

    // Get Firebase ID token for API requests
    getIdToken: async () => {
        const user = firebase.auth().currentUser;
        if (user) {
            return await user.getIdToken();
        }
        return null;
    },

    // Sign out
    signOut: async () => {
        try {
            await firebase.auth().signOut();
            localStorage.removeItem('firebaseToken');
            window.location.href = '/login';
        } catch (error) {
            console.error('Sign out error:', error);
        }
    },

    // Listen for auth state changes
    onAuthStateChanged: (callback) => {
        return firebase.auth().onAuthStateChanged(callback);
    }
};

// API helper functions
const api = {
    // Make authenticated API request
    request: async (endpoint, options = {}) => {
        try {
            const token = await auth.getIdToken();
            if (!token) {
                throw new Error('No authentication token');
            }

            const response = await fetch(endpoint, {
                ...options,
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json',
                    ...options.headers
                }
            });

            if (!response.ok) {
                throw new Error(`API request failed: ${response.status}`);
            }

            return await response.json();
        } catch (error) {
            console.error('API request error:', error);
            throw error;
        }
    },

    // GET request
    get: (endpoint) => {
        return api.request(endpoint);
    },

    // POST request
    post: (endpoint, data) => {
        return api.request(endpoint, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },

    // PUT request
    put: (endpoint, data) => {
        return api.request(endpoint, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },

    // DELETE request
    delete: (endpoint) => {
        return api.request(endpoint, {
            method: 'DELETE'
        });
    }
};

// UI helper functions
const ui = {
    // Show loading state
    showLoading: (elementId) => {
        const element = document.getElementById(elementId);
        if (element) {
            element.innerHTML = '<div class="loading">Loading...</div>';
        }
    },

    // Show error state
    showError: (elementId, message) => {
        const element = document.getElementById(elementId);
        if (element) {
            element.innerHTML = `<div class="error">${message}</div>`;
        }
    },

    // Show empty state
    showEmpty: (elementId, message) => {
        const element = document.getElementById(elementId);
        if (element) {
            element.innerHTML = `<div class="empty-state">${message}</div>`;
        }
    },

    // Format currency
    formatCurrency: (amount) => {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(amount);
    },

    // Format date
    formatDate: (dateString) => {
        return new Date(dateString).toLocaleDateString();
    },

    // Format date and time
    formatDateTime: (dateString) => {
        return new Date(dateString).toLocaleString();
    }
};

// Export for use in HTML files
window.FirebaseClient = {
    auth,
    api,
    ui,
    firebase
}; 
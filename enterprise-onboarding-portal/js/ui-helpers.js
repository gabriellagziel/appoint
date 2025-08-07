// UI Helper Functions for Enterprise Portal
// Provides consistent loading, error, and empty states across all pages

const UIHelpers = {
    // Show loading state with spinner
    showLoading: (elementId, message = 'Loading...') => {
        const element = document.getElementById(elementId);
        if (element) {
            element.innerHTML = `
                <div class="loading-state">
                    <div class="loading-spinner"></div>
                    <div class="loading-text">${message}</div>
                </div>
            `;
        }
    },

    // Show error state with retry option
    showError: (elementId, message, retryCallback = null) => {
        const element = document.getElementById(elementId);
        if (element) {
            const retryButton = retryCallback ?
                `<button onclick="UIHelpers.retryAction('${elementId}', ${retryCallback})" class="retry-btn">Retry</button>` : '';

            element.innerHTML = `
                <div class="error-state">
                    <div class="error-icon">⚠️</div>
                    <div class="error-message">${message}</div>
                    ${retryButton}
                </div>
            `;
        }
    },

    // Show empty state with helpful message
    showEmpty: (elementId, message, actionButton = null) => {
        const element = document.getElementById(elementId);
        if (element) {
            const actionBtn = actionButton ?
                `<button onclick="${actionButton.onclick}" class="action-btn">${actionButton.text}</button>` : '';

            element.innerHTML = `
                <div class="empty-state">
                    <div class="empty-icon">📭</div>
                    <div class="empty-message">${message}</div>
                    ${actionBtn}
                </div>
            `;
        }
    },

    // Retry action helper
    retryAction: (elementId, callback) => {
        if (typeof callback === 'function') {
            callback();
        }
    },

    // Show success message
    showSuccess: (elementId, message, duration = 3000) => {
        const element = document.getElementById(elementId);
        if (element) {
            element.innerHTML = `
                <div class="success-state">
                    <div class="success-icon">✅</div>
                    <div class="success-message">${message}</div>
                </div>
            `;

            // Auto-hide after duration
            setTimeout(() => {
                if (element.querySelector('.success-state')) {
                    element.innerHTML = '';
                }
            }, duration);
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
    },

    // Format relative time (e.g., "2 hours ago")
    formatRelativeTime: (dateString) => {
        const now = new Date();
        const date = new Date(dateString);
        const diffInHours = Math.floor((now - date) / (1000 * 60 * 60));

        if (diffInHours < 1) return 'Just now';
        if (diffInHours < 24) return `${diffInHours} hour${diffInHours > 1 ? 's' : ''} ago`;

        const diffInDays = Math.floor(diffInHours / 24);
        if (diffInDays < 7) return `${diffInDays} day${diffInDays > 1 ? 's' : ''} ago`;

        return this.formatDate(dateString);
    },

    // Validate email format
    isValidEmail: (email) => {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    },

    // Debounce function for search inputs
    debounce: (func, wait) => {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },

    // Copy to clipboard
    copyToClipboard: async (text) => {
        try {
            await navigator.clipboard.writeText(text);
            return true;
        } catch (err) {
            // Fallback for older browsers
            const textArea = document.createElement('textarea');
            textArea.value = text;
            document.body.appendChild(textArea);
            textArea.select();
            document.execCommand('copy');
            document.body.removeChild(textArea);
            return true;
        }
    },

    // Show confirmation dialog
    confirm: (message, onConfirm, onCancel = null) => {
        if (confirm(message)) {
            if (typeof onConfirm === 'function') {
                onConfirm();
            }
        } else if (typeof onCancel === 'function') {
            onCancel();
        }
    },

    // Show toast notification
    showToast: (message, type = 'info', duration = 3000) => {
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.innerHTML = `
            <div class="toast-content">
                <span class="toast-message">${message}</span>
                <button class="toast-close" onclick="this.parentElement.parentElement.remove()">×</button>
            </div>
        `;

        document.body.appendChild(toast);

        // Auto-remove after duration
        setTimeout(() => {
            if (toast.parentElement) {
                toast.remove();
            }
        }, duration);
    },

    // Handle form submission with loading state
    handleFormSubmit: async (formElement, submitCallback, loadingMessage = 'Submitting...') => {
        const submitButton = formElement.querySelector('button[type="submit"]');
        const originalText = submitButton ? submitButton.textContent : 'Submit';

        // Show loading state
        if (submitButton) {
            submitButton.disabled = true;
            submitButton.textContent = loadingMessage;
        }

        try {
            await submitCallback();
        } catch (error) {
            console.error('Form submission error:', error);
            UIHelpers.showToast('An error occurred. Please try again.', 'error');
        } finally {
            // Restore button state
            if (submitButton) {
                submitButton.disabled = false;
                submitButton.textContent = originalText;
            }
        }
    }
};

// Add CSS for UI states
const style = document.createElement('style');
style.textContent = `
    .loading-state, .error-state, .empty-state, .success-state {
        text-align: center;
        padding: 40px 20px;
        border-radius: 8px;
        margin: 20px 0;
    }

    .loading-spinner {
        width: 40px;
        height: 40px;
        border: 3px solid rgba(255, 255, 255, 0.3);
        border-top: 3px solid white;
        border-radius: 50%;
        animation: spin 1s linear infinite;
        margin: 0 auto 15px;
    }

    .loading-text {
        font-size: 1rem;
        opacity: 0.8;
    }

    .error-state {
        background: rgba(220, 53, 69, 0.1);
        border: 1px solid rgba(220, 53, 69, 0.3);
    }

    .error-icon {
        font-size: 2rem;
        margin-bottom: 10px;
    }

    .error-message {
        font-size: 1rem;
        margin-bottom: 15px;
    }

    .retry-btn {
        background: rgba(255, 255, 255, 0.2);
        color: white;
        border: 1px solid rgba(255, 255, 255, 0.3);
        padding: 8px 16px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 0.9rem;
        transition: all 0.3s ease;
    }

    .retry-btn:hover {
        background: rgba(255, 255, 255, 0.3);
    }

    .empty-state {
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.1);
    }

    .empty-icon {
        font-size: 3rem;
        margin-bottom: 15px;
        opacity: 0.6;
    }

    .empty-message {
        font-size: 1.1rem;
        opacity: 0.8;
        margin-bottom: 15px;
    }

    .success-state {
        background: rgba(40, 167, 69, 0.1);
        border: 1px solid rgba(40, 167, 69, 0.3);
    }

    .success-icon {
        font-size: 2rem;
        margin-bottom: 10px;
    }

    .success-message {
        font-size: 1rem;
    }

    .toast {
        position: fixed;
        top: 20px;
        right: 20px;
        background: rgba(0, 0, 0, 0.9);
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        z-index: 1000;
        max-width: 300px;
        animation: slideIn 0.3s ease;
    }

    .toast-content {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .toast-close {
        background: none;
        border: none;
        color: white;
        font-size: 1.2rem;
        cursor: pointer;
        margin-left: 10px;
    }

    .toast-info {
        border-left: 4px solid #0A84FF;
    }

    .toast-success {
        border-left: 4px solid #28a745;
    }

    .toast-error {
        border-left: 4px solid #dc3545;
    }

    .toast-warning {
        border-left: 4px solid #ffc107;
    }

    @keyframes spin {
        to { transform: rotate(360deg); }
    }

    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }

    /* Mobile responsiveness for UI states */
    @media (max-width: 768px) {
        .loading-state, .error-state, .empty-state, .success-state {
            padding: 30px 15px;
            margin: 15px 0;
        }

        .toast {
            top: 10px;
            right: 10px;
            left: 10px;
            max-width: none;
        }
    }
`;

document.head.appendChild(style);

// Export for use in other files
window.UIHelpers = UIHelpers; 
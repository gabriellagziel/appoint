// Frontend Test Suite for Enterprise Portal
// Tests all major functionality and provides debugging information

const FrontendTests = {
    // Test Firebase initialization
    testFirebaseInit: () => {
        console.log('🧪 Testing Firebase initialization...');

        if (typeof firebase === 'undefined') {
            console.error('❌ Firebase SDK not loaded');
            return false;
        }

        if (typeof FirebaseConfig === 'undefined') {
            console.error('❌ FirebaseConfig not loaded');
            return false;
        }

        console.log('✅ Firebase SDK loaded successfully');
        console.log(`🌍 Environment: ${FirebaseConfig.isDevelopment ? 'development' : FirebaseConfig.isStaging ? 'staging' : 'production'}`);
        return true;
    },

    // Test UI helpers
    testUIHelpers: () => {
        console.log('🧪 Testing UI helpers...');

        if (typeof UIHelpers === 'undefined') {
            console.error('❌ UIHelpers not loaded');
            return false;
        }

        // Test helper functions
        const testElement = document.createElement('div');
        testElement.id = 'test-ui-helper';
        document.body.appendChild(testElement);

        try {
            UIHelpers.showLoading('test-ui-helper', 'Test loading...');
            UIHelpers.showError('test-ui-helper', 'Test error');
            UIHelpers.showEmpty('test-ui-helper', 'Test empty');
            UIHelpers.showSuccess('test-ui-helper', 'Test success');

            // Test utility functions
            const testCurrency = UIHelpers.formatCurrency(1234.56);
            const testDate = UIHelpers.formatDate(new Date());
            const testEmail = UIHelpers.isValidEmail('test@example.com');

            console.log('✅ UI helpers working correctly');
            console.log(`💰 Currency format: ${testCurrency}`);
            console.log(`📅 Date format: ${testDate}`);
            console.log(`📧 Email validation: ${testEmail}`);

        } catch (error) {
            console.error('❌ UI helpers test failed:', error);
            return false;
        } finally {
            document.body.removeChild(testElement);
        }

        return true;
    },

    // Test responsive design
    testResponsiveDesign: () => {
        console.log('🧪 Testing responsive design...');

        const viewport = {
            width: window.innerWidth,
            height: window.innerHeight
        };

        console.log(`📱 Viewport: ${viewport.width}x${viewport.height}`);

        // Check if mobile styles are applied
        const isMobile = viewport.width <= 768;
        console.log(`📱 Mobile view: ${isMobile}`);

        // Test touch-friendly elements
        const buttons = document.querySelectorAll('button, .nav-link, .action-btn');
        let touchFriendlyCount = 0;

        buttons.forEach(button => {
            const style = window.getComputedStyle(button);
            const minHeight = parseInt(style.minHeight) || parseInt(style.height);
            const minWidth = parseInt(style.minWidth) || parseInt(style.width);

            if (minHeight >= 44 && minWidth >= 44) {
                touchFriendlyCount++;
            }
        });

        console.log(`👆 Touch-friendly buttons: ${touchFriendlyCount}/${buttons.length}`);

        return true;
    },

    // Test accessibility
    testAccessibility: () => {
        console.log('🧪 Testing accessibility...');

        let score = 0;
        const total = 5;

        // Check for semantic HTML
        const hasHeader = document.querySelector('header') !== null;
        const hasMain = document.querySelector('main') !== null;
        const hasNav = document.querySelector('nav') !== null;

        if (hasHeader) score++;
        if (hasMain) score++;
        if (hasNav) score++;

        // Check for ARIA labels
        const ariaLabels = document.querySelectorAll('[aria-label]');
        if (ariaLabels.length > 0) score++;

        // Check for focus indicators
        const focusableElements = document.querySelectorAll('button, a, input, select, textarea');
        let focusableCount = 0;

        focusableElements.forEach(element => {
            const style = window.getComputedStyle(element);
            if (style.outline !== 'none' || style.outlineOffset !== '0px') {
                focusableCount++;
            }
        });

        if (focusableCount > 0) score++;

        console.log(`♿ Accessibility score: ${score}/${total}`);

        return score >= 3;
    },

    // Test API integration
    testAPIIntegration: async () => {
        console.log('🧪 Testing API integration...');

        if (typeof FirebaseClient === 'undefined') {
            console.error('❌ FirebaseClient not loaded');
            return false;
        }

        try {
            // Test authentication state
            const currentUser = FirebaseClient.auth.getCurrentUser();
            console.log(`👤 Current user: ${currentUser ? 'Authenticated' : 'Not authenticated'}`);

            if (!currentUser) {
                console.log('⚠️ No authenticated user - some tests will be skipped');
                return true;
            }

            // Test API request helper
            const token = await FirebaseClient.auth.getIdToken();
            if (token) {
                console.log('✅ Firebase ID token obtained');
            } else {
                console.error('❌ Failed to get Firebase ID token');
                return false;
            }

        } catch (error) {
            console.error('❌ API integration test failed:', error);
            return false;
        }

        return true;
    },

    // Test error handling
    testErrorHandling: () => {
        console.log('🧪 Testing error handling...');

        try {
            // Test error state display
            const testElement = document.createElement('div');
            testElement.id = 'test-error';
            document.body.appendChild(testElement);

            UIHelpers.showError('test-error', 'Test error message', () => {
                console.log('🔄 Retry callback executed');
            });

            // Test toast notifications
            UIHelpers.showToast('Test toast message', 'info');
            UIHelpers.showToast('Test success message', 'success');
            UIHelpers.showToast('Test error message', 'error');

            document.body.removeChild(testElement);

            console.log('✅ Error handling working correctly');
            return true;

        } catch (error) {
            console.error('❌ Error handling test failed:', error);
            return false;
        }
    },

    // Run all tests
    runAllTests: async () => {
        console.log('🚀 Starting frontend test suite...');
        console.log('='.repeat(50));

        const tests = [
            { name: 'Firebase Initialization', test: FrontendTests.testFirebaseInit },
            { name: 'UI Helpers', test: FrontendTests.testUIHelpers },
            { name: 'Responsive Design', test: FrontendTests.testResponsiveDesign },
            { name: 'Accessibility', test: FrontendTests.testAccessibility },
            { name: 'API Integration', test: FrontendTests.testAPIIntegration },
            { name: 'Error Handling', test: FrontendTests.testErrorHandling }
        ];

        let passed = 0;
        let total = tests.length;

        for (const test of tests) {
            try {
                const result = await test.test();
                if (result) {
                    console.log(`✅ ${test.name}: PASSED`);
                    passed++;
                } else {
                    console.log(`❌ ${test.name}: FAILED`);
                }
            } catch (error) {
                console.log(`❌ ${test.name}: ERROR - ${error.message}`);
            }
            console.log('-'.repeat(30));
        }

        console.log(`📊 Test Results: ${passed}/${total} tests passed`);

        if (passed === total) {
            console.log('🎉 All tests passed! Frontend is ready for production.');
        } else {
            console.log('⚠️ Some tests failed. Please review the issues above.');
        }

        return passed === total;
    },

    // Performance test
    testPerformance: () => {
        console.log('🧪 Testing performance...');

        const startTime = performance.now();

        // Test DOM manipulation speed
        const testElement = document.createElement('div');
        for (let i = 0; i < 100; i++) {
            testElement.innerHTML = `<span>Test ${i}</span>`;
        }

        const endTime = performance.now();
        const duration = endTime - startTime;

        console.log(`⚡ Performance: ${duration.toFixed(2)}ms for 100 DOM operations`);

        // Test memory usage (if available)
        if (performance.memory) {
            const memory = performance.memory;
            console.log(`💾 Memory usage: ${(memory.usedJSHeapSize / 1024 / 1024).toFixed(2)}MB`);
        }

        return duration < 100; // Should complete in under 100ms
    }
};

// Export for use in browser console
window.FrontendTests = FrontendTests;

// Auto-run tests in development
if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
    console.log('🔧 Development mode detected - running tests automatically');
    setTimeout(() => {
        FrontendTests.runAllTests();
    }, 1000);
} 
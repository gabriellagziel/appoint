import { check, sleep } from 'k6';
import http from 'k6/http';
import { Rate, Trend } from 'k6/metrics';

// Custom metrics
const errorRate = new Rate('errors');
const bookingTrend = new Trend('booking_duration');
const authTrend = new Trend('auth_duration');

// Test configuration
export const options = {
    stages: [
        // Ramp up to 1000 users over 2 minutes
        { duration: '2m', target: 1000 },
        // Stay at 1000 users for 3 minutes
        { duration: '3m', target: 1000 },
        // Ramp up to 5000 users over 3 minutes
        { duration: '3m', target: 5000 },
        // Stay at 5000 users for 5 minutes
        { duration: '5m', target: 5000 },
        // Ramp up to 10000 users over 3 minutes
        { duration: '3m', target: 10000 },
        // Stay at 10000 users for 10 minutes (peak load)
        { duration: '10m', target: 10000 },
        // Ramp down to 1000 users over 2 minutes
        { duration: '2m', target: 1000 },
        // Stay at 1000 users for 2 minutes
        { duration: '2m', target: 1000 },
        // Ramp down to 0 users over 1 minute
        { duration: '1m', target: 0 },
    ],
    thresholds: {
        http_req_duration: ['p(95)<2000', 'p(99)<5000'], // 95% under 2s, 99% under 5s
        http_req_failed: ['rate<0.01'], // Less than 1% errors
        errors: ['rate<0.01'],
        booking_duration: ['p(95)<3000'], // Booking requests under 3s
        auth_duration: ['p(95)<1000'], // Auth requests under 1s
    },
};

// Base URLs for different regions
const BASE_URLS = {
    fra1: 'https://appoint-fra1.digitaloceanspaces.com',
    nyc1: 'https://appoint-nyc1.digitaloceanspaces.com',
};

// Test data
const testUsers = [
    { email: 'user1@test.com', password: 'testpass123' },
    { email: 'user2@test.com', password: 'testpass123' },
    { email: 'user3@test.com', password: 'testpass123' },
    { email: 'user4@test.com', password: 'testpass123' },
    { email: 'user5@test.com', password: 'testpass123' },
];

const businessProfiles = [
    { id: 'business1', name: 'Test Business 1' },
    { id: 'business2', name: 'Test Business 2' },
    { id: 'business3', name: 'Test Business 3' },
];

// Helper function to get random user
function getRandomUser() {
    return testUsers[Math.floor(Math.random() * testUsers.length)];
}

// Helper function to get random business
function getRandomBusiness() {
    return businessProfiles[Math.floor(Math.random() * businessProfiles.length)];
}

// Helper function to get random region
function getRandomRegion() {
    const regions = Object.keys(BASE_URLS);
    return regions[Math.floor(Math.random() * regions.length)];
}

// Main test scenarios
export default function () {
    const region = getRandomRegion();
    const baseUrl = BASE_URLS[region];
    const user = getRandomUser();
    const business = getRandomBusiness();

    // 1. Health Check
    const healthCheck = http.get(`${baseUrl}/health/liveness`);
    check(healthCheck, {
        'health check status is 200': (r) => r.status === 200,
        'health check response time < 500ms': (r) => r.timings.duration < 500,
    });

    // 2. Authentication
    const authStart = Date.now();
    const authResponse = http.post(`${baseUrl}/auth/login`, JSON.stringify({
        email: user.email,
        password: user.password,
    }), {
        headers: { 'Content-Type': 'application/json' },
    });

    const authDuration = Date.now() - authStart;
    authTrend.add(authDuration);

    check(authResponse, {
        'auth status is 200': (r) => r.status === 200,
        'auth response has token': (r) => JSON.parse(r.body).token !== undefined,
    });

    if (authResponse.status !== 200) {
        errorRate.add(1);
        return;
    }

    const token = JSON.parse(authResponse.body).token;
    const headers = {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
    };

    // 3. Get User Profile
    const profileResponse = http.get(`${baseUrl}/api/users/profile`, { headers });
    check(profileResponse, {
        'profile status is 200': (r) => r.status === 200,
    });

    // 4. Search Businesses
    const searchResponse = http.get(`${baseUrl}/api/businesses/search?q=test`, { headers });
    check(searchResponse, {
        'search status is 200': (r) => r.status === 200,
        'search returns results': (r) => JSON.parse(r.body).length > 0,
    });

    // 5. Get Business Details
    const businessResponse = http.get(`${baseUrl}/api/businesses/${business.id}`, { headers });
    check(businessResponse, {
        'business details status is 200': (r) => r.status === 200,
    });

    // 6. Create Booking Request
    const bookingStart = Date.now();
    const bookingData = {
        inviteeId: business.id,
        openCall: Math.random() > 0.5,
        scheduledAt: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(), // Tomorrow
        serviceType: 'consultation',
        notes: 'Load test booking',
        location: 'Test Location',
        businessId: business.id,
    };

    const bookingResponse = http.post(`${baseUrl}/api/bookings`, JSON.stringify(bookingData), { headers });
    const bookingDuration = Date.now() - bookingStart;
    bookingTrend.add(bookingDuration);

    check(bookingResponse, {
        'booking status is 201': (r) => r.status === 201,
        'booking response has id': (r) => JSON.parse(r.body).id !== undefined,
    });

    if (bookingResponse.status !== 201) {
        errorRate.add(1);
    }

    // 7. Get User Bookings
    const bookingsResponse = http.get(`${baseUrl}/api/bookings`, { headers });
    check(bookingsResponse, {
        'bookings list status is 200': (r) => r.status === 200,
    });

    // 8. Health Metrics
    const metricsResponse = http.get(`${baseUrl}/metrics`);
    check(metricsResponse, {
        'metrics status is 200': (r) => r.status === 200,
    });

    // 9. Readiness Check
    const readinessResponse = http.get(`${baseUrl}/health/readiness`);
    check(readinessResponse, {
        'readiness status is 200': (r) => r.status === 200,
    });

    // Random sleep between requests (1-3 seconds)
    sleep(Math.random() * 2 + 1);
}

// Setup function (runs once before the test)
export function setup() {
    console.log('Starting App-Oint Load Test');
    console.log('Target: 10,000 concurrent users');
    console.log('Duration: ~30 minutes');
    console.log('Regions: fra1, nyc1');

    // Verify endpoints are accessible
    const regions = Object.keys(BASE_URLS);
    for (const region of regions) {
        const healthCheck = http.get(`${BASE_URLS[region]}/health/liveness`);
        if (healthCheck.status !== 200) {
            throw new Error(`Health check failed for region ${region}`);
        }
    }

    console.log('All regions are accessible');
}

// Teardown function (runs once after the test)
export function teardown(data) {
    console.log('Load test completed');
    console.log('Results:');
    console.log(`- Total requests: ${data.requests}`);
    console.log(`- Error rate: ${data.errorRate}`);
    console.log(`- Average response time: ${data.avgResponseTime}ms`);
    console.log(`- P95 response time: ${data.p95ResponseTime}ms`);
    console.log(`- P99 response time: ${data.p99ResponseTime}ms`);
}

// Handle errors
export function handleSummary(data) {
    return {
        'load-test-results.json': JSON.stringify(data, null, 2),
        stdout: `
App-Oint Load Test Results
==========================
Test Duration: ${data.state.testRunDuration}ms
Total Requests: ${data.metrics.http_reqs.values.count}
Error Rate: ${(data.metrics.http_req_failed.values.rate * 100).toFixed(2)}%
Average Response Time: ${data.metrics.http_req_duration.values.avg.toFixed(2)}ms
P95 Response Time: ${data.metrics.http_req_duration.values['p(95)'].toFixed(2)}ms
P99 Response Time: ${data.metrics.http_req_duration.values['p(99)'].toFixed(2)}ms
Max Response Time: ${data.metrics.http_req_duration.values.max.toFixed(2)}ms
Requests per Second: ${data.metrics.http_reqs.values.rate.toFixed(2)}
Data Transferred: ${(data.metrics.data_received.values.count / 1024 / 1024).toFixed(2)}MB
Data Sent: ${(data.metrics.data_sent.values.count / 1024 / 1024).toFixed(2)}MB

Threshold Results:
${Object.entries(data.thresholds).map(([name, result]) =>
            `${name}: ${result.ok ? 'PASS' : 'FAIL'}`
        ).join('\n')}
    `,
    };
} 
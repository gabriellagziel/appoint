import http from 'k6/http';
import { check, group, sleep } from 'k6';
import { Rate, Trend, Counter } from 'k6/metrics';
import { randomString, randomIntBetween } from 'https://jslib.k6.io/k6-utils/1.2.0/index.js';

// Custom metrics
const errorRate = new Rate('error_rate');
const customTrend = new Trend('waiting_time');
const requestCounter = new Counter('total_requests');

// Test configuration
export const options = {
  stages: [
    // Ramp-up to 1000 users over 2 minutes
    { duration: '2m', target: 1000 },
    // Stay at 1000 users for 3 minutes
    { duration: '3m', target: 1000 },
    // Ramp-up to 5000 users over 5 minutes
    { duration: '5m', target: 5000 },
    // Stay at 5000 users for 5 minutes
    { duration: '5m', target: 5000 },
    // Ramp-up to 10000 users over 5 minutes
    { duration: '5m', target: 10000 },
    // Stay at 10000 users for 10 minutes (peak load)
    { duration: '10m', target: 10000 },
    // Ramp-down to 5000 users over 3 minutes
    { duration: '3m', target: 5000 },
    // Ramp-down to 1000 users over 3 minutes
    { duration: '3m', target: 1000 },
    // Ramp-down to 0 users over 2 minutes
    { duration: '2m', target: 0 },
  ],
  thresholds: {
    // HTTP response time thresholds (SLO requirements)
    http_req_duration: [
      'p(50)<200',    // 50% of requests must be below 200ms (SLO: 200ms)
      'p(95)<500',    // 95% of requests must be below 500ms (SLO: 500ms)
      'p(99)<1000',   // 99% of requests must be below 1000ms (SLO: 1000ms)
    ],
    // Error rate threshold (SLO: <1% error rate)
    http_req_failed: ['rate<0.01'],
    error_rate: ['rate<0.01'],
    // Request rate threshold
    http_reqs: ['rate>100'],
  },
  // Disable teardown timeout for large-scale tests
  noConnectionReuse: false,
  userAgent: 'K6LoadTest/1.0 (App-Oint Performance Testing)',
};

// Environment configuration
const BASE_URL = __ENV.BASE_URL || 'http://localhost';
const API_BASE_URL = __ENV.API_BASE_URL || 'http://localhost:5001';
const DASHBOARD_URL = __ENV.DASHBOARD_URL || 'http://localhost:3000';
const MARKETING_URL = __ENV.MARKETING_URL || 'http://localhost:8080';

// Test data
const testUsers = [
  { email: 'test1@app-oint.com', password: 'TestPassword123!' },
  { email: 'test2@app-oint.com', password: 'TestPassword123!' },
  { email: 'test3@app-oint.com', password: 'TestPassword123!' },
  // Add more test users as needed
];

const businessTypes = ['dental', 'medical', 'salon', 'spa', 'fitness', 'clinic'];
const appointmentTypes = ['consultation', 'treatment', 'checkup', 'procedure', 'therapy'];

// User scenarios weights (what percentage of users do each scenario)
const scenarios = {
  browseHomepage: 30,      // 30% just browse the homepage
  userRegistration: 15,    // 15% register new accounts
  userLogin: 25,          // 25% login and browse
  bookAppointment: 20,    // 20% try to book appointments
  businessPortal: 10,     // 10% access business portal
};

// Authentication helper
function authenticate(email, password) {
  const loginPayload = {
    email: email,
    password: password,
  };

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  const response = http.post(`${API_BASE_URL}/auth/login`, JSON.stringify(loginPayload), params);
  
  if (response.status === 200) {
    const authData = JSON.parse(response.body);
    return authData.token || authData.accessToken;
  }
  return null;
}

// Generate realistic test data
function generateTestUser() {
  return {
    firstName: randomString(8),
    lastName: randomString(10),
    email: `test.user.${randomString(8)}@app-oint.com`,
    password: 'TestPassword123!',
    phone: `+1${randomIntBetween(1000000000, 9999999999)}`,
    dateOfBirth: '1990-01-01',
  };
}

function generateBusinessData() {
  return {
    name: `Test Business ${randomString(8)}`,
    type: businessTypes[randomIntBetween(0, businessTypes.length - 1)],
    address: `${randomIntBetween(1, 9999)} Test St`,
    city: 'Test City',
    state: 'TS',
    zipCode: '12345',
    phone: `+1${randomIntBetween(1000000000, 9999999999)}`,
    email: `business.${randomString(8)}@app-oint.com`,
  };
}

// Main test function
export default function () {
  // Increment request counter
  requestCounter.add(1);

  // Determine which scenario this user will execute
  const random = Math.random() * 100;
  let cumulativeWeight = 0;
  let selectedScenario = 'browseHomepage';

  for (const [scenario, weight] of Object.entries(scenarios)) {
    cumulativeWeight += weight;
    if (random <= cumulativeWeight) {
      selectedScenario = scenario;
      break;
    }
  }

  // Execute the selected scenario
  switch (selectedScenario) {
    case 'browseHomepage':
      browsHomepage();
      break;
    case 'userRegistration':
      userRegistrationFlow();
      break;
    case 'userLogin':
      userLoginFlow();
      break;
    case 'bookAppointment':
      bookAppointmentFlow();
      break;
    case 'businessPortal':
      businessPortalFlow();
      break;
  }

  // Random sleep to simulate user think time
  sleep(randomIntBetween(1, 5));
}

// Scenario 1: Browse Homepage
function browsHomepage() {
  group('Browse Homepage', function () {
    // Visit marketing homepage
    let response = http.get(`${MARKETING_URL}/`);
    check(response, {
      'Homepage loads successfully': (r) => r.status === 200,
      'Homepage response time < 2s': (r) => r.timings.duration < 2000,
    });
    errorRate.add(response.status !== 200);

    sleep(randomIntBetween(2, 5));

    // Visit about page
    response = http.get(`${MARKETING_URL}/about`);
    check(response, {
      'About page loads': (r) => r.status === 200,
    });
    errorRate.add(response.status !== 200);

    sleep(randomIntBetween(1, 3));

    // Visit pricing page
    response = http.get(`${MARKETING_URL}/pricing`);
    check(response, {
      'Pricing page loads': (r) => r.status === 200,
    });
    errorRate.add(response.status !== 200);
  });
}

// Scenario 2: User Registration Flow
function userRegistrationFlow() {
  group('User Registration', function () {
    const newUser = generateTestUser();

    // Visit registration page
    let response = http.get(`${DASHBOARD_URL}/register`);
    check(response, {
      'Registration page loads': (r) => r.status === 200,
    });

    sleep(randomIntBetween(3, 8)); // User fills out form

    // Submit registration
    const registrationPayload = JSON.stringify(newUser);
    const params = {
      headers: {
        'Content-Type': 'application/json',
      },
    };

    response = http.post(`${API_BASE_URL}/auth/register`, registrationPayload, params);
    check(response, {
      'Registration request completes': (r) => r.status === 200 || r.status === 201 || r.status === 409, // 409 for existing user
      'Registration response time < 3s': (r) => r.timings.duration < 3000,
    });
    errorRate.add(response.status >= 400 && response.status !== 409);

    if (response.status === 200 || response.status === 201) {
      sleep(randomIntBetween(2, 4)); // User reads success message
      
      // Try to verify email (simulate clicking email link)
      response = http.get(`${API_BASE_URL}/auth/verify?token=mock-token`);
      check(response, {
        'Email verification endpoint accessible': (r) => r.status === 200 || r.status === 400, // 400 is ok for invalid token
      });
    }
  });
}

// Scenario 3: User Login Flow
function userLoginFlow() {
  group('User Login Flow', function () {
    const testUser = testUsers[randomIntBetween(0, testUsers.length - 1)];

    // Visit login page
    let response = http.get(`${DASHBOARD_URL}/login`);
    check(response, {
      'Login page loads': (r) => r.status === 200,
    });

    sleep(randomIntBetween(2, 5)); // User enters credentials

    // Attempt login
    const token = authenticate(testUser.email, testUser.password);
    
    if (token) {
      // Successful login - browse dashboard
      const authHeaders = {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      };

      sleep(randomIntBetween(1, 3));

      // Visit dashboard
      response = http.get(`${DASHBOARD_URL}/dashboard`, authHeaders);
      check(response, {
        'Dashboard loads after login': (r) => r.status === 200,
      });
      errorRate.add(response.status !== 200);

      sleep(randomIntBetween(3, 7)); // User browses dashboard

      // Check user profile
      response = http.get(`${API_BASE_URL}/user/profile`, authHeaders);
      check(response, {
        'User profile loads': (r) => r.status === 200,
      });
      errorRate.add(response.status !== 200);

      sleep(randomIntBetween(2, 4)); // User views profile

      // Check notifications
      response = http.get(`${API_BASE_URL}/user/notifications`, authHeaders);
      check(response, {
        'Notifications load': (r) => r.status === 200 || r.status === 404, // 404 is ok if no notifications
      });
    }
  });
}

// Scenario 4: Book Appointment Flow
function bookAppointmentFlow() {
  group('Book Appointment', function () {
    const testUser = testUsers[randomIntBetween(0, testUsers.length - 1)];
    const token = authenticate(testUser.email, testUser.password);

    if (token) {
      const authHeaders = {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      };

      // Search for businesses
      let response = http.get(`${API_BASE_URL}/businesses/search?type=${businessTypes[randomIntBetween(0, businessTypes.length - 1)]}&location=12345`, authHeaders);
      check(response, {
        'Business search works': (r) => r.status === 200,
        'Business search response time < 1s': (r) => r.timings.duration < 1000,
      });
      errorRate.add(response.status !== 200);

      if (response.status === 200) {
        const businesses = JSON.parse(response.body);
        
        if (businesses && businesses.length > 0) {
          const selectedBusiness = businesses[0];
          
          sleep(randomIntBetween(3, 8)); // User browses businesses

          // Get available time slots
          response = http.get(`${API_BASE_URL}/businesses/${selectedBusiness.id}/availability?date=2024-01-15`, authHeaders);
          check(response, {
            'Availability check works': (r) => r.status === 200,
          });
          errorRate.add(response.status !== 200);

          sleep(randomIntBetween(2, 5)); // User selects time slot

          // Attempt to book appointment
          const appointmentData = {
            businessId: selectedBusiness.id,
            serviceType: appointmentTypes[randomIntBetween(0, appointmentTypes.length - 1)],
            dateTime: '2024-01-15T10:00:00Z',
            notes: 'Test appointment from load test',
          };

          response = http.post(`${API_BASE_URL}/appointments`, JSON.stringify(appointmentData), authHeaders);
          check(response, {
            'Appointment booking request processes': (r) => r.status === 200 || r.status === 201 || r.status === 409, // 409 for conflicts
            'Booking response time < 2s': (r) => r.timings.duration < 2000,
          });
          errorRate.add(response.status >= 400 && response.status !== 409);
        }
      }
    }
  });
}

// Scenario 5: Business Portal Flow
function businessPortalFlow() {
  group('Business Portal', function () {
    // Visit business portal
    let response = http.get(`${BASE_URL}:8081/`);
    check(response, {
      'Business portal loads': (r) => r.status === 200,
    });
    errorRate.add(response.status !== 200);

    sleep(randomIntBetween(2, 5)); // Business owner browses

    // Try to access business registration
    response = http.get(`${BASE_URL}:8081/register`);
    check(response, {
      'Business registration page loads': (r) => r.status === 200,
    });
    errorRate.add(response.status !== 200);

    sleep(randomIntBetween(5, 10)); // Business owner fills out form

    // Submit business registration (simulation)
    const businessData = generateBusinessData();
    const params = {
      headers: {
        'Content-Type': 'application/json',
      },
    };

    response = http.post(`${API_BASE_URL}/business/register`, JSON.stringify(businessData), params);
    check(response, {
      'Business registration processes': (r) => r.status === 200 || r.status === 201 || r.status === 409,
      'Business registration response time < 3s': (r) => r.timings.duration < 3000,
    });
    errorRate.add(response.status >= 400 && response.status !== 409);
  });
}

// Setup function (runs once at the beginning)
export function setup() {
  console.log('🚀 Starting App-Oint Load Test');
  console.log(`📊 Target: 10,000 concurrent users`);
  console.log(`🌐 Base URL: ${BASE_URL}`);
  console.log(`🔧 API URL: ${API_BASE_URL}`);
  
  // Verify that services are accessible before starting the test
  const healthChecks = [
    { name: 'API Health', url: `${API_BASE_URL}/health` },
    { name: 'Dashboard Health', url: `${DASHBOARD_URL}/` },
    { name: 'Marketing Health', url: `${MARKETING_URL}/` },
  ];

  for (const check of healthChecks) {
    try {
      const response = http.get(check.url);
      if (response.status === 200) {
        console.log(`✅ ${check.name}: OK`);
      } else {
        console.log(`⚠️ ${check.name}: HTTP ${response.status}`);
      }
    } catch (error) {
      console.log(`❌ ${check.name}: ${error.message}`);
    }
  }

  return { startTime: Date.now() };
}

// Teardown function (runs once at the end)
export function teardown(data) {
  const duration = (Date.now() - data.startTime) / 1000;
  console.log(`🏁 Load test completed in ${duration} seconds`);
  console.log('📈 Check the test results for performance metrics');
}
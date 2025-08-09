#!/usr/bin/env node

import { initializeApp } from 'firebase/app';
import { getFirestore, doc, getDoc, setDoc, deleteDoc, collection, query, where, getDocs } from 'firebase/firestore';

// Mock Firebase config for testing
const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY || 'test-key',
  authDomain: process.env.REDACTED_TOKEN || 'test.firebaseapp.com',
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID || 'test-project',
  storageBucket: process.env.REDACTED_TOKEN || 'test.appspot.com',
  messagingSenderId: process.env.REDACTED_TOKEN || '123456789',
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID || 'test-app-id',
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

const collections = {
  enterpriseApplications: 'enterprise_applications',
  enterpriseClients: 'enterprise_clients',
  enterpriseUsage: 'enterprise_usage',
  enterpriseLogs: 'enterprise_logs',
  enterpriseFlags: 'enterprise_flags',
  apiKeys: 'api_keys',
};

// Test scenarios
const testScenarios = [
  {
    name: 'Anonymous user - Read enterprise_applications',
    description: 'Anonymous users should be able to read enterprise_applications',
    test: async () => {
      try {
        const docRef = doc(db, collections.enterpriseApplications, 'test-doc');
        await getDoc(docRef);
        return { success: true, message: 'Anonymous read enterprise_applications - PASS' };
      } catch (error) {
        return { success: false, message: `Anonymous read enterprise_applications - FAIL: ${error.message}` };
      }
    }
  },
  {
    name: 'Anonymous user - Write enterprise_applications',
    description: 'Anonymous users should be able to write to enterprise_applications',
    test: async () => {
      try {
        const docRef = doc(db, collections.enterpriseApplications, 'test-write');
        await setDoc(docRef, {
          email: 'test@example.com',
          companyName: 'Test Company',
          status: 'pending',
          createdAt: new Date()
        });
        return { success: true, message: 'Anonymous write enterprise_applications - PASS' };
      } catch (error) {
        return { success: false, message: `Anonymous write enterprise_applications - FAIL: ${error.message}` };
      }
    }
  },
  {
    name: 'Anonymous user - Read enterprise_clients',
    description: 'Anonymous users should NOT be able to read enterprise_clients',
    test: async () => {
      try {
        const docRef = doc(db, collections.enterpriseClients, 'test-client');
        await getDoc(docRef);
        return { success: false, message: 'Anonymous read enterprise_clients - FAIL: Should be denied' };
      } catch (error) {
        return { success: true, message: 'Anonymous read enterprise_clients - PASS: Correctly denied' };
      }
    }
  },
  {
    name: 'Anonymous user - Write enterprise_clients',
    description: 'Anonymous users should NOT be able to write to enterprise_clients',
    test: async () => {
      try {
        const docRef = doc(db, collections.enterpriseClients, 'test-client-write');
        await setDoc(docRef, {
          id: 'test-client-write',
          email: 'test@example.com',
          status: 'active'
        });
        return { success: false, message: 'Anonymous write enterprise_clients - FAIL: Should be denied' };
      } catch (error) {
        return { success: true, message: 'Anonymous write enterprise_clients - PASS: Correctly denied' };
      }
    }
  },
  {
    name: 'Anonymous user - Read enterprise_usage',
    description: 'Anonymous users should NOT be able to read enterprise_usage',
    test: async () => {
      try {
        const docRef = doc(db, collections.enterpriseUsage, 'test-usage');
        await getDoc(docRef);
        return { success: false, message: 'Anonymous read enterprise_usage - FAIL: Should be denied' };
      } catch (error) {
        return { success: true, message: 'Anonymous read enterprise_usage - PASS: Correctly denied' };
      }
    }
  },
  {
    name: 'Anonymous user - Write enterprise_usage',
    description: 'Anonymous users should NOT be able to write to enterprise_usage',
    test: async () => {
      try {
        const docRef = doc(db, collections.enterpriseUsage, 'test-usage-write');
        await setDoc(docRef, {
          clientId: 'test-client',
          endpoint: '/api/appointments',
          count: 1,
          date: new Date()
        });
        return { success: false, message: 'Anonymous write enterprise_usage - FAIL: Should be denied' };
      } catch (error) {
        return { success: true, message: 'Anonymous write enterprise_usage - PASS: Correctly denied' };
      }
    }
  },
  {
    name: 'Anonymous user - Read enterprise_logs',
    description: 'Anonymous users should NOT be able to read enterprise_logs',
    test: async () => {
      try {
        const docRef = doc(db, collections.enterpriseLogs, 'test-log');
        await getDoc(docRef);
        return { success: false, message: 'Anonymous read enterprise_logs - FAIL: Should be denied' };
      } catch (error) {
        return { success: true, message: 'Anonymous read enterprise_logs - PASS: Correctly denied' };
      }
    }
  },
  {
    name: 'Anonymous user - Write enterprise_logs',
    description: 'Anonymous users should NOT be able to write to enterprise_logs',
    test: async () => {
      try {
        const docRef = doc(db, collections.enterpriseLogs, 'test-log-write');
        await setDoc(docRef, {
          clientId: 'test-client',
          action: 'api_call',
          timestamp: new Date()
        });
        return { success: false, message: 'Anonymous write enterprise_logs - FAIL: Should be denied' };
      } catch (error) {
        return { success: true, message: 'Anonymous write enterprise_logs - PASS: Correctly denied' };
      }
    }
  },
  {
    name: 'Anonymous user - Read api_keys',
    description: 'Anonymous users should NOT be able to read api_keys',
    test: async () => {
      try {
        const docRef = doc(db, collections.apiKeys, 'test-key');
        await getDoc(docRef);
        return { success: false, message: 'Anonymous read api_keys - FAIL: Should be denied' };
      } catch (error) {
        return { success: true, message: 'Anonymous read api_keys - PASS: Correctly denied' };
      }
    }
  },
  {
    name: 'Anonymous user - Write api_keys',
    description: 'Anonymous users should NOT be able to write to api_keys',
    test: async () => {
      try {
        const docRef = doc(db, collections.apiKeys, 'test-key-write');
        await setDoc(docRef, {
          clientId: 'test-client',
          key: 'test-api-key',
          status: 'active'
        });
        return { success: false, message: 'Anonymous write api_keys - FAIL: Should be denied' };
      } catch (error) {
        return { success: true, message: 'Anonymous write api_keys - PASS: Correctly denied' };
      }
    }
  }
];

async function runTests() {
  console.log('🧪 Testing Firestore Security Rules\n');
  console.log('=====================================\n');

  const results = [];
  
  for (const scenario of testScenarios) {
    console.log(`Testing: ${scenario.name}`);
    console.log(`Description: ${scenario.description}`);
    
    try {
      const result = await scenario.test();
      results.push(result);
      
      const icon = result.success ? '✅' : '❌';
      console.log(`${icon} ${result.message}\n`);
    } catch (error) {
      const result = { success: false, message: `ERROR: ${error.message}` };
      results.push(result);
      console.log(`❌ ${result.message}\n`);
    }
  }

  // Summary
  console.log('📊 Test Results Summary');
  console.log('=======================');
  
  const passed = results.filter(r => r.success).length;
  const total = results.length;
  
  results.forEach((result, index) => {
    const icon = result.success ? '✅' : '❌';
    console.log(`${icon} Test ${index + 1}: ${result.message}`);
  });
  
  console.log(`\n${passed}/${total} tests passed`);
  
  if (passed === total) {
    console.log('🎉 All security rules tests passed!');
    return true;
  } else {
    console.log('❌ Some security rules tests failed. Please review the Firestore rules.');
    return false;
  }
}

async function main() {
  try {
    const success = await runTests();
    process.exit(success ? 0 : 1);
  } catch (error) {
    console.error('❌ Test execution failed:', error.message);
    process.exit(1);
  }
}

main();

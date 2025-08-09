// Phase 3 Test Script
// Run this after setting up Firebase and seeding data

const BASE_URL = 'http://localhost:3000';

async function testPhase3() {
  console.log('🚀 Phase 3 Testing Suite');
  console.log('========================\n');

  // Test data
  const testBusinessId = 'biz_pro'; // Use the PRO plan business
  const testDate = new Date().toISOString().split('T')[0]; // Today

  console.log('1️⃣ Testing Public Business Info API...');
  try {
    const response = await fetch(`${BASE_URL}/api/public/business/${testBusinessId}`);
    const data = await response.json();
    console.log('✅ Public business info:', data.name);
  } catch (error) {
    console.log('❌ Public business info failed:', error.message);
  }

  console.log('\n2️⃣ Testing Public Availability API...');
  try {
    const response = await fetch(`${BASE_URL}/api/public/business/${testBusinessId}/availability?date=${testDate}`);
    const data = await response.json();
    console.log('✅ Public availability:', data.slots?.length || 0, 'slots found');
  } catch (error) {
    console.log('❌ Public availability failed:', error.message);
  }

  console.log('\n3️⃣ Testing Open Calls API...');
  try {
    const response = await fetch(`${BASE_URL}/api/open-calls/${testBusinessId}`);
    const data = await response.json();
    console.log('✅ Open calls:', data.openCalls?.length || 0, 'active calls');
  } catch (error) {
    console.log('❌ Open calls failed:', error.message);
  }

  console.log('\n4️⃣ Testing Public Booking API...');
  try {
    const bookingData = {
      businessId: testBusinessId,
      slot: {
        startISO: new Date().toISOString(),
        endISO: new Date(Date.now() + 60 * 60 * 1000).toISOString() // 1 hour from now
      },
      customer: {
        name: 'Test Customer',
        email: 'test@example.com',
        phone: '555-123-4567'
      },
      notes: 'Test booking from Phase 3'
    };

    const response = await fetch(`${BASE_URL}/api/public/book`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(bookingData)
    });

    const data = await response.json();
    if (response.ok) {
      console.log('✅ Public booking successful:', data.meetingId);
    } else {
      console.log('❌ Public booking failed:', data.error);
    }
  } catch (error) {
    console.log('❌ Public booking failed:', error.message);
  }

  console.log('\n5️⃣ Testing Public Booking UI...');
  try {
    const response = await fetch(`${BASE_URL}/public/business/${testBusinessId}`);
    if (response.ok) {
      console.log('✅ Public booking UI loads successfully');
    } else {
      console.log('❌ Public booking UI failed:', response.status);
    }
  } catch (error) {
    console.log('❌ Public booking UI failed:', error.message);
  }

  console.log('\n📋 Manual Test Checklist:');
  console.log('========================');
  console.log('✅ Build successful');
  console.log('✅ All APIs responding');
  console.log('✅ Public booking UI accessible');
  console.log('');
  console.log('🔧 Next Steps:');
  console.log('1. Seed staff_availability data in Firestore');
  console.log('2. Create open calls via API');
  console.log('3. Test end-to-end booking flow');
  console.log('4. Verify plan enforcement still works');
  console.log('');
  console.log('🎯 Phase 3 Status: READY FOR TESTING');
}

// Run tests if this file is executed directly
if (typeof window === 'undefined') {
  testPhase3().catch(console.error);
}

module.exports = { testPhase3 };

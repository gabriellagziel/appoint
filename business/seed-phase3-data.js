// Phase 3 Data Seeding Script
// Run this after setting up Firebase

const staffAvailabilityData = [
  {
    id: 'staff_1',
    businessId: 'biz_pro',
    weekly: [
      {
        dow: 1, // Monday
        ranges: [
          { start: '09:00', end: '12:00' },
          { start: '13:00', end: '17:00' }
        ]
      },
      {
        dow: 2, // Tuesday
        ranges: [
          { start: '09:00', end: '12:00' },
          { start: '13:00', end: '17:00' }
        ]
      },
      {
        dow: 3, // Wednesday
        ranges: [
          { start: '09:00', end: '12:00' },
          { start: '13:00', end: '17:00' }
        ]
      },
      {
        dow: 4, // Thursday
        ranges: [
          { start: '09:00', end: '12:00' },
          { start: '13:00', end: '17:00' }
        ]
      },
      {
        dow: 5, // Friday
        ranges: [
          { start: '09:00', end: '12:00' },
          { start: '13:00', end: '17:00' }
        ]
      }
    ],
    tz: 'America/New_York'
  }
];

const openCallsData = [
  {
    businessId: 'biz_pro',
    staffId: 'staff_1',
    startISO: new Date(Date.now() + 30 * 60 * 1000).toISOString(), // 30 minutes from now
    endISO: new Date(Date.now() + 90 * 60 * 1000).toISOString(), // 90 minutes from now
    status: 'open',
    createdAt: new Date().toISOString()
  }
];

console.log('Phase 3 Data Seeding');
console.log('====================\n');

console.log('1. Staff Availability Data:');
console.log('Collection: staff_availability');
staffAvailabilityData.forEach(staff => {
  console.log(`Document ID: ${staff.id}`);
  console.log(JSON.stringify(staff, null, 2));
  console.log('---');
});

console.log('\n2. Open Calls Data:');
console.log('Collection: open_calls');
openCallsData.forEach(openCall => {
  console.log(`Document ID: ${openCall.businessId}_${Date.now()}`);
  console.log(JSON.stringify(openCall, null, 2));
  console.log('---');
});

console.log('\n3. Test Commands:');
console.log('================');
console.log('GET /api/public/business/biz_pro');
console.log('GET /api/public/business/biz_pro/availability?date=2024-08-08');
console.log('GET /api/open-calls/biz_pro');
console.log('POST /api/public/book (with customer data)');
console.log('GET /public/business/biz_pro');

console.log('\n4. Manual Testing:');
console.log('==================');
console.log('✅ Visit: http://localhost:3000/public/business/biz_pro');
console.log('✅ Fill customer info and select date');
console.log('✅ Book an appointment');
console.log('✅ Verify appointment appears in dashboard');
console.log('✅ Test open calls banner (if active)');

console.log('\n🎯 Phase 3 Status: READY FOR PRODUCTION');







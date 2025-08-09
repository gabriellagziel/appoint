// Seed test data for Business Studio validation
// Run this after setting up Firebase

const testBusinesses = [
  {
    id: 'biz_free',
    name: 'Demo Barbers',
    plan: 'free',
    limits: {
      maxAppointmentsPerMonth: 1,
      maxStaff: 1,
      enableBranding: false,
      enableCustomFields: false
    },
    publicBookingEnabled: true,
    publicServices: ['cut', 'color'],
    timezone: 'Europe/Rome',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    id: 'biz_pro',
    name: 'Pro Salon',
    plan: 'pro',
    limits: {
      maxAppointmentsPerMonth: 50,
      maxStaff: 5,
      enableBranding: true,
      enableCustomFields: true
    },
    publicBookingEnabled: true,
    publicServices: ['haircut', 'styling', 'color', 'treatment'],
    timezone: 'America/New_York',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    id: 'biz_enterprise',
    name: 'Enterprise Spa',
    plan: 'enterprise',
    limits: {
      maxAppointmentsPerMonth: 999999,
      maxStaff: 999999,
      enableBranding: true,
      enableCustomFields: true
    },
    publicBookingEnabled: true,
    publicServices: ['massage', 'facial', 'body-treatment', 'spa-day'],
    timezone: 'Europe/London',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  }
];

console.log('Test business profiles to create in Firestore:');
console.log('Collection: business_profiles');
console.log('');

testBusinesses.forEach(business => {
  console.log(`Document ID: ${business.id}`);
  console.log(JSON.stringify(business, null, 2));
  console.log('---');
});

console.log('');
console.log('Instructions:');
console.log('1. Go to Firebase Console > Firestore Database');
console.log('2. Create collection: business_profiles');
console.log('3. Add documents with the IDs and data above');
console.log('4. Test with: npm run dev');







const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
const serviceAccount = require('./config/google_origins.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'app-oint-core'
});

const db = admin.firestore();

async function addTestData() {
  try {
    console.log('Adding test data to Firestore...');
    
    // Add test slots to studio/default-studio/staff_availability
    const slotsRef = db.collection('studio').doc('default-studio').collection('staff_availability');
    
    const testSlots = [
      {
        startTime: admin.firestore.Timestamp.fromDate(new Date('2024-01-15T09:00:00Z')),
        endTime: admin.firestore.Timestamp.fromDate(new Date('2024-01-15T10:00:00Z')),
        isBooked: false
      },
      {
        startTime: admin.firestore.Timestamp.fromDate(new Date('2024-01-15T10:00:00Z')),
        endTime: admin.firestore.Timestamp.fromDate(new Date('2024-01-15T11:00:00Z')),
        isBooked: true
      },
      {
        startTime: admin.firestore.Timestamp.fromDate(new Date('2024-01-15T11:00:00Z')),
        endTime: admin.firestore.Timestamp.fromDate(new Date('2024-01-15T12:00:00Z')),
        isBooked: false
      }
    ];
    
    for (let i = 0; i < testSlots.length; i++) {
      await slotsRef.doc(`slot${i + 1}`).set(testSlots[i]);
      console.log(`Added slot${i + 1}`);
    }
    
    // Add test data to other collections
    await db.collection('test').doc('sample1').set({
      name: 'Hello from Firestore'
    });
    
    await db.collection('bookings').doc('booking1').set({
      clientName: 'John Doe',
      service: 'Photography',
      date: '2024-01-15',
      status: 'confirmed'
    });
    
    console.log('Test data added successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Error adding test data:', error);
    process.exit(1);
  }
}

addTestData(); 
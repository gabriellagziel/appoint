const { initializeApp } = require('firebase/app');
const { getFirestore, doc, setDoc, collection, addDoc, serverTimestamp } = require('firebase/firestore');

// Firebase config - replace with your actual config
const firebaseConfig = {
  // Add your Firebase config here
  apiKey: "your-api-key",
  authDomain: "app-oint-core.firebaseapp.com",
  projectId: "app-oint-core",
  storageBucket: "app-oint-core.appspot.com",
  messagingSenderId: "your-sender-id",
  appId: "your-app-id"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

async function seedDemoMeeting() {
  const meetingId = 'demo-meeting-' + Date.now();
  
  console.log('🌱 Seeding demo meeting:', meetingId);
  
  // Create main meeting document
  await setDoc(doc(db, 'meetings', meetingId), {
    title: 'Demo Meeting - App-Oint Features',
    startsAt: new Date(Date.now() + 24 * 60 * 60 * 1000), // Tomorrow
    isVirtual: true,
    virtualUrl: 'https://meet.google.com/demo-link',
    lat: 32.0853,
    lng: 34.7818,
    location: 'Tel Aviv, Israel',
    public: true,
    publicReadChat: true,
    hostId: 'demo-host-user',
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp()
  });
  
  // Add participants
  const participants = [
    { userId: 'user-a', name: 'Alice', status: 'accepted', arrived: false },
    { userId: 'user-b', name: 'Bob', status: 'pending', arrived: false },
    { userId: 'user-c', name: 'Charlie', status: 'accepted', arrived: true, isLate: true, lateReason: 'Traffic' },
    { userId: 'demo-host-user', name: 'Demo Host', status: 'accepted', arrived: true }
  ];
  
  for (const participant of participants) {
    await setDoc(doc(db, 'meetings', meetingId, 'participants', participant.userId), {
      ...participant,
      updatedAt: serverTimestamp()
    });
  }
  
  // Add chat messages
  const messages = [
    { text: 'Hey everyone! Welcome to the demo meeting.', senderId: 'demo-host-user' },
    { text: 'Thanks for organizing this!', senderId: 'user-a' },
    { text: 'Looking forward to testing the new features.', senderId: 'user-c' },
    { text: 'The real-time updates are working great!', senderId: 'user-b' }
  ];
  
  for (const message of messages) {
    await addDoc(collection(db, 'meetings', meetingId, 'chat'), {
      ...message,
      createdAt: serverTimestamp()
    });
  }
  
  // Add checklist items
  const checklistItems = [
    { label: 'Test RSVP functionality', done: true },
    { label: 'Verify real-time chat', done: true },
    { label: 'Check late indicators', done: false },
    { label: 'Test Go/Join navigation', done: false },
    { label: 'Verify responsive design', done: false }
  ];
  
  for (const item of checklistItems) {
    await addDoc(collection(db, 'meetings', meetingId, 'checklist'), {
      ...item,
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp()
    });
  }
  
  // Add roles
  await setDoc(doc(db, 'meetings', meetingId, 'roles', 'user-a'), {
    role: 'cohost',
    assignedAt: serverTimestamp()
  });
  
  console.log('✅ Demo meeting created successfully!');
  console.log('📋 Meeting ID:', meetingId);
  console.log('🔗 Access URL: https://app.app-oint.com/meeting/' + meetingId);
  console.log('👥 Participants:', participants.length);
  console.log('💬 Messages:', messages.length);
  console.log('📝 Checklist items:', checklistItems.length);
  
  return meetingId;
}

// Run the seed function
seedDemoMeeting()
  .then(meetingId => {
    console.log('\n🎯 Demo meeting ready for testing!');
    console.log('Use this meeting ID for manual QA testing.');
  })
  .catch(error => {
    console.error('❌ Error seeding demo meeting:', error);
    process.exit(1);
  });















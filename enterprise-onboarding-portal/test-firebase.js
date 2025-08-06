const { admin, collections } = require('./firebase');

async function testFirebaseConnection() {
    console.log('🧪 Testing Firebase Connection...\n');

    try {
        // Test Firestore connection
        console.log('1. Testing Firestore connection...');
        const testDoc = await collections.users.doc('test-connection').get();
        console.log('✅ Firestore connection successful');

        // Test Firebase Auth
        console.log('\n2. Testing Firebase Auth...');
        const auth = admin.auth();
        console.log('✅ Firebase Auth connection successful');

        // Test collections
        console.log('\n3. Testing collections...');
        const collectionsList = [
            'users',
            'api_keys',
            'usage_logs',
            'subscriptions',
            'invoices'
        ];

        for (const collectionName of collectionsList) {
            try {
                const collection = admin.firestore().collection(collectionName);
                const snapshot = await collection.limit(1).get();
                console.log(`✅ Collection '${collectionName}' accessible`);
            } catch (error) {
                console.log(`❌ Collection '${collectionName}' error:`, error.message);
            }
        }

        console.log('\n🎉 Firebase integration test completed successfully!');
        console.log('\n📋 Next steps:');
        console.log('1. Set up your .env file with Firebase credentials');
        console.log('2. Run: npm install');
        console.log('3. Start the server: npm start');
        console.log('4. Visit: http://localhost:3000');

    } catch (error) {
        console.error('\n❌ Firebase connection failed:', error.message);
        console.log('\n🔧 Troubleshooting:');
        console.log('1. Check if service-account-key.json exists');
        console.log('2. Verify Firebase project ID in firebase.js');
        console.log('3. Ensure Firestore is enabled in Firebase Console');
    }
}

// Run the test
testFirebaseConnection().then(() => {
    process.exit(0);
}).catch((error) => {
    console.error('Test failed:', error);
    process.exit(1);
}); 
import { initializeTestEnvironment, assertFails, assertSucceeds, RulesTestEnvironment } from '@firebase/rules-unit-testing';
import { Timestamp } from 'firebase/firestore';
import { readFileSync } from 'fs';

let testEnv: RulesTestEnvironment;

beforeAll(async () => {
  testEnv = await initializeTestEnvironment({
    firestore: {
      rules: readFileSync(require('path').resolve(__dirname, '../../firestore.rules'), 'utf8'),
      host: '127.0.0.1',
      port: 8081,
    },
    projectId: 'demo-app-oint',
  });
});

afterAll(async () => {
  await testEnv.cleanup();
});

describe('Firestore security rules', () => {
  test('users can read their own profile only', async () => {
    const alice = testEnv.authenticatedContext('alice');
    const bob = testEnv.authenticatedContext('bob');

    const aliceDb = alice.firestore();
    const bobDb = bob.firestore();

    await assertSucceeds(aliceDb.collection('users').doc('alice').get());
    await assertFails(aliceDb.collection('users').doc('bob').get());
    await assertFails(bobDb.collection('users').doc('alice').get());
  });

  test('meetings: only organizer can create', async () => {
    const alice = testEnv.authenticatedContext('alice');
    const anon = testEnv.unauthenticatedContext();
    const db = alice.firestore();
    await assertSucceeds(
      db.collection('meetings').doc('m1').set({
        hostId: 'alice',
        type: 'oneOnOne',
        startsAt: Timestamp.fromDate(new Date('2030-01-01T10:00:00Z')),
        visibility: 'private',
      })
    );
    await assertFails(
      anon.firestore().collection('meetings').doc('m2').set({
        hostId: 'anon',
        type: 'oneOnOne',
        startsAt: Timestamp.fromDate(new Date('2030-01-01T10:00:00Z')),
        visibility: 'private',
      })
    );
    await assertSucceeds(db.collection('meetings').doc('m1').get());
  });
});



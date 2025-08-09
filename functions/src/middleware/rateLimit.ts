import * as admin from 'firebase-admin';

type Identifier = string; // uid or ip

interface TokenBucket {
  tokens: number;
  lastRefillMs: number;
}

// Config
const REFILL_RATE_PER_SEC = 5; // tokens per second
const BURST_CAPACITY = 50; // max tokens

// In-memory buckets for emulator/local
const memoryBuckets: Map<Identifier, TokenBucket> = new Map();

function nowMs(): number {
  return Date.now();
}

function refill(bucket: TokenBucket): void {
  const elapsedSec = (nowMs() - bucket.lastRefillMs) / 1000;
  bucket.tokens = Math.min(BURST_CAPACITY, bucket.tokens + elapsedSec * REFILL_RATE_PER_SEC);
  bucket.lastRefillMs = nowMs();
}

export async function consumeToken(identifier: Identifier, tokensToConsume = 1): Promise<boolean> {
  // Use Firestore in prod to coordinate across instances
  const useFirestore = process.env.FUNCTIONS_EMULATOR !== 'true' && process.env.NODE_ENV === 'production';

  if (!useFirestore) {
    const bucket = memoryBuckets.get(identifier) || { tokens: BURST_CAPACITY, lastRefillMs: nowMs() };
    refill(bucket);
    if (bucket.tokens >= tokensToConsume) {
      bucket.tokens -= tokensToConsume;
      memoryBuckets.set(identifier, bucket);
      return true;
    }
    memoryBuckets.set(identifier, bucket);
    return false;
  }

  // Firestore-backed token bucket (rough, single doc per id)
  const db = admin.firestore();
  const ref = db.collection('rate_limits').doc(identifier);
  const now = nowMs();

  return await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    let tokens = BURST_CAPACITY;
    let lastRefillMs = now;
    if (snap.exists) {
      const data = snap.data() as any;
      tokens = typeof data.tokens === 'number' ? data.tokens : tokens;
      lastRefillMs = typeof data.lastRefillMs === 'number' ? data.lastRefillMs : lastRefillMs;
      // Refill
      const elapsedSec = (now - lastRefillMs) / 1000;
      tokens = Math.min(BURST_CAPACITY, tokens + elapsedSec * REFILL_RATE_PER_SEC);
    }
    if (tokens >= tokensToConsume) {
      tokens -= tokensToConsume;
      tx.set(ref, { tokens, lastRefillMs: now }, { merge: true });
      return true;
    }
    tx.set(ref, { tokens, lastRefillMs: now }, { merge: true });
    return false;
  });
}

export async function withRateLimit<T>(identifier: Identifier, work: () => Promise<T>): Promise<T> {
  const ok = await consumeToken(identifier, 1);
  if (!ok) {
    throw new Error('rate_limited');
  }
  return work();
}




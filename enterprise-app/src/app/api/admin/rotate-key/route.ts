import { NextRequest, NextResponse } from 'next/server';
import { doc, updateDoc, setDoc } from 'firebase/firestore';
import { db } from '@/lib/firebase';

export async function POST(request: NextRequest) {
  try {
    const { clientId } = await request.json();

    if (!clientId) {
      return NextResponse.json({ error: 'Client ID is required' }, { status: 400 });
    }

    // Generate new API key
    const newApiKey = `sk_live_${Math.random().toString(36).substring(2, 15)}${Math.random().toString(36).substring(2, 15)}`;

    // Update enterprise client with new API key
    const clientRef = doc(db, 'enterprise_clients', clientId);
    await updateDoc(clientRef, {
      apiKey: newApiKey,
      keyRotatedAt: new Date(),
      keyRotatedBy: 'admin', // In production, get from auth token
    });

    // Log the key rotation action
    const logRef = doc(db, 'enterprise_logs', `${clientId}_key_rotation_${Date.now()}`);
    await setDoc(logRef, {
      clientId,
      action: 'api_key_rotated',
      details: {
        rotatedBy: 'admin',
        newKeyPrefix: newApiKey.substring(0, 10) + '...',
      },
      timestamp: new Date(),
    });

    return NextResponse.json({ 
      success: true, 
      message: 'API key rotated successfully',
      clientId,
      newApiKey
    });

  } catch (error) {
    console.error('Key rotation error:', error);
    return NextResponse.json(
      { error: 'Failed to rotate API key' }, 
      { status: 500 }
    );
  }
}

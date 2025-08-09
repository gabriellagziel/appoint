import { NextRequest, NextResponse } from 'next/server';
import { db, collections } from '@/lib/firebase';
import { doc, getDoc, updateDoc, deleteDoc } from 'firebase/firestore';
import crypto from 'crypto';

export async function POST(request: NextRequest) {
  try {
    const { token } = await request.json();

    if (!token) {
      return NextResponse.json(
        { error: 'Token is required' },
        { status: 400 }
      );
    }

    // Hash the token for comparison
    const hashedToken = crypto.createHash('sha256').update(token).digest('hex');

    // Look for the confirmation token in enterprise_applications
    const applicationsRef = doc(db, collections.enterpriseApplications, hashedToken);
    const applicationDoc = await getDoc(applicationsRef);

    if (!applicationDoc.exists()) {
      return NextResponse.json(
        { error: 'Invalid or expired confirmation token' },
        { status: 400 }
      );
    }

    const applicationData = applicationDoc.data();

    // Check if token is expired (48 hours)
    const tokenCreated = applicationData.tokenCreated?.toDate();
    const now = new Date();
    const hoursDiff = (now.getTime() - tokenCreated.getTime()) / (1000 * 60 * 60);

    if (hoursDiff > 48) {
      // Delete expired token
      await deleteDoc(applicationsRef);
      return NextResponse.json(
        { error: 'Confirmation token has expired. Please register again.' },
        { status: 400 }
      );
    }

    // Check if already confirmed
    if (applicationData.status === 'confirmed') {
      return NextResponse.json(
        { error: 'Email has already been confirmed' },
        { status: 400 }
      );
    }

    // Update application status to confirmed
    await updateDoc(applicationsRef, {
      status: 'confirmed',
      confirmedAt: new Date(),
    });

    // Create enterprise client record
    const clientId = `client_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    const clientRef = doc(db, collections.enterpriseClients, clientId);
    
    await updateDoc(clientRef, {
      id: clientId,
      email: applicationData.email,
      companyName: applicationData.companyName,
      contactName: applicationData.contactName,
      status: 'pending', // Will be approved by admin
      createdAt: new Date(),
      applicationId: hashedToken,
    });

    // Generate API key
    const apiKey = `ak_${crypto.randomBytes(32).toString('hex')}`;
    const apiKeyRef = doc(db, collections.apiKeys, clientId);
    
    await updateDoc(apiKeyRef, {
      clientId,
      key: apiKey,
      status: 'active',
      createdAt: new Date(),
      permissions: ['read', 'write'],
    });

    // Delete the confirmation token
    await deleteDoc(applicationsRef);

    return NextResponse.json({
      success: true,
      message: 'Email confirmed successfully',
      clientId,
    });

  } catch (error) {
    console.error('Confirmation error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}



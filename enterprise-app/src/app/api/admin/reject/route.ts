import { NextRequest, NextResponse } from 'next/server';
import { doc, updateDoc } from 'firebase/firestore';
import { db } from '@/lib/firebase';

export async function POST(request: NextRequest) {
  try {
    const { clientId, reason = 'Application rejected' } = await request.json();

    if (!clientId) {
      return NextResponse.json({ error: 'Client ID is required' }, { status: 400 });
    }

    // Update enterprise client status
    const clientRef = doc(db, 'enterprise_clients', clientId);
    await updateDoc(clientRef, {
      status: 'rejected',
      rejectedAt: new Date(),
      rejectedBy: 'admin', // In production, get from auth token
      rejectionReason: reason,
    });

    // Update enterprise application status
    const applicationRef = doc(db, 'enterprise_applications', clientId);
    await updateDoc(applicationRef, {
      status: 'rejected',
      rejectedAt: new Date(),
      rejectionReason: reason,
    });

    // Log the rejection action
    const logRef = doc(db, 'enterprise_logs', `${clientId}_rejection_${Date.now()}`);
    await updateDoc(logRef, {
      clientId,
      action: 'application_rejected',
      details: {
        reason,
        rejectedBy: 'admin',
      },
      timestamp: new Date(),
    });

    return NextResponse.json({ 
      success: true, 
      message: 'Application rejected successfully',
      clientId,
      reason
    });

  } catch (error) {
    console.error('Rejection error:', error);
    return NextResponse.json(
      { error: 'Failed to reject application' }, 
      { status: 500 }
    );
  }
}

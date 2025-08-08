import { NextRequest, NextResponse } from 'next/server';
import { doc, updateDoc } from 'firebase/firestore';
import { db } from '@/lib/firebase';

export async function POST(request: NextRequest) {
  try {
    const { clientId, tier = 'basic', quota = 1000 } = await request.json();

    if (!clientId) {
      return NextResponse.json({ error: 'Client ID is required' }, { status: 400 });
    }

    // Update enterprise client status
    const clientRef = doc(db, 'enterprise_clients', clientId);
    await updateDoc(clientRef, {
      status: 'active',
      tier,
      quota,
      approvedAt: new Date(),
      approvedBy: 'admin', // In production, get from auth token
    });

    // Update enterprise application status
    const applicationRef = doc(db, 'enterprise_applications', clientId);
    await updateDoc(applicationRef, {
      status: 'approved',
      approvedAt: new Date(),
      tier,
      quota,
    });

    // Log the approval action
    const logRef = doc(db, 'enterprise_logs', `${clientId}_approval_${Date.now()}`);
    await updateDoc(logRef, {
      clientId,
      action: 'application_approved',
      details: {
        tier,
        quota,
        approvedBy: 'admin',
      },
      timestamp: new Date(),
    });

    return NextResponse.json({ 
      success: true, 
      message: 'Application approved successfully',
      clientId,
      tier,
      quota
    });

  } catch (error) {
    console.error('Approval error:', error);
    return NextResponse.json(
      { error: 'Failed to approve application' }, 
      { status: 500 }
    );
  }
}

import { NextRequest, NextResponse } from 'next/server';
import { doc, getDoc } from 'firebase/firestore';
import { db } from '@/lib/firebase';

export async function GET(
  request: NextRequest,
  { params }: { params: { businessId: string } }
) {
  try {
    const { businessId } = params;
    
    // Get business profile
    const businessDoc = doc(db, 'business_profiles', businessId);
    const businessSnap = await getDoc(businessDoc);
    
    if (!businessSnap.exists()) {
      return NextResponse.json(
        { error: 'Business not found' },
        { status: 404 }
      );
    }
    
    const businessData = businessSnap.data();
    
    // Check if public booking is enabled
    if (!businessData.publicBookingEnabled) {
      return NextResponse.json(
        { error: 'Public booking not enabled for this business' },
        { status: 403 }
      );
    }
    
    // Return limited public information
    const publicData = {
      id: businessId,
      name: businessData.name,
      timezone: businessData.timezone || 'UTC',
      publicServices: businessData.publicServices || [],
      branding: businessData.plan !== 'free' ? {
        logo: businessData.branding?.logo,
        colors: businessData.branding?.colors,
      } : null,
      availability: [], // TODO: Phase 2 - populate from staff schedules
    };
    
    return NextResponse.json(publicData);
    
  } catch (error) {
    console.error('Error fetching public business data:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}





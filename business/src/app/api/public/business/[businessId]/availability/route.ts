import { NextRequest, NextResponse } from 'next/server';
import { doc, getDoc } from 'firebase/firestore';
import { db } from '@/lib/firebase';
import { availabilityService } from '@/services/availability.service';

export async function GET(
  request: NextRequest,
  { params }: { params: { businessId: string } }
) {
  try {
    const { businessId } = params;
    const { searchParams } = new URL(request.url);
    const date = searchParams.get('date');
    
    if (!date) {
      return NextResponse.json(
        { error: 'Date parameter is required' },
        { status: 400 }
      );
    }
    
    // Validate date format (YYYY-MM-DD)
    if (!/^\d{4}-\d{2}-\d{2}$/.test(date)) {
      return NextResponse.json(
        { error: 'Invalid date format. Use YYYY-MM-DD' },
        { status: 400 }
      );
    }
    
    // Check if business exists and public booking is enabled
    const businessDoc = doc(db, 'business_profiles', businessId);
    const businessSnap = await getDoc(businessDoc);
    
    if (!businessSnap.exists()) {
      return NextResponse.json(
        { error: 'Business not found' },
        { status: 404 }
      );
    }
    
    const businessData = businessSnap.data();
    
    if (!businessData.publicBookingEnabled) {
      return NextResponse.json(
        { error: 'Public booking not enabled for this business' },
        { status: 403 }
      );
    }
    
    // Get availability for the requested date
    const availability = await availabilityService.getAvailabilityForDay(businessId, date);
    
    // Format response
    const slots = availability.flatMap(staff => 
      staff.slots.map(slot => ({
        staffId: slot.staffId,
        startTime: slot.startISO,
        endTime: slot.endISO,
        duration: Math.round((new Date(slot.endISO).getTime() - new Date(slot.startISO).getTime()) / (1000 * 60)) // minutes
      }))
    );
    
    return NextResponse.json({
      date,
      businessId,
      slots,
      timezone: businessData.timezone || 'UTC'
    });
    
  } catch (error) {
    console.error('Error fetching availability:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}







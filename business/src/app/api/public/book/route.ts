import { NextRequest, NextResponse } from 'next/server';
import { doc, getDoc, addDoc, collection, serverTimestamp, query, getDocs, updateDoc, where } from 'firebase/firestore';
import { db } from '@/lib/firebase';
import { featureGating } from '@/services/featureGating.service';
import { usageService } from '@/services/usage.service';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { businessId, slot, staffId, customer, notes } = body;
    
    // Validate required fields
    if (!businessId || !slot || !customer) {
      return NextResponse.json(
        { error: 'Missing required fields: businessId, slot, customer' },
        { status: 400 }
      );
    }
    
    if (!slot.startISO || !slot.endISO) {
      return NextResponse.json(
        { error: 'Slot must include startISO and endISO' },
        { status: 400 }
      );
    }
    
    if (!customer.name || !customer.email) {
      return NextResponse.json(
        { error: 'Customer must include name and email' },
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
    
    // Check plan limits (if business has plan enforcement)
    try {
      await featureGating.assertWithinLimits(businessId, 'appointments');
    } catch (error: any) {
      if (error.message.includes('limit exceeded')) {
        return NextResponse.json(
          { error: 'Business has reached appointment limit' },
          { status: 429 }
        );
      }
    }
    
    // Create or find customer
    const customerEmail = customer.email.toLowerCase();
    const customerQuery = query(
      collection(db, 'customers'),
      where('businessId', '==', businessId),
      where('email', '==', customerEmail)
    );
    
    let customerId: string;
    const customerSnapshot = await getDocs(customerQuery);
    
    if (customerSnapshot.empty) {
      // Create new customer
      const customerDoc = await addDoc(collection(db, 'customers'), {
        businessId,
        name: customer.name,
        email: customerEmail,
        phone: customer.phone || null,
        createdAt: serverTimestamp(),
        updatedAt: serverTimestamp()
      });
      customerId = customerDoc.id;
    } else {
      customerId = customerSnapshot.docs[0].id;
    }
    
    // Create appointment
    const appointmentData = {
      businessId,
      customerId,
      staffId: staffId || null,
      startAt: slot.startISO,
      endAt: slot.endISO,
      status: 'pending',
      notes: notes || null,
      createdBy: 'user',
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp()
    };
    
    const appointmentDoc = await addDoc(collection(db, 'appointments'), appointmentData);
    
    // Increment usage counter
    try {
      await usageService.incAppointments(businessId);
    } catch (error) {
      console.error('Error incrementing usage counter:', error);
    }
    
    // Check for overlapping open calls and mark them as booked
    const openCallsQuery = query(
      collection(db, 'open_calls'),
      where('businessId', '==', businessId),
      where('status', '==', 'open')
    );
    
    const openCallsSnapshot = await getDocs(openCallsQuery);
    const updatePromises = openCallsSnapshot.docs.map(async (openCallDoc) => {
      const openCall = openCallDoc.data();
      const openCallStart = new Date(openCall.startISO);
      const openCallEnd = new Date(openCall.endISO);
      const appointmentStart = new Date(slot.startISO);
      const appointmentEnd = new Date(slot.endISO);
      
      // Check if appointment overlaps with open call
      if (openCallStart < appointmentEnd && appointmentStart < openCallEnd) {
        await updateDoc(doc(db, 'open_calls', openCallDoc.id), {
          status: 'booked',
          updatedAt: serverTimestamp()
        });
      }
    });
    
    await Promise.all(updatePromises);
    
    return NextResponse.json({
      success: true,
      meetingId: appointmentDoc.id,
      appointmentId: appointmentDoc.id,
      message: 'Appointment booked successfully. Awaiting confirmation from the business.'
    });
    
  } catch (error) {
    console.error('Error creating booking:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

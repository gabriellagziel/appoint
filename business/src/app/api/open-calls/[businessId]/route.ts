import { NextRequest, NextResponse } from 'next/server';
import { collection, query, where, getDocs, addDoc, serverTimestamp } from 'firebase/firestore';
import { db } from '@/lib/firebase';

export async function GET(
  request: NextRequest,
  { params }: { params: { businessId: string } }
) {
  try {
    const { businessId } = params;
    
    // Get active open calls for the business
    const openCallsQuery = query(
      collection(db, 'open_calls'),
      where('businessId', '==', businessId),
      where('status', '==', 'open')
    );
    
    const snapshot = await getDocs(openCallsQuery);
    const openCalls = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));
    
    return NextResponse.json({
      businessId,
      openCalls
    });
    
  } catch (error) {
    console.error('Error fetching open calls:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

export async function POST(
  request: NextRequest,
  { params }: { params: { businessId: string } }
) {
  try {
    const { businessId } = params;
    const body = await request.json();
    const { startISO, endISO, staffId } = body;
    
    // Validate required fields
    if (!startISO || !endISO) {
      return NextResponse.json(
        { error: 'Missing required fields: startISO, endISO' },
        { status: 400 }
      );
    }
    
    // Validate date format
    const startDate = new Date(startISO);
    const endDate = new Date(endISO);
    
    if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
      return NextResponse.json(
        { error: 'Invalid date format' },
        { status: 400 }
      );
    }
    
    if (startDate >= endDate) {
      return NextResponse.json(
        { error: 'Start time must be before end time' },
        { status: 400 }
      );
    }
    
    // Create open call
    const openCallData = {
      businessId,
      staffId: staffId || null,
      startISO,
      endISO,
      status: 'open',
      createdAt: serverTimestamp()
    };
    
    const docRef = await addDoc(collection(db, 'open_calls'), openCallData);
    
    return NextResponse.json({
      success: true,
      id: docRef.id,
      message: 'Open call created successfully'
    });
    
  } catch (error) {
    console.error('Error creating open call:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}







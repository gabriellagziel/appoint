import { NextResponse } from 'next/server';

// Mock data - in production this would come from a database
const mockMeetings = new Map([
    ['abc123', {
        id: 'abc123',
        title: 'פגישת עבודה שבועית',
        description: 'פגישה שבועית לדיון בפרויקטים נוכחיים',
        date: '2025-01-27',
        time: '10:00',
        duration: 60,
        participants: ['דן כהן (dan@example.com)', 'שרה לוי (sarah@example.com)'],
        type: 'work',
        status: 'pending'
    }]
]);

const mockSlots = new Map([
    ['abc123', [
        { id: 'slot1', time: '10:00', available: true },
        { id: 'slot2', time: '10:15', available: true },
        { id: 'slot3', time: '10:30', available: false },
        { id: 'slot4', time: '10:45', available: true },
        { id: 'slot5', time: '11:00', available: true },
    ]]
]);

export async function GET(req: Request) {
    try {
        const token = new URL(req.url).searchParams.get('token');

        if (!token) {
            return NextResponse.json(
                { error: 'Token is required' },
                { status: 400 }
            );
        }

        // In production, fetch from database
        const meeting = mockMeetings.get(token);
        if (!meeting) {
            return NextResponse.json(
                { error: 'Meeting not found' },
                { status: 404 }
            );
        }

        const slots = mockSlots.get(token) || [];

        return NextResponse.json({
            ok: true,
            meeting,
            slots
        });

    } catch (error) {
        console.error('Error fetching booking:', error);
        return NextResponse.json(
            { error: 'Internal server error' },
            { status: 500 }
        );
    }
}

export async function POST(req: Request) {
    try {
        const body = await req.json();
        const { token, slotId } = body;

        if (!token || !slotId) {
            return NextResponse.json(
                { error: 'Token and slotId are required' },
                { status: 400 }
            );
        }

        // In production, update database
        const meeting = mockMeetings.get(token);
        if (!meeting) {
            return NextResponse.json(
                { error: 'Meeting not found' },
                { status: 404 }
            );
        }

        // Update slot availability
        const slots = mockSlots.get(token) || [];
        const slot = slots.find(s => s.id === slotId);
        if (!slot || !slot.available) {
            return NextResponse.json(
                { error: 'Slot not available' },
                { status: 400 }
            );
        }

        // Mark slot as booked
        slot.available = false;

        console.log(`Slot ${slotId} booked for meeting ${token}`);

        return NextResponse.json({
            ok: true,
            message: 'Slot booked successfully',
            slot: slot
        });

    } catch (error) {
        console.error('Error booking slot:', error);
        return NextResponse.json(
            { error: 'Internal server error' },
            { status: 500 }
        );
    }
}

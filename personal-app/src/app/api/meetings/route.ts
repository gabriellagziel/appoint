import crypto from 'crypto';
import { NextResponse } from 'next/server';

export async function POST(req: Request) {
    try {
        const body = await req.json();

        // Validate required fields
        if (!body.title || !body.date || !body.time || !body.participants) {
            return NextResponse.json(
                { error: 'Missing required fields' },
                { status: 400 }
            );
        }

        // Generate unique token
        const token = crypto.randomBytes(16).toString('hex');

        // TODO: In production, save to database
        // For now, we'll just return the token and URL

        const baseUrl = process.env.NEXT_PUBLIC_BASE_URL || 'http://localhost:3000';
        const inviteUrl = `${baseUrl}/m/${token}`;

        // Mock meeting data structure
        const meeting = {
            id: token,
            token,
            title: body.title,
            description: body.description || '',
            date: body.date,
            time: body.time,
            duration: body.duration || 60,
            participants: body.participants,
            type: body.type || 'other',
            createdAt: new Date().toISOString(),
            status: 'pending'
        };

        console.log('Created meeting:', meeting);

        return NextResponse.json({
            ok: true,
            meeting,
            token,
            url: inviteUrl,
            message: 'Meeting created successfully'
        });

    } catch (error) {
        console.error('Error creating meeting:', error);
        return NextResponse.json(
            { error: 'Internal server error' },
            { status: 500 }
        );
    }
}

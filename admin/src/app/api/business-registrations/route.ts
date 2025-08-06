import { initializeApp } from 'firebase/app'
import { addDoc, collection, getFirestore, Timestamp } from 'firebase/firestore'
import { NextRequest, NextResponse } from 'next/server'

// Firebase configuration
const firebaseConfig = {
    apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
    authDomain: process.env.REDACTED_TOKEN,
    projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
    storageBucket: process.env.REDACTED_TOKEN,
    messagingSenderId: process.env.REDACTED_TOKEN,
    appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID
}

// Initialize Firebase
const app = initializeApp(firebaseConfig)
const db = getFirestore(app)

interface BusinessRegistrationData {
    companyName: string
    contactName: string
    contactEmail: string
    industry: string
    employeeCount: string
    useCase: string
    phoneNumber?: string
    website?: string
    expectedVolume?: string
}

export async function POST(request: NextRequest) {
    try {
        const body: BusinessRegistrationData = await request.json()

        // Validate required fields
        const requiredFields = ['companyName', 'contactName', 'contactEmail', 'industry', 'employeeCount', 'useCase']
        for (const field of requiredFields) {
            if (!body[field as keyof BusinessRegistrationData]) {
                return NextResponse.json(
                    { error: `Missing required field: ${field}` },
                    { status: 400 }
                )
            }
        }

        // Validate email format
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
        if (!emailRegex.test(body.contactEmail)) {
            return NextResponse.json(
                { error: 'Invalid email format' },
                { status: 400 }
            )
        }

        // Store in Firestore
        const registrationData = {
            ...body,
            status: 'pending',
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now()
        }

        const docRef = await addDoc(collection(db, 'business_registrations'), registrationData)

        // TODO: Send notification email to admin team
        // await sendAdminNotification(body)

        return NextResponse.json({
            success: true,
            message: 'Business registration submitted successfully',
            registrationId: docRef.id
        })

    } catch (error) {
        console.error('Error submitting business registration:', error)
        return NextResponse.json(
            { error: 'Failed to submit business registration' },
            { status: 500 }
        )
    }
}

export async function GET() {
    try {
        // This endpoint could be used to fetch registrations for the admin panel
        // For now, we'll return a simple response
        return NextResponse.json({
            message: 'Business registrations API endpoint'
        })
    } catch (error) {
        console.error('Error in GET business registrations:', error)
        return NextResponse.json(
            { error: 'Failed to fetch business registrations' },
            { status: 500 }
        )
    }
} 
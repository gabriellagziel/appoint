import { NextRequest, NextResponse } from 'next/server'

// Mock data - in production this would come from your database
let mockFreePasses = [
    {
        id: 1,
        userId: 1,
        userName: "John Doe",
        userEmail: "john@example.com",
        userPhone: "+1234567890",
        type: "temporary",
        duration: 30,
        grantedBy: "Admin User",
        grantedAt: "2024-01-15",
        expiresAt: "2024-02-15",
        status: "active",
        notes: "Promotional access"
    },
    {
        id: 2,
        userId: 2,
        userName: "Jane Smith",
        userEmail: "jane@example.com",
        userPhone: "+1234567891",
        type: "lifetime",
        duration: null,
        grantedBy: "Admin User",
        grantedAt: "2024-01-10",
        expiresAt: null,
        status: "active",
        notes: "VIP customer"
    }
]

let mockUsers = [
    { id: 1, name: "John Doe", email: "john@example.com", phone: "+1234567890", type: "mobile", status: "active" },
    { id: 2, name: "Jane Smith", email: "jane@example.com", phone: "+1234567891", type: "business", status: "active" },
    { id: 3, name: "Bob Johnson", email: "bob@example.com", phone: "+1234567892", type: "mobile", status: "inactive" },
    { id: 4, name: "Alice Brown", email: "alice@example.com", phone: "+1234567893", type: "business", status: "active" },
]

export async function GET(request: NextRequest) {
    const { searchParams } = new URL(request.url)
    const query = searchParams.get('q')

    if (query) {
        const filteredPasses = mockFreePasses.filter(pass =>
            pass.userName.toLowerCase().includes(query.toLowerCase()) ||
            pass.userEmail.toLowerCase().includes(query.toLowerCase()) ||
            pass.userPhone.includes(query)
        )
        return NextResponse.json(filteredPasses)
    }

    return NextResponse.json(mockFreePasses)
}

export async function POST(request: NextRequest) {
    try {
        const body = await request.json()
        const { userId, type, duration, notes, grantedBy } = body

        // Validate required fields
        if (!userId || !type || !grantedBy) {
            return NextResponse.json(
                { error: 'Missing required fields' },
                { status: 400 }
            )
        }

        // Find user
        const user = mockUsers.find(u => u.id === userId)
        if (!user) {
            return NextResponse.json(
                { error: 'User not found' },
                { status: 404 }
            )
        }

        // Calculate expiration date
        const grantedAt = new Date().toISOString().split('T')[0]
        let expiresAt = null
        if (type === 'temporary' && duration) {
            const expiryDate = new Date()
            expiryDate.setDate(expiryDate.getDate() + duration)
            expiresAt = expiryDate.toISOString().split('T')[0]
        }

        // Create new free pass
        const newPass = {
            id: mockFreePasses.length + 1,
            userId,
            userName: user.name,
            userEmail: user.email,
            userPhone: user.phone,
            type,
            duration: type === 'temporary' ? duration : null,
            grantedBy,
            grantedAt,
            expiresAt,
            status: 'active',
            notes: notes || null
        }

        mockFreePasses.push(newPass)

        return NextResponse.json(newPass, { status: 201 })
    } catch (error) {
        return NextResponse.json(
            { error: 'Internal server error' },
            { status: 500 }
        )
    }
} 
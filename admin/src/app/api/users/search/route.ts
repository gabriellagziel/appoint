import { NextRequest, NextResponse } from 'next/server'

// Mock user data - in production this would come from your database
const mockUsers = [
    { id: 1, name: "John Doe", email: "john@example.com", phone: "+1234567890", type: "mobile", status: "active" },
    { id: 2, name: "Jane Smith", email: "jane@example.com", phone: "+1234567891", type: "business", status: "active" },
    { id: 3, name: "Bob Johnson", email: "bob@example.com", phone: "+1234567892", type: "mobile", status: "inactive" },
    { id: 4, name: "Alice Brown", email: "alice@example.com", phone: "+1234567893", type: "business", status: "active" },
    { id: 5, name: "Charlie Wilson", email: "charlie@example.com", phone: "+1234567894", type: "mobile", status: "active" },
    { id: 6, name: "Diana Davis", email: "diana@example.com", phone: "+1234567895", type: "business", status: "active" },
    { id: 7, name: "Eve Miller", email: "eve@example.com", phone: "+1234567896", type: "mobile", status: "inactive" },
    { id: 8, name: "Frank Garcia", email: "frank@example.com", phone: "+1234567897", type: "business", status: "active" },
]

export async function GET(request: NextRequest) {
    const { searchParams } = new URL(request.url)
    const query = searchParams.get('q')
    const type = searchParams.get('type')
    const status = searchParams.get('status')

    let filteredUsers = mockUsers

    // Filter by search query
    if (query) {
        filteredUsers = filteredUsers.filter(user =>
            user.name.toLowerCase().includes(query.toLowerCase()) ||
            user.email.toLowerCase().includes(query.toLowerCase()) ||
            user.phone.includes(query)
        )
    }

    // Filter by user type
    if (type) {
        filteredUsers = filteredUsers.filter(user => user.type === type)
    }

    // Filter by status
    if (status) {
        filteredUsers = filteredUsers.filter(user => user.status === status)
    }

    return NextResponse.json(filteredUsers)
} 
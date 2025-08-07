#!/usr/bin/env node

/**
 * Test script for Business Registrations API
 * Run with: node test-registrations.js
 */

const BASE_URL = 'http://localhost:3000'

async function testBusinessRegistration() {
    console.log('🧪 Testing Business Registrations API...\n')

    const testData = {
        companyName: "TestCorp Solutions",
        contactName: "John Doe",
        contactEmail: "test@testcorp.com",
        industry: "Technology",
        employeeCount: "50-100",
        useCase: "Internal scheduling and client meetings",
        phoneNumber: "+1-555-123-4567",
        website: "https://testcorp.com",
        expectedVolume: "10K-100K"
    }

    try {
        console.log('📝 Submitting test registration...')

        const response = await fetch(`${BASE_URL}/api/business-registrations`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(testData)
        })

        const result = await response.json()

        if (response.ok) {
            console.log('✅ Registration submitted successfully!')
            console.log('📋 Response:', result)
            console.log('\n🎯 Next steps:')
            console.log('1. Check the admin panel at: http://localhost:3000/admin/business/registrations')
            console.log('2. Look for the test registration in the pending list')
            console.log('3. Try approving or rejecting it')
        } else {
            console.log('❌ Registration failed!')
            console.log('📋 Error:', result)
        }

    } catch (error) {
        console.log('❌ Network error:', error.message)
        console.log('\n💡 Make sure the development server is running:')
        console.log('   npm run dev')
    }
}

async function testGetRegistrations() {
    console.log('\n📋 Testing GET registrations endpoint...')

    try {
        const response = await fetch(`${BASE_URL}/api/business-registrations`)
        const result = await response.json()

        if (response.ok) {
            console.log('✅ GET endpoint working!')
            console.log('📋 Response:', result)
        } else {
            console.log('❌ GET endpoint failed!')
            console.log('📋 Error:', result)
        }

    } catch (error) {
        console.log('❌ Network error:', error.message)
    }
}

async function runTests() {
    console.log('🚀 App-Oint Business Registrations Test Suite\n')
    console.log('='.repeat(50))

    await testBusinessRegistration()
    await testGetRegistrations()

    console.log('\n' + '='.repeat(50))
    console.log('✨ Test suite completed!')
    console.log('\n📖 For more information, see: BUSINESS_REGISTRATIONS_SETUP.md')
}

// Run the tests
runTests().catch(console.error) 
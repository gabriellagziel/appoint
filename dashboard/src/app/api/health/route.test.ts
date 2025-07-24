import { GET } from './route'

// Mock NextResponse
jest.mock('next/server', () => ({
  NextResponse: {
    json: jest.fn((data, options) => ({
      json: jest.fn().mockResolvedValue(data),
      status: options?.status || 200,
    })),
  },
}))

describe('/api/health', () => {
  it('should return healthy status', async () => {
    const response = await GET()
    
    expect(response).toBeDefined()
    expect(response.status).toBe(200)
  })

  it('should include required health data fields', async () => {
    const { NextResponse } = require('next/server')
    
    await GET()
    
    const callArgs = NextResponse.json.mock.calls[0][0]
    
    expect(callArgs).toHaveProperty('status', 'healthy')
    expect(callArgs).toHaveProperty('timestamp')
    expect(callArgs).toHaveProperty('service', 'dashboard')
    expect(callArgs).toHaveProperty('uptime')
    expect(callArgs).toHaveProperty('environment')
  })
})
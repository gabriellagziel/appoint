import { NextResponse } from 'next/server';

export async function GET() {
  try {
    // Basic health check - can be extended with database connectivity, etc.
    const healthData = {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      service: 'dashboard',
      uptime: process.uptime(),
      environment: process.env.NODE_ENV,
    };

    return NextResponse.json(healthData, { status: 200 });
  } catch (error) {
    console.error('Health check failed:', error);
    
    return NextResponse.json(
      {
        status: 'unhealthy',
        timestamp: new Date().toISOString(),
        service: 'dashboard',
        error: error instanceof Error ? error.message : 'Unknown error',
      },
      { status: 500 }
    );
  }
}
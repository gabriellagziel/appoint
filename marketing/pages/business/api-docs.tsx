import { Navbar } from '../../src/components/Navbar'
import { Button } from '../../src/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../../src/components/ui/card'
import { Badge } from '../../src/components/ui/badge'
import { Code, Download, ExternalLink, Book, Zap, Shield, Users } from 'lucide-react'
import { useState } from 'react'

export default function BusinessApiDocs() {
  const [activeTab, setActiveTab] = useState('overview')

  const tabs = [
    { id: 'overview', label: 'Overview', icon: Book },
    { id: 'quickstart', label: 'Quick Start', icon: Zap },
    { id: 'authentication', label: 'Authentication', icon: Shield },
    { id: 'endpoints', label: 'API Reference', icon: Code },
    { id: 'sdks', label: 'SDKs & Examples', icon: Download },
    { id: 'onboarding', label: 'Onboarding Guide', icon: Users },
  ]

  const TabContent = () => {
    switch (activeTab) {
      case 'overview':
        return (
          <div className="space-y-6">
            <div>
              <h2 className="text-3xl font-bold mb-4">App-Oint Enterprise API</h2>
              <p className="text-lg text-gray-600 mb-6">
                Complete REST API for enterprise appointment scheduling integration. Built for scale, security, and reliability.
              </p>
              
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center">
                      <Shield className="w-5 h-5 mr-2 text-blue-600" />
                      Enterprise Security
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <p className="text-sm text-gray-600">
                      Bank-level security with OAuth 2.0, rate limiting, and data encryption.
                    </p>
                  </CardContent>
                </Card>
                
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center">
                      <Zap className="w-5 h-5 mr-2 text-green-600" />
                      High Performance
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <p className="text-sm text-gray-600">
                      99.9% uptime SLA with global CDN and optimized response times.
                    </p>
                  </CardContent>
                </Card>
                
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center">
                      <Code className="w-5 h-5 mr-2 text-purple-600" />
                      RESTful API
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <p className="text-sm text-gray-600">
                      Complete REST API with comprehensive documentation and SDKs.
                    </p>
                  </CardContent>
                </Card>
              </div>

              <div className="bg-blue-50 p-6 rounded-lg">
                <h3 className="text-xl font-semibold mb-3">Current API Status</h3>
                <div className="flex flex-wrap gap-2 mb-4">
                  <Badge variant="default" className="bg-green-100 text-green-800">✅ Production Ready</Badge>
                  <Badge variant="default" className="bg-blue-100 text-blue-800">📚 Full Documentation</Badge>
                  <Badge variant="default" className="bg-purple-100 text-purple-800">🔧 SDKs Available</Badge>
                  <Badge variant="default" className="bg-yellow-100 text-yellow-800">⚡ Rate Limited</Badge>
                </div>
                <div className="flex space-x-4">
                  <Button asChild>
                    <a href="#" onClick={() => setActiveTab('quickstart')}>
                      Get Started
                    </a>
                  </Button>
                  <Button variant="outline" asChild>
                    <a href="/business/api-docs/openapi.json" target="_blank" rel="noopener noreferrer">
                      <ExternalLink className="w-4 h-4 mr-2" />
                      OpenAPI Spec
                    </a>
                  </Button>
                </div>
              </div>
            </div>
          </div>
        )

      case 'quickstart':
        return (
          <div className="space-y-6">
            <h2 className="text-3xl font-bold mb-4">Quick Start Guide</h2>
            
            <div className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle>1. Register Your Business</CardTitle>
                  <CardDescription>Get your API key and initial quota</CardDescription>
                </CardHeader>
                <CardContent>
                  <pre className="bg-gray-100 p-4 rounded-lg overflow-x-auto">
                    <code>{`curl -X POST https://us-central1-app-oint-core.cloudfunctions.net/registerBusiness \\
  -H "Content-Type: application/json" \\
  -d '{
    "name": "Acme Healthcare",
    "email": "admin@acme-health.com",
    "industry": "Healthcare"
  }'`}</code>
                  </pre>
                  <p className="text-sm text-gray-600 mt-2">
                    Response includes your API key and 1,000 monthly quota.
                  </p>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>2. Create Your First Appointment</CardTitle>
                  <CardDescription>Use your API key to create an appointment</CardDescription>
                </CardHeader>
                <CardContent>
                  <pre className="bg-gray-100 p-4 rounded-lg overflow-x-auto">
                    <code>{`curl -X POST https://us-central1-app-oint-core.cloudfunctions.net/businessApi/appointments/create \\
  -H "Content-Type: application/json" \\
  -H "X-API-Key: YOUR_API_KEY_HERE" \\
  -d '{
    "customerName": "John Doe",
    "customerEmail": "john@example.com",
    "start": "2024-01-15T10:00:00Z",
    "duration": 60,
    "description": "Annual checkup",
    "location": "Room 101"
  }'`}</code>
                  </pre>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>3. List Appointments</CardTitle>
                  <CardDescription>Retrieve your appointments with optional filtering</CardDescription>
                </CardHeader>
                <CardContent>
                  <pre className="bg-gray-100 p-4 rounded-lg overflow-x-auto">
                    <code>{`curl -X GET "https://us-central1-app-oint-core.cloudfunctions.net/businessApi/appointments?status=confirmed&limit=10" \\
  -H "X-API-Key: YOUR_API_KEY_HERE"`}</code>
                  </pre>
                </CardContent>
              </Card>
            </div>
          </div>
        )

      case 'authentication':
        return (
          <div className="space-y-6">
            <h2 className="text-3xl font-bold mb-4">Authentication</h2>
            
            <div className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle>API Key Authentication</CardTitle>
                  <CardDescription>Primary authentication method for Enterprise API</CardDescription>
                </CardHeader>
                <CardContent>
                  <p className="mb-4">Include your API key in the <code className="bg-gray-100 px-2 py-1 rounded">X-API-Key</code> header:</p>
                  <pre className="bg-gray-100 p-4 rounded-lg">
                    <code>X-API-Key: YOUR_API_KEY_HERE</code>
                  </pre>
                  <div className="mt-4 p-4 bg-yellow-50 rounded-lg">
                    <p className="text-sm text-yellow-800">
                      <strong>Security Note:</strong> Keep your API key secure. Never expose it in client-side code or public repositories.
                    </p>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>OAuth 2.0 (Advanced)</CardTitle>
                  <CardDescription>For applications requiring granular permissions</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div>
                      <h4 className="font-semibold mb-2">Available Scopes:</h4>
                      <ul className="space-y-2">
                        <li className="flex items-center">
                          <Badge variant="outline" className="mr-2">appointments:read</Badge>
                          <span className="text-sm">Read appointment data</span>
                        </li>
                        <li className="flex items-center">
                          <Badge variant="outline" className="mr-2">appointments:write</Badge>
                          <span className="text-sm">Create and modify appointments</span>
                        </li>
                        <li className="flex items-center">
                          <Badge variant="outline" className="mr-2">billing:read</Badge>
                          <span className="text-sm">Read billing and usage information</span>
                        </li>
                        <li className="flex items-center">
                          <Badge variant="outline" className="mr-2">billing:write</Badge>
                          <span className="text-sm">Manage billing and invoices</span>
                        </li>
                      </ul>
                    </div>
                    
                    <div>
                      <h4 className="font-semibold mb-2">Authorization Flow:</h4>
                      <pre className="bg-gray-100 p-4 rounded-lg text-sm">
                        <code>{`1. GET /oauth/authorize?client_id=...&redirect_uri=...&scope=appointments:read,appointments:write
2. POST /oauth/token with authorization code
3. Use access_token in Authorization: Bearer header`}</code>
                      </pre>
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Rate Limits & Quotas</CardTitle>
                  <CardDescription>Understanding API usage limits</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <h4 className="font-semibold mb-2">Rate Limits:</h4>
                      <ul className="text-sm space-y-1">
                        <li>• 60 requests per minute</li>
                        <li>• Burst protection enabled</li>
                        <li>• Headers indicate remaining quota</li>
                      </ul>
                    </div>
                    <div>
                      <h4 className="font-semibold mb-2">Monthly Quotas:</h4>
                      <ul className="text-sm space-y-1">
                        <li>• Free tier: 1,000 calls/month</li>
                        <li>• Overage: $0.01 per additional call</li>
                        <li>• Auto-billing when exceeded</li>
                      </ul>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        )

      case 'endpoints':
        return (
          <div className="space-y-6">
            <div className="flex justify-between items-center">
              <h2 className="text-3xl font-bold">API Reference</h2>
              <Button asChild variant="outline">
                <a href="/business/api-docs/openapi.json" target="_blank" rel="noopener noreferrer">
                  <ExternalLink className="w-4 h-4 mr-2" />
                  OpenAPI Spec
                </a>
              </Button>
            </div>

            {/* Interactive Swagger UI would go here */}
            <Card>
              <CardHeader>
                <CardTitle>Interactive API Explorer</CardTitle>
                <CardDescription>Test API endpoints directly from your browser</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="h-96 bg-gray-100 rounded-lg flex items-center justify-center">
                  <div className="text-center">
                    <Code className="w-16 h-16 mx-auto text-gray-400 mb-4" />
                    <p className="text-gray-600 mb-4">Interactive Swagger UI</p>
                    <Button asChild>
                      <a href="https://petstore.swagger.io/?url=/business/api-docs/openapi.json" target="_blank" rel="noopener noreferrer">
                        <ExternalLink className="w-4 h-4 mr-2" />
                        Open in Swagger UI
                      </a>
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>

            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <Card>
                <CardHeader>
                  <CardTitle>Appointments</CardTitle>
                  <CardDescription>Create, cancel, and manage appointments</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    <div className="flex items-center justify-between p-2 bg-green-50 rounded">
                      <span className="font-mono text-sm">POST /appointments/create</span>
                      <Badge className="bg-green-100 text-green-800">Create</Badge>
                    </div>
                    <div className="flex items-center justify-between p-2 bg-red-50 rounded">
                      <span className="font-mono text-sm">POST /appointments/cancel</span>
                      <Badge className="bg-red-100 text-red-800">Cancel</Badge>
                    </div>
                    <div className="flex items-center justify-between p-2 bg-blue-50 rounded">
                      <span className="font-mono text-sm">GET /appointments</span>
                      <Badge className="bg-blue-100 text-blue-800">List</Badge>
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Calendar Integration</CardTitle>
                  <CardDescription>ICS feeds and calendar management</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    <div className="flex items-center justify-between p-2 bg-blue-50 rounded">
                      <span className="font-mono text-sm">GET /icsFeed</span>
                      <Badge className="bg-blue-100 text-blue-800">Calendar</Badge>
                    </div>
                    <div className="flex items-center justify-between p-2 bg-purple-50 rounded">
                      <span className="font-mono text-sm">POST /rotateIcsToken</span>
                      <Badge className="bg-purple-100 text-purple-800">Token</Badge>
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Analytics</CardTitle>
                  <CardDescription>Usage statistics and reporting</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    <div className="flex items-center justify-between p-2 bg-blue-50 rounded">
                      <span className="font-mono text-sm">GET /getUsageStats</span>
                      <Badge className="bg-blue-100 text-blue-800">Stats</Badge>
                    </div>
                    <div className="flex items-center justify-between p-2 bg-green-50 rounded">
                      <span className="font-mono text-sm">GET /downloadUsageCSV</span>
                      <Badge className="bg-green-100 text-green-800">Export</Badge>
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Authentication</CardTitle>
                  <CardDescription>OAuth and business registration</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    <div className="flex items-center justify-between p-2 bg-green-50 rounded">
                      <span className="font-mono text-sm">POST /registerBusiness</span>
                      <Badge className="bg-green-100 text-green-800">Register</Badge>
                    </div>
                    <div className="flex items-center justify-between p-2 bg-yellow-50 rounded">
                      <span className="font-mono text-sm">GET /oauth/authorize</span>
                      <Badge className="bg-yellow-100 text-yellow-800">OAuth</Badge>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        )

      case 'sdks':
        return (
          <div className="space-y-6">
            <h2 className="text-3xl font-bold mb-4">SDKs & Client Libraries</h2>
            
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center">
                    <img src="/icons/nodejs.svg" alt="Node.js" className="w-6 h-6 mr-2" />
                    Node.js SDK
                  </CardTitle>
                  <CardDescription>Official Node.js client library</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div>
                      <h4 className="font-semibold mb-2">Installation:</h4>
                      <pre className="bg-gray-100 p-3 rounded text-sm">
                        <code>npm install @app-oint/enterprise-api</code>
                      </pre>
                    </div>
                    <div>
                      <h4 className="font-semibold mb-2">Usage:</h4>
                      <pre className="bg-gray-100 p-3 rounded text-sm">
                        <code>{`import { AppOintAPI } from '@app-oint/enterprise-api';

const api = new AppOintAPI({
  apiKey: 'YOUR_API_KEY'
});

const appointment = await api.appointments.create({
  customerName: 'John Doe',
  start: '2024-01-15T10:00:00Z',
  duration: 60
});`}</code>
                      </pre>
                    </div>
                    <Button asChild className="w-full">
                      <a href="/sdks/nodejs-sdk.zip" download>
                        <Download className="w-4 h-4 mr-2" />
                        Download Node.js SDK
                      </a>
                    </Button>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center">
                    <img src="/icons/python.svg" alt="Python" className="w-6 h-6 mr-2" />
                    Python SDK
                  </CardTitle>
                  <CardDescription>Official Python client library</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div>
                      <h4 className="font-semibold mb-2">Installation:</h4>
                      <pre className="bg-gray-100 p-3 rounded text-sm">
                        <code>pip install app-oint-enterprise</code>
                      </pre>
                    </div>
                    <div>
                      <h4 className="font-semibold mb-2">Usage:</h4>
                      <pre className="bg-gray-100 p-3 rounded text-sm">
                        <code>{`from app_oint import AppOintAPI

api = AppOintAPI(api_key='YOUR_API_KEY')

appointment = api.appointments.create(
    customer_name='John Doe',
    start='2024-01-15T10:00:00Z',
    duration=60
)`}</code>
                      </pre>
                    </div>
                    <Button asChild className="w-full">
                      <a href="/sdks/python-sdk.zip" download>
                        <Download className="w-4 h-4 mr-2" />
                        Download Python SDK
                      </a>
                    </Button>
                  </div>
                </CardContent>
              </Card>
            </div>

            <Card>
              <CardHeader>
                <CardTitle>Example Applications</CardTitle>
                <CardDescription>Complete example implementations</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <Button variant="outline" asChild>
                    <a href="/examples/healthcare-portal.zip" download>
                      Healthcare Portal Example
                    </a>
                  </Button>
                  <Button variant="outline" asChild>
                    <a href="/examples/booking-widget.zip" download>
                      Booking Widget Example
                    </a>
                  </Button>
                  <Button variant="outline" asChild>
                    <a href="/examples/calendar-sync.zip" download>
                      Calendar Sync Example
                    </a>
                  </Button>
                </div>
              </CardContent>
            </Card>
          </div>
        )

      case 'onboarding':
        return (
          <div className="space-y-6">
            <h2 className="text-3xl font-bold mb-4">Enterprise Onboarding Guide</h2>
            
            <div className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle>Step 1: Choose Your Plan</CardTitle>
                  <CardDescription>Select the right tier for your organization</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div className="p-4 border rounded-lg">
                      <h3 className="font-semibold text-green-600 mb-2">Developer (Free)</h3>
                      <ul className="text-sm space-y-1">
                        <li>• 1,000 API calls/month</li>
                        <li>• Basic documentation</li>
                        <li>• Community support</li>
                      </ul>
                    </div>
                    <div className="p-4 border rounded-lg bg-blue-50">
                      <h3 className="font-semibold text-blue-600 mb-2">Business API (Custom)</h3>
                      <ul className="text-sm space-y-1">
                        <li>• Custom rate limits</li>
                        <li>• Priority support</li>
                        <li>• SLA guarantee</li>
                      </ul>
                    </div>
                    <div className="p-4 border rounded-lg">
                      <h3 className="font-semibold text-purple-600 mb-2">Enterprise (Contact)</h3>
                      <ul className="text-sm space-y-1">
                        <li>• Unlimited API calls</li>
                        <li>• Dedicated support</li>
                        <li>• Custom features</li>
                      </ul>
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Step 2: Register & Get API Key</CardTitle>
                  <CardDescription>Self-service registration for immediate access</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="flex items-start space-x-3">
                      <div className="w-6 h-6 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center text-sm font-semibold">1</div>
                      <div>
                        <h4 className="font-semibold">Call Registration Endpoint</h4>
                        <p className="text-sm text-gray-600">Use the /registerBusiness endpoint with your organization details</p>
                      </div>
                    </div>
                    <div className="flex items-start space-x-3">
                      <div className="w-6 h-6 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center text-sm font-semibold">2</div>
                      <div>
                        <h4 className="font-semibold">Receive API Key</h4>
                        <p className="text-sm text-gray-600">Get your unique API key and initial 1,000-call quota</p>
                      </div>
                    </div>
                    <div className="flex items-start space-x-3">
                      <div className="w-6 h-6 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center text-sm font-semibold">3</div>
                      <div>
                        <h4 className="font-semibold">Test Authentication</h4>
                        <p className="text-sm text-gray-600">Verify your API key works with a simple test call</p>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Step 3: Integration Testing</CardTitle>
                  <CardDescription>Test your integration before going live</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="p-4 bg-yellow-50 rounded-lg">
                      <h4 className="font-semibold mb-2">Test Environment</h4>
                      <p className="text-sm mb-2">Use your Developer tier quota for testing:</p>
                      <ul className="text-sm space-y-1">
                        <li>• Create test appointments with future dates</li>
                        <li>• Verify webhook deliveries (if using)</li>
                        <li>• Test error handling and rate limits</li>
                        <li>• Validate OAuth flows (if applicable)</li>
                      </ul>
                    </div>
                    
                    <div>
                      <h4 className="font-semibold mb-2">Test Credentials</h4>
                      <div className="bg-gray-100 p-3 rounded">
                        <p className="text-sm font-mono">Test Customer: test@appoint-api.com</p>
                        <p className="text-sm font-mono">Test Phone: +1-555-TEST-API</p>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Step 4: Production Deployment</CardTitle>
                  <CardDescription>Go live with confidence</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div>
                        <h4 className="font-semibold mb-2">Pre-Launch Checklist:</h4>
                        <ul className="text-sm space-y-1">
                          <li>☐ API key secured in environment variables</li>
                          <li>☐ Error handling implemented</li>
                          <li>☐ Rate limit handling added</li>
                          <li>☐ Monitoring/logging configured</li>
                          <li>☐ Backup error flows tested</li>
                        </ul>
                      </div>
                      <div>
                        <h4 className="font-semibold mb-2">Launch Support:</h4>
                        <ul className="text-sm space-y-1">
                          <li>📧 enterprise@app-oint.com</li>
                          <li>📞 Priority phone support</li>
                          <li>💬 Dedicated Slack channel</li>
                          <li>📊 Real-time monitoring</li>
                          <li>🚨 24/7 emergency support</li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Need Help?</CardTitle>
                  <CardDescription>Get support from our enterprise team</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="flex space-x-4">
                    <Button asChild>
                      <a href="mailto:enterprise@app-oint.com">
                        Contact Enterprise Sales
                      </a>
                    </Button>
                    <Button variant="outline" asChild>
                      <a href="/support" target="_blank">
                        Support Portal
                      </a>
                    </Button>
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        )

      default:
        return null
    }
  }

  return (
    <main className="min-h-screen bg-gray-50">
      <Navbar />
      
      <div className="max-w-7xl mx-auto px-4 py-8">
        {/* Tab Navigation */}
        <div className="flex flex-wrap gap-2 mb-8 p-1 bg-white rounded-lg shadow-sm">
          {tabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex items-center px-4 py-2 rounded-md text-sm font-medium transition-colors ${
                activeTab === tab.id
                  ? 'bg-blue-100 text-blue-700'
                  : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
              }`}
            >
              <tab.icon className="w-4 h-4 mr-2" />
              {tab.label}
            </button>
          ))}
        </div>

        {/* Tab Content */}
        <div className="bg-white rounded-lg shadow-sm p-6">
          <TabContent />
        </div>
      </div>
    </main>
  )
}
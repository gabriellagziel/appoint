import { Card } from '@/components/Card';
import { Button } from '@/components/Button';

export default function DocsPage() {
  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">API Documentation</h1>
          <p className="text-lg text-gray-600">
            Complete guide to integrating with the App-Oint Enterprise API
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Quick Start */}
          <Card className="lg:col-span-2">
            <h2 className="text-2xl font-semibold mb-4">Quick Start</h2>
            <div className="space-y-4">
              <div>
                <h3 className="text-lg font-medium mb-2">Authentication</h3>
                <p className="text-gray-600 mb-3">
                  All API requests require an API key in the Authorization header:
                </p>
                <pre className="bg-gray-100 p-3 rounded text-sm overflow-x-auto">
{`Authorization: Bearer YOUR_API_KEY`}
                </pre>
              </div>

              <div>
                <h3 className="text-lg font-medium mb-2">Base URL</h3>
                <pre className="bg-gray-100 p-3 rounded text-sm">
{`https://api.app-oint.com/v1`}
                </pre>
              </div>

              <div>
                <h3 className="text-lg font-medium mb-2">Rate Limits</h3>
                <ul className="text-gray-600 space-y-1">
                  <li>• 1000 requests per hour per API key</li>
                  <li>• 100 requests per minute per endpoint</li>
                  <li>• Rate limit headers included in responses</li>
                </ul>
              </div>
            </div>
          </Card>

          {/* API Key Management */}
          <Card>
            <h2 className="text-xl font-semibold mb-4">API Key Management</h2>
            <div className="space-y-4">
              <p className="text-gray-600">
                Generate and manage your API keys from the dashboard.
              </p>
              <Button href="/dashboard/api-keys" className="w-full">
                Manage API Keys
              </Button>
            </div>
          </Card>
        </div>

        {/* Endpoints */}
        <div className="mt-8">
          <Card>
            <h2 className="text-2xl font-semibold mb-6">API Endpoints</h2>
            
            <div className="space-y-6">
              {/* Create Appointment */}
              <div className="border-b border-gray-200 pb-6">
                <h3 className="text-xl font-semibold mb-3">Create Appointment</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <p className="text-sm font-medium text-gray-500 mb-1">Endpoint</p>
                    <pre className="bg-gray-100 p-2 rounded text-sm">POST /appointments</pre>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500 mb-1">Method</p>
                    <span className="inline-block bg-green-100 text-green-800 px-2 py-1 rounded text-sm">POST</span>
                  </div>
                </div>
                <div className="mt-3">
                  <p className="text-sm font-medium text-gray-500 mb-1">Request Body</p>
                  <pre className="bg-gray-100 p-3 rounded text-sm overflow-x-auto">
{`{
  "serviceId": "service_123",
  "startTime": "2024-01-15T10:00:00Z",
  "customerEmail": "customer@example.com",
  "customerName": "John Doe",
  "notes": "Optional appointment notes"
}`}
                  </pre>
                </div>
              </div>

              {/* Get Appointments */}
              <div className="border-b border-gray-200 pb-6">
                <h3 className="text-xl font-semibold mb-3">Get Appointments</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <p className="text-sm font-medium text-gray-500 mb-1">Endpoint</p>
                    <pre className="bg-gray-100 p-2 rounded text-sm">GET /appointments</pre>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500 mb-1">Method</p>
                    <span className="inline-block bg-blue-100 text-blue-800 px-2 py-1 rounded text-sm">GET</span>
                  </div>
                </div>
                <div className="mt-3">
                  <p className="text-sm font-medium text-gray-500 mb-1">Query Parameters</p>
                  <ul className="text-sm text-gray-600 space-y-1">
                    <li>• <code>start_date</code> - Filter from date (ISO format)</li>
                    <li>• <code>end_date</code> - Filter to date (ISO format)</li>
                    <li>• <code>status</code> - Filter by status (confirmed, cancelled, pending)</li>
                    <li>• <code>limit</code> - Number of results (default: 50, max: 100)</li>
                  </ul>
                </div>
              </div>

              {/* Get Services */}
              <div className="border-b border-gray-200 pb-6">
                <h3 className="text-xl font-semibold mb-3">Get Services</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <p className="text-sm font-medium text-gray-500 mb-1">Endpoint</p>
                    <pre className="bg-gray-100 p-2 rounded text-sm">GET /services</pre>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500 mb-1">Method</p>
                    <span className="inline-block bg-blue-100 text-blue-800 px-2 py-1 rounded text-sm">GET</span>
                  </div>
                </div>
                <div className="mt-3">
                  <p className="text-sm font-medium text-gray-500 mb-1">Response</p>
                  <pre className="bg-gray-100 p-3 rounded text-sm overflow-x-auto">
{`{
  "services": [
    {
      "id": "service_123",
      "name": "Consultation",
      "duration": 60,
      "price": 100.00,
      "description": "Initial consultation session"
    }
  ]
}`}
                  </pre>
                </div>
              </div>

              {/* Get Availability */}
              <div>
                <h3 className="text-xl font-semibold mb-3">Get Availability</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <p className="text-sm font-medium text-gray-500 mb-1">Endpoint</p>
                    <pre className="bg-gray-100 p-2 rounded text-sm">GET /availability</pre>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500 mb-1">Method</p>
                    <span className="inline-block bg-blue-100 text-blue-800 px-2 py-1 rounded text-sm">GET</span>
                  </div>
                </div>
                <div className="mt-3">
                  <p className="text-sm font-medium text-gray-500 mb-1">Query Parameters</p>
                  <ul className="text-sm text-gray-600 space-y-1">
                    <li>• <code>service_id</code> - Service ID to check availability for</li>
                    <li>• <code>date</code> - Date to check (YYYY-MM-DD format)</li>
                    <li>• <code>start_time</code> - Start time for range (optional)</li>
                    <li>• <code>end_time</code> - End time for range (optional)</li>
                  </ul>
                </div>
              </div>
            </div>
          </Card>
        </div>

        {/* SDKs and Libraries */}
        <div className="mt-8">
          <Card>
            <h2 className="text-2xl font-semibold mb-6">SDKs & Libraries</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              <div className="border border-gray-200 rounded-lg p-4">
                <h3 className="font-semibold mb-2">JavaScript/Node.js</h3>
                <p className="text-sm text-gray-600 mb-3">
                  Official SDK for Node.js and browser environments
                </p>
                <pre className="bg-gray-100 p-2 rounded text-xs">npm install @app-oint/api</pre>
              </div>
              
              <div className="border border-gray-200 rounded-lg p-4">
                <h3 className="font-semibold mb-2">Python</h3>
                <p className="text-sm text-gray-600 mb-3">
                  Python SDK for easy integration
                </p>
                <pre className="bg-gray-100 p-2 rounded text-xs">pip install app-oint-api</pre>
              </div>
              
              <div className="border border-gray-200 rounded-lg p-4">
                <h3 className="font-semibold mb-2">PHP</h3>
                <p className="text-sm text-gray-600 mb-3">
                  PHP SDK for server-side integration
                </p>
                <pre className="bg-gray-100 p-2 rounded text-xs">composer require app-oint/api</pre>
              </div>
            </div>
          </Card>
        </div>

        {/* Support */}
        <div className="mt-8">
          <Card>
            <h2 className="text-2xl font-semibold mb-4">Need Help?</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <h3 className="text-lg font-medium mb-2">Documentation</h3>
                <p className="text-gray-600 mb-3">
                  Complete API reference with examples and best practices.
                </p>
                <Button href="https://docs.app-oint.com" variant="outline">
                  View Full Docs
                </Button>
              </div>
              
              <div>
                <h3 className="text-lg font-medium mb-2">Support</h3>
                <p className="text-gray-600 mb-3">
                  Get help from our technical support team.
                </p>
                <Button href="mailto:support@app-oint.com" variant="outline">
                  Contact Support
                </Button>
              </div>
            </div>
          </Card>
        </div>
      </div>
    </div>
  );
}

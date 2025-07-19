import { Navbar } from '@/components/Navbar'

export default function BusinessApiDocs() {
  return (
    <main className="min-h-screen">
      <Navbar />
      <article className="prose lg:prose-lg max-w-3xl mx-auto p-8">
        <h1>App-Oint Business API Documentation</h1>
        <p>
          Welcome to the App-Oint Business API! Use this REST API to integrate appointment creation and cancellation into your own products.
        </p>

        <h2>Authentication</h2>
        <p>
          Include your unique <code>API Key</code> in the <code>X-API-Key</code> request header when calling any endpoint.
        </p>
        <pre>
X-API-Key: YOUR_API_KEY_HERE
        </pre>
        <h3>Rate Limits & Quota</h3>
        <p>
          Each business has a monthly quota (default 1,000 calls). When the quota is reached, further requests will return <code>429 Too Many Requests</code>.
        </p>

        <h2>Endpoints</h2>
        <h3>POST /api/business/appointments/create</h3>
        <p>Create a new appointment.</p>
        <pre>{`POST https://<region>-<project>.cloudfunctions.net/businessApi/appointments/create
Headers:
  X-API-Key: YOUR_API_KEY
Body (JSON):
{
  "customerName": "Jane Doe",
  "start": "2024-01-10T10:00:00Z",
  "duration": 60
}
`}</pre>
        <h3>POST /api/business/appointments/cancel</h3>
        <p>Cancel an existing appointment.</p>
        <pre>{`POST https://<region>-<project>.cloudfunctions.net/businessApi/appointments/cancel
Headers:
  X-API-Key: YOUR_API_KEY
Body (JSON):
{
  "appointmentId": "abc123"
}`}</pre>

        <h2>Error Codes</h2>
        <ul>
          <li><strong>401 Unauthorized</strong> – Missing or invalid API key</li>
          <li><strong>403 Forbidden</strong> – Suspended API key</li>
          <li><strong>429 Too Many Requests</strong> – Monthly quota exceeded</li>
          <li><strong>500 Internal Server Error</strong> – Unexpected server error</li>
        </ul>
      </article>
    </main>
  )
}
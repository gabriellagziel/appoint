import { Card } from '@/components/Card';
import { Button } from '@/components/Button';

export default function PendingPage() {
  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center px-4">
      <Card className="w-full max-w-md">
        <div className="text-center">
          <div className="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-yellow-100 mb-4">
            <svg className="h-8 w-8 text-yellow-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          
          <h1 className="text-2xl font-bold text-gray-900 mb-2">Application Under Review</h1>
          <p className="text-gray-600 mb-4">
            Thank you for your enterprise application! Our team is currently reviewing your submission.
          </p>
          
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
            <h3 className="font-medium text-blue-900 mb-2">What happens next?</h3>
            <ul className="text-sm text-blue-800 space-y-1 text-left">
              <li>• We'll review your application within 1-2 business days</li>
              <li>• You'll receive an email with our decision</li>
              <li>• If approved, you'll get access to your dashboard</li>
              <li>• We may contact you for additional information</li>
            </ul>
          </div>
          
          <div className="space-y-3">
            <Button href="/login" className="w-full">
              Check Status
            </Button>
            <Button href="/" variant="outline" className="w-full">
              Back to Home
            </Button>
          </div>
          
          <div className="mt-6 pt-6 border-t border-gray-200">
            <p className="text-sm text-gray-500">
              Questions? Contact{' '}
              <a href="mailto:enterprise@app-oint.com" className="text-blue-600 hover:text-blue-800">
                enterprise@app-oint.com
              </a>
            </p>
          </div>
        </div>
      </Card>
    </div>
  );
}

import { Card } from '@/components/Card';
import { Button } from '@/components/Button';

export default function UnauthorizedPage() {
  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center px-4">
      <Card className="w-full max-w-md">
        <div className="text-center">
          <div className="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-red-100 mb-4">
            <svg className="h-8 w-8 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" />
            </svg>
          </div>
          
          <h1 className="text-2xl font-bold text-gray-900 mb-2">Access Denied</h1>
          <p className="text-gray-600 mb-6">
            You don't have permission to access this resource. Please contact your administrator or log in with appropriate credentials.
          </p>
          
          <div className="space-y-3">
            <Button href="/login" className="w-full">
              Log In
            </Button>
            <Button href="/" variant="outline" className="w-full">
              Go to Home
            </Button>
          </div>
          
          <div className="mt-6 pt-6 border-t border-gray-200">
            <p className="text-sm text-gray-500">
              If you believe this is an error, please contact{' '}
              <a href="mailto:support@app-oint.com" className="text-blue-600 hover:text-blue-800">
                support@app-oint.com
              </a>
            </p>
          </div>
        </div>
      </Card>
    </div>
  );
}

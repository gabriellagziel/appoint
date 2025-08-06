import { ProtectedRoute } from '@/components/ProtectedRoute';
import { SubscriptionCheck } from '@/components/SubscriptionCheck';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <ProtectedRoute>
      <SubscriptionCheck>
        {children}
      </SubscriptionCheck>
    </ProtectedRoute>
  );
} 
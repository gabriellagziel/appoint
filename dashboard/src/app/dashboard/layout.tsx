import { ProtectedRoute } from '@/components/ProtectedRoute';
import { SubscriptionCheck } from '@/components/SubscriptionCheck';
import DashboardLayout from '@/components/DashboardLayout';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <ProtectedRoute>
      <SubscriptionCheck>
        <DashboardLayout>
          {children}
        </DashboardLayout>
      </SubscriptionCheck>
    </ProtectedRoute>
  );
} 
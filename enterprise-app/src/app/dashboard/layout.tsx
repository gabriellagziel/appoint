import React from 'react';
import Layout from '@/components/Layout';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <Layout showSidebar={true}>
      {children}
    </Layout>
  );
} 
import { AdminHeader } from '@/components/AdminHeader';
// import { ProtectedRoute } from '@/components/ProtectedRoute';

export default function AdminLayout({
    children,
}: {
    children: React.ReactNode;
}) {
    return (
        <div className="min-h-screen bg-gray-50">
            <header className="bg-white shadow-sm border-b border-gray-200">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div className="flex justify-between items-center h-16">
                        <div className="flex items-center">
                            <h1 className="text-xl font-semibold text-gray-900">
                                App-Oint Admin
                            </h1>
                        </div>
                    </div>
                </div>
            </header>
            <main className="py-6">
                {children}
            </main>
        </div>
    );
} 
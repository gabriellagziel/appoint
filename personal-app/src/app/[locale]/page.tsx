export default function LocaleHome({ params: { locale } }: { params: { locale: string } }) {
    return (
        <main className="min-h-dvh p-4">
            <h1 className="text-xl font-semibold">Hi Gabriel 👋</h1>
            <p className="text-sm opacity-70">Locale: {locale}</p>
            <p className="mt-2">What would you like to do today?</p>

            <div className="mt-6 space-y-3">
                <h2 className="text-lg font-medium">Quick Actions</h2>
                <div className="flex flex-wrap gap-3">
                    <a
                        href={`/${locale}/preview/calendar`}
                        className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
                    >
                        📅 Calendar View
                    </a>
                    <a
                        href={`/${locale}/preview/persistence`}
                        className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors"
                    >
                        💾 Persistence Demo
                    </a>
                </div>
            </div>
        </main>
    );
}


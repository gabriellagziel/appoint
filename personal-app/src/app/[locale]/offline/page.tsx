export default function OfflinePage() {
    return (
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8">
            <div className="text-center">
                <div className="text-6xl mb-4">📶</div>
                <h1 className="text-2xl font-semibold mb-4">You're Offline</h1>
                <p className="text-gray-600 mb-6">
                    Don't worry! You can still access previously loaded content.
                </p>
                <div className="space-y-3">
                    <button
                        onClick={() => window.location.reload()}
                        className="w-full rounded-xl border p-3 hover:shadow bg-blue-50"
                    >
                        🔄 Try Again
                    </button>
                    <button
                        onClick={() => window.history.back()}
                        className="w-full rounded-xl border p-3 hover:shadow"
                    >
                        ← Go Back
                    </button>
                </div>
            </div>
        </main>
    );
}


'use client'

export default function Hero() {
    return (
        <section className="relative overflow-hidden gradient-bg py-20 lg:py-32">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                {/* App-Oint Logo and Slogan */}
                <div className="text-center mb-12">
                    <div className="flex justify-center items-center mb-4">
                        <div className="flex items-center">
                            <img
                                src="/logo.svg"
                                alt="App-Oint Logo"
                                className="h-16 w-16"
                                onError={(e) => {
                                    console.warn('Logo failed to load – verify asset path. Re-test in production after DigitalOcean deployment.')
                                    e.currentTarget.style.display = 'none'
                                    e.currentTarget.nextElementSibling?.classList.remove('hidden')
                                }}
                            />
                            <div className="h-16 w-16 bg-blue-600 rounded-lg flex items-center justify-center text-white text-2xl font-bold hidden">
                                A
                            </div>
                        </div>
                        <span className="ml-3 text-3xl font-bold text-gray-900">App-Oint</span>
                    </div>
                    <h2 className="text-2xl font-semibold text-gray-800 mb-2">
                        Time Organized
                    </h2>
                    <p className="text-lg text-gray-600 italic">
                        Set · Send · Done
                    </p>
                </div>

                <div className="grid lg:grid-cols-2 gap-12 items-center">
                    <div>
                        <h1 className="text-5xl lg:text-6xl font-bold text-gray-900 mb-6 leading-tight">
                            Managing your business has never been{' '}
                            <span className="text-blue-600">easier</span>
                        </h1>
                        <p className="text-xl text-gray-600 mb-8 leading-relaxed">
                            Appointments, clients, reports – all in one place. Focus on growth, let us handle the operations.
                        </p>
                        <div className="flex flex-col sm:flex-row gap-4">
                            <a href="/login" className="btn-primary text-lg px-8 py-4 text-center">
                                Start Now
                            </a>
                        </div>
                        <p className="text-sm text-gray-500 mt-4">
                            No credit card required • 30-day free trial
                        </p>
                    </div>
                    <div className="relative">
                        {/* Visual Mockup: Mobile + Desktop with Bidirectional Sync */}
                        <div className="relative flex items-center justify-center">
                            {/* Mobile Phone */}
                            <div className="relative z-10 transform -rotate-6 hover:rotate-0 transition-transform duration-300">
                                <div className="w-48 h-80 bg-gray-900 rounded-3xl p-2 shadow-2xl">
                                    <div className="w-full h-full bg-white rounded-2xl p-3">
                                        {/* App Screen */}
                                        <div className="w-full h-full bg-gradient-to-br from-blue-500 to-purple-600 rounded-xl p-4 text-white">
                                            <div className="flex justify-between items-center mb-4">
                                                <div className="text-sm font-semibold">App-Oint</div>
                                                <div className="text-xs">9:41</div>
                                            </div>
                                            <div className="space-y-3">
                                                <div className="bg-white/20 rounded-lg p-2">
                                                    <div className="text-xs font-medium">Book Appointment</div>
                                                    <div className="text-xs opacity-75">Tap to schedule</div>
                                                </div>
                                                <div className="bg-white/20 rounded-lg p-2">
                                                    <div className="text-xs font-medium">View Calendar</div>
                                                    <div className="text-xs opacity-75">Your schedule</div>
                                                </div>
                                                <div className="bg-white/20 rounded-lg p-2">
                                                    <div className="text-xs font-medium">Notifications</div>
                                                    <div className="text-xs opacity-75">3 new messages</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            {/* Bidirectional Arrow */}
                            <div className="absolute z-20 mx-8">
                                <div className="flex items-center space-x-2">
                                    <div className="w-8 h-0.5 bg-blue-500"></div>
                                    <div className="w-4 h-4 bg-blue-500 rounded-full flex items-center justify-center">
                                        <svg className="w-3 h-3 text-white" fill="currentColor" viewBox="0 0 20 20">
                                            <path fillRule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clipRule="evenodd" />
                                        </svg>
                                    </div>
                                    <div className="w-8 h-0.5 bg-blue-500"></div>
                                </div>
                                <div className="text-center mt-2">
                                    <div className="text-xs font-medium text-blue-600">Real-time Sync</div>
                                </div>
                            </div>

                            {/* Desktop/Laptop */}
                            <div className="relative z-10 transform rotate-6 hover:rotate-0 transition-transform duration-300">
                                <div className="w-64 h-48 bg-gray-800 rounded-lg shadow-2xl">
                                    <div className="w-full h-full bg-white rounded-lg p-4">
                                        {/* Business Calendar Screen */}
                                        <div className="w-full h-full">
                                            <div className="flex justify-between items-center mb-3">
                                                <div className="text-sm font-semibold text-gray-800">Business Studio</div>
                                                <div className="text-xs text-gray-500">CRM Dashboard</div>
                                            </div>
                                            <div className="grid grid-cols-7 gap-1 text-xs">
                                                {['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day, i) => (
                                                    <div key={i} className="text-center text-gray-500 font-medium">{day}</div>
                                                ))}
                                                {Array.from({ length: 35 }, (_, i) => (
                                                    <div key={i} className={`h-6 flex items-center justify-center rounded ${i === 15 ? 'bg-blue-100 text-blue-600 font-medium' : 'text-gray-400'
                                                        }`}>
                                                        {i < 4 ? '' : i - 3}
                                                    </div>
                                                ))}
                                            </div>
                                            <div className="mt-2 space-y-1">
                                                <div className="bg-green-100 text-green-700 text-xs p-1 rounded">
                                                    📅 3 appointments today
                                                </div>
                                                <div className="bg-blue-100 text-blue-700 text-xs p-1 rounded">
                                                    💬 5 new messages
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* Connection Lines */}
                        <div className="absolute inset-0 pointer-events-none">
                            <svg className="w-full h-full" viewBox="0 0 400 300">
                                <defs>
                                    <linearGradient id="syncGradient" x1="0%" y1="0%" x2="100%" y2="0%">
                                        <stop offset="0%" style={{ stopColor: '#3B82F6', stopOpacity: 0.3 }} />
                                        <stop offset="50%" style={{ stopColor: '#3B82F6', stopOpacity: 0.8 }} />
                                        <stop offset="100%" style={{ stopColor: '#3B82F6', stopOpacity: 0.3 }} />
                                    </linearGradient>
                                </defs>
                                <path d="M 120 150 Q 200 140 280 150" stroke="url(#syncGradient)" strokeWidth="2" fill="none" strokeDasharray="5,5" />
                            </svg>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    )
} 
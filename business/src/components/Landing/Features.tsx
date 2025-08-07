export default function Features() {
    const features = [
        {
            icon: "📅",
            title: "Appointments",
            description: "Streamline your scheduling with intelligent booking systems, automated reminders, and calendar integration.",
            benefits: ["Smart scheduling", "Automated reminders", "Calendar sync"]
        },
        {
            icon: "🎨",
            title: "Branding",
            description: "Customize your business presence with branded booking pages, custom domains, and professional templates.",
            benefits: ["Custom branding", "Professional templates", "White-label options"]
        },
        {
            icon: "📊",
            title: "Analytics",
            description: "Track performance, understand customer behavior, and make data-driven decisions with comprehensive reporting.",
            benefits: ["Performance tracking", "Customer insights", "Data visualization"]
        },
        {
            icon: "📱",
            title: "App-Oint App Integration",
            description: "Reach your clients directly inside the App-Oint mobile app. Let them schedule with your business from their own calendar, and build a powerful two-way connection.",
            benefits: ["Customers book you directly from their app", "Businesses schedule follow-ups with clients", "Real-time availability sync", "A unique 2-way marketing and engagement system"]
        }
    ]

    return (
        <section id="features" className="py-20 bg-white">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="text-center mb-16">
                    <h2 className="text-4xl font-bold text-gray-900 mb-4">
                        Everything you need to grow your business
                    </h2>
                    <p className="text-xl text-gray-600 max-w-3xl mx-auto">
                        From scheduling to analytics, we've got all the tools you need to manage and scale your business effectively.
                    </p>
                </div>

                <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
                    {features.map((feature, index) => (
                        <div key={index} className="card">
                            <div className="text-4xl mb-4">{feature.icon}</div>
                            <h3 className="text-2xl font-bold text-gray-900 mb-4">
                                {feature.title}
                            </h3>
                            <p className="text-gray-600 mb-6 leading-relaxed">
                                {feature.description}
                            </p>
                            <ul className="space-y-2">
                                {feature.benefits.map((benefit, benefitIndex) => (
                                    <li key={benefitIndex} className="flex items-center text-gray-700">
                                        <span className="text-green-500 mr-2">✓</span>
                                        {benefit}
                                    </li>
                                ))}
                            </ul>
                        </div>
                    ))}
                </div>
            </div>
        </section>
    )
} 
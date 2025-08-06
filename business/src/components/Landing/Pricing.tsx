export default function Pricing() {
    const plans = [
        {
            name: "Starter",
            price: "$29",
            period: "/month",
            description: "Perfect for small businesses getting started",
            features: [
                "Up to 5 team members",
                "Basic appointment scheduling",
                "Standard analytics",
                "Email support",
                "Basic branding options"
            ],
            popular: false
        },
        {
            name: "Professional",
            price: "$79",
            period: "/month",
            description: "Ideal for growing businesses",
            features: [
                "Up to 20 team members",
                "Advanced scheduling features",
                "Comprehensive analytics",
                "Priority support",
                "Full branding customization",
                "API access"
            ],
            popular: true
        },
        {
            name: "Enterprise",
            price: "$199",
            period: "/month",
            description: "For large organizations",
            features: [
                "Unlimited team members",
                "Custom integrations",
                "Advanced reporting",
                "Dedicated support",
                "White-label solutions",
                "Custom domain setup"
            ],
            popular: false
        }
    ]

    return (
        <section id="pricing" className="py-20 gradient-bg">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="text-center mb-16">
                    <h2 className="text-4xl font-bold text-gray-900 mb-4">
                        Simple, transparent pricing
                    </h2>
                    <p className="text-xl text-gray-600 max-w-3xl mx-auto">
                        Choose the plan that fits your business needs. All plans include our core features.
                    </p>
                </div>

                <div className="grid md:grid-cols-3 gap-8">
                    {plans.map((plan, index) => (
                        <div key={index} className={`card relative ${plan.popular ? 'ring-2 ring-blue-500 scale-105' : ''}`}>
                            {plan.popular && (
                                <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                                    <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-semibold">
                                        Most Popular
                                    </span>
                                </div>
                            )}

                            <div className="text-center mb-8">
                                <h3 className="text-2xl font-bold text-gray-900 mb-2">
                                    {plan.name}
                                </h3>
                                <div className="flex items-baseline justify-center">
                                    <span className="text-4xl font-bold text-gray-900">{plan.price}</span>
                                    <span className="text-gray-600 ml-1">{plan.period}</span>
                                </div>
                                <p className="text-gray-600 mt-2">{plan.description}</p>
                            </div>

                            <ul className="space-y-4 mb-8">
                                {plan.features.map((feature, featureIndex) => (
                                    <li key={featureIndex} className="flex items-center">
                                        <span className="text-green-500 mr-3">✓</span>
                                        <span className="text-gray-700">{feature}</span>
                                    </li>
                                ))}
                            </ul>

                            <a
                                href="/signup"
                                className={`w-full text-center py-3 px-6 rounded-lg font-semibold transition-all duration-200 ${plan.popular
                                    ? 'bg-blue-600 hover:bg-blue-700 text-white'
                                    : 'bg-gray-100 hover:bg-gray-200 text-gray-900'
                                    }`}
                            >
                                Get Started
                            </a>
                        </div>
                    ))}
                </div>

                <div className="text-center mt-12">
                    <p className="text-gray-600 mb-4">
                        Need a custom plan? Contact our sales team
                    </p>
                    <a href="#contact" className="text-blue-600 font-semibold hover:text-blue-700 transition-colors">
                        Contact Sales →
                    </a>
                </div>
            </div>
        </section>
    )
} 
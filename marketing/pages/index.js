import Head from 'next/head'
import { useState } from 'react'

// Section Components
const SectionHero = () => (
  <section className="relative overflow-hidden bg-gradient-to-br from-blue-50 to-indigo-100 py-20 lg:py-32">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="grid lg:grid-cols-2 gap-12 items-center">
        <div>
          <h1 className="text-5xl lg:text-6xl font-bold text-gray-900 mb-6 leading-tight">
            Your time is too valuable to waste on{' '}
            <span className="text-blue-600">back-and-forths</span>
          </h1>
          <p className="text-xl text-gray-600 mb-8 leading-relaxed">
            App-Oint doesn't just schedule — it understands your rhythm.
            From open calls to multi-location businesses, we built this for the chaos.
          </p>
          <div className="flex flex-col sm:flex-row gap-4">
            <button className="btn-primary text-lg px-8 py-4">
              Get Started Free
            </button>
            <button className="btn-secondary text-lg px-8 py-4">
              View Demo
            </button>
          </div>
          <p className="text-sm text-gray-500 mt-4">
            No credit card required • 30-day free trial
          </p>
        </div>
        <div className="relative">
          <div className="bg-white rounded-2xl shadow-2xl p-8 transform rotate-3 hover:rotate-0 transition-transform duration-300">
            <div className="bg-gray-900 rounded-lg p-6 font-mono text-sm text-white">
              <div className="flex items-center mb-4">
                <div className="flex space-x-2">
                  <div className="w-3 h-3 bg-red-500 rounded-full"></div>
                  <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
                  <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                </div>
                <span className="ml-4 text-gray-400">app-oint.com</span>
              </div>
              <div className="space-y-2">
                <div><span className="text-blue-400">const</span> <span className="text-yellow-400">appointment</span> = {`{`}</div>
                <div className="pl-4"><span className="text-green-400">customer</span>: <span className="text-green-400">'john@example.com'</span>,</div>
                <div className="pl-4"><span className="text-green-400">time</span>: <span className="text-green-400">'2024-01-15T10:00:00Z'</span>,</div>
                <div className="pl-4"><span className="text-green-400">duration</span>: <span className="text-green-400">30</span></div>
                <div>{`}`};</div>
                <div className="mt-4 text-blue-400">// AI-enhanced scheduling</div>
                <div className="text-green-400">// Human-centered design</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
)

const SectionTrust = () => (
  <section className="bg-white py-8 border-b">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="flex flex-wrap justify-center items-center space-x-8 text-gray-500">
        <div className="flex items-center space-x-2">
          <div className="w-6 h-6 bg-green-500 rounded-full flex items-center justify-center">
            <span className="text-white text-xs font-bold">✓</span>
          </div>
          <span className="text-sm font-medium">SOC2 Compliant</span>
        </div>
        <div className="flex items-center space-x-2">
          <div className="w-6 h-6 bg-blue-500 rounded-full flex items-center justify-center">
            <span className="text-white text-xs font-bold">✓</span>
          </div>
          <span className="text-sm font-medium">GDPR Ready</span>
        </div>
        <div className="flex items-center space-x-2">
          <div className="w-6 h-6 bg-purple-500 rounded-full flex items-center justify-center">
            <span className="text-white text-xs font-bold">✓</span>
          </div>
          <span className="text-sm font-medium">ISO 27001</span>
        </div>
        <div className="flex items-center space-x-2">
          <div className="w-6 h-6 bg-orange-500 rounded-full flex items-center justify-center">
            <span className="text-white text-xs font-bold">✓</span>
          </div>
          <span className="text-sm font-medium">99.9% Uptime</span>
        </div>
      </div>
    </div>
  </section>
)

const SectionFeaturesPersonal = () => (
  <section className="py-20 bg-gray-50">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="text-center mb-16">
        <h2 className="text-4xl font-bold text-gray-900 mb-4">Perfect for Personal Scheduling</h2>
        <p className="text-xl text-gray-600">AI-enhanced. Human-centered. Scheduling done right.</p>
      </div>
      <div className="grid md:grid-cols-3 gap-8">
        <div className="bg-white rounded-xl shadow-md p-8 hover:shadow-lg transition-shadow">
          <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mb-4">
            <span className="text-2xl">🧠</span>
          </div>
          <h3 className="text-xl font-semibold text-gray-900 mb-4">Smart Scheduling</h3>
          <p className="text-gray-600">AI learns your preferences and suggests optimal times, reducing back-and-forth by 80%.</p>
        </div>
        <div className="bg-white rounded-xl shadow-md p-8 hover:shadow-lg transition-shadow">
          <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mb-4">
            <span className="text-2xl">⚡</span>
          </div>
          <h3 className="text-xl font-semibold text-gray-900 mb-4">Instant Booking</h3>
          <p className="text-gray-600">Share your link and let others book instantly. No more email chains or phone calls.</p>
        </div>
        <div className="bg-white rounded-xl shadow-md p-8 hover:shadow-lg transition-shadow">
          <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mb-4">
            <span className="text-2xl">📱</span>
          </div>
          <h3 className="text-xl font-semibold text-gray-900 mb-4">Everywhere Access</h3>
          <p className="text-gray-600">Web, mobile apps, and integrations. Your schedule follows you everywhere.</p>
        </div>
      </div>
    </div>
  </section>
)

const SectionFeaturesBusiness = () => (
  <section className="py-20 bg-white">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="text-center mb-16">
        <h2 className="text-4xl font-bold text-gray-900 mb-4">Transform Your Business Scheduling</h2>
        <p className="text-xl text-gray-600">From solo entrepreneurs to enterprise teams, we built this for the chaos.</p>
      </div>
      <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
        <div className="bg-gray-50 rounded-xl p-8 hover:bg-white hover:shadow-lg transition-all">
          <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mb-4">
            <span className="text-2xl">👥</span>
          </div>
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Team Collaboration</h3>
          <p className="text-gray-600">Coordinate schedules across your entire team with shared calendars and availability.</p>
        </div>
        <div className="bg-gray-50 rounded-xl p-8 hover:bg-white hover:shadow-lg transition-all">
          <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mb-4">
            <span className="text-2xl">🏢</span>
          </div>
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Multi-Location</h3>
          <p className="text-gray-600">Manage multiple locations from one dashboard with centralized control and reporting.</p>
        </div>
        <div className="bg-gray-50 rounded-xl p-8 hover:bg-white hover:shadow-lg transition-all">
          <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mb-4">
            <span className="text-2xl">📊</span>
          </div>
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Advanced Analytics</h3>
          <p className="text-gray-600">Track performance, analyze patterns, and optimize your scheduling efficiency.</p>
        </div>
        <div className="bg-gray-50 rounded-xl p-8 hover:bg-white hover:shadow-lg transition-all">
          <div className="w-12 h-12 bg-orange-100 rounded-lg flex items-center justify-center mb-4">
            <span className="text-2xl">🎨</span>
          </div>
          <h3 className="text-lg font-semibold text-gray-900 mb-4">White-Label</h3>
          <p className="text-gray-600">Custom branding and white-label solutions to match your company identity.</p>
        </div>
      </div>
    </div>
  </section>
)

const SectionFeaturesAPI = () => (
  <section className="py-20 bg-gray-900 text-white">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="text-center mb-16">
        <h2 className="text-4xl font-bold mb-4">Developer-First Enterprise API</h2>
        <p className="text-xl text-gray-300">Build powerful scheduling applications with our enterprise-grade API.</p>
      </div>
      <div className="grid lg:grid-cols-2 gap-12 items-center">
        <div>
          <div className="space-y-6">
            <div className="flex items-start space-x-4">
              <div className="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center flex-shrink-0">
                <span className="text-white font-bold">1</span>
              </div>
              <div>
                <h3 className="text-lg font-semibold mb-2">RESTful API</h3>
                <p className="text-gray-300">Clean, intuitive endpoints with comprehensive documentation and SDKs.</p>
              </div>
            </div>
            <div className="flex items-start space-x-4">
              <div className="w-8 h-8 bg-green-500 rounded-full flex items-center justify-center flex-shrink-0">
                <span className="text-white font-bold">2</span>
              </div>
              <div>
                <h3 className="text-lg font-semibold mb-2">Webhooks & Integrations</h3>
                <p className="text-gray-300">Real-time notifications and seamless integration with your existing systems.</p>
              </div>
            </div>
            <div className="flex items-start space-x-4">
              <div className="w-8 h-8 bg-purple-500 rounded-full flex items-center justify-center flex-shrink-0">
                <span className="text-white font-bold">3</span>
              </div>
              <div>
                <h3 className="text-lg font-semibold mb-2">Enterprise Security</h3>
                <p className="text-gray-300">SOC2, GDPR, ISO 27001 compliant with IP whitelisting and audit logs.</p>
              </div>
            </div>
          </div>
        </div>
        <div className="bg-gray-800 rounded-xl p-6">
          <div className="bg-gray-900 rounded-lg p-4 font-mono text-sm">
            <div className="text-gray-400 mb-2">// Create appointment via API</div>
            <div className="space-y-1">
              <div><span className="text-blue-400">POST</span> <span className="text-green-400">/api/v1/appointments</span></div>
              <div><span className="text-yellow-400">Authorization:</span> <span className="text-green-400">Bearer YOUR_API_KEY</span></div>
              <div className="mt-2 text-gray-400">{`{`}</div>
              <div className="pl-4 text-gray-300">
                <div><span className="text-green-400">"customer"</span>: <span className="text-green-400">"john@example.com"</span>,</div>
                <div><span className="text-green-400">"time"</span>: <span className="text-green-400">"2024-01-15T10:00:00Z"</span>,</div>
                <div><span className="text-green-400">"duration"</span>: <span className="text-green-400">30</span></div>
              </div>
              <div className="text-gray-400">{`}`}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
)

const SectionAmbassadors = () => (
  <section className="py-20 bg-gradient-to-br from-blue-50 to-indigo-100">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="text-center mb-16">
        <h2 className="text-4xl font-bold text-gray-900 mb-4">Join Our Community</h2>
        <p className="text-xl text-gray-600">Become an App-Oint Ambassador and help others discover better scheduling.</p>
      </div>
      <div className="grid md:grid-cols-3 gap-8">
        <div className="bg-white rounded-xl shadow-md p-8 text-center">
          <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <span className="text-3xl">🌟</span>
          </div>
          <h3 className="text-xl font-semibold text-gray-900 mb-4">Earn Rewards</h3>
          <p className="text-gray-600">Get exclusive benefits, early access to features, and recognition in our community.</p>
        </div>
        <div className="bg-white rounded-xl shadow-md p-8 text-center">
          <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <span className="text-3xl">🤝</span>
          </div>
          <h3 className="text-xl font-semibold text-gray-900 mb-4">Share Knowledge</h3>
          <p className="text-gray-600">Help others discover better scheduling practices and build meaningful connections.</p>
        </div>
        <div className="bg-white rounded-xl shadow-md p-8 text-center">
          <div className="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <span className="text-3xl">🚀</span>
          </div>
          <h3 className="text-xl font-semibold text-gray-900 mb-4">Grow Together</h3>
          <p className="text-gray-600">Access exclusive events, networking opportunities, and professional development.</p>
        </div>
      </div>
      <div className="text-center mt-12">
        <button className="btn-primary text-lg px-8 py-4">
          Become an Ambassador
        </button>
      </div>
    </div>
  </section>
)

const SectionTestimonials = () => (
  <section className="py-20 bg-white">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="text-center mb-16">
        <h2 className="text-4xl font-bold text-gray-900 mb-4">Trusted by Thousands</h2>
        <p className="text-xl text-gray-600">Join thousands of users who've transformed their scheduling experience.</p>
      </div>
      <div className="grid md:grid-cols-3 gap-8">
        <div className="bg-gray-50 rounded-xl p-8">
          <div className="flex items-center mb-4">
            <div className="w-12 h-12 bg-blue-500 rounded-full flex items-center justify-center text-white font-bold">
              S
            </div>
            <div className="ml-4">
              <h4 className="font-semibold text-gray-900">Sarah Chen</h4>
              <p className="text-sm text-gray-600">Freelance Consultant</p>
            </div>
          </div>
          <p className="text-gray-600 italic">"App-Oint reduced my scheduling back-and-forth by 90%. My clients love the instant booking experience."</p>
        </div>
        <div className="bg-gray-50 rounded-xl p-8">
          <div className="flex items-center mb-4">
            <div className="w-12 h-12 bg-green-500 rounded-full flex items-center justify-center text-white font-bold">
              M
            </div>
            <div className="ml-4">
              <h4 className="font-semibold text-gray-900">Mike Rodriguez</h4>
              <p className="text-sm text-gray-600">Dental Practice Owner</p>
            </div>
          </div>
          <p className="text-gray-600 italic">"Managing 3 locations became effortless. The multi-location features are game-changing for our practice."</p>
        </div>
        <div className="bg-gray-50 rounded-xl p-8">
          <div className="flex items-center mb-4">
            <div className="w-12 h-12 bg-purple-500 rounded-full flex items-center justify-center text-white font-bold">
              A
            </div>
            <div className="ml-4">
              <h4 className="font-semibold text-gray-900">Alex Thompson</h4>
              <p className="text-sm text-gray-600">Tech Startup CEO</p>
            </div>
          </div>
          <p className="text-gray-600 italic">"The API integration was seamless. We built our entire scheduling system on App-Oint's foundation."</p>
        </div>
      </div>
    </div>
  </section>
)

const SectionPricing = () => {
  const [billingCycle, setBillingCycle] = useState('monthly')

  return (
    <section className="py-20 bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-bold text-gray-900 mb-4">Simple, Transparent Pricing</h2>
          <p className="text-xl text-gray-600">Choose the plan that fits your needs. All plans include our core features.</p>

          <div className="flex justify-center mt-8">
            <div className="bg-white rounded-lg p-1 flex">
              <button
                onClick={() => setBillingCycle('monthly')}
                className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${billingCycle === 'monthly'
                    ? 'bg-blue-600 text-white'
                    : 'text-gray-600 hover:text-gray-900'
                  }`}
              >
                Monthly
              </button>
              <button
                onClick={() => setBillingCycle('yearly')}
                className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${billingCycle === 'yearly'
                    ? 'bg-blue-600 text-white'
                    : 'text-gray-600 hover:text-gray-900'
                  }`}
              >
                Yearly
                <span className="ml-1 text-xs bg-green-100 text-green-800 px-2 py-1 rounded">Save 20%</span>
              </button>
            </div>
          </div>
        </div>

        <div className="grid md:grid-cols-4 gap-8">
          {/* Free Plan */}
          <div className="bg-white rounded-xl shadow-md p-8">
            <h3 className="text-2xl font-bold text-gray-900 mb-2">Free</h3>
            <div className="text-4xl font-bold text-gray-900 mb-2">
              €0<span className="text-lg text-gray-500">/mo</span>
            </div>
            <p className="text-gray-600 mb-8">Perfect for getting started</p>
            <ul className="space-y-4 mb-8">
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                Up to 10 appointments/month
              </li>
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                Basic scheduling
              </li>
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                Email support
              </li>
            </ul>
            <button className="w-full btn-secondary py-3">
              Get Started Free
            </button>
          </div>

          {/* Professional Plan */}
          <div className="bg-white rounded-xl shadow-lg p-8 border-2 border-blue-500 relative">
            <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
              <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-semibold">
                Most Popular
              </span>
            </div>
            <h3 className="text-2xl font-bold text-gray-900 mb-2">Professional</h3>
            <div className="text-4xl font-bold text-gray-900 mb-2">
              €{billingCycle === 'yearly' ? '12' : '15'}<span className="text-lg text-gray-500">/mo</span>
            </div>
            <p className="text-gray-600 mb-8">For growing businesses</p>
            <ul className="space-y-4 mb-8">
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                Unlimited appointments
              </li>
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                Team collaboration
              </li>
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                Advanced analytics
              </li>
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                Priority support
              </li>
            </ul>
            <button className="w-full btn-primary py-3">
              Start Professional
            </button>
          </div>

          {/* Business Plus Plan */}
          <div className="bg-white rounded-xl shadow-md p-8">
            <h3 className="text-2xl font-bold text-gray-900 mb-2">Business Plus</h3>
            <div className="text-4xl font-bold text-gray-900 mb-2">
              €{billingCycle === 'yearly' ? '20' : '25'}<span className="text-lg text-gray-500">/mo</span>
            </div>
            <p className="text-gray-600 mb-8">For established companies</p>
            <ul className="space-y-4 mb-8">
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                Multi-location support
              </li>
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                White-label options
              </li>
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                API access
              </li>
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                Dedicated support
              </li>
            </ul>
            <button className="w-full btn-secondary py-3">
              Start Business Plus
            </button>
          </div>

          {/* Enterprise Plan */}
          <div className="bg-white rounded-xl shadow-md p-8">
            <h3 className="text-2xl font-bold text-gray-900 mb-2">Enterprise</h3>
            <div className="text-4xl font-bold text-gray-900 mb-2">
              Contact us
            </div>
            <p className="text-gray-600 mb-8">For enterprise needs</p>
            <ul className="space-y-4 mb-8">
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                Unlimited everything
              </li>
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                Custom integrations
              </li>
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                SLA guarantee
              </li>
              <li className="flex items-center">
                <span className="text-green-500 mr-3">✓</span>
                Account manager
              </li>
            </ul>
            <button className="w-full btn-secondary py-3">
              Contact Sales
            </button>
          </div>
        </div>
      </div>
    </section>
  )
}

const SectionApps = () => (
  <section className="py-20 bg-white">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="text-center mb-16">
        <h2 className="text-4xl font-bold text-gray-900 mb-4">Available Everywhere</h2>
        <p className="text-xl text-gray-600">Access your schedule on any device, anywhere, anytime.</p>
      </div>
      <div className="grid md:grid-cols-2 gap-12 items-center">
        <div>
          <h3 className="text-2xl font-bold text-gray-900 mb-6">Mobile Apps</h3>
          <div className="space-y-6">
            <div className="flex items-center space-x-4">
              <div className="w-12 h-12 bg-black rounded-xl flex items-center justify-center">
                <span className="text-white text-2xl">📱</span>
              </div>
              <div>
                <h4 className="font-semibold text-gray-900">iOS App</h4>
                <p className="text-gray-600">Available on the App Store</p>
              </div>
            </div>
            <div className="flex items-center space-x-4">
              <div className="w-12 h-12 bg-green-500 rounded-xl flex items-center justify-center">
                <span className="text-white text-2xl">🤖</span>
              </div>
              <div>
                <h4 className="font-semibold text-gray-900">Android App</h4>
                <p className="text-gray-600">Available on Google Play</p>
              </div>
            </div>
          </div>
          <div className="mt-8">
            <button className="btn-primary mr-4">
              Download iOS App
            </button>
            <button className="btn-secondary">
              Download Android App
            </button>
          </div>
        </div>
        <div className="relative">
          <div className="bg-gradient-to-br from-blue-50 to-indigo-100 rounded-2xl p-8">
            <div className="bg-white rounded-xl shadow-lg p-6">
              <div className="flex items-center justify-between mb-4">
                <h4 className="font-semibold text-gray-900">App-Oint Mobile</h4>
                <span className="text-sm text-gray-500">v2.1.0</span>
              </div>
              <div className="space-y-3">
                <div className="flex items-center justify-between">
                  <span className="text-sm text-gray-600">Today's Schedule</span>
                  <span className="text-sm font-medium text-gray-900">3 meetings</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-sm text-gray-600">Next Meeting</span>
                  <span className="text-sm font-medium text-gray-900">10:00 AM</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-sm text-gray-600">Status</span>
                  <span className="text-sm text-green-600 font-medium">✓ Online</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
)

const SectionIntegrations = () => (
  <section className="py-20 bg-gray-50">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="text-center mb-16">
        <h2 className="text-4xl font-bold text-gray-900 mb-4">Seamless Integrations</h2>
        <p className="text-xl text-gray-600">Works with the tools you already use and love.</p>
      </div>
      <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-8">
        {[
          { name: 'Google Calendar', icon: '📅' },
          { name: 'Outlook', icon: '📧' },
          { name: 'Slack', icon: '💬' },
          { name: 'Zoom', icon: '🎥' },
          { name: 'Stripe', icon: '💳' },
          { name: 'Salesforce', icon: '☁️' },
          { name: 'HubSpot', icon: '🎯' },
          { name: 'Zapier', icon: '🔗' },
          { name: 'Notion', icon: '📝' },
          { name: 'Trello', icon: '📋' },
          { name: 'Asana', icon: '✅' },
          { name: 'Jira', icon: '🐛' }
        ].map((integration, index) => (
          <div key={index} className="bg-white rounded-xl p-6 text-center hover:shadow-lg transition-shadow">
            <div className="text-3xl mb-2">{integration.icon}</div>
            <h4 className="font-medium text-gray-900">{integration.name}</h4>
          </div>
        ))}
      </div>
    </div>
  </section>
)

const Footer = () => {
  const [language, setLanguage] = useState('en')

  return (
    <footer className="bg-gray-900 text-white py-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid md:grid-cols-4 gap-8">
          <div>
            <div className="flex items-center space-x-3 mb-4">
              <span className="text-2xl">🎯</span>
              <span className="text-xl font-bold">App-Oint</span>
            </div>
            <p className="text-gray-400">
              Your time is too valuable to waste on back-and-forths.
              AI-enhanced. Human-centered. Scheduling done right.
            </p>
          </div>
          <div>
            <h3 className="font-semibold mb-4">Product</h3>
            <ul className="space-y-2 text-gray-400">
              <li><a href="#" className="hover:text-white">Features</a></li>
              <li><a href="#" className="hover:text-white">Pricing</a></li>
              <li><a href="#" className="hover:text-white">API</a></li>
              <li><a href="#" className="hover:text-white">Mobile Apps</a></li>
            </ul>
          </div>
          <div>
            <h3 className="font-semibold mb-4">Company</h3>
            <ul className="space-y-2 text-gray-400">
              <li><a href="#" className="hover:text-white">About</a></li>
              <li><a href="#" className="hover:text-white">Blog</a></li>
              <li><a href="#" className="hover:text-white">Careers</a></li>
              <li><a href="#" className="hover:text-white">Contact</a></li>
            </ul>
          </div>
          <div>
            <h3 className="font-semibold mb-4">Legal</h3>
            <ul className="space-y-2 text-gray-400">
              <li><a href="#" className="hover:text-white">Privacy Policy</a></li>
              <li><a href="#" className="hover:text-white">Terms of Service</a></li>
              <li><a href="#" className="hover:text-white">Cookie Policy</a></li>
              <li><a href="#" className="hover:text-white">Security</a></li>
            </ul>
          </div>
        </div>

        <div className="border-t border-gray-800 mt-8 pt-8 flex flex-col md:flex-row justify-between items-center">
          <p className="text-gray-400">&copy; 2024 App-Oint. All rights reserved.</p>
          <div className="flex items-center space-x-4 mt-4 md:mt-0">
            <select
              value={language}
              onChange={(e) => setLanguage(e.target.value)}
              className="bg-gray-800 text-white px-3 py-1 rounded text-sm"
            >
              <option value="en">English</option>
              <option value="es">Español</option>
              <option value="fr">Français</option>
              <option value="de">Deutsch</option>
            </select>
            <div className="flex space-x-4">
              <a href="#" className="text-gray-400 hover:text-white">
                <span className="sr-only">Twitter</span>
                <span className="text-xl">🐦</span>
              </a>
              <a href="#" className="text-gray-400 hover:text-white">
                <span className="sr-only">LinkedIn</span>
                <span className="text-xl">💼</span>
              </a>
              <a href="#" className="text-gray-400 hover:text-white">
                <span className="sr-only">GitHub</span>
                <span className="text-xl">🐙</span>
              </a>
            </div>
          </div>
        </div>
      </div>
    </footer>
  )
}

// Main Landing Page Component
export default function Home() {
  return (
    <div lang="en">
      <Head>
        <title>App-Oint — Time Organized</title>
        <meta name="description" content="From personal scheduling to enterprise APIs — organize your time with AI-enhanced smart appointments. Set – Send – Done." />
        <meta name="keywords" content="appointments, scheduling, calendar, booking, business, API, enterprise" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />

        {/* Open Graph */}
        <meta property="og:title" content="App-Oint — Time Organized" />
        <meta property="og:description" content="From personal scheduling to enterprise APIs — organize your time with AI-enhanced smart appointments." />
        <meta property="og:type" content="website" />
        <meta property="og:url" content="https://app-oint.com" />
        <meta property="og:image" content="https://app-oint.com/og-image.png" />

        {/* Twitter */}
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:title" content="App-Oint — Time Organized" />
        <meta name="twitter:description" content="From personal scheduling to enterprise APIs — organize your time with AI-enhanced smart appointments." />
        <meta name="twitter:image" content="https://app-oint.com/og-image.png" />

        {/* Favicon */}
        <link rel="icon" href="/favicon.ico" />

        {/* Analytics Placeholders */}
        <script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
        <script
          dangerouslySetInnerHTML={{
            __html: `
              window.dataLayer = window.dataLayer || [];
              function gtag(){dataLayer.push(arguments);}
              gtag('js', new Date());
              gtag('config', 'GA_MEASUREMENT_ID');
            `,
          }}
        />
      </Head>

      {/* Navigation */}
      <nav className="bg-white shadow-sm sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            <div className="flex items-center space-x-3">
              <span className="text-2xl">🎯</span>
              <span className="text-xl font-bold text-gray-900">App-Oint</span>
            </div>
            <div className="hidden md:flex items-center space-x-8">
              <a href="#features" className="text-gray-600 hover:text-gray-900">Features</a>
              <a href="#pricing" className="text-gray-600 hover:text-gray-900">Pricing</a>
              <a href="#api" className="text-gray-600 hover:text-gray-900">API</a>
              <button className="btn-primary">
                Get Started
              </button>
            </div>
            <div className="md:hidden">
              <button className="text-gray-600">
                <span className="text-xl">☰</span>
              </button>
            </div>
          </div>
        </div>
      </nav>

      {/* Main Content */}
      <main>
        <SectionHero />
        <SectionTrust />
        <SectionFeaturesPersonal />
        <SectionFeaturesBusiness />
        <SectionFeaturesAPI />
        <SectionAmbassadors />
        <SectionTestimonials />
        <SectionPricing />
        <SectionApps />
        <SectionIntegrations />
      </main>

      <Footer />
    </div>
  )
}

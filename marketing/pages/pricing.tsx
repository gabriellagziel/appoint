import { Navbar } from '../src/components/Navbar'
import Head from 'next/head'


export default function PricingPage() {

  return (
    <div>
      <Head>
        <title>Pricing - App-Oint</title>
        <meta name="description" content="Simple, transparent pricing for App-Oint scheduling platform" />
      </Head>

      <div className="min-h-screen bg-gray-50">
        <Navbar />

        <main className="py-16">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center mb-16">
              <h1 className="text-4xl font-bold text-gray-900 mb-4">
                Simple, Transparent Pricing
              </h1>
              <p className="text-xl text-gray-600 max-w-3xl mx-auto">
                Choose the perfect plan for your needs.
              </p>
            </div>
          </div>
        </main>
      </div>
    </div>
  )
}
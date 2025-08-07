import Features from '@/components/Landing/Features'
import Footer from '@/components/Landing/Footer'
import Hero from '@/components/Landing/Hero'
import Pricing from '@/components/Landing/Pricing'
import Testimonials from '@/components/Landing/Testimonials'

export default function Home() {
    return (
        <main className="min-h-screen">
            <Hero />
            <Features />
            <Pricing />
            <Testimonials />
            <Footer />
        </main>
    )
} 
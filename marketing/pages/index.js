import Head from 'next/head'
import Link from 'next/link'
import Script from 'next/script'
import Image from 'next/image'
import { detectLocale, loadCommonMessages } from '../lib/locale'
import { useEffect, useState } from 'react'

const BUSINESS_URL = process.env.NEXT_PUBLIC_BUSINESS_URL || 'https://business.app-oint.com';
const ENTERPRISE_URL = process.env.NEXT_PUBLIC_ENTERPRISE_URL || 'https://enterprise.app-oint.com';

export default function Home({ locale = 'en', t = {} }) {
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  const track = (name) => {
    if (typeof window !== 'undefined') {
      if (window.gtag) {
        window.gtag('event', name)
      } else if (window.dataLayer) {
        window.dataLayer.push({ event: name })
      } else {
        // eslint-disable-next-line no-console
        console.log('analytics_event', name)
      }
    }
  }

  const navigateWithAnalytics = (eventName, href) => (e) => {
    if (mounted && typeof window !== 'undefined' && window.gtag) {
      e.preventDefault()
      window.gtag('event', eventName, {
        event_callback: () => {
          // External navigation; fall back to location.assign
          window.location.assign(href)
        },
      })
      // Fallback in case callback doesn't fire
      setTimeout(() => window.location.assign(href), 500)
    }
  }

  const faqJsonLd = {
    '@context': 'https://schema.org',
    '@type': 'FAQPage',
    mainEntity: [
      {
        '@type': 'Question',
        name: 'Is this a native app?',
        acceptedAnswer: {
          '@type': 'Answer',
          text: 'It’s a PWA. Add to Home Screen for a full-screen app experience.'
        }
      },
      {
        '@type': 'Question',
        name: 'How do ads/premium work?',
        acceptedAnswer: {
          '@type': 'Answer',
          text: 'Free shows ads before confirm; Premium removes ads. Kids are ad-free.'
        }
      },
      {
        '@type': 'Question',
        name: 'Do you send SMS?',
        acceptedAnswer: {
          '@type': 'Answer',
          text: 'No. All notifications are in-app for privacy and control.'
        }
      },
      {
        '@type': 'Question',
        name: 'How do I connect to a business?',
        acceptedAnswer: {
          '@type': 'Answer',
          text: 'Book the business directly; they confirm in their Business Studio.'
        }
      }
    ]
  }

  return (
    <main id="main" className="min-h-screen bg-white text-neutral-900">
      <Head>
        <title>{t?.seo?.defaultTitle || 'App-Oint — Smart Time Organizer: Appointments, Reminders, Business & Enterprise'}</title>
        <meta
          name="description"
          content={t?.seo?.defaultDescription || 'App-Oint is a conversational time organizer: the fastest appointment fixer, smart reminders, and live connections to businesses and enterprise systems.'}
        />
        <meta property="og:title" content="App-Oint — Smart Time Organizer" />
        <meta
          property="og:description"
          content="Appointments that feel like a chat, reminders that actually help, and seamless connections to businesses and enterprise systems."
        />
        <meta property="og:type" content="website" />
        <meta property="og:url" content="https://app-oint.com" />
        <meta property="og:image" content="/logo.jpeg" />
        <link rel="icon" href="/logo.svg" />
        <link rel="canonical" href="https://app-oint.com" />
      </Head>

      <Script id="faq-jsonld" type="application/ld+json" strategy="afterInteractive">
        {JSON.stringify(faqJsonLd)}
      </Script>

      {/* Navbar */}
      <a href="#main" className="sr-only focus:not-sr-only focus:absolute focus:top-2 focus:left-2 focus:z-50 focus:bg-white focus:text-blue-700 focus:ring-2 focus:ring-blue-600 focus:px-3 focus:py-2 rounded">Skip to content</a>
      <header className="sticky top-0 z-40 bg-white/80 backdrop-blur border-b">
        <div className="mx-auto max-w-7xl px-4 h-16 flex items-center justify-between">
          <Link href="/" className="flex items-center gap-3 font-semibold" aria-label="Home">
            <Image src="/logo.jpeg" alt="App-Oint" width={32} height={32} className="rounded" priority />
            <span>{t?.brand?.name || 'App-Oint'}</span>
          </Link>
          <nav className="hidden md:flex items-center gap-6 text-sm" aria-label="Primary">
            <Link href="/user/" className="hover:text-blue-700">User</Link>
            <a href={BUSINESS_URL} onClick={navigateWithAnalytics('cta_business_clicked', BUSINESS_URL)} className="hover:text-blue-700">Business</a>
            <a href={ENTERPRISE_URL} onClick={navigateWithAnalytics('cta_enterprise_clicked', ENTERPRISE_URL)} className="hover:text-blue-700">Enterprise</a>
            <Link href="#pricing" className="hover:text-blue-700">Pricing</Link>
            <a href="https://enterprise.app-oint.com/docs" className="hover:text-blue-700">Docs</a>
            <Link href={`/?lang=${locale === 'en' ? 'fr' : 'en'}`} className="hover:text-blue-700">
              {t?.language?.switchLanguage || 'Switch Language'}
            </Link>
            <a
              href="https://app.app-oint.com"
              onClick={navigateWithAnalytics('cta_signin_clicked', 'https://app.app-oint.com')}
              className="px-3 py-1.5 rounded-lg bg-blue-600 text-white hover:bg-blue-700"
            >
              Sign in
            </a>
          </nav>
        </div>
      </header>

      {/* Hero */}
      <section className="mx-auto max-w-7xl px-4 py-16 lg:py-24">
        <div className="grid lg:grid-cols-2 gap-10 items-center">
          <div>
            <h1 className="text-4xl/tight lg:text-5xl/tight font-semibold">
              Your day, <span className="text-blue-600">perfectly organized</span>.
            </h1>
            <p className="mt-4 text-lg text-neutral-700">
              App-Oint is a conversational time organizer: the fastest appointment fixer,
              a genuinely smart reminders system, and live connections to businesses and enterprise systems.
            </p>
            <div className="mt-6 flex flex-wrap gap-3">
              <a
                href="https://app.app-oint.com"
                onClick={navigateWithAnalytics('cta_open_app_clicked', 'https://app.app-oint.com')}
                className="px-5 py-3 rounded-xl bg-blue-600 text-white hover:bg-blue-700"
              >
                Open the App
              </a>
              <a
                href={BUSINESS_URL}
                onClick={navigateWithAnalytics('cta_business_clicked', BUSINESS_URL)}
                className="px-5 py-3 rounded-xl border hover:bg-neutral-50"
              >
                For Business
              </a>
              <a
                href={ENTERPRISE_URL}
                onClick={navigateWithAnalytics('cta_enterprise_clicked', ENTERPRISE_URL)}
                className="px-5 py-3 rounded-xl border hover:bg-neutral-50"
              >
                For Enterprise
              </a>
            </div>
            <ul className="mt-4 text-sm text-neutral-600 flex flex-wrap gap-x-4 gap-y-1">
              <li>• PWA: Add to Home Screen</li>
              <li>• Google Sign-In</li>
              <li>• Privacy-first (in-app notifications, no SMS)</li>
            </ul>
          </div>
          <div aria-hidden className="relative h-72 lg:h-96 rounded-2xl border overflow-hidden">
            <div className="absolute inset-0 bg-gradient-to-br from-blue-50 via-white to-amber-50" />
            <div className="absolute inset-6 rounded-2xl border bg-white shadow-sm flex items-center justify-center">
              <div className="grid gap-3 p-6 w-full max-w-md">
                <div className="h-3 w-24 bg-neutral-200 rounded" />
                <div className="h-10 rounded-xl bg-blue-600/10" />
                <div className="h-3 w-40 bg-neutral-200 rounded" />
                <div className="h-10 rounded-xl bg-amber-500/10" />
                <div className="h-3 w-28 bg-neutral-200 rounded" />
                <div className="h-10 rounded-xl bg-neutral-200/80" />
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Value Trio */}
      <section className="mx-auto max-w-7xl px-4 py-12">
        <div className="grid md:grid-cols-3 gap-6">
          {[
            {
              title: 'Appointment Fixer',
              body:
                'Create one-on-one, group, virtual, business, or Playtime meetings in a natural conversational flow.'
            },
            {
              title: 'Smart Reminders',
              body:
                'Set reminders for yourself or family, recurring patterns, and checklists with in-app notifications.'
            },
            {
              title: 'Connect Everywhere',
              body:
                'Two-way scheduling with businesses and a clean Enterprise API for large systems.'
            }
          ].map((c) => (
            <div key={c.title} className="rounded-2xl border p-6 hover:shadow-sm">
              <h3 className="font-semibold">{c.title}</h3>
              <p className="mt-2 text-neutral-700">{c.body}</p>
            </div>
          ))}
        </div>
      </section>

      {/* How it works */}
      <section className="mx-auto max-w-7xl px-4 py-12">
        <h2 className="text-2xl font-semibold">How it works</h2>
        <div className="mt-6 grid md:grid-cols-3 gap-6">
          {[
            { step: '1', title: 'Pick what you need', text: 'Meeting, Playtime, or Reminder — personal, group, virtual.' },
            { step: '2', title: 'Invite & set time', text: 'Invite people or groups, choose the time, and you’re done.' },
            { step: '3', title: 'Live meeting page', text: 'Chat, “I’m running late”, “I’ve arrived”, navigation or join link.' }
          ].map((s) => (
            <div key={s.step} className="rounded-2xl border p-6">
              <div className="text-blue-600 font-semibold">Step {s.step}</div>
              <h3 className="mt-1 font-semibold">{s.title}</h3>
              <p className="mt-2 text-neutral-700">{s.text}</p>
            </div>
          ))}
        </div>
      </section>

      {/* User PWA */}
      <section id="user" className="mx-auto max-w-7xl px-4 py-12">
        <div className="rounded-3xl border p-8 lg:p-10 bg-blue-50/40">
          <h2 className="text-2xl font-semibold">User App (PWA)</h2>
          <p className="mt-2 text-neutral-700">
            Add App-Oint to your home screen for a full-screen, app-like experience. No stores, no friction.
            Free (with ads) or Premium (€4) with no ads.
          </p>
          <div className="mt-4 flex flex-wrap gap-3">
            <a
              href="https://app.app-oint.com"
              onClick={navigateWithAnalytics('cta_open_app_clicked', 'https://app.app-oint.com')}
              className="px-5 py-3 rounded-xl bg-blue-600 text-white hover:bg-blue-700"
            >
              Open the App
            </a>
            <Link
              href="/how-to-install-pwa"
              className="px-5 py-3 rounded-xl border hover:bg-neutral-50"
            >
              How to Add to Home Screen
            </Link>
          </div>
        </div>
      </section>

      {/* Business */}
      <section id="business" className="mx-auto max-w-7xl px-4 py-12">
        <div className="grid lg:grid-cols-2 gap-8 items-center">
          <div>
            <h2 className="text-2xl font-semibold">Business Studio</h2>
            <p className="mt-2 text-neutral-700">
              Turn user requests into confirmed visits. Live calendar, two-way confirmation, branding, and lightweight analytics.
            </p>
            <div className="mt-4">
              <a
                href={BUSINESS_URL}
                onClick={navigateWithAnalytics('cta_business_clicked', BUSINESS_URL)}
                className="px-5 py-3 rounded-xl border hover:bg-neutral-50"
              >
                Explore Business Studio
              </a>
            </div>
          </div>
          <div aria-hidden className="rounded-2xl border h-56 lg:h-72 bg-neutral-50 overflow-hidden">
            <Image
              src="/business-studio.png"
              alt="App-Oint Business Studio dashboard"
              width={1200}
              height={720}
              className="w-full h-full object-cover"
              priority
            />
          </div>
        </div>
      </section>

      {/* Enterprise */}
      <section id="enterprise" className="mx-auto max-w-7xl px-4 py-12">
        <div className="grid lg:grid-cols-2 gap-8 items-center">
          <div>
            <h2 className="text-2xl font-semibold">Enterprise API</h2>
            <p className="mt-2 text-neutral-700">
              Schedule at scale via API. Keys, usage dashboards, and monthly invoicing.
              Typical pricing: $0.99 per meeting with location, $0.49 without.
            </p>
            <div className="mt-4 flex flex-wrap gap-3">
              <a
                href={ENTERPRISE_URL}
                onClick={navigateWithAnalytics('cta_enterprise_clicked', ENTERPRISE_URL)}
                className="px-5 py-3 rounded-xl border hover:bg-neutral-50"
              >
                See the API Portal
              </a>
              <a
                href="https://enterprise.app-oint.com/docs"
                className="px-5 py-3 rounded-xl border hover:bg-neutral-50"
              >
                Read the Docs
              </a>
            </div>
          </div>
          <div aria-hidden className="rounded-2xl border h-56 lg:h-72 bg-neutral-50 overflow-hidden">
            <Image
              src="/enterprise-portal.png"
              alt="App-Oint Enterprise API portal and docs"
              width={1200}
              height={720}
              className="w-full h-full object-cover"
            />
          </div>
        </div>
      </section>

      {/* Playtime & Family */}
      <section className="mx-auto max-w-7xl px-4 py-12">
        <div className="grid md:grid-cols-2 gap-6">
          <div className="rounded-2xl border p-6">
            <h3 className="font-semibold">Playtime</h3>
            <p className="mt-2 text-neutral-700">
              Physical or virtual. Invite friends, set the time, bring the fun. Parents can approve child sessions.
            </p>
          </div>
          <div className="rounded-2xl border p-6">
            <h3 className="font-semibold">Family & Reminders</h3>
            <p className="mt-2 text-neutral-700">
              Share reminders across family members with in-app notifications. No SMS — privacy by default.
            </p>
          </div>
        </div>
      </section>

      {/* Pricing snapshot */}
      <section id="pricing" className="mx-auto max-w-7xl px-4 py-12">
        <h2 className="text-2xl font-semibold">Pricing Snapshot</h2>
        <div className="mt-6 grid md:grid-cols-3 gap-6">
          <div className="rounded-2xl border p-6">
            <h3 className="font-semibold">User</h3>
            <p className="mt-2 text-neutral-700">Free (ads) or Premium €4/month (no ads, PWA prompts).</p>
          </div>
          <div className="rounded-2xl border p-6">
            <h3 className="font-semibold">Business</h3>
            <p className="mt-2 text-neutral-700">Plans inside Business Studio. Live calendar, two-way confirms.</p>
          </div>
          <div className="rounded-2xl border p-6">
            <h3 className="font-semibold">Enterprise</h3>
            <p className="mt-2 text-neutral-700">$0.99 (with location) / $0.49 (without). Monthly billing via bank transfer.</p>
          </div>
        </div>
      </section>

      {/* FAQ */}
      <section className="mx-auto max-w-7xl px-4 py-12">
        <h2 className="text-2xl font-semibold">FAQ</h2>
        <div className="mt-6 grid md:grid-cols-2 gap-6">
          <div>
            <h3 className="font-medium">Is this a native app?</h3>
            <p className="mt-1 text-neutral-700">It’s a PWA. Add to Home Screen for a full-screen app experience.</p>
          </div>
          <div>
            <h3 className="font-medium">How do ads/premium work?</h3>
            <p className="mt-1 text-neutral-700">Free shows ads before confirm; Premium removes ads. Kids are ad-free.</p>
          </div>
          <div>
            <h3 className="font-medium">Do you send SMS?</h3>
            <p className="mt-1 text-neutral-700">No. All notifications are in-app for privacy and control.</p>
          </div>
          <div>
            <h3 className="font-medium">How do I connect to a business?</h3>
            <p className="mt-1 text-neutral-700">Book the business directly; they confirm in their Business Studio.</p>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t">
        <div className="mx-auto max-w-7xl px-4 py-10 grid md:grid-cols-4 gap-6 text-sm">
          <div>
            <div className="font-semibold">App-Oint</div>
            <p className="mt-2 text-neutral-600">
              The conversational time organizer — appointments, reminders, and connections.
            </p>
          </div>
          <div>
            <div className="font-semibold">Product</div>
            <ul className="mt-2 space-y-1">
              <li><a href="https://app.app-oint.com" onClick={navigateWithAnalytics('footer_user_app_clicked', 'https://app.app-oint.com')} className="hover:text-blue-700">User App</a></li>
              <li><a href="https://business.app-oint.com" onClick={navigateWithAnalytics('footer_business_clicked', 'https://business.app-oint.com')} className="hover:text-blue-700">Business Studio</a></li>
              <li><a href="https://enterprise.app-oint.com" onClick={navigateWithAnalytics('footer_enterprise_clicked', 'https://enterprise.app-oint.com')} className="hover:text-blue-700">Enterprise Portal</a></li>
            </ul>
          </div>
          <div>
            <div className="font-semibold">Company</div>
            <ul className="mt-2 space-y-1">
              <li><Link href="/privacy" className="hover:text-blue-700">Privacy</Link></li>
              <li><Link href="/terms" className="hover:text-blue-700">Terms</Link></li>
              <li><Link href="/status" className="hover:text-blue-700">Status</Link></li>
            </ul>
          </div>
          <div>
            <div className="font-semibold">Developers</div>
            <ul className="mt-2 space-y-1">
              <li><a href="https://enterprise.app-oint.com/docs" className="hover:text-blue-700">API Docs</a></li>
              <li><Link href="/changelog" className="hover:text-blue-700">Changelog</Link></li>
              <li><Link href="/contact" className="hover:text-blue-700">Contact</Link></li>
            </ul>
          </div>
        </div>
        <div className="mx-auto max-w-7xl px-4 pb-8 text-xs text-neutral-500">
          © {new Date().getFullYear()} App-Oint. All rights reserved.
        </div>
      </footer>
    </main>
  )
}

export async function getServerSideProps({ req }) {
  const locale = detectLocale(req);
  const { locale: resolved, messages } = loadCommonMessages(locale);
  return {
    props: {
      locale: resolved,
      t: messages || {},
    },
  };
}

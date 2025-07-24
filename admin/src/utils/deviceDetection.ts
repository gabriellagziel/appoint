import { headers } from 'next/headers'

export function isMobileDevice(userAgent?: string): boolean {
  const ua = userAgent || getUserAgent()
  return /android|webos|iphone|ipad|ipod|blackberry|iemobile|opera mini/i.test(ua.toLowerCase())
}

export function isTabletDevice(userAgent?: string): boolean {
  const ua = userAgent || getUserAgent()
  return /ipad|tablet|(android(?!.*mobile))/i.test(ua.toLowerCase())
}

export function isMobileOrTablet(userAgent?: string): boolean {
  return isMobileDevice(userAgent) || isTabletDevice(userAgent)
}

export function getUserAgent(): string {
  try {
    const headersList = headers()
    return headersList.get('user-agent') || ''
  } catch {
    // Fallback for client-side
    return typeof window !== 'undefined' ? window.navigator.userAgent : ''
  }
}

export function getDeviceType(userAgent?: string): 'mobile' | 'tablet' | 'desktop' {
  const ua = userAgent || getUserAgent()
  
  if (isMobileDevice(ua)) return 'mobile'
  if (isTabletDevice(ua)) return 'tablet'
  return 'desktop'
}

// Client-side device detection hook
export function useDeviceDetection() {
  if (typeof window === 'undefined') {
    return { isMobile: false, isTablet: false, isDesktop: true }
  }

  const userAgent = window.navigator.userAgent
  const isMobile = isMobileDevice(userAgent)
  const isTablet = isTabletDevice(userAgent)
  const isDesktop = !isMobile && !isTablet

  return { isMobile, isTablet, isDesktop }
}
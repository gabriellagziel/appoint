import { notFound } from 'next/navigation'
import { auditLogger } from './audit-logger'

interface User {
  uid?: string
  email?: string | null
  role?: string
}

interface PrivateLandingAccessOptions {
  user: User | null
  searchParams?: { [key: string]: string | string[] | undefined }
  ipAddress?: string
  userAgent?: string
}

export async function assertPrivateLandingAccess({ user, searchParams, ipAddress, userAgent }: PrivateLandingAccessOptions): Promise<void> {
  let accessGranted = false
  let errorReason = ''

  try {
    // Gate 1: Role check - must be super_admin
    if (!user || user.role !== 'super_admin') {
      errorReason = 'Insufficient role permissions'
      throw new Error(errorReason)
    }

    // Gate 2: Identity check - must match allowed email or UID (server-side only)
    const allowedEmail = process.env.PRIVATE_LANDING_ALLOWED_EMAIL
    const allowedUid = process.env.PRIVATE_LANDING_ALLOWED_UID

    const emailMatch = allowedEmail && user.email === allowedEmail
    const uidMatch = allowedUid && user.uid === allowedUid

    if (!emailMatch && !uidMatch) {
      errorReason = 'User not in allowlist'
      throw new Error(errorReason)
    }

    // Gate 3: Optional token check (server-side only)
    const requiredToken = process.env.PRIVATE_LANDING_TOKEN
    if (requiredToken) {
      const providedToken = searchParams?.token
      if (!providedToken || providedToken !== requiredToken) {
        errorReason = 'Invalid or missing token'
        throw new Error(errorReason)
      }
    }

    accessGranted = true
  } catch (error) {
    // Log the access attempt
    await auditLogger.logPrivateLandingAccess(
      false,
      user?.uid,
      user?.email || undefined,
      user?.role,
      ipAddress,
      userAgent,
      errorReason || (error instanceof Error ? error.message : 'Unknown error')
    )
    
    notFound()
  }

  // Log successful access
  if (accessGranted) {
    await auditLogger.logPrivateLandingAccess(
      true,
      user?.uid,
      user?.email || undefined,
      user?.role,
      ipAddress,
      userAgent
    )
  }
}

export function getPrivateLandingUrl(): string {
  const token = process.env.PRIVATE_LANDING_TOKEN
  return token ? `/admin/surveys/landing?token=${token}` : '/admin/surveys/landing'
}

// Removed duplicate getPrivateLandingUrl definition

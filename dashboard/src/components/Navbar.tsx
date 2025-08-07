"use client"
import { useAuth } from '@/contexts/AuthContext'
import { signOutUser } from '@/services/auth_service'
import Link from "next/link"
import { useRouter } from 'next/navigation'

export default function Navbar() {
  const { user, loading } = useAuth()
  const router = useRouter()

  const handleSignOut = async () => {
    try {
      await signOutUser()
      router.push('/login')
    } catch (error) {
      console.error('Error signing out:', error)
    }
  }

  // Handle loading state
  if (loading) {
    return (
      <nav className="flex items-center justify-between px-6 py-4 bg-white border-b">
        <Link href="/dashboard">
          <span className="font-bold text-xl">APP-OINT</span>
        </Link>
        <div className="flex items-center gap-4">
          <span>Loading...</span>
        </div>
      </nav>
    )
  }

  return (
    <nav className="flex items-center justify-between px-6 py-4 bg-white border-b">
      <Link href="/dashboard">
        <span className="font-bold text-xl">APP-OINT</span>
      </Link>
      <div className="flex items-center gap-4">
        {user && (
          <>
            <span className="rounded-full bg-gray-200 px-3 py-1 text-sm font-medium">
              {user.displayName || user.email}
            </span>
            <button
              className="px-4 py-2 bg-gray-900 text-white rounded hover:bg-gray-700"
              onClick={handleSignOut}
            >
              Sign out
            </button>
          </>
        )}
      </div>
    </nav>
  )
} 
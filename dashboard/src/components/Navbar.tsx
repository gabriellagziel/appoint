"use client"
import Link from "next/link"
import { signOut, useSession } from "next-auth/react"

export default function Navbar() {
  const { data: session } = useSession()
  return (
    <nav className="flex items-center justify-between px-6 py-4 bg-white border-b">
      <Link href="/dashboard">
        <span className="font-bold text-xl">APP-OINT</span>
      </Link>
      <div className="flex items-center gap-4">
        {session?.user && (
          <>
            <span className="rounded-full bg-gray-200 px-3 py-1 text-sm font-medium">
              {session.user.name || session.user.email}
            </span>
            <button
              className="px-4 py-2 bg-gray-900 text-white rounded hover:bg-gray-700"
              onClick={() => signOut({ callbackUrl: "/auth/signin" })}
            >
              Sign out
            </button>
          </>
        )}
      </div>
    </nav>
  )
} 
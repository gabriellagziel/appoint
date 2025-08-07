"use client"
import { signIn } from "next-auth/react"
import { useState } from "react"

export default function SignInPage() {
  const [error, setError] = useState("")
  const [loading, setLoading] = useState(false)

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    setLoading(true)
    setError("")
    const form = e.currentTarget
    const username = (form.elements.namedItem("username") as HTMLInputElement).value
    const password = (form.elements.namedItem("password") as HTMLInputElement).value
    const res = await signIn("credentials", {
      username,
      password,
      redirect: true,
      callbackUrl: "/dashboard"
    })
    if (res?.error) setError("Invalid credentials")
    setLoading(false)
  }

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-50">
      <form onSubmit={handleSubmit} className="bg-white p-8 rounded shadow w-96 flex flex-col gap-4">
        <h1 className="text-2xl font-bold mb-2">Sign in to Client Portal</h1>
        <input name="username" placeholder="Username" className="border px-3 py-2 rounded" required />
        <input name="password" type="password" placeholder="Password" className="border px-3 py-2 rounded" required />
        {error && <div className="text-red-500 text-sm">{error}</div>}
        <button type="submit" className="bg-gray-900 text-white px-4 py-2 rounded" disabled={loading}>
          {loading ? "Signing in..." : "Sign in"}
        </button>
      </form>
    </div>
  )
} 
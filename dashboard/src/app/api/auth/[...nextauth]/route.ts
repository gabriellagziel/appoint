import NextAuth from "next-auth"
import CredentialsProvider from "next-auth/providers/credentials"
import { getAdminAuth } from "@/lib/firebaseAdmin"
import { cookies } from "next/headers"
import { z } from "zod"

const handler = NextAuth({
  providers: [
    // Production: Firebase ID token based auth for dashboard users.
    CredentialsProvider({
      name: "Firebase",
      credentials: { idToken: { label: "Firebase ID Token", type: "text" } },
      async authorize(credentials) {
        const parsed = z.object({ idToken: z.string().min(10) }).safeParse(credentials)
        if (!parsed.success) return null
        const auth = getAdminAuth()
        const decoded = await auth.verifyIdToken(parsed.data.idToken)
        // Optionally gate by a custom claim or presence in a collection.
        // For now, accept any valid Firebase user as a dashboard client.
        try {
          const sessionCookie = await auth.createSessionCookie(parsed.data.idToken, { expiresIn: 60 * 60 * 1000 })
          cookies().set('session-token', sessionCookie, { httpOnly: true, secure: true, sameSite: 'lax', path: '/' })
          cookies().set('firebase-auth-token', parsed.data.idToken, { httpOnly: true, secure: true, sameSite: 'lax', path: '/' })
        } catch {}
        return { id: decoded.uid, name: decoded.name || 'User', email: decoded.email || '', role: 'client' }
      },
    })
  ],
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.role = user.role
      }
      return token
    },
    async session({ session, token }) {
      if (session?.user) {
        session.user.role = token.role
      }
      return session
    }
  },
  pages: {
    signIn: "/auth/signin",
  },
  session: {
    strategy: "jwt",
  },
})

export { handler as GET, handler as POST } 
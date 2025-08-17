import NextAuth from "next-auth"
import CredentialsProvider from "next-auth/providers/credentials"
import { getAdminAuth, getAdminDb } from "@/lib/firebaseAdmin"
import { cookies } from "next/headers"
import { z } from "zod"

const handler = NextAuth({
  providers: [
    // Production-ready Firebase session: verify ID token provided by client
    // The client should obtain an ID token via Firebase Web SDK and send it as a credential.
    CredentialsProvider({
      name: "Firebase",
      credentials: {
        idToken: { label: "Firebase ID Token", type: "text" },
      },
      async authorize(credentials) {
        // Validate credential shape
        const parsed = z.object({ idToken: z.string().min(10) }).safeParse(credentials)
        if (!parsed.success) return null

        // Verify token with Firebase Admin
        const auth = getAdminAuth()
        const db = getAdminDb()
        const decoded = await auth.verifyIdToken(parsed.data.idToken)

        // Enforce admin access based on Firestore record and/or custom claims
        const uid = decoded.uid
        const adminDoc = await db.collection('admin_users').doc(uid).get()
        if (!adminDoc.exists) return null
        const data = adminDoc.data() || {}
        const role = data.role || decoded.role || 'admin'

        // Persist a short-lived session cookie (optional): enables middleware cookie check
        try {
          const sessionCookie = await auth.createSessionCookie(parsed.data.idToken, { expiresIn: 60 * 60 * 1000 })
          cookies().set('session-token', sessionCookie, { httpOnly: true, secure: true, sameSite: 'lax', path: '/' })
          cookies().set('firebase-auth-token', parsed.data.idToken, { httpOnly: true, secure: true, sameSite: 'lax', path: '/' })
        } catch {}

        return {
          id: uid,
          name: data.displayName || decoded.name || 'Admin',
          email: data.email || decoded.email || '',
          role,
        }
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
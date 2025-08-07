import NextAuth from "next-auth"
import CredentialsProvider from "next-auth/providers/credentials"

const handler = NextAuth({
  providers: [
    CredentialsProvider({
      name: "Credentials",
      credentials: {
        username: { label: "Username", type: "text" },
        password: { label: "Password", type: "password" }
      },
      async authorize(credentials) {
        // Mock client authentication - replace with real auth logic
        if (credentials?.username === "client" && credentials?.password === "client123") {
          return {
            id: "2",
            name: "Client User",
            email: "client@app-oint.com",
            role: "client",
          }
        }
        return null
      }
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
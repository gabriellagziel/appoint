import Link from "next/link";

export default function SiteFooter() {
  return (
    <footer className="mt-16 border-t border-white/10 py-10">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-sm text-slate-400">
        <div className="flex flex-wrap gap-4 items-center justify-between">
          <p>© {new Date().getFullYear()} App‑Oint. All rights reserved.</p>
          <nav className="flex flex-wrap gap-4">
            <Link href="/" className="hover:text-slate-200">Home</Link>
            <Link href="/login" className="hover:text-slate-200">Login</Link>
            <Link href="/dashboard" className="hover:text-slate-200">Dashboard</Link>
            <Link href="/dashboard/billing" className="hover:text-slate-200">Billing</Link>
          </nav>
        </div>
      </div>
    </footer>
  );
}



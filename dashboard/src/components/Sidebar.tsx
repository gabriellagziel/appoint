"use client"
import Link from "next/link"
import { usePathname } from "next/navigation"

const links = [
  { href: "/dashboard", label: "Overview" },
  { href: "/dashboard/appointments", label: "Appointments" },
  { href: "/dashboard/appointments/new", label: "New Booking" },
  { href: "/dashboard/reports", label: "Reports" },
]

export default function Sidebar() {
  const pathname = usePathname()
  return (
    <aside className="w-56 h-full bg-sidebar border-r flex flex-col py-6 px-4" aria-label="Sidebar">
      <nav className="flex flex-col gap-4">
        {links.map(link => (
          <Link
            key={link.href}
            href={link.href}
            aria-current={pathname === link.href ? 'page' : undefined}
            className={`px-3 py-2 rounded text-base font-medium ${pathname === link.href ? "bg-gray-200" : "hover:bg-gray-100"}`}
          >
            {link.label}
          </Link>
        ))}
      </nav>
    </aside>
  )
} 
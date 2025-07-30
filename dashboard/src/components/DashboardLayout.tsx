import Navbar from "./Navbar"
import Sidebar from "./Sidebar"

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex flex-col h-screen">
      <Navbar />
      <div className="flex flex-1">
        <Sidebar />
        <main className="flex-1 p-8 overflow-y-auto bg-gray-50">{children}</main>
      </div>
    </div>
  )
} 
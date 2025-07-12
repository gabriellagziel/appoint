import { reports } from "@/lib/mock-data"
import { Card } from "@/components/ui/card"

export default function ReportsPage() {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      <Card className="p-6">
        <h2 className="text-xl font-bold mb-4">Monthly Bookings</h2>
        <table className="w-full">
          <thead>
            <tr>
              <th className="text-left">Month</th>
              <th className="text-left">Bookings</th>
            </tr>
          </thead>
          <tbody>
            {reports.monthlyBookings.map(row => (
              <tr key={row.month}>
                <td>{row.month}</td>
                <td>{row.count}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </Card>
      <Card className="p-6">
        <h2 className="text-xl font-bold mb-4">Revenue</h2>
        <table className="w-full">
          <thead>
            <tr>
              <th className="text-left">Month</th>
              <th className="text-left">Revenue ($)</th>
            </tr>
          </thead>
          <tbody>
            {reports.revenue.map(row => (
              <tr key={row.month}>
                <td>{row.month}</td>
                <td>{row.amount}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </Card>
    </div>
  )
} 
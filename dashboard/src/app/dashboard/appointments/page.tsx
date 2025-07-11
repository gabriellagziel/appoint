import { appointments } from "@/lib/mock-data"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"

export default function AppointmentsListPage() {
  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Appointments</h1>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Date</TableHead>
            <TableHead>Time</TableHead>
            <TableHead>Status</TableHead>
            <TableHead>Customer</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {appointments.map(appt => (
            <TableRow key={appt.id}>
              <TableCell>{appt.date}</TableCell>
              <TableCell>{appt.time}</TableCell>
              <TableCell>{appt.status}</TableCell>
              <TableCell>{appt.customer}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  )
} 
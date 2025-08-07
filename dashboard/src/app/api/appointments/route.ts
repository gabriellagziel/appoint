import { NextResponse } from "next/server"
import { appointments } from "@/lib/mock-data"

export async function GET() {
  return NextResponse.json(appointments)
}

export async function POST() {
  // In a real app, parse and save the new appointment
  return NextResponse.json({ success: true, message: "Appointment created (mock)" })
} 
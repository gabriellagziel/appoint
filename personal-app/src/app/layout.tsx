import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "APP-OINT - Time Organized. Set Send Done.",
  description: "Your Healthcare Appointment Platform",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}

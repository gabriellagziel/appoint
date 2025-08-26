import { redirect } from "next/navigation";

export default function RootPage() {
  // This will be handled by middleware
  // Default fallback to English
  redirect("/en");
}

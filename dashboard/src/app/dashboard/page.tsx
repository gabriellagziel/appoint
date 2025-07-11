import { overviewCards } from "@/lib/mock-data"
import { Card } from "@/components/ui/card"

export default function DashboardOverviewPage() {
  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
      {overviewCards.map(card => (
        <Card key={card.title} className="p-6 flex flex-col items-center justify-center">
          <div className="text-3xl font-bold mb-2">{card.value}</div>
          <div className="text-lg text-gray-600">{card.title}</div>
        </Card>
      ))}
    </div>
  )
} 
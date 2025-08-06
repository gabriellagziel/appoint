'use client'
export const dynamic = 'force-dynamic'

import { BarChart } from '@/components/Charts/BarChart'
import { Alert, AlertDescription } from '@/components/ui/alert'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { useAuth } from '@/contexts/AuthContext'
import { getRevenueBySource, getRevenueData, RevenueData } from '@/services/analytics_service'
import { exportRevenueToCSV } from '@/utils/exportToCSV'
import {
  AlertTriangle,
  BarChart3,
  DollarSign,
  Download,
  FileText,
  Loader2
} from 'lucide-react'
import { useEffect, useState } from 'react'

export default function ReportsPage() {
  const { user } = useAuth()
  const [revenueData, setRevenueData] = useState<RevenueData[]>([])
  const [revenueBySource, setRevenueBySource] = useState<Array<{ source: string; amount: number }>>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (user?.businessId) {
      loadData()
    }
  }, [user?.businessId])

  const loadData = async () => {
    try {
      setLoading(true)
      setError(null)

      const [revenue, bySource] = await Promise.all([
        getRevenueData(user!.businessId!),
        getRevenueBySource(user!.businessId!)
      ])

      setRevenueData(revenue)
      setRevenueBySource(bySource)
    } catch (error) {
      console.error('Error loading revenue data:', error)
      setError('Failed to load revenue data')
    } finally {
      setLoading(false)
    }
  }

  const handleExportRevenue = () => {
    exportRevenueToCSV(revenueData)
  }

  const getTotalRevenue = (): number => {
    return revenueData.reduce((sum, item) => sum + item.amount, 0)
  }

  const getRevenueByMonth = () => {
    const monthlyRevenue: { [key: string]: number } = {}

    revenueData.forEach(item => {
      const date = new Date(item.date)
      const monthKey = date.toLocaleDateString('en-US', { month: 'short', year: 'numeric' })
      monthlyRevenue[monthKey] = (monthlyRevenue[monthKey] || 0) + item.amount
    })

    return Object.entries(monthlyRevenue).map(([month, amount]) => ({
      label: month,
      value: amount
    }))
  }

  const formatCurrency = (amount: number): string => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount)
  }

  const getSourceColor = (source: string): string => {
    switch (source) {
      case 'stripeReported':
        return '#3B82F6'
      case 'cash':
        return '#10B981'
      case 'other':
        return '#F59E0B'
      default:
        return '#6B7280'
    }
  }

  if (loading) {
    return (
      <div className="p-6">
        <div className="flex justify-center items-center h-64">
          <div className="flex items-center space-x-2">
            <Loader2 className="h-6 w-6 animate-spin" />
            <span>Loading reports...</span>
          </div>
        </div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="p-6">
        <Alert variant="destructive">
          <AlertTriangle className="h-4 w-4" />
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      </div>
    )
  }

  return (
    <div className="p-6">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Financial Reports</h1>
            <p className="text-gray-600">CRM revenue tracking and financial insights</p>
          </div>
          <Button onClick={handleExportRevenue} variant="outline">
            <Download className="w-4 h-4 mr-2" />
            Export Revenue
          </Button>
        </div>

        {/* Key Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Total Revenue</CardTitle>
              <DollarSign className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{formatCurrency(getTotalRevenue())}</div>
              <p className="text-xs text-muted-foreground">
                CRM tracking only
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Revenue Sources</CardTitle>
              <BarChart3 className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{revenueBySource.length}</div>
              <p className="text-xs text-muted-foreground">
                different sources
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Transactions</CardTitle>
              <FileText className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{revenueData.length}</div>
              <p className="text-xs text-muted-foreground">
                total transactions
              </p>
            </CardContent>
          </Card>
        </div>

        {/* Charts */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          <BarChart
            data={revenueBySource.map(item => ({
              label: item.source === 'stripeReported' ? 'Stripe' :
                item.source === 'cash' ? 'Cash' : 'Other',
              value: item.amount,
              color: getSourceColor(item.source)
            }))}
            title="Revenue by Source"
            height={300}
          />

          <BarChart
            data={getRevenueByMonth().map(item => ({
              label: item.label,
              value: item.value
            }))}
            title="Revenue by Month"
            height={300}
          />
        </div>

        {/* Revenue Sources Breakdown */}
        <Card className="mb-8">
          <CardHeader>
            <CardTitle>Revenue Sources</CardTitle>
            <CardDescription>Breakdown of revenue by source</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {revenueBySource.map((source) => (
                <div key={source.source} className="text-center p-4 border rounded-lg">
                  <div className="text-2xl font-bold" style={{ color: getSourceColor(source.source) }}>
                    {formatCurrency(source.amount)}
                  </div>
                  <div className="text-sm text-gray-600 capitalize">
                    {source.source === 'stripeReported' ? 'Stripe Reported' : source.source}
                  </div>
                  <div className="text-xs text-gray-500">
                    {((source.amount / getTotalRevenue()) * 100).toFixed(1)}% of total
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Revenue Table */}
        <Card>
          <CardHeader>
            <CardTitle>Revenue Transactions</CardTitle>
            <CardDescription>Detailed list of all revenue entries</CardDescription>
          </CardHeader>
          <CardContent>
            {revenueData.length === 0 ? (
              <div className="text-center py-8">
                <FileText className="h-12 w-12 text-gray-400 mx-auto mb-4" />
                <p className="text-gray-500">No revenue data available</p>
                <p className="text-sm text-gray-400">Revenue entries will appear here when added</p>
              </div>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Date</TableHead>
                    <TableHead>Amount</TableHead>
                    <TableHead>Source</TableHead>
                    <TableHead>Description</TableHead>
                    <TableHead>Service</TableHead>
                    <TableHead>Customer</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {revenueData.map((item) => (
                    <TableRow key={item.id}>
                      <TableCell>
                        {new Date(item.date).toLocaleDateString()}
                      </TableCell>
                      <TableCell className="font-medium">
                        {formatCurrency(item.amount)}
                      </TableCell>
                      <TableCell>
                        <Badge
                          variant="outline"
                          style={{
                            borderColor: getSourceColor(item.source),
                            color: getSourceColor(item.source)
                          }}
                        >
                          {item.source === 'stripeReported' ? 'Stripe' :
                            item.source === 'cash' ? 'Cash' : 'Other'}
                        </Badge>
                      </TableCell>
                      <TableCell>{item.description}</TableCell>
                      <TableCell>{item.serviceId || 'N/A'}</TableCell>
                      <TableCell>{item.customerId || 'N/A'}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </CardContent>
        </Card>

        {/* Important Notice */}
        <Alert className="mt-8">
          <AlertTriangle className="h-4 w-4" />
          <AlertDescription>
            <strong>Important:</strong> This is a CRM-only system. No actual payments are processed.
            Revenue data is for tracking and reporting purposes only. For actual payment processing,
            integrate with Stripe or other payment providers.
          </AlertDescription>
        </Alert>
      </div>
    </div>
  )
} 
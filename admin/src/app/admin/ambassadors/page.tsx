"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { Textarea } from "@/components/ui/textarea"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Activity, Award, Globe, TrendingUp, Users2, AlertTriangle, CheckCircle, XCircle, Clock, Flag, Download, MessageSquare } from "lucide-react"
import { useState, useEffect } from "react"
import { toast } from "sonner"

interface Ambassador {
  id: string
  userId: string
  name: string
  email: string
  country: string
  language: string
  status: 'pending_ambassador' | 'approved' | 'inactive' | 'suspended'
  tier: 'basic' | 'premium' | 'lifetime'
  referrals: number
  monthlyReferrals: number
  totalReferrals: number
  joinedAt: string
  shareCode?: string
  flags?: Array<{
    flagType: string
    reason: string
    flaggedAt: string
  }>
  rejectionReason?: string
}

interface PendingAmbassador {
  userId: string
  name: string
  email: string
  country: string
  language: string
  referralCount: number
  pendingSince: string
}

interface AmbassadorFlag {
  userId: string
  flagType: 'suspicious_ip' | 'suspicious_device' | 'suspicious_email_domain' | 'rapid_referrals'
  reason: string
  flaggedAt: string
  reviewed: boolean
  reviewedBy?: string
  reviewedAt?: string
}

export default function AmbassadorsPage() {
  const [ambassadors, setAmbassadors] = useState<Ambassador[]>([])
  const [pendingAmbassadors, setPendingAmbassadors] = useState<PendingAmbassador[]>([])
  const [flags, setFlags] = useState<AmbassadorFlag[]>([])
  const [selectedCountry, setSelectedCountry] = useState("all")
  const [selectedStatus, setSelectedStatus] = useState("all")
  const [selectedTier, setSelectedTier] = useState("all")
  const [searchTerm, setSearchTerm] = useState("")
  const [isLoading, setIsLoading] = useState(true)
  const [selectedAmbassador, setSelectedAmbassador] = useState<Ambassador | null>(null)
  const [rejectionReason, setRejectionReason] = useState("")
  const [isRejectDialogOpen, setIsRejectDialogOpen] = useState(false)

  // Mock data - replace with real API calls
  useEffect(() => {
    const loadData = async () => {
      setIsLoading(true)
      try {
        // Simulate API calls
        await new Promise(resolve => setTimeout(resolve, 1000))
        
        setAmbassadors([
          {
            id: "1",
            userId: "user1",
            name: "John Smith",
            email: "john@example.com",
            country: "US",
            language: "en",
            status: "approved",
            tier: "premium",
            referrals: 15,
            monthlyReferrals: 8,
            totalReferrals: 45,
            joinedAt: "2024-01-15",
            shareCode: "JOHN123",
          },
          {
            id: "2",
            userId: "user2",
            name: "Maria Garcia",
            email: "maria@example.com",
            country: "ES",
            language: "es",
            status: "approved",
            tier: "basic",
            referrals: 12,
            monthlyReferrals: 5,
            totalReferrals: 12,
            joinedAt: "2024-01-20",
            shareCode: "MARIA456",
          },
          {
            id: "3",
            userId: "user3",
            name: "Hans Mueller",
            email: "hans@example.com",
            country: "DE",
            language: "de",
            status: "approved",
            tier: "lifetime",
            referrals: 18,
            monthlyReferrals: 12,
            totalReferrals: 1200,
            joinedAt: "2024-01-10",
            shareCode: "HANS789",
          },
        ])

        setPendingAmbassadors([
          {
            userId: "user4",
            name: "Pierre Dubois",
            email: "pierre@example.com",
            country: "FR",
            language: "fr",
            referralCount: 8,
            pendingSince: "2024-01-25",
          },
          {
            userId: "user5",
            name: "Anna Kowalski",
            email: "anna@example.com",
            country: "PL",
            language: "pl",
            referralCount: 6,
            pendingSince: "2024-01-26",
          },
        ])

        setFlags([
          {
            userId: "user6",
            flagType: "rapid_referrals",
            reason: "User made 15 referrals in 24 hours",
            flaggedAt: "2024-01-27",
            reviewed: false,
          },
          {
            userId: "user7",
            flagType: "suspicious_email_domain",
            reason: "All referrals from same domain: test.com",
            flaggedAt: "2024-01-28",
            reviewed: false,
          },
        ])
      } catch (error) {
        toast.error("Failed to load ambassador data")
      } finally {
        setIsLoading(false)
      }
    }

    loadData()
  }, [])

  const filteredAmbassadors = ambassadors.filter(ambassador => {
    if (selectedCountry !== "all" && ambassador.country !== selectedCountry) return false
    if (selectedStatus !== "all" && ambassador.status !== selectedStatus) return false
    if (selectedTier !== "all" && ambassador.tier !== selectedTier) return false
    if (searchTerm && !ambassador.name.toLowerCase().includes(searchTerm.toLowerCase()) && 
        !ambassador.email.toLowerCase().includes(searchTerm.toLowerCase()) &&
        !ambassador.shareCode?.toLowerCase().includes(searchTerm.toLowerCase())) return false
    return true
  })

  const handleApproveAmbassador = async (userId: string) => {
    try {
      // Call Firebase function
      // await approvePendingAmbassador(userId)
      toast.success("Ambassador approved successfully")
      setPendingAmbassadors(prev => prev.filter(p => p.userId !== userId))
    } catch (error) {
      toast.error("Failed to approve ambassador")
    }
  }

  const handleRejectAmbassador = async (userId: string) => {
    if (!rejectionReason.trim()) {
      toast.error("Please provide a rejection reason")
      return
    }

    try {
      // Call Firebase function
      // await rejectPendingAmbassador(userId, rejectionReason)
      toast.success("Ambassador rejected successfully")
      setPendingAmbassadors(prev => prev.filter(p => p.userId !== userId))
      setRejectionReason("")
      setIsRejectDialogOpen(false)
    } catch (error) {
      toast.error("Failed to reject ambassador")
    }
  }

  const handleFlagReview = async (userId: string, reviewedBy: string) => {
    try {
      // Call Firebase function to mark flag as reviewed
      // await reviewAmbassadorFlag(userId, reviewedBy)
      toast.success("Flag reviewed successfully")
      setFlags(prev => prev.map(f => 
        f.userId === userId ? { ...f, reviewed: true, reviewedBy, reviewedAt: new Date().toISOString() } : f
      ))
    } catch (error) {
      toast.error("Failed to review flag")
    }
  }

  const handlePromoteTier = async (userId: string, newTier: string) => {
    try {
      // Call Firebase function
      // await promoteAmbassadorTier(userId, newTier)
      toast.success(`Ambassador promoted to ${newTier} tier`)
      setAmbassadors(prev => prev.map(a => 
        a.userId === userId ? { ...a, tier: newTier as any } : a
      ))
    } catch (error) {
      toast.error("Failed to promote ambassador")
    }
  }

  const handleDemoteAmbassador = async (userId: string, reason: string) => {
    try {
      // Call Firebase function
      // await demoteAmbassador(userId, reason)
      toast.success("Ambassador demoted successfully")
      setAmbassadors(prev => prev.map(a => 
        a.userId === userId ? { ...a, status: 'inactive' as any } : a
      ))
    } catch (error) {
      toast.error("Failed to demote ambassador")
    }
  }

  const exportToCSV = () => {
    const csvContent = [
      ['Name', 'Email', 'Country', 'Language', 'Status', 'Tier', 'Total Referrals', 'Monthly Referrals', 'Joined At'],
      ...filteredAmbassadors.map(a => [
        a.name,
        a.email,
        a.country,
        a.language,
        a.status,
        a.tier,
        a.totalReferrals.toString(),
        a.monthlyReferrals.toString(),
        a.joinedAt
      ])
    ].map(row => row.join(',')).join('\n')

    const blob = new Blob([csvContent], { type: 'text/csv' })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = 'ambassadors.csv'
    a.click()
    window.URL.revokeObjectURL(url)
    toast.success("CSV exported successfully")
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'approved': return 'default'
      case 'pending_ambassador': return 'secondary'
      case 'inactive': return 'destructive'
      case 'suspended': return 'destructive'
      default: return 'secondary'
    }
  }

  const getTierColor = (tier: string) => {
    switch (tier) {
      case 'basic': return 'default'
      case 'premium': return 'secondary'
      case 'lifetime': return 'destructive'
      default: return 'default'
    }
  }

  if (isLoading) {
    return (
      <AdminLayout>
        <div className="flex items-center justify-center h-64">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
        </div>
      </AdminLayout>
    )
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Ambassador Program</h1>
            <p className="text-gray-600">Manage and monitor the global ambassador program</p>
          </div>
          <div className="flex space-x-2">
            <Button onClick={exportToCSV} variant="outline">
              <Download className="h-4 w-4 mr-2" />
              Export CSV
            </Button>
            <Button>
              <MessageSquare className="h-4 w-4 mr-2" />
              Mass Message
            </Button>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Total Ambassadors</CardTitle>
              <Users2 className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{ambassadors.length}</div>
              <div className="flex items-center text-xs text-green-600">
                <TrendingUp className="h-3 w-3 mr-1" />
                +{ambassadors.filter(a => a.status === 'approved').length} active
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Pending Approvals</CardTitle>
              <Clock className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{pendingAmbassadors.length}</div>
              <div className="flex items-center text-xs text-orange-600">
                <AlertTriangle className="h-3 w-3 mr-1" />
                Need review
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Fraud Flags</CardTitle>
              <Flag className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{flags.filter(f => !f.reviewed).length}</div>
              <div className="flex items-center text-xs text-red-600">
                <AlertTriangle className="h-3 w-3 mr-1" />
                Unreviewed
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Avg Referrals</CardTitle>
              <Award className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                {ambassadors.length > 0 
                  ? Math.round(ambassadors.reduce((sum, a) => sum + a.totalReferrals, 0) / ambassadors.length)
                  : 0
                }
              </div>
              <div className="flex items-center text-xs text-green-600">
                <TrendingUp className="h-3 w-3 mr-1" />
                Per ambassador
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Main Content Tabs */}
        <Tabs defaultValue="ambassadors" className="space-y-6">
          <TabsList>
            <TabsTrigger value="ambassadors">Ambassadors</TabsTrigger>
            <TabsTrigger value="pending">Pending Approvals</TabsTrigger>
            <TabsTrigger value="flags">Fraud Flags</TabsTrigger>
            <TabsTrigger value="logs">Logs</TabsTrigger>
          </TabsList>

          <TabsContent value="ambassadors">
            {/* Filters */}
            <Card>
              <CardHeader>
                <CardTitle>Filters</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="country">Country</Label>
                    <Select value={selectedCountry} onValueChange={setSelectedCountry}>
                      <SelectTrigger>
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="all">All Countries</SelectItem>
                        <SelectItem value="US">United States</SelectItem>
                        <SelectItem value="ES">Spain</SelectItem>
                        <SelectItem value="DE">Germany</SelectItem>
                        <SelectItem value="FR">France</SelectItem>
                        <SelectItem value="PL">Poland</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="status">Status</Label>
                    <Select value={selectedStatus} onValueChange={setSelectedStatus}>
                      <SelectTrigger>
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="all">All Status</SelectItem>
                        <SelectItem value="approved">Approved</SelectItem>
                        <SelectItem value="inactive">Inactive</SelectItem>
                        <SelectItem value="suspended">Suspended</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="tier">Tier</Label>
                    <Select value={selectedTier} onValueChange={setSelectedTier}>
                      <SelectTrigger>
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="all">All Tiers</SelectItem>
                        <SelectItem value="basic">Basic</SelectItem>
                        <SelectItem value="premium">Premium</SelectItem>
                        <SelectItem value="lifetime">Lifetime</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="search">Search</Label>
                    <Input 
                      placeholder="Search ambassadors..." 
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                    />
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Ambassadors Table */}
            <Card>
              <CardHeader>
                <CardTitle>Ambassadors ({filteredAmbassadors.length})</CardTitle>
              </CardHeader>
              <CardContent>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Name</TableHead>
                      <TableHead>Email</TableHead>
                      <TableHead>Country</TableHead>
                      <TableHead>Language</TableHead>
                      <TableHead>Status</TableHead>
                      <TableHead>Tier</TableHead>
                      <TableHead>Referrals</TableHead>
                      <TableHead>Monthly</TableHead>
                      <TableHead>Joined</TableHead>
                      <TableHead>Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {filteredAmbassadors.map((ambassador) => (
                      <TableRow key={ambassador.id}>
                        <TableCell className="font-medium">{ambassador.name}</TableCell>
                        <TableCell>{ambassador.email}</TableCell>
                        <TableCell>{ambassador.country}</TableCell>
                        <TableCell>{ambassador.language.toUpperCase()}</TableCell>
                        <TableCell>
                          <Badge variant={getStatusColor(ambassador.status)}>
                            {ambassador.status}
                          </Badge>
                        </TableCell>
                        <TableCell>
                          <Badge variant={getTierColor(ambassador.tier)}>
                            {ambassador.tier}
                          </Badge>
                        </TableCell>
                        <TableCell>{ambassador.totalReferrals}</TableCell>
                        <TableCell>{ambassador.monthlyReferrals}</TableCell>
                        <TableCell>{ambassador.joinedAt}</TableCell>
                        <TableCell>
                          <div className="flex space-x-2">
                            <Button
                              size="sm"
                              variant="outline"
                              onClick={() => setSelectedAmbassador(ambassador)}
                            >
                              View
                            </Button>
                            {ambassador.tier === 'basic' && (
                              <Button
                                size="sm"
                                variant="outline"
                                onClick={() => handlePromoteTier(ambassador.userId, 'premium')}
                              >
                                Promote
                              </Button>
                            )}
                            {ambassador.tier === 'premium' && (
                              <Button
                                size="sm"
                                variant="outline"
                                onClick={() => handlePromoteTier(ambassador.userId, 'lifetime')}
                              >
                                Promote
                              </Button>
                            )}
                            <Button
                              size="sm"
                              variant="destructive"
                              onClick={() => handleDemoteAmbassador(ambassador.userId, 'Manual demotion')}
                            >
                              Demote
                            </Button>
                          </div>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="pending">
            <Card>
              <CardHeader>
                <CardTitle>Pending Approvals ({pendingAmbassadors.length})</CardTitle>
              </CardHeader>
              <CardContent>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Name</TableHead>
                      <TableHead>Email</TableHead>
                      <TableHead>Country</TableHead>
                      <TableHead>Language</TableHead>
                      <TableHead>Referrals</TableHead>
                      <TableHead>Pending Since</TableHead>
                      <TableHead>Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {pendingAmbassadors.map((ambassador) => (
                      <TableRow key={ambassador.userId}>
                        <TableCell className="font-medium">{ambassador.name}</TableCell>
                        <TableCell>{ambassador.email}</TableCell>
                        <TableCell>{ambassador.country}</TableCell>
                        <TableCell>{ambassador.language.toUpperCase()}</TableCell>
                        <TableCell>{ambassador.referralCount}</TableCell>
                        <TableCell>{ambassador.pendingSince}</TableCell>
                        <TableCell>
                          <div className="flex space-x-2">
                            <Button
                              size="sm"
                              variant="outline"
                              onClick={() => handleApproveAmbassador(ambassador.userId)}
                            >
                              <CheckCircle className="h-4 w-4 mr-1" />
                              Approve
                            </Button>
                            <Button
                              size="sm"
                              variant="destructive"
                              onClick={() => {
                                setSelectedAmbassador({ ...ambassador, userId: ambassador.userId } as any)
                                setIsRejectDialogOpen(true)
                              }}
                            >
                              <XCircle className="h-4 w-4 mr-1" />
                              Reject
                            </Button>
                          </div>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="flags">
            <Card>
              <CardHeader>
                <CardTitle>Fraud Flags ({flags.filter(f => !f.reviewed).length} unreviewed)</CardTitle>
              </CardHeader>
              <CardContent>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>User ID</TableHead>
                      <TableHead>Flag Type</TableHead>
                      <TableHead>Reason</TableHead>
                      <TableHead>Flagged At</TableHead>
                      <TableHead>Status</TableHead>
                      <TableHead>Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {flags.map((flag) => (
                      <TableRow key={`${flag.userId}-${flag.flaggedAt}`}>
                        <TableCell className="font-medium">{flag.userId}</TableCell>
                        <TableCell>
                          <Badge variant="destructive">
                            {flag.flagType}
                          </Badge>
                        </TableCell>
                        <TableCell>{flag.reason}</TableCell>
                        <TableCell>{flag.flaggedAt}</TableCell>
                        <TableCell>
                          <Badge variant={flag.reviewed ? "default" : "destructive"}>
                            {flag.reviewed ? "Reviewed" : "Unreviewed"}
                          </Badge>
                        </TableCell>
                        <TableCell>
                          {!flag.reviewed && (
                            <Button
                              size="sm"
                              variant="outline"
                              onClick={() => handleFlagReview(flag.userId, "admin")}
                            >
                              Mark Reviewed
                            </Button>
                          )}
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="logs">
            <Card>
              <CardHeader>
                <CardTitle>System Logs</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <Button variant="outline" className="h-20">
                      <div className="text-center">
                        <Activity className="h-6 w-6 mx-auto mb-2" />
                        <div>Automation Logs</div>
                      </div>
                    </Button>
                    <Button variant="outline" className="h-20">
                      <div className="text-center">
                        <Award className="h-6 w-6 mx-auto mb-2" />
                        <div>Tier Upgrades</div>
                      </div>
                    </Button>
                    <Button variant="outline" className="h-20">
                      <div className="text-center">
                        <Flag className="h-6 w-6 mx-auto mb-2" />
                        <div>Fraud Logs</div>
                      </div>
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>

        {/* Rejection Dialog */}
        <Dialog open={isRejectDialogOpen} onOpenChange={setIsRejectDialogOpen}>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Reject Ambassador Application</DialogTitle>
              <DialogDescription>
                Please provide a reason for rejecting this ambassador application.
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-4">
              <div>
                <Label htmlFor="rejection-reason">Rejection Reason</Label>
                <Textarea
                  id="rejection-reason"
                  placeholder="Enter rejection reason..."
                  value={rejectionReason}
                  onChange={(e) => setRejectionReason(e.target.value)}
                />
              </div>
            </div>
            <DialogFooter>
              <Button variant="outline" onClick={() => setIsRejectDialogOpen(false)}>
                Cancel
              </Button>
              <Button 
                variant="destructive" 
                onClick={() => selectedAmbassador && handleRejectAmbassador(selectedAmbassador.userId)}
              >
                Reject Application
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>
    </AdminLayout>
  )
} 
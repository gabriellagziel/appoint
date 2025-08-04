"use client"

import { AdminLayout } from "@/components/AdminLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Textarea } from "@/components/ui/textarea"
import { AlertTriangle, Eye, Flag, MessageSquare, Shield, User } from "lucide-react"
import { useState } from "react"

// Mock flag data
const mockFlags = [
  {
    id: 1,
    type: "abuse",
    severity: "high",
    status: "pending",
    reporter: "user123",
    reportedUser: "user456",
    reason: "Inappropriate content in appointment description",
    description: "User posted offensive language in appointment notes",
    timestamp: "2024-01-15 14:30",
    evidence: "Screenshot attached",
  },
  {
    id: 2,
    type: "legal",
    severity: "medium",
    status: "reviewed",
    reporter: "user789",
    reportedUser: "business101",
    reason: "Suspicious business practices",
    description: "Business appears to be operating without proper licensing",
    timestamp: "2024-01-15 12:15",
    evidence: "Documentation provided",
  },
  {
    id: 3,
    type: "spam",
    severity: "low",
    status: "resolved",
    reporter: "system",
    reportedUser: "user202",
    reason: "Automated spam detection",
    description: "Multiple identical appointments created in short time",
    timestamp: "2024-01-15 10:45",
    evidence: "System logs",
  },
  {
    id: 4,
    type: "abuse",
    severity: "high",
    status: "pending",
    reporter: "user303",
    reportedUser: "user404",
    reason: "Harassment in messages",
    description: "User sent threatening messages to another user",
    timestamp: "2024-01-15 09:20",
    evidence: "Message history",
  },
]

export default function FlagsPage() {
  const [selectedFlag, setSelectedFlag] = useState<any>(null)
  const [filterType, setFilterType] = useState("all")
  const [filterStatus, setFilterStatus] = useState("all")
  const [showDetails, setShowDetails] = useState(false)

  const getSeverityColor = (severity: string) => {
    switch (severity) {
      case "high": return "destructive"
      case "medium": return "secondary"
      case "low": return "default"
      default: return "default"
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case "pending": return "secondary"
      case "reviewed": return "default"
      case "resolved": return "default"
      case "dismissed": return "default"
      default: return "default"
    }
  }

  const getTypeIcon = (type: string) => {
    switch (type) {
      case "abuse": return <AlertTriangle className="h-4 w-4 text-red-500" />
      case "legal": return <Shield className="h-4 w-4 text-blue-500" />
      case "spam": return <MessageSquare className="h-4 w-4 text-yellow-500" />
      default: return <Flag className="h-4 w-4 text-gray-500" />
    }
  }

  const filteredFlags = mockFlags.filter(flag => {
    if (filterType !== "all" && flag.type !== filterType) return false
    if (filterStatus !== "all" && flag.status !== filterStatus) return false
    return true
  })

  const handleReviewFlag = (flagId: number, action: string) => {
    console.log(`Reviewing flag ${flagId} with action: ${action}`)
    // In real implementation, update flag status in database
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Flag Management</h1>
          <p className="text-gray-600">Review and manage user reports and flags</p>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Total Flags</CardTitle>
              <Flag className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{mockFlags.length}</div>
              <p className="text-xs text-gray-500">All time</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Pending Review</CardTitle>
              <AlertTriangle className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                {mockFlags.filter(f => f.status === "pending").length}
              </div>
              <p className="text-xs text-gray-500">Requires attention</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">High Severity</CardTitle>
              <Shield className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                {mockFlags.filter(f => f.severity === "high").length}
              </div>
              <p className="text-xs text-gray-500">Critical issues</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Resolved</CardTitle>
              <Eye className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                {mockFlags.filter(f => f.status === "resolved").length}
              </div>
              <p className="text-xs text-gray-500">Completed reviews</p>
            </CardContent>
          </Card>
        </div>

        {/* Filters */}
        <Card>
          <CardHeader>
            <CardTitle>Filters</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex gap-4">
              <div className="flex-1">
                <label className="text-sm font-medium">Type</label>
                <Select value={filterType} onValueChange={setFilterType}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All Types</SelectItem>
                    <SelectItem value="abuse">Abuse</SelectItem>
                    <SelectItem value="legal">Legal</SelectItem>
                    <SelectItem value="spam">Spam</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="flex-1">
                <label className="text-sm font-medium">Status</label>
                <Select value={filterStatus} onValueChange={setFilterStatus}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All Status</SelectItem>
                    <SelectItem value="pending">Pending</SelectItem>
                    <SelectItem value="reviewed">Reviewed</SelectItem>
                    <SelectItem value="resolved">Resolved</SelectItem>
                    <SelectItem value="dismissed">Dismissed</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="flex-1">
                <label className="text-sm font-medium">Search</label>
                <Input placeholder="Search flags..." />
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Flags Table */}
        <Card>
          <CardHeader>
            <CardTitle>Flags</CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>ID</TableHead>
                  <TableHead>Type</TableHead>
                  <TableHead>Severity</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>Reporter</TableHead>
                  <TableHead>Reported User</TableHead>
                  <TableHead>Timestamp</TableHead>
                  <TableHead>Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {filteredFlags.map((flag) => (
                  <TableRow key={flag.id}>
                    <TableCell className="font-medium">#{flag.id}</TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        {getTypeIcon(flag.type)}
                        <span className="capitalize">{flag.type}</span>
                      </div>
                    </TableCell>
                    <TableCell>
                      <Badge variant={getSeverityColor(flag.severity)}>
                        {flag.severity}
                      </Badge>
                    </TableCell>
                    <TableCell>
                      <Badge variant={getStatusColor(flag.status)}>
                        {flag.status}
                      </Badge>
                    </TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        <User className="h-4 w-4" />
                        {flag.reporter}
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        <User className="h-4 w-4" />
                        {flag.reportedUser}
                      </div>
                    </TableCell>
                    <TableCell>{flag.timestamp}</TableCell>
                    <TableCell>
                      <div className="flex space-x-2">
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => {
                            setSelectedFlag(flag)
                            setShowDetails(true)
                          }}
                        >
                          <Eye className="h-4 w-4 mr-1" />
                          Review
                        </Button>
                        {flag.status === "pending" && (
                          <>
                            <Button
                              variant="outline"
                              size="sm"
                              onClick={() => handleReviewFlag(flag.id, "resolve")}
                            >
                              Resolve
                            </Button>
                            <Button
                              variant="outline"
                              size="sm"
                              onClick={() => handleReviewFlag(flag.id, "dismiss")}
                            >
                              Dismiss
                            </Button>
                          </>
                        )}
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>

        {/* Flag Details Modal */}
        {showDetails && selectedFlag && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div className="bg-white rounded-lg p-6 max-w-2xl w-full mx-4 max-h-[80vh] overflow-y-auto">
              <div className="flex items-center justify-between mb-4">
                <h2 className="text-xl font-bold">Flag Details #{selectedFlag.id}</h2>
                <Button variant="outline" onClick={() => setShowDetails(false)}>
                  Close
                </Button>
              </div>

              <div className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="text-sm font-medium">Type</label>
                    <div className="flex items-center gap-2 mt-1">
                      {getTypeIcon(selectedFlag.type)}
                      <span className="capitalize">{selectedFlag.type}</span>
                    </div>
                  </div>
                  <div>
                    <label className="text-sm font-medium">Severity</label>
                    <Badge variant={getSeverityColor(selectedFlag.severity)} className="mt-1">
                      {selectedFlag.severity}
                    </Badge>
                  </div>
                  <div>
                    <label className="text-sm font-medium">Status</label>
                    <Badge variant={getStatusColor(selectedFlag.status)} className="mt-1">
                      {selectedFlag.status}
                    </Badge>
                  </div>
                  <div>
                    <label className="text-sm font-medium">Timestamp</label>
                    <p className="text-sm mt-1">{selectedFlag.timestamp}</p>
                  </div>
                </div>

                <div>
                  <label className="text-sm font-medium">Reason</label>
                  <p className="text-sm mt-1">{selectedFlag.reason}</p>
                </div>

                <div>
                  <label className="text-sm font-medium">Description</label>
                  <p className="text-sm mt-1">{selectedFlag.description}</p>
                </div>

                <div>
                  <label className="text-sm font-medium">Evidence</label>
                  <p className="text-sm mt-1">{selectedFlag.evidence}</p>
                </div>

                <div>
                  <label className="text-sm font-medium">Admin Notes</label>
                  <Textarea
                    placeholder="Add admin notes..."
                    className="mt-1"
                    rows={3}
                  />
                </div>

                <div className="flex gap-2 pt-4">
                  <Button
                    onClick={() => {
                      handleReviewFlag(selectedFlag.id, "resolve")
                      setShowDetails(false)
                    }}
                  >
                    Resolve Flag
                  </Button>
                  <Button
                    variant="outline"
                    onClick={() => {
                      handleReviewFlag(selectedFlag.id, "dismiss")
                      setShowDetails(false)
                    }}
                  >
                    Dismiss Flag
                  </Button>
                  <Button
                    variant="outline"
                    onClick={() => setShowDetails(false)}
                  >
                    Cancel
                  </Button>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </AdminLayout>
  )
} 
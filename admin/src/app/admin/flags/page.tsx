"use client"

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Textarea } from "@/components/ui/textarea";
import { useAuth } from "@/contexts/AuthContext";
import { exportFlags, fetchFlags, getFlagStats, updateFlagStatus, type FlagFilters, type UserFlag } from "@/services/flags_service";
import {
  AlertTriangle,
  Check,
  CheckCircle,
  Clock,
  Download,
  Eye,
  Filter,
  Flag,
  MessageSquare,
  RefreshCw,
  Search,
  Shield,
  X,
  XCircle
} from "lucide-react";
import { useEffect, useState } from 'react';

export default function FlagsPage() {
  const { user: currentUser } = useAuth();
  const [flags, setFlags] = useState<UserFlag[]>([]);
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState<any>(null);
  const [filters, setFilters] = useState<FlagFilters>({});
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedFlag, setSelectedFlag] = useState<UserFlag | null>(null);
  const [showFlagDetails, setShowFlagDetails] = useState(false);
  const [resolveDialog, setResolveDialog] = useState(false);
  const [newStatus, setNewStatus] = useState<'reviewed' | 'ignored' | 'resolved'>('reviewed');
  const [adminNotes, setAdminNotes] = useState('');
  const [actionTaken, setActionTaken] = useState<'none' | 'warning' | 'suspension' | 'ban'>('none');
  const [exporting, setExporting] = useState(false);

  useEffect(() => {
    loadFlags();
    loadStats();
  }, [filters]);

  const loadFlags = async () => {
    try {
      setLoading(true);
      const response = await fetchFlags(filters);
      setFlags(response.flags);
    } catch (error) {
      console.error('Error loading flags:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadStats = async () => {
    try {
      const statsData = await getFlagStats();
      setStats(statsData);
    } catch (error) {
      console.error('Error loading stats:', error);
    }
  };

  const handleSearch = () => {
    setFilters(prev => ({ ...prev, search: searchTerm }));
  };

  const handleStatusFilter = (status: string) => {
    setFilters(prev => ({ ...prev, status: status === 'all' ? undefined : status }));
  };

  const handleCategoryFilter = (category: string) => {
    setFilters(prev => ({ ...prev, category: category === 'all' ? undefined : category }));
  };

  const handleSeverityFilter = (severity: string) => {
    setFilters(prev => ({ ...prev, severity: severity === 'all' ? undefined : severity }));
  };

  const handleFlagAction = (flagId: string, action: 'view' | 'resolve') => {
    const flag = flags.find(f => f.id === flagId);
    if (!flag) return;

    setSelectedFlag(flag);

    if (action === 'view') {
      setShowFlagDetails(true);
    } else if (action === 'resolve') {
      setResolveDialog(true);
    }
  };

  const handleResolveFlag = async () => {
    if (!selectedFlag || !currentUser) return;

    try {
      await updateFlagStatus(selectedFlag.id, newStatus, {
        reviewedBy: currentUser.uid,
        reviewedByEmail: currentUser.email || '',
        adminNotes,
        actionTaken
      });

      // Refresh flags list
      await loadFlags();
      setResolveDialog(false);
      setNewStatus('reviewed');
      setAdminNotes('');
      setActionTaken('none');
    } catch (error) {
      console.error('Error resolving flag:', error);
    }
  };

  const handleExport = async () => {
    try {
      setExporting(true);
      const csvContent = await exportFlags(filters);

      // Create and download CSV file
      const blob = new Blob([csvContent], { type: 'text/csv' });
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `user-flags-${new Date().toISOString().split('T')[0]}.csv`;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      window.URL.revokeObjectURL(url);
    } catch (error) {
      console.error('Error exporting flags:', error);
    } finally {
      setExporting(false);
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'pending': return 'default';
      case 'reviewed': return 'secondary';
      case 'ignored': return 'outline';
      case 'resolved': return 'default';
      default: return 'default';
    }
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'pending': return <Clock className="h-4 w-4 text-yellow-500" />;
      case 'reviewed': return <CheckCircle className="h-4 w-4 text-blue-500" />;
      case 'ignored': return <XCircle className="h-4 w-4 text-gray-500" />;
      case 'resolved': return <Check className="h-4 w-4 text-green-500" />;
      default: return <Clock className="h-4 w-4 text-gray-500" />;
    }
  };

  const getSeverityColor = (severity: string) => {
    switch (severity) {
      case 'critical': return 'destructive';
      case 'high': return 'destructive';
      case 'medium': return 'secondary';
      case 'low': return 'default';
      default: return 'default';
    }
  };

  const getCategoryColor = (category: string) => {
    switch (category) {
      case 'spam': return 'secondary';
      case 'inappropriate': return 'destructive';
      case 'harassment': return 'destructive';
      case 'fake_account': return 'outline';
      case 'other': return 'default';
      default: return 'default';
    }
  };

  const formatDate = (date: Date) => {
    return new Intl.DateTimeFormat('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    }).format(date);
  };

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">User Flags</h1>
            <p className="text-gray-600">Review and manage user flags and moderation actions</p>
          </div>
          <div className="flex items-center space-x-2">
            <Button variant="outline" onClick={() => loadFlags()}>
              <RefreshCw className="h-4 w-4 mr-2" />
              Refresh
            </Button>
            <Button variant="outline" onClick={handleExport} disabled={exporting}>
              <Download className="h-4 w-4 mr-2" />
              {exporting ? 'Exporting...' : 'Export'}
            </Button>
          </div>
        </div>

        {/* Stats Cards */}
        {stats && (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <Card>
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Total Flags</CardTitle>
                <Flag className="h-4 w-4 text-gray-400" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stats.total}</div>
                <p className="text-xs text-gray-500">All user flags</p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Pending</CardTitle>
                <Clock className="h-4 w-4 text-yellow-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stats.pending}</div>
                <p className="text-xs text-gray-500">Awaiting review</p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">This Week</CardTitle>
                <AlertTriangle className="h-4 w-4 text-orange-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stats.thisWeek}</div>
                <p className="text-xs text-gray-500">Flags this week</p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">This Month</CardTitle>
                <Shield className="h-4 w-4 text-purple-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stats.thisMonth}</div>
                <p className="text-xs text-gray-500">Flags this month</p>
              </CardContent>
            </Card>
          </div>
        )}

        {/* Filters */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Filter className="h-5 w-5" />
              Filters
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div>
                <Label htmlFor="search">Search</Label>
                <div className="flex gap-2 mt-1">
                  <Input
                    id="search"
                    placeholder="Search flags..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    onKeyPress={(e) => e.key === 'Enter' && handleSearch()}
                  />
                  <Button onClick={handleSearch}>
                    <Search className="h-4 w-4" />
                  </Button>
                </div>
              </div>

              <div>
                <Label htmlFor="status">Status</Label>
                <Select onValueChange={handleStatusFilter}>
                  <SelectTrigger className="mt-1">
                    <SelectValue placeholder="All statuses" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All statuses</SelectItem>
                    <SelectItem value="pending">Pending</SelectItem>
                    <SelectItem value="reviewed">Reviewed</SelectItem>
                    <SelectItem value="ignored">Ignored</SelectItem>
                    <SelectItem value="resolved">Resolved</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div>
                <Label htmlFor="category">Category</Label>
                <Select onValueChange={handleCategoryFilter}>
                  <SelectTrigger className="mt-1">
                    <SelectValue placeholder="All categories" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All categories</SelectItem>
                    <SelectItem value="spam">Spam</SelectItem>
                    <SelectItem value="inappropriate">Inappropriate</SelectItem>
                    <SelectItem value="harassment">Harassment</SelectItem>
                    <SelectItem value="fake_account">Fake Account</SelectItem>
                    <SelectItem value="other">Other</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div>
                <Label htmlFor="severity">Severity</Label>
                <Select onValueChange={handleSeverityFilter}>
                  <SelectTrigger className="mt-1">
                    <SelectValue placeholder="All severities" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All severities</SelectItem>
                    <SelectItem value="low">Low</SelectItem>
                    <SelectItem value="medium">Medium</SelectItem>
                    <SelectItem value="high">High</SelectItem>
                    <SelectItem value="critical">Critical</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div className="flex justify-end mt-4">
              <Button
                variant="outline"
                onClick={() => setFilters({})}
              >
                <X className="h-4 w-4 mr-2" />
                Clear Filters
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* Flags Table */}
        <Card>
          <CardHeader>
            <CardTitle>User Flags</CardTitle>
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="flex items-center justify-center py-8">
                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
                <span className="ml-2">Loading flags...</span>
              </div>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>User</TableHead>
                    <TableHead>Reason</TableHead>
                    <TableHead>Category</TableHead>
                    <TableHead>Severity</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead>Flagged By</TableHead>
                    <TableHead>Created</TableHead>
                    <TableHead>Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {flags.map((flag) => (
                    <TableRow key={flag.id}>
                      <TableCell>
                        <div className="text-sm">
                          <div className="font-medium">{flag.userEmail || 'Unknown'}</div>
                          <div className="text-gray-500">{flag.userName || 'No name'}</div>
                        </div>
                      </TableCell>
                      <TableCell>
                        <div className="max-w-xs truncate">
                          {flag.reason}
                        </div>
                      </TableCell>
                      <TableCell>
                        <Badge variant={getCategoryColor(flag.category)}>
                          {flag.category.replace('_', ' ')}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <Badge variant={getSeverityColor(flag.severity)}>
                          {flag.severity}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <div className="flex items-center space-x-2">
                          {getStatusIcon(flag.status)}
                          <Badge variant={getStatusColor(flag.status)}>
                            {flag.status}
                          </Badge>
                        </div>
                      </TableCell>
                      <TableCell>
                        <div className="text-sm">
                          <div className="font-medium">{flag.flaggedByEmail || 'Unknown'}</div>
                          <div className="text-gray-500 text-xs">{formatDate(flag.createdAt)}</div>
                        </div>
                      </TableCell>
                      <TableCell className="text-sm text-gray-500">
                        {formatDate(flag.createdAt)}
                      </TableCell>
                      <TableCell>
                        <div className="flex items-center space-x-2">
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleFlagAction(flag.id, 'view')}
                          >
                            <Eye className="h-4 w-4" />
                          </Button>
                          {flag.status === 'pending' && (
                            <Button
                              variant="outline"
                              size="sm"
                              onClick={() => handleFlagAction(flag.id, 'resolve')}
                            >
                              <MessageSquare className="h-4 w-4" />
                            </Button>
                          )}
                        </div>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}

            {flags.length === 0 && !loading && (
              <div className="text-center py-8">
                <Flag className="h-12 w-12 text-gray-400 mx-auto mb-4" />
                <p className="text-gray-500">No flags found</p>
              </div>
            )}
          </CardContent>
        </Card>
      </div>

      {/* Flag Details Dialog */}
      <Dialog open={showFlagDetails} onOpenChange={setShowFlagDetails}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>Flag Details</DialogTitle>
          </DialogHeader>
          {selectedFlag && (
            <div className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label>User</Label>
                  <div className="text-sm">
                    <div className="font-medium">{selectedFlag.userEmail || 'Unknown'}</div>
                    <div className="text-gray-500">{selectedFlag.userName || 'No name'}</div>
                    <div className="text-gray-500 text-xs">ID: {selectedFlag.userId}</div>
                  </div>
                </div>
                <div>
                  <Label>Status</Label>
                  <div className="flex items-center space-x-2">
                    {getStatusIcon(selectedFlag.status)}
                    <Badge variant={getStatusColor(selectedFlag.status)}>
                      {selectedFlag.status}
                    </Badge>
                  </div>
                </div>
                <div>
                  <Label>Category</Label>
                  <Badge variant={getCategoryColor(selectedFlag.category)}>
                    {selectedFlag.category.replace('_', ' ')}
                  </Badge>
                </div>
                <div>
                  <Label>Severity</Label>
                  <Badge variant={getSeverityColor(selectedFlag.severity)}>
                    {selectedFlag.severity}
                  </Badge>
                </div>
              </div>

              <div>
                <Label>Reason</Label>
                <p className="text-sm bg-gray-50 p-3 rounded border">{selectedFlag.reason}</p>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label>Flagged By</Label>
                  <div className="text-sm">
                    <div className="font-medium">{selectedFlag.flaggedByEmail || 'Unknown'}</div>
                    <div className="text-gray-500 text-xs">{selectedFlag.flaggedBy}</div>
                  </div>
                </div>
                <div>
                  <Label>Created</Label>
                  <p className="text-sm">{formatDate(selectedFlag.createdAt)}</p>
                </div>
              </div>

              {selectedFlag.reviewedBy && (
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <Label>Reviewed By</Label>
                    <div className="text-sm">
                      <div className="font-medium">{selectedFlag.reviewedByEmail || 'Unknown'}</div>
                      <div className="text-gray-500 text-xs">{selectedFlag.reviewedBy}</div>
                    </div>
                  </div>
                  <div>
                    <Label>Reviewed At</Label>
                    <p className="text-sm">{selectedFlag.reviewedAt ? formatDate(selectedFlag.reviewedAt) : 'Not reviewed'}</p>
                  </div>
                </div>
              )}

              {selectedFlag.adminNotes && (
                <div>
                  <Label>Admin Notes</Label>
                  <p className="text-sm bg-gray-50 p-3 rounded border">{selectedFlag.adminNotes}</p>
                </div>
              )}

              {selectedFlag.actionTaken && selectedFlag.actionTaken !== 'none' && (
                <div>
                  <Label>Action Taken</Label>
                  <Badge variant="outline">{selectedFlag.actionTaken}</Badge>
                </div>
              )}

              {selectedFlag.evidence && (
                <div>
                  <Label>Evidence</Label>
                  <p className="text-sm bg-gray-50 p-3 rounded border">{selectedFlag.evidence}</p>
                </div>
              )}
            </div>
          )}
        </DialogContent>
      </Dialog>

      {/* Resolve Flag Dialog */}
      <Dialog open={resolveDialog} onOpenChange={setResolveDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Resolve Flag</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div>
              <Label htmlFor="status">New Status</Label>
              <Select value={newStatus} onValueChange={(value: any) => setNewStatus(value)}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="reviewed">Reviewed</SelectItem>
                  <SelectItem value="ignored">Ignored</SelectItem>
                  <SelectItem value="resolved">Resolved</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div>
              <Label htmlFor="actionTaken">Action Taken</Label>
              <Select value={actionTaken} onValueChange={(value: any) => setActionTaken(value)}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="none">No Action</SelectItem>
                  <SelectItem value="warning">Warning</SelectItem>
                  <SelectItem value="suspension">Suspension</SelectItem>
                  <SelectItem value="ban">Ban</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div>
              <Label htmlFor="adminNotes">Admin Notes</Label>
              <Textarea
                id="adminNotes"
                placeholder="Enter admin notes..."
                value={adminNotes}
                onChange={(e) => setAdminNotes(e.target.value)}
                rows={4}
              />
            </div>

            <div className="flex justify-end space-x-2">
              <Button variant="outline" onClick={() => setResolveDialog(false)}>
                Cancel
              </Button>
              <Button onClick={handleResolveFlag}>
                Resolve Flag
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
} 
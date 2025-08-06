"use client"

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import { useAuth } from "@/contexts/AuthContext";
import { getUserFlags, type UserFlag } from "@/services/flags_service";
import { getUserLogs, type SystemLog } from "@/services/logs_service";
import { addModerationNote, fetchUsers, getUserById, getUserStats, updateUserStatus, type User, type UserFilters } from "@/services/users_service";
import {
  Ban,
  CheckCircle,
  Clock,
  Download,
  Eye,
  Filter,
  MessageSquare,
  RefreshCw,
  Search,
  Shield,
  User as UserIcon,
  Users,
  X
} from "lucide-react";
import { useEffect, useState } from 'react';

export default function UsersPage() {
  const { user: currentUser } = useAuth();
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState<any>(null);
  const [filters, setFilters] = useState<UserFilters>({});
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedUser, setSelectedUser] = useState<User | null>(null);
  const [userLogs, setUserLogs] = useState<SystemLog[]>([]);
  const [userFlags, setUserFlags] = useState<UserFlag[]>([]);
  const [showUserDetails, setShowUserDetails] = useState(false);
  const [statusUpdateDialog, setStatusUpdateDialog] = useState(false);
  const [noteDialog, setNoteDialog] = useState(false);
  const [newStatus, setNewStatus] = useState<'active' | 'suspended' | 'banned'>('active');
  const [statusReason, setStatusReason] = useState('');
  const [newNote, setNewNote] = useState('');
  const [suspendedUntil, setSuspendedUntil] = useState('');

  useEffect(() => {
    loadUsers();
    loadStats();
  }, [filters]);

  const loadUsers = async () => {
    try {
      setLoading(true);
      const response = await fetchUsers(filters);
      setUsers(response.users);
    } catch (error) {
      console.error('Error loading users:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadStats = async () => {
    try {
      const statsData = await getUserStats();
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

  const handleRoleFilter = (role: string) => {
    setFilters(prev => ({ ...prev, role: role === 'all' ? undefined : role }));
  };

  const handleUserAction = async (userId: string, action: 'view' | 'edit' | 'status' | 'note') => {
    try {
      const user = await getUserById(userId);
      if (!user) return;

      setSelectedUser(user);

      if (action === 'view') {
        // Load user logs and flags
        const [logs, flags] = await Promise.all([
          getUserLogs(userId),
          getUserFlags(userId)
        ]);
        setUserLogs(logs);
        setUserFlags(flags);
        setShowUserDetails(true);
      } else if (action === 'status') {
        setStatusUpdateDialog(true);
      } else if (action === 'note') {
        setNoteDialog(true);
      }
    } catch (error) {
      console.error('Error handling user action:', error);
    }
  };

  const handleStatusUpdate = async () => {
    if (!selectedUser) return;

    try {
      const suspendedDate = suspendedUntil ? new Date(suspendedUntil) : undefined;
      await updateUserStatus(selectedUser.id, newStatus, statusReason, suspendedDate);

      // Refresh users list
      await loadUsers();
      setStatusUpdateDialog(false);
      setNewStatus('active');
      setStatusReason('');
      setSuspendedUntil('');
    } catch (error) {
      console.error('Error updating user status:', error);
    }
  };

  const handleAddNote = async () => {
    if (!selectedUser || !newNote.trim()) return;

    try {
      await addModerationNote(selectedUser.id, newNote);

      // Refresh users list
      await loadUsers();
      setNoteDialog(false);
      setNewNote('');
    } catch (error) {
      console.error('Error adding note:', error);
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active': return 'default';
      case 'suspended': return 'secondary';
      case 'banned': return 'destructive';
      default: return 'default';
    }
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'active': return <CheckCircle className="h-4 w-4 text-green-500" />;
      case 'suspended': return <Clock className="h-4 w-4 text-yellow-500" />;
      case 'banned': return <Ban className="h-4 w-4 text-red-500" />;
      default: return <UserIcon className="h-4 w-4 text-gray-500" />;
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
            <h1 className="text-3xl font-bold text-gray-900">User Management</h1>
            <p className="text-gray-600">Manage user accounts, status, and moderation</p>
          </div>
          <div className="flex items-center space-x-2">
            <Button variant="outline" onClick={() => loadUsers()}>
              <RefreshCw className="h-4 w-4 mr-2" />
              Refresh
            </Button>
            <Button variant="outline">
              <Download className="h-4 w-4 mr-2" />
              Export
            </Button>
          </div>
        </div>

        {/* Stats Cards */}
        {stats && (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <Card>
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Total Users</CardTitle>
                <Users className="h-4 w-4 text-gray-400" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stats.total}</div>
                <p className="text-xs text-gray-500">All registered users</p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Active Users</CardTitle>
                <CheckCircle className="h-4 w-4 text-green-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stats.active}</div>
                <p className="text-xs text-gray-500">Currently active</p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Suspended</CardTitle>
                <Clock className="h-4 w-4 text-yellow-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stats.suspended}</div>
                <p className="text-xs text-gray-500">Temporarily suspended</p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Banned</CardTitle>
                <Ban className="h-4 w-4 text-red-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stats.banned}</div>
                <p className="text-xs text-gray-500">Permanently banned</p>
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
                    placeholder="Search users..."
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
                    <SelectItem value="active">Active</SelectItem>
                    <SelectItem value="suspended">Suspended</SelectItem>
                    <SelectItem value="banned">Banned</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div>
                <Label htmlFor="role">Role</Label>
                <Select onValueChange={handleRoleFilter}>
                  <SelectTrigger className="mt-1">
                    <SelectValue placeholder="All roles" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All roles</SelectItem>
                    <SelectItem value="user">User</SelectItem>
                    <SelectItem value="admin">Admin</SelectItem>
                    <SelectItem value="moderator">Moderator</SelectItem>
                    <SelectItem value="business">Business</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="flex items-end">
                <Button
                  variant="outline"
                  onClick={() => setFilters({})}
                  className="w-full"
                >
                  <X className="h-4 w-4 mr-2" />
                  Clear Filters
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Users Table */}
        <Card>
          <CardHeader>
            <CardTitle>Users</CardTitle>
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="flex items-center justify-center py-8">
                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
                <span className="ml-2">Loading users...</span>
              </div>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>User</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead>Role</TableHead>
                    <TableHead>Created</TableHead>
                    <TableHead>Last Active</TableHead>
                    <TableHead>Flags</TableHead>
                    <TableHead>Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {users.map((user) => (
                    <TableRow key={user.id}>
                      <TableCell>
                        <div className="flex items-center space-x-3">
                          <div className="h-8 w-8 rounded-full bg-gray-200 flex items-center justify-center">
                            {user.photoURL ? (
                              <img src={user.photoURL} alt="" className="h-8 w-8 rounded-full" />
                            ) : (
                              <UserIcon className="h-4 w-4 text-gray-500" />
                            )}
                          </div>
                          <div>
                            <div className="font-medium">{user.displayName || 'No name'}</div>
                            <div className="text-sm text-gray-500">{user.email}</div>
                          </div>
                        </div>
                      </TableCell>
                      <TableCell>
                        <div className="flex items-center space-x-2">
                          {getStatusIcon(user.status)}
                          <Badge variant={getStatusColor(user.status)}>
                            {user.status}
                          </Badge>
                        </div>
                      </TableCell>
                      <TableCell>
                        <Badge variant="outline">{user.role}</Badge>
                      </TableCell>
                      <TableCell className="text-sm text-gray-500">
                        {formatDate(user.createdAt)}
                      </TableCell>
                      <TableCell className="text-sm text-gray-500">
                        {user.lastActive ? formatDate(user.lastActive) : 'Never'}
                      </TableCell>
                      <TableCell>
                        {(user.flags || 0) > 0 ? (
                          <Badge variant="destructive">{user.flags}</Badge>
                        ) : (
                          <span className="text-gray-400">0</span>
                        )}
                      </TableCell>
                      <TableCell>
                        <div className="flex items-center space-x-2">
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleUserAction(user.id, 'view')}
                          >
                            <Eye className="h-4 w-4" />
                          </Button>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleUserAction(user.id, 'status')}
                          >
                            <Shield className="h-4 w-4" />
                          </Button>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleUserAction(user.id, 'note')}
                          >
                            <MessageSquare className="h-4 w-4" />
                          </Button>
                        </div>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </CardContent>
        </Card>
      </div>

      {/* User Details Dialog */}
      <Dialog open={showUserDetails} onOpenChange={setShowUserDetails}>
        <DialogContent className="max-w-4xl max-h-[80vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>User Details - {selectedUser?.displayName || selectedUser?.email}</DialogTitle>
          </DialogHeader>
          {selectedUser && (
            <Tabs defaultValue="profile" className="w-full">
              <TabsList>
                <TabsTrigger value="profile">Profile</TabsTrigger>
                <TabsTrigger value="logs">Activity Logs</TabsTrigger>
                <TabsTrigger value="flags">Flags</TabsTrigger>
                <TabsTrigger value="notes">Moderation Notes</TabsTrigger>
              </TabsList>

              <TabsContent value="profile" className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <Label>Email</Label>
                    <p className="text-sm">{selectedUser.email}</p>
                  </div>
                  <div>
                    <Label>Display Name</Label>
                    <p className="text-sm">{selectedUser.displayName || 'Not set'}</p>
                  </div>
                  <div>
                    <Label>Status</Label>
                    <div className="flex items-center space-x-2">
                      {getStatusIcon(selectedUser.status)}
                      <Badge variant={getStatusColor(selectedUser.status)}>
                        {selectedUser.status}
                      </Badge>
                    </div>
                  </div>
                  <div>
                    <Label>Role</Label>
                    <Badge variant="outline">{selectedUser.role}</Badge>
                  </div>
                  <div>
                    <Label>Created</Label>
                    <p className="text-sm">{formatDate(selectedUser.createdAt)}</p>
                  </div>
                  <div>
                    <Label>Last Active</Label>
                    <p className="text-sm">{selectedUser.lastActive ? formatDate(selectedUser.lastActive) : 'Never'}</p>
                  </div>
                  {selectedUser.suspendedUntil && (
                    <div>
                      <Label>Suspended Until</Label>
                      <p className="text-sm">{formatDate(selectedUser.suspendedUntil)}</p>
                    </div>
                  )}
                  {selectedUser.banReason && (
                    <div>
                      <Label>Ban Reason</Label>
                      <p className="text-sm">{selectedUser.banReason}</p>
                    </div>
                  )}
                </div>
              </TabsContent>

              <TabsContent value="logs" className="space-y-4">
                <h3 className="font-semibold">Recent Activity</h3>
                <div className="space-y-2">
                  {userLogs.map((log) => (
                    <div key={log.id} className="p-3 border rounded-lg">
                      <div className="flex justify-between items-start">
                        <div>
                          <p className="font-medium">{log.action}</p>
                          <p className="text-sm text-gray-500">{formatDate(log.timestamp)}</p>
                        </div>
                        <Badge variant="outline">{log.severity}</Badge>
                      </div>
                      {log.context && (
                        <p className="text-sm text-gray-600 mt-2">
                          {JSON.stringify(log.context, null, 2)}
                        </p>
                      )}
                    </div>
                  ))}
                  {userLogs.length === 0 && (
                    <p className="text-gray-500 text-center py-4">No activity logs found</p>
                  )}
                </div>
              </TabsContent>

              <TabsContent value="flags" className="space-y-4">
                <h3 className="font-semibold">User Flags</h3>
                <div className="space-y-2">
                  {userFlags.map((flag) => (
                    <div key={flag.id} className="p-3 border rounded-lg">
                      <div className="flex justify-between items-start">
                        <div>
                          <p className="font-medium">{flag.reason}</p>
                          <p className="text-sm text-gray-500">
                            {formatDate(flag.createdAt)} • {flag.category}
                          </p>
                        </div>
                        <Badge variant={flag.status === 'pending' ? 'default' : 'secondary'}>
                          {flag.status}
                        </Badge>
                      </div>
                      {flag.adminNotes && (
                        <p className="text-sm text-gray-600 mt-2">{flag.adminNotes}</p>
                      )}
                    </div>
                  ))}
                  {userFlags.length === 0 && (
                    <p className="text-gray-500 text-center py-4">No flags found</p>
                  )}
                </div>
              </TabsContent>

              <TabsContent value="notes" className="space-y-4">
                <h3 className="font-semibold">Moderation Notes</h3>
                {selectedUser.moderationNotes ? (
                  <div className="p-3 border rounded-lg bg-gray-50">
                    <pre className="text-sm whitespace-pre-wrap">{selectedUser.moderationNotes}</pre>
                  </div>
                ) : (
                  <p className="text-gray-500 text-center py-4">No moderation notes</p>
                )}
              </TabsContent>
            </Tabs>
          )}
        </DialogContent>
      </Dialog>

      {/* Status Update Dialog */}
      <Dialog open={statusUpdateDialog} onOpenChange={setStatusUpdateDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Update User Status</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div>
              <Label htmlFor="status">New Status</Label>
              <Select value={newStatus} onValueChange={(value: any) => setNewStatus(value)}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="active">Active</SelectItem>
                  <SelectItem value="suspended">Suspended</SelectItem>
                  <SelectItem value="banned">Banned</SelectItem>
                </SelectContent>
              </Select>
            </div>

            {newStatus === 'suspended' && (
              <div>
                <Label htmlFor="suspendedUntil">Suspended Until</Label>
                <Input
                  id="suspendedUntil"
                  type="datetime-local"
                  value={suspendedUntil}
                  onChange={(e) => setSuspendedUntil(e.target.value)}
                />
              </div>
            )}

            <div>
              <Label htmlFor="reason">Reason</Label>
              <Textarea
                id="reason"
                placeholder="Enter reason for status change..."
                value={statusReason}
                onChange={(e) => setStatusReason(e.target.value)}
              />
            </div>

            <div className="flex justify-end space-x-2">
              <Button variant="outline" onClick={() => setStatusUpdateDialog(false)}>
                Cancel
              </Button>
              <Button onClick={handleStatusUpdate}>
                Update Status
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>

      {/* Add Note Dialog */}
      <Dialog open={noteDialog} onOpenChange={setNoteDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Add Moderation Note</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div>
              <Label htmlFor="note">Note</Label>
              <Textarea
                id="note"
                placeholder="Enter moderation note..."
                value={newNote}
                onChange={(e) => setNewNote(e.target.value)}
                rows={4}
              />
            </div>

            <div className="flex justify-end space-x-2">
              <Button variant="outline" onClick={() => setNoteDialog(false)}>
                Cancel
              </Button>
              <Button onClick={handleAddNote}>
                Add Note
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
} 
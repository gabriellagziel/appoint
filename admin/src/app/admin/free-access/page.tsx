'use client';

import { useState, useEffect } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { 
  Table, 
  TableBody, 
  TableCell, 
  TableHead, 
  TableHeader, 
  TableRow 
} from '@/components/ui/table';
import { 
  Select, 
  SelectContent, 
  SelectItem, 
  SelectTrigger, 
  SelectValue 
} from '@/components/ui/select';
import { 
  Dialog, 
  DialogContent, 
  DialogHeader, 
  DialogTitle, 
  DialogTrigger 
} from '@/components/ui/dialog';
import { 
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@/components/ui/alert-dialog';
import { 
  Users, 
  Building2, 
  Key, 
  Calendar, 
  AlertTriangle,
  Plus,
  Search,
  Filter,
  MoreHorizontal,
  Eye,
  X
} from 'lucide-react';
import { freeAccessService, FreeAccessGrant } from '@/services/free_access_service';
import { useAuth } from '@/hooks/useAuth';
import { toast } from 'sonner';

export default function FreeAccessPage() {
  const { user } = useAuth();
  const [grants, setGrants] = useState<FreeAccessGrant[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState<string>('all');
  const [filterStatus, setFilterStatus] = useState<string>('all');
  const [revokeDialog, setRevokeDialog] = useState<{
    open: boolean;
    grant: FreeAccessGrant | null;
    reason: string;
  }>({ open: false, grant: null, reason: '' });

  // Check if user has super_admin permissions
  const isSuperAdmin = user?.claims?.super_admin === true;

  useEffect(() => {
    loadGrants();
  }, []);

  const loadGrants = async () => {
    try {
      setLoading(true);
      const activeGrants = await freeAccessService.getActiveGrants();
      setGrants(activeGrants);
    } catch (error) {
      console.error('Failed to load grants:', error);
      toast.error('Failed to load free access grants');
    } finally {
      setLoading(false);
    }
  };

  const handleRevoke = async () => {
    if (!revokeDialog.grant || !revokeDialog.reason.trim()) {
      toast.error('Please provide a reason for revocation');
      return;
    }

    try {
      await freeAccessService.revokeFreeAccess(
        user!.uid,
        revokeDialog.grant.id,
        { reason: revokeDialog.reason }
      );
      
      toast.success('Free access revoked successfully');
      setRevokeDialog({ open: false, grant: null, reason: '' });
      loadGrants(); // Refresh the list
    } catch (error) {
      console.error('Failed to revoke grant:', error);
      toast.error('Failed to revoke free access');
    }
  };

  const filteredGrants = grants.filter(grant => {
    const matchesSearch = 
      grant.targetId.toLowerCase().includes(searchTerm.toLowerCase()) ||
      grant.reason.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesType = filterType === 'all' || grant.targetType === filterType;
    const matchesStatus = filterStatus === 'all' || grant.status === filterStatus;
    
    return matchesSearch && matchesType && matchesStatus;
  });

  const getTargetTypeIcon = (type: string) => {
    switch (type) {
      case 'personal': return <Users className="w-4 h-4" />;
      case 'business': return <Building2 className="w-4 h-4" />;
      case 'enterprise': return <Key className="w-4 h-4" />;
      default: return null;
    }
  };

  const getStatusBadge = (grant: FreeAccessGrant) => {
    const now = new Date();
    const expiresAt = grant.expiresAt?.toDate();
    
    if (!expiresAt) {
      return <Badge variant="default">PERMANENT</Badge>;
    }
    
    if (expiresAt < now) {
      return <Badge variant="destructive">EXPIRED</Badge>;
    }
    
    const daysUntilExpiry = Math.ceil((expiresAt.getTime() - now.getTime()) / (1000 * 60 * 60 * 24));
    
    if (daysUntilExpiry <= 7) {
      return <Badge variant="destructive">EXPIRES {daysUntilExpiry}d</Badge>;
    } else if (daysUntilExpiry <= 30) {
      return <Badge variant="secondary">EXPIRES {daysUntilExpiry}d</Badge>;
    } else {
      return <Badge variant="outline">EXPIRES {daysUntilExpiry}d</Badge>;
    }
  };

  const getStats = () => {
    const total = grants.length;
    const personal = grants.filter(g => g.targetType === 'personal').length;
    const business = grants.filter(g => g.targetType === 'business').length;
    const enterprise = grants.filter(g => g.targetType === 'enterprise').length;
    const expiringSoon = grants.filter(g => {
      const expiresAt = g.expiresAt?.toDate();
      if (!expiresAt) return false;
      const daysUntilExpiry = Math.ceil((expiresAt.getTime() - new Date().getTime()) / (1000 * 60 * 60 * 24));
      return daysUntilExpiry <= 7;
    }).length;

    return { total, personal, business, enterprise, expiringSoon };
  };

  const stats = getStats();

  if (!isSuperAdmin) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <AlertTriangle className="w-12 h-12 text-destructive mx-auto mb-4" />
          <h2 className="text-xl font-semibold mb-2">Access Denied</h2>
          <p className="text-muted-foreground">
            You need super admin permissions to access free access management.
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold">Free Access Management</h1>
          <p className="text-muted-foreground">
            Grant and manage free access to personal users, business accounts, and enterprise clients.
          </p>
        </div>
        <Dialog>
          <DialogTrigger asChild>
            <Button>
              <Plus className="w-4 h-4 mr-2" />
              Grant Free Access
            </Button>
          </DialogTrigger>
          <DialogContent className="max-w-2xl">
            <DialogHeader>
              <DialogTitle>Grant Free Access</DialogTitle>
            </DialogHeader>
            {/* Grant form would go here */}
            <div className="text-center py-8">
              <p className="text-muted-foreground">
                Grant form component will be implemented here.
              </p>
            </div>
          </DialogContent>
        </Dialog>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Active</CardTitle>
            <Users className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.total}</div>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Personal</CardTitle>
            <Users className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.personal}</div>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Business</CardTitle>
            <Building2 className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.business}</div>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Enterprise</CardTitle>
            <Key className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.enterprise}</div>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Expiring Soon</CardTitle>
            <AlertTriangle className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-destructive">{stats.expiringSoon}</div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <Card>
        <CardHeader>
          <CardTitle>Active Grants</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="flex flex-col sm:flex-row gap-4 mb-6">
            <div className="flex-1">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground w-4 h-4" />
                <Input
                  placeholder="Search by target ID or reason..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10"
                />
              </div>
            </div>
            
            <Select value={filterType} onValueChange={setFilterType}>
              <SelectTrigger className="w-[180px]">
                <SelectValue placeholder="Filter by type" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All Types</SelectItem>
                <SelectItem value="personal">Personal</SelectItem>
                <SelectItem value="business">Business</SelectItem>
                <SelectItem value="enterprise">Enterprise</SelectItem>
              </SelectContent>
            </Select>
            
            <Select value={filterStatus} onValueChange={setFilterStatus}>
              <SelectTrigger className="w-[180px]">
                <SelectValue placeholder="Filter by status" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All Status</SelectItem>
                <SelectItem value="active">Active</SelectItem>
                <SelectItem value="expired">Expired</SelectItem>
                <SelectItem value="revoked">Revoked</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {/* Grants Table */}
          <div className="rounded-md border">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Target</TableHead>
                  <TableHead>Type</TableHead>
                  <TableHead>Reason</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>Created</TableHead>
                  <TableHead>Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {loading ? (
                  <TableRow>
                    <TableCell colSpan={6} className="text-center py-8">
                      Loading grants...
                    </TableCell>
                  </TableRow>
                ) : filteredGrants.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={6} className="text-center py-8">
                      No grants found
                    </TableCell>
                  </TableRow>
                ) : (
                  filteredGrants.map((grant) => (
                    <TableRow key={grant.id}>
                      <TableCell className="font-mono text-sm">
                        {grant.targetId}
                      </TableCell>
                      <TableCell>
                        <div className="flex items-center gap-2">
                          {getTargetTypeIcon(grant.targetType)}
                          <span className="capitalize">{grant.targetType}</span>
                        </div>
                      </TableCell>
                      <TableCell className="max-w-xs truncate">
                        {grant.reason}
                      </TableCell>
                      <TableCell>
                        {getStatusBadge(grant)}
                      </TableCell>
                      <TableCell>
                        {grant.createdAt?.toDate().toLocaleDateString()}
                      </TableCell>
                      <TableCell>
                        <div className="flex items-center gap-2">
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => {
                              // View grant details
                            }}
                          >
                            <Eye className="w-4 h-4" />
                          </Button>
                          
                          <AlertDialog
                            open={revokeDialog.open && revokeDialog.grant?.id === grant.id}
                            onOpenChange={(open) => {
                              if (!open) {
                                setRevokeDialog({ open: false, grant: null, reason: '' });
                              }
                            }}
                          >
                            <AlertDialogTrigger asChild>
                              <Button
                                variant="ghost"
                                size="sm"
                                onClick={() => {
                                  setRevokeDialog({ 
                                    open: true, 
                                    grant, 
                                    reason: '' 
                                  });
                                }}
                              >
                                <X className="w-4 h-4" />
                              </Button>
                            </AlertDialogTrigger>
                            <AlertDialogContent>
                              <AlertDialogHeader>
                                <AlertDialogTitle>Revoke Free Access</AlertDialogTitle>
                                <AlertDialogDescription>
                                  Are you sure you want to revoke free access for {grant.targetId}? 
                                  This action cannot be undone.
                                </AlertDialogDescription>
                              </AlertDialogHeader>
                              <div className="space-y-4">
                                <div>
                                  <label className="text-sm font-medium">Reason for revocation</label>
                                  <Input
                                    value={revokeDialog.reason}
                                    onChange={(e) => setRevokeDialog(prev => ({
                                      ...prev,
                                      reason: e.target.value
                                    }))}
                                    placeholder="Enter reason for revocation..."
                                  />
                                </div>
                              </div>
                              <AlertDialogFooter>
                                <AlertDialogCancel>Cancel</AlertDialogCancel>
                                <AlertDialogAction
                                  onClick={handleRevoke}
                                  className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
                                >
                                  Revoke Access
                                </AlertDialogAction>
                              </AlertDialogFooter>
                            </AlertDialogContent>
                          </AlertDialog>
                        </div>
                      </TableCell>
                    </TableRow>
                  ))
                )}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}

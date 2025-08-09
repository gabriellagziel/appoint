'use client';

import { useState, useEffect } from 'react';
import { useParams } from 'next/navigation';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
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
  Crown, 
  Calendar, 
  AlertTriangle,
  Plus,
  X,
  ArrowLeft
} from 'lucide-react';
import { freeAccessService, FreeAccessGrant } from '@/services/free_access_service';
import { useAuth } from '@/hooks/useAuth';
import { GrantForm } from '@/components/free-access/GrantForm';
import { GrantHistory } from '@/components/free-access/GrantHistory';
import { toast } from 'sonner';
import Link from 'next/link';

export default function UserFreeAccessPage() {
  const params = useParams();
  const userId = params.id as string;
  const { user } = useAuth();
  const [activeGrant, setActiveGrant] = useState<FreeAccessGrant | null>(null);
  const [loading, setLoading] = useState(true);
  const [grantDialogOpen, setGrantDialogOpen] = useState(false);
  const [revokeDialog, setRevokeDialog] = useState<{
    open: boolean;
    reason: string;
  }>({ open: false, reason: '' });

  const isSuperAdmin = user?.claims?.super_admin === true;

  useEffect(() => {
    loadActiveGrant();
  }, [userId]);

  const loadActiveGrant = async () => {
    try {
      setLoading(true);
      const grant = await freeAccessService.getActiveGrant('personal', userId);
      setActiveGrant(grant);
    } catch (error) {
      console.error('Failed to load active grant:', error);
      toast.error('Failed to load free access status');
    } finally {
      setLoading(false);
    }
  };

  const handleGrantSuccess = () => {
    setGrantDialogOpen(false);
    loadActiveGrant();
    toast.success('Free access granted successfully');
  };

  const handleRevoke = async () => {
    if (!activeGrant || !revokeDialog.reason.trim()) {
      toast.error('Please provide a reason for revocation');
      return;
    }

    try {
      await freeAccessService.revokeFreeAccess(
        user!.uid,
        activeGrant.id,
        { reason: revokeDialog.reason }
      );
      
      toast.success('Free access revoked successfully');
      setRevokeDialog({ open: false, reason: '' });
      loadActiveGrant(); // Refresh the status
    } catch (error) {
      console.error('Failed to revoke grant:', error);
      toast.error('Failed to revoke free access');
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

  if (!isSuperAdmin) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <AlertTriangle className="w-12 h-12 text-destructive mx-auto mb-4" />
          <h2 className="text-xl font-semibold mb-2">Access Denied</h2>
          <p className="text-muted-foreground">
            You need super admin permissions to manage free access.
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Link href="/admin/users">
            <Button variant="ghost" size="sm">
              <ArrowLeft className="w-4 h-4 mr-2" />
              Back to Users
            </Button>
          </Link>
          <div>
            <h1 className="text-3xl font-bold">Free Access Management</h1>
            <p className="text-muted-foreground">
              Manage free access for user: <code className="bg-muted px-1 rounded">{userId}</code>
            </p>
          </div>
        </div>
      </div>

      {/* Current Status */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Crown className="w-5 h-5" />
            Current Free Access Status
          </CardTitle>
        </CardHeader>
        <CardContent>
          {loading ? (
            <div className="text-center py-8">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto mb-4"></div>
              <p className="text-muted-foreground">Loading status...</p>
            </div>
          ) : activeGrant ? (
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <Users className="w-5 h-5 text-green-500" />
                  <span className="font-semibold">Active Free Access</span>
                  {getStatusBadge(activeGrant)}
                </div>
                
                <AlertDialog
                  open={revokeDialog.open}
                  onOpenChange={(open) => {
                    if (!open) {
                      setRevokeDialog({ open: false, reason: '' });
                    }
                  }}
                >
                  <AlertDialogTrigger asChild>
                    <Button variant="destructive" size="sm">
                      <X className="w-4 h-4 mr-2" />
                      Revoke Access
                    </Button>
                  </AlertDialogTrigger>
                  <AlertDialogContent>
                    <AlertDialogHeader>
                      <AlertDialogTitle>Revoke Free Access</AlertDialogTitle>
                      <AlertDialogDescription>
                        Are you sure you want to revoke free access for this user? 
                        This action cannot be undone.
                      </AlertDialogDescription>
                    </AlertDialogHeader>
                    <div className="space-y-4">
                      <div>
                        <label className="text-sm font-medium">Reason for revocation</label>
                        <input
                          type="text"
                          value={revokeDialog.reason}
                          onChange={(e) => setRevokeDialog(prev => ({
                            ...prev,
                            reason: e.target.value
                          }))}
                          placeholder="Enter reason for revocation..."
                          className="w-full mt-1 px-3 py-2 border border-input rounded-md"
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

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Granted</label>
                  <div className="text-sm mt-1">
                    {activeGrant.createdAt?.toDate().toLocaleDateString()} by {activeGrant.createdBy}
                  </div>
                </div>
                
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Expires</label>
                  <div className="text-sm mt-1">
                    {activeGrant.expiresAt ? 
                      activeGrant.expiresAt.toDate().toLocaleDateString() : 
                      'Never (Permanent)'
                    }
                  </div>
                </div>
              </div>

              <div>
                <label className="text-sm font-medium text-muted-foreground">Reason</label>
                <div className="text-sm mt-1 p-3 bg-muted rounded-md">
                  {activeGrant.reason}
                </div>
              </div>

              {activeGrant.overrideNote && (
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Notes</label>
                  <div className="text-sm mt-1 p-3 bg-muted rounded-md">
                    {activeGrant.overrideNote}
                  </div>
                </div>
              )}

              <div>
                <label className="text-sm font-medium text-muted-foreground">Applied Changes</label>
                <div className="text-sm mt-1 p-3 bg-muted rounded-md">
                  <pre className="whitespace-pre-wrap">
                    {JSON.stringify(activeGrant.fieldsApplied, null, 2)}
                  </pre>
                </div>
              </div>
            </div>
          ) : (
            <div className="text-center py-8">
              <Users className="w-12 h-12 mx-auto mb-4 text-muted-foreground" />
              <h3 className="text-lg font-semibold mb-2">No Active Free Access</h3>
              <p className="text-muted-foreground mb-4">
                This user does not have any active free access grants.
              </p>
              
              <Dialog open={grantDialogOpen} onOpenChange={setGrantDialogOpen}>
                <DialogTrigger asChild>
                  <Button>
                    <Plus className="w-4 h-4 mr-2" />
                    Grant Free Access
                  </Button>
                </DialogTrigger>
                <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
                  <DialogHeader>
                    <DialogTitle>Grant Free Access</DialogTitle>
                  </DialogHeader>
                  <GrantForm
                    targetType="personal"
                    targetId={userId}
                    onSuccess={handleGrantSuccess}
                    onCancel={() => setGrantDialogOpen(false)}
                  />
                </DialogContent>
              </Dialog>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Grant History */}
      <GrantHistory targetType="personal" targetId={userId} />
    </div>
  );
}

'use client';

import { useState, useEffect } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { 
  Table, 
  TableBody, 
  TableCell, 
  TableHead, 
  TableHeader, 
  TableRow 
} from '@/components/ui/table';
import { Button } from '@/components/ui/button';
import { 
  Dialog, 
  DialogContent, 
  DialogHeader, 
  DialogTitle, 
  DialogTrigger 
} from '@/components/ui/dialog';
import { 
  Clock, 
  CheckCircle, 
  XCircle, 
  AlertTriangle,
  Eye,
  Calendar
} from 'lucide-react';
import { freeAccessService, FreeAccessGrant } from '@/services/free_access_service';
import { format } from 'date-fns';

interface GrantHistoryProps {
  targetType: 'personal' | 'business' | 'enterprise';
  targetId: string;
}

export function GrantHistory({ targetType, targetId }: GrantHistoryProps) {
  const [grants, setGrants] = useState<FreeAccessGrant[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedGrant, setSelectedGrant] = useState<FreeAccessGrant | null>(null);

  useEffect(() => {
    loadGrantHistory();
  }, [targetType, targetId]);

  const loadGrantHistory = async () => {
    try {
      setLoading(true);
      const history = await freeAccessService.getGrantHistory(targetType, targetId);
      setGrants(history);
    } catch (error) {
      console.error('Failed to load grant history:', error);
    } finally {
      setLoading(false);
    }
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'active':
        return <CheckCircle className="w-4 h-4 text-green-500" />;
      case 'revoked':
        return <XCircle className="w-4 h-4 text-red-500" />;
      case 'expired':
        return <AlertTriangle className="w-4 h-4 text-yellow-500" />;
      default:
        return <Clock className="w-4 h-4 text-gray-500" />;
    }
  };

  const getStatusBadge = (grant: FreeAccessGrant) => {
    const now = new Date();
    const expiresAt = grant.expiresAt?.toDate();
    
    if (grant.status === 'active') {
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
    }
    
    return <Badge variant="outline" className="capitalize">{grant.status}</Badge>;
  };

  const getTargetTypeLabel = (type: string) => {
    switch (type) {
      case 'personal': return 'Personal User';
      case 'business': return 'Business Account';
      case 'enterprise': return 'Enterprise Client';
      default: return type;
    }
  };

  const formatFieldsApplied = (fields: Record<string, any>) => {
    return Object.entries(fields)
      .filter(([key]) => key !== 'overrideNote') // Don't show notes in summary
      .map(([key, value]) => {
        if (key === 'freeUntil' && value) {
          return `${key}: ${format(value.toDate(), 'PPP')}`;
        }
        if (value === true) return `${key}: enabled`;
        if (value === false) return `${key}: disabled`;
        if (value === -1) return `${key}: unlimited`;
        if (Array.isArray(value)) return `${key}: ${value.join(', ')}`;
        return `${key}: ${value}`;
      })
      .join(', ');
  };

  if (loading) {
    return (
      <Card>
        <CardHeader>
          <CardTitle>Grant History</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="text-center py-8">
            <Clock className="w-8 h-8 mx-auto mb-4 text-muted-foreground animate-spin" />
            <p className="text-muted-foreground">Loading grant history...</p>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Calendar className="w-5 h-5" />
          Grant History
          <Badge variant="outline" className="ml-auto">
            {grants.length} {grants.length === 1 ? 'grant' : 'grants'}
          </Badge>
        </CardTitle>
      </CardHeader>
      <CardContent>
        {grants.length === 0 ? (
          <div className="text-center py-8">
            <Clock className="w-12 h-12 mx-auto mb-4 text-muted-foreground" />
            <h3 className="text-lg font-semibold mb-2">No Grant History</h3>
            <p className="text-muted-foreground">
              No free access grants have been made for this {getTargetTypeLabel(targetType).toLowerCase()}.
            </p>
          </div>
        ) : (
          <div className="space-y-4">
            <div className="rounded-md border">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Status</TableHead>
                    <TableHead>Granted</TableHead>
                    <TableHead>Expires</TableHead>
                    <TableHead>Reason</TableHead>
                    <TableHead>Changes</TableHead>
                    <TableHead>Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {grants.map((grant) => (
                    <TableRow key={grant.id}>
                      <TableCell>
                        <div className="flex items-center gap-2">
                          {getStatusIcon(grant.status)}
                          {getStatusBadge(grant)}
                        </div>
                      </TableCell>
                      <TableCell>
                        <div className="text-sm">
                          <div>{format(grant.createdAt.toDate(), 'MMM dd, yyyy')}</div>
                          <div className="text-muted-foreground">
                            by {grant.createdBy}
                          </div>
                        </div>
                      </TableCell>
                      <TableCell>
                        {grant.expiresAt ? (
                          <div className="text-sm">
                            {format(grant.expiresAt.toDate(), 'MMM dd, yyyy')}
                          </div>
                        ) : (
                          <span className="text-muted-foreground text-sm">Never</span>
                        )}
                      </TableCell>
                      <TableCell className="max-w-xs">
                        <div className="truncate" title={grant.reason}>
                          {grant.reason}
                        </div>
                      </TableCell>
                      <TableCell className="max-w-xs">
                        <div className="text-sm text-muted-foreground truncate" title={formatFieldsApplied(grant.fieldsApplied)}>
                          {formatFieldsApplied(grant.fieldsApplied)}
                        </div>
                      </TableCell>
                      <TableCell>
                        <Dialog>
                          <DialogTrigger asChild>
                            <Button
                              variant="ghost"
                              size="sm"
                              onClick={() => setSelectedGrant(grant)}
                            >
                              <Eye className="w-4 h-4" />
                            </Button>
                          </DialogTrigger>
                          <DialogContent className="max-w-2xl">
                            <DialogHeader>
                              <DialogTitle>Grant Details</DialogTitle>
                            </DialogHeader>
                            {selectedGrant && (
                              <div className="space-y-4">
                                <div className="grid grid-cols-2 gap-4">
                                  <div>
                                    <label className="text-sm font-medium text-muted-foreground">Status</label>
                                    <div className="flex items-center gap-2 mt-1">
                                      {getStatusIcon(selectedGrant.status)}
                                      {getStatusBadge(selectedGrant)}
                                    </div>
                                  </div>
                                  <div>
                                    <label className="text-sm font-medium text-muted-foreground">Grant ID</label>
                                    <div className="font-mono text-sm mt-1">{selectedGrant.id}</div>
                                  </div>
                                </div>

                                <div className="grid grid-cols-2 gap-4">
                                  <div>
                                    <label className="text-sm font-medium text-muted-foreground">Created</label>
                                    <div className="text-sm mt-1">
                                      {format(selectedGrant.createdAt.toDate(), 'PPP p')}
                                    </div>
                                  </div>
                                  <div>
                                    <label className="text-sm font-medium text-muted-foreground">Created By</label>
                                    <div className="font-mono text-sm mt-1">{selectedGrant.createdBy}</div>
                                  </div>
                                </div>

                                {selectedGrant.expiresAt && (
                                  <div>
                                    <label className="text-sm font-medium text-muted-foreground">Expires</label>
                                    <div className="text-sm mt-1">
                                      {format(selectedGrant.expiresAt.toDate(), 'PPP p')}
                                    </div>
                                  </div>
                                )}

                                <div>
                                  <label className="text-sm font-medium text-muted-foreground">Reason</label>
                                  <div className="text-sm mt-1 p-3 bg-muted rounded-md">
                                    {selectedGrant.reason}
                                  </div>
                                </div>

                                {selectedGrant.overrideNote && (
                                  <div>
                                    <label className="text-sm font-medium text-muted-foreground">Notes</label>
                                    <div className="text-sm mt-1 p-3 bg-muted rounded-md">
                                      {selectedGrant.overrideNote}
                                    </div>
                                  </div>
                                )}

                                <div>
                                  <label className="text-sm font-medium text-muted-foreground">Applied Changes</label>
                                  <div className="mt-1 p-3 bg-muted rounded-md">
                                    <pre className="text-sm whitespace-pre-wrap">
                                      {JSON.stringify(selectedGrant.fieldsApplied, null, 2)}
                                    </pre>
                                  </div>
                                </div>

                                {selectedGrant.status === 'revoked' && (
                                  <div className="grid grid-cols-2 gap-4">
                                    <div>
                                      <label className="text-sm font-medium text-muted-foreground">Revoked At</label>
                                      <div className="text-sm mt-1">
                                        {selectedGrant.revokedAt ? 
                                          format(selectedGrant.revokedAt.toDate(), 'PPP p') : 
                                          'Unknown'
                                        }
                                      </div>
                                    </div>
                                    <div>
                                      <label className="text-sm font-medium text-muted-foreground">Revoked By</label>
                                      <div className="font-mono text-sm mt-1">
                                        {selectedGrant.revokedBy || 'Unknown'}
                                      </div>
                                    </div>
                                  </div>
                                )}

                                {selectedGrant.status === 'expired' && (
                                  <div>
                                    <label className="text-sm font-medium text-muted-foreground">Expired At</label>
                                    <div className="text-sm mt-1">
                                      {selectedGrant.expiredAt ? 
                                        format(selectedGrant.expiredAt.toDate(), 'PPP p') : 
                                        'Unknown'
                                      }
                                    </div>
                                  </div>
                                )}
                              </div>
                            )}
                          </DialogContent>
                        </Dialog>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          </div>
        )}
      </CardContent>
    </Card>
  );
}

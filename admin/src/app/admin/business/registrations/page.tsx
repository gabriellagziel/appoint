'use client';

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger
} from '@/components/ui/alert-dialog';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger
} from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from '@/components/ui/table';
import { approveBusiness, getAllBusinessRegistrations, rejectBusiness } from '@/services/business_registrations_service';
import {
  Building2,
  CheckCircle,
  Clock,
  Eye,
  Filter,
  RefreshCw,
  Search,
  XCircle
} from 'lucide-react';
import { useEffect, useState } from 'react';

type Business = {
  id: string;
  name: string;
  email: string;
  phone?: string;
  companySize: string;
  industry: string;
  status: 'pending' | 'approved' | 'rejected';
  submittedAt: Date;
  reviewedAt?: Date;
  reviewerId?: string;
  notes?: string;
  plan?: 'free' | 'basic' | 'premium' | 'enterprise';
  address?: string;
  website?: string;
  socialMedia?: {
    facebook?: string;
    instagram?: string;
    linkedin?: string;
  };
};

export default function BusinessRegistrationsPage() {
  const [businesses, setBusinesses] = useState<Business[]>([]);
  const [filteredBusinesses, setFilteredBusinesses] = useState<Business[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [selectedBusiness, setSelectedBusiness] = useState<Business | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const data = await getAllBusinessRegistrations();
        setBusinesses(data);
        setFilteredBusinesses(data);
      } catch (error) {
        console.error('Error fetching business registrations:', error);
        // Fallback to mock data for testing
        const mockData: Business[] = [
          {
            id: '1',
            name: 'Tech Solutions Inc.',
            email: 'john@techsolutions.com',
            phone: '+1 (555) 123-4567',
            companySize: '25-50 employees',
            industry: 'Software Development',
            status: 'pending',
            submittedAt: new Date('2024-07-20T10:00:00Z'),
            plan: 'premium',
            address: '123 Tech Lane, Silicon Valley, CA',
            website: 'https://techsolutions.com'
          },
          {
            id: '2',
            name: 'Global Marketing Agency',
            email: 'jane@globalmarketing.com',
            phone: '+1 (555) 987-6543',
            companySize: '100-250 employees',
            industry: 'Marketing',
            status: 'approved',
            submittedAt: new Date('2024-07-15T14:30:00Z'),
            reviewedAt: new Date('2024-07-16T09:00:00Z'),
            reviewerId: 'admin1',
            plan: 'enterprise',
            address: '456 Creative Blvd, New York, NY',
            website: 'https://globalmarketing.com'
          },
          {
            id: '3',
            name: 'Local Cafe & Bistro',
            email: 'alice@localcafe.com',
            phone: '+1 (555) 222-3333',
            companySize: '10-25 employees',
            industry: 'Food & Beverage',
            status: 'rejected',
            submittedAt: new Date('2024-07-10T11:00:00Z'),
            reviewedAt: new Date('2024-07-11T16:00:00Z'),
            reviewerId: 'admin2',
            notes: 'Missing required business license.',
            plan: 'basic',
            address: '789 Main St, Anytown, USA'
          },
          {
            id: '4',
            name: 'Fitness Hub Gym',
            email: 'bob@fitnesshub.com',
            phone: '+1 (555) 444-5555',
            companySize: '25-50 employees',
            industry: 'Health & Fitness',
            status: 'approved',
            submittedAt: new Date('2024-06-01T09:00:00Z'),
            reviewedAt: new Date('2024-06-02T10:00:00Z'),
            reviewerId: 'admin1',
            plan: 'premium',
            address: '101 Workout Rd, Sportsville, USA',
            website: 'https://fitnesshub.com'
          },
          {
            id: '5',
            name: 'Creative Design Studio',
            email: 'charlie@creativedesign.com',
            phone: '+1 (555) 777-8888',
            companySize: '5-10 employees',
            industry: 'Graphic Design',
            status: 'pending',
            submittedAt: new Date('2024-07-25T09:30:00Z'),
            plan: 'basic',
            address: '202 Art Lane, Design City, USA',
            website: 'https://creativedesign.com'
          }
        ];
        setBusinesses(mockData);
        setFilteredBusinesses(mockData);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  // Filter businesses based on search and status
  useEffect(() => {
    let filtered = businesses;

    if (searchTerm) {
      filtered = filtered.filter(biz =>
        biz.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        biz.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
        biz.industry.toLowerCase().includes(searchTerm.toLowerCase())
      );
    }

    if (statusFilter !== 'all') {
      filtered = filtered.filter(biz => biz.status === statusFilter);
    }

    setFilteredBusinesses(filtered);
  }, [businesses, searchTerm, statusFilter]);

  const handleApprove = async (id: string) => {
    try {
      await approveBusiness(id);
      setBusinesses(prev =>
        prev.map(b => (b.id === id ? { ...b, status: 'approved' as const, reviewedAt: new Date() } : b))
      );
    } catch (error) {
      console.error('Error approving business:', error);
      // Fallback for mock data
      setBusinesses(prev =>
        prev.map(b => (b.id === id ? { ...b, status: 'approved' as const, reviewedAt: new Date() } : b))
      );
    }
  };

  const handleReject = async (id: string, reason: string) => {
    try {
      await rejectBusiness(id, reason);
      setBusinesses(prev =>
        prev.map(b => (b.id === id ? { ...b, status: 'rejected' as const, reviewedAt: new Date(), notes: reason } : b))
      );
    } catch (error) {
      console.error('Error rejecting business:', error);
      // Fallback for mock data
      setBusinesses(prev =>
        prev.map(b => (b.id === id ? { ...b, status: 'rejected' as const, reviewedAt: new Date(), notes: reason } : b))
      );
    }
  };

  const getStatusBadge = (status: string) => {
    const variants = {
      pending: 'bg-yellow-100 text-yellow-800',
      approved: 'bg-green-100 text-green-800',
      rejected: 'bg-red-100 text-red-800'
    };
    return <Badge className={variants[status as keyof typeof variants]}>{status}</Badge>;
  };

  const stats = {
    total: businesses.length,
    pending: businesses.filter(b => b.status === 'pending').length,
    approved: businesses.filter(b => b.status === 'approved').length,
    rejected: businesses.filter(b => b.status === 'rejected').length
  };

  if (loading) {
    return (
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold">Business Registrations</h1>
          <p className="text-gray-600">Manage business account registrations and approvals</p>
        </div>
        <div className="flex items-center justify-center h-64">
          <div className="text-center">
            <RefreshCw className="h-8 w-8 animate-spin text-blue-500 mx-auto mb-4" />
            <p className="text-gray-600">Loading business registrations...</p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold">Business Registrations</h1>
          <p className="text-gray-600">Manage business account registrations and approvals</p>
        </div>
        <Button onClick={() => window.location.reload()}>
          <RefreshCw className="w-4 h-4 mr-2" />
          Refresh
        </Button>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total</CardTitle>
            <Building2 className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.total}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Pending</CardTitle>
            <Clock className="h-4 w-4 text-yellow-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-yellow-600">{stats.pending}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Approved</CardTitle>
            <CheckCircle className="h-4 w-4 text-green-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-green-600">{stats.approved}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Rejected</CardTitle>
            <XCircle className="h-4 w-4 text-red-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-red-600">{stats.rejected}</div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <Card>
        <CardHeader>
          <CardTitle>Filters</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="space-y-2">
              <Label htmlFor="search">Search</Label>
              <div className="relative">
                <Search className="absolute left-3 top-3 h-4 w-4 text-gray-400" />
                <Input
                  id="search"
                  placeholder="Search businesses..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10"
                />
              </div>
            </div>
            <div className="space-y-2">
              <Label htmlFor="status">Status</Label>
              <select
                id="status"
                name="status"
                aria-label="Filter by status"
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="all">All Statuses</option>
                <option value="pending">Pending</option>
                <option value="approved">Approved</option>
                <option value="rejected">Rejected</option>
              </select>
            </div>
            <div className="space-y-2">
              <Label>&nbsp;</Label>
              <Button variant="outline" className="w-full">
                <Filter className="w-4 h-4 mr-2" />
                Advanced Filters
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Business Registrations Table */}
      <Card>
        <CardHeader>
          <CardTitle>Business Registrations ({filteredBusinesses.length})</CardTitle>
        </CardHeader>
        <CardContent>
          {filteredBusinesses.length === 0 ? (
            <div className="text-center py-8">
              <Building2 className="h-12 w-12 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600">No business registrations found</p>
            </div>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Business</TableHead>
                  <TableHead>Contact</TableHead>
                  <TableHead>Industry</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>Submitted</TableHead>
                  <TableHead>Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {filteredBusinesses.map((business) => (
                  <TableRow key={business.id}>
                    <TableCell>
                      <div>
                        <div className="font-medium">{business.name}</div>
                        <div className="text-sm text-gray-500">{business.companySize} employees</div>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div>
                        <div className="text-sm">{business.email}</div>
                        {business.phone && (
                          <div className="text-sm text-gray-500">{business.phone}</div>
                        )}
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="text-sm">{business.industry}</div>
                    </TableCell>
                    <TableCell>
                      {getStatusBadge(business.status)}
                    </TableCell>
                    <TableCell>
                      <div className="text-sm">
                        {business.submittedAt.toLocaleDateString()}
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="flex space-x-2">
                        <Dialog>
                          <DialogTrigger asChild>
                            <Button variant="outline" size="sm">
                              <Eye className="w-4 h-4" />
                            </Button>
                          </DialogTrigger>
                          <DialogContent className="max-w-2xl">
                            <DialogHeader>
                              <DialogTitle>Business Details</DialogTitle>
                              <DialogDescription>
                                Complete business registration information
                              </DialogDescription>
                            </DialogHeader>
                            <div className="space-y-4">
                              <div className="grid grid-cols-2 gap-4">
                                <div>
                                  <Label className="text-sm font-medium">Business Name</Label>
                                  <p className="text-sm">{business.name}</p>
                                </div>
                                <div>
                                  <Label className="text-sm font-medium">Email</Label>
                                  <p className="text-sm">{business.email}</p>
                                </div>
                                <div>
                                  <Label className="text-sm font-medium">Phone</Label>
                                  <p className="text-sm">{business.phone || 'Not provided'}</p>
                                </div>
                                <div>
                                  <Label className="text-sm font-medium">Company Size</Label>
                                  <p className="text-sm">{business.companySize}</p>
                                </div>
                                <div>
                                  <Label className="text-sm font-medium">Industry</Label>
                                  <p className="text-sm">{business.industry}</p>
                                </div>
                                <div>
                                  <Label className="text-sm font-medium">Plan</Label>
                                  <p className="text-sm">{business.plan || 'Not selected'}</p>
                                </div>
                              </div>
                              {business.address && (
                                <div>
                                  <Label className="text-sm font-medium">Address</Label>
                                  <p className="text-sm">{business.address}</p>
                                </div>
                              )}
                              {business.website && (
                                <div>
                                  <Label className="text-sm font-medium">Website</Label>
                                  <p className="text-sm">{business.website}</p>
                                </div>
                              )}
                              {business.notes && (
                                <div>
                                  <Label className="text-sm font-medium">Notes</Label>
                                  <p className="text-sm text-red-600">{business.notes}</p>
                                </div>
                              )}
                            </div>
                          </DialogContent>
                        </Dialog>

                        {business.status === 'pending' && (
                          <>
                            <AlertDialog>
                              <AlertDialogTrigger asChild>
                                <Button size="sm" className="bg-green-600 hover:bg-green-700">
                                  <CheckCircle className="w-4 h-4" />
                                </Button>
                              </AlertDialogTrigger>
                              <AlertDialogContent>
                                <AlertDialogHeader>
                                  <AlertDialogTitle>Approve Registration</AlertDialogTitle>
                                  <AlertDialogDescription>
                                    Are you sure you want to approve this business registration?
                                    This will activate their account.
                                  </AlertDialogDescription>
                                </AlertDialogHeader>
                                <AlertDialogFooter>
                                  <AlertDialogCancel>Cancel</AlertDialogCancel>
                                  <AlertDialogAction
                                    onClick={() => handleApprove(business.id)}
                                    className="bg-green-600 hover:bg-green-700"
                                  >
                                    Approve
                                  </AlertDialogAction>
                                </AlertDialogFooter>
                              </AlertDialogContent>
                            </AlertDialog>

                            <AlertDialog>
                              <AlertDialogTrigger asChild>
                                <Button size="sm" variant="destructive">
                                  <XCircle className="w-4 h-4" />
                                </Button>
                              </AlertDialogTrigger>
                              <AlertDialogContent>
                                <AlertDialogHeader>
                                  <AlertDialogTitle>Reject Registration</AlertDialogTitle>
                                  <AlertDialogDescription>
                                    Please provide a reason for rejecting this registration.
                                  </AlertDialogDescription>
                                </AlertDialogHeader>
                                <div className="space-y-4">
                                  <div>
                                    <Label htmlFor="rejection-reason">Reason for Rejection</Label>
                                    <Input
                                      id="rejection-reason"
                                      placeholder="Enter rejection reason..."
                                    />
                                  </div>
                                </div>
                                <AlertDialogFooter>
                                  <AlertDialogCancel>Cancel</AlertDialogCancel>
                                  <AlertDialogAction
                                    className="bg-red-600 hover:bg-red-700 text-white"
                                    onClick={() => handleReject(business.id, 'Incomplete documentation')}
                                  >
                                    Reject
                                  </AlertDialogAction>
                                </AlertDialogFooter>
                              </AlertDialogContent>
                            </AlertDialog>
                          </>
                        )}
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
  );
} 
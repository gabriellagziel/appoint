"use client"

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { useAuth } from "@/contexts/AuthContext";
import { exportLogs, fetchLogs, getLogStats, type LogFilters, type SystemLog } from "@/services/logs_service";
import {
    Activity,
    AlertTriangle,
    Calendar,
    Clock,
    Download,
    Eye,
    Filter,
    RefreshCw,
    Search,
    Shield,
    X
} from "lucide-react";
import { useEffect, useState } from 'react';

export default function LogsPage() {
    const { user: currentUser } = useAuth();
    const [logs, setLogs] = useState<SystemLog[]>([]);
    const [loading, setLoading] = useState(true);
    const [stats, setStats] = useState<any>(null);
    const [filters, setFilters] = useState<LogFilters>({});
    const [searchTerm, setSearchTerm] = useState('');
    const [selectedLog, setSelectedLog] = useState<SystemLog | null>(null);
    const [showLogDetails, setShowLogDetails] = useState(false);
    const [exporting, setExporting] = useState(false);

    useEffect(() => {
        loadLogs();
        loadStats();
    }, [filters]);

    const loadLogs = async () => {
        try {
            setLoading(true);
            const response = await fetchLogs(filters);
            setLogs(response.logs);
        } catch (error) {
            console.error('Error loading logs:', error);
        } finally {
            setLoading(false);
        }
    };

    const loadStats = async () => {
        try {
            const statsData = await getLogStats();
            setStats(statsData);
        } catch (error) {
            console.error('Error loading stats:', error);
        }
    };

    const handleSearch = () => {
        setFilters(prev => ({ ...prev, search: searchTerm }));
    };

    const handleActionFilter = (action: string) => {
        setFilters(prev => ({ ...prev, action: action === 'all' ? undefined : action }));
    };

    const handleSeverityFilter = (severity: string) => {
        setFilters(prev => ({ ...prev, severity: severity === 'all' ? undefined : severity }));
    };

    const handleDateFilter = (type: 'from' | 'to', value: string) => {
        const date = value ? new Date(value) : undefined;
        setFilters(prev => ({ ...prev, [`date${type === 'from' ? 'From' : 'To'}`]: date }));
    };

    const handleExport = async () => {
        try {
            setExporting(true);
            const csvContent = await exportLogs(filters);

            // Create and download CSV file
            const blob = new Blob([csvContent], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `system-logs-${new Date().toISOString().split('T')[0]}.csv`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);
        } catch (error) {
            console.error('Error exporting logs:', error);
        } finally {
            setExporting(false);
        }
    };

    const getSeverityColor = (severity: string) => {
        switch (severity) {
            case 'critical': return 'destructive';
            case 'error': return 'destructive';
            case 'warning': return 'secondary';
            case 'info': return 'default';
            default: return 'default';
        }
    };

    const getSeverityIcon = (severity: string) => {
        switch (severity) {
            case 'critical': return <AlertTriangle className="h-4 w-4 text-red-600" />;
            case 'error': return <AlertTriangle className="h-4 w-4 text-red-500" />;
            case 'warning': return <AlertTriangle className="h-4 w-4 text-yellow-500" />;
            case 'info': return <Activity className="h-4 w-4 text-blue-500" />;
            default: return <Activity className="h-4 w-4 text-gray-500" />;
        }
    };

    const formatDate = (date: Date) => {
        return new Intl.DateTimeFormat('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        }).format(date);
    };

    const formatAction = (action: string) => {
        return action.split('_').map(word =>
            word.charAt(0).toUpperCase() + word.slice(1)
        ).join(' ');
    };

    return (
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="space-y-6">
                {/* Header */}
                <div className="flex items-center justify-between">
                    <div>
                        <h1 className="text-3xl font-bold text-gray-900">System Logs</h1>
                        <p className="text-gray-600">Monitor system activity and audit trails</p>
                    </div>
                    <div className="flex items-center space-x-2">
                        <Button variant="outline" onClick={() => loadLogs()}>
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
                                <CardTitle className="text-sm font-medium">Total Logs</CardTitle>
                                <Activity className="h-4 w-4 text-gray-400" />
                            </CardHeader>
                            <CardContent>
                                <div className="text-2xl font-bold">{stats.total}</div>
                                <p className="text-xs text-gray-500">All system logs</p>
                            </CardContent>
                        </Card>

                        <Card>
                            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                                <CardTitle className="text-sm font-medium">Today</CardTitle>
                                <Calendar className="h-4 w-4 text-blue-500" />
                            </CardHeader>
                            <CardContent>
                                <div className="text-2xl font-bold">{stats.today}</div>
                                <p className="text-xs text-gray-500">Logs from today</p>
                            </CardContent>
                        </Card>

                        <Card>
                            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                                <CardTitle className="text-sm font-medium">This Week</CardTitle>
                                <Clock className="h-4 w-4 text-green-500" />
                            </CardHeader>
                            <CardContent>
                                <div className="text-2xl font-bold">{stats.thisWeek}</div>
                                <p className="text-xs text-gray-500">Logs from this week</p>
                            </CardContent>
                        </Card>

                        <Card>
                            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                                <CardTitle className="text-sm font-medium">This Month</CardTitle>
                                <Shield className="h-4 w-4 text-purple-500" />
                            </CardHeader>
                            <CardContent>
                                <div className="text-2xl font-bold">{stats.thisMonth}</div>
                                <p className="text-xs text-gray-500">Logs from this month</p>
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
                        <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
                            <div>
                                <Label htmlFor="search">Search</Label>
                                <div className="flex gap-2 mt-1">
                                    <Input
                                        id="search"
                                        placeholder="Search logs..."
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
                                <Label htmlFor="action">Action</Label>
                                <Select onValueChange={handleActionFilter}>
                                    <SelectTrigger className="mt-1">
                                        <SelectValue placeholder="All actions" />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="all">All actions</SelectItem>
                                        <SelectItem value="login">Login</SelectItem>
                                        <SelectItem value="logout">Logout</SelectItem>
                                        <SelectItem value="update_user_status">Update User Status</SelectItem>
                                        <SelectItem value="add_moderation_note">Add Moderation Note</SelectItem>
                                        <SelectItem value="bulk_update_user_status">Bulk Update Users</SelectItem>
                                        <SelectItem value="update_flag_status">Update Flag Status</SelectItem>
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
                                        <SelectItem value="info">Info</SelectItem>
                                        <SelectItem value="warning">Warning</SelectItem>
                                        <SelectItem value="error">Error</SelectItem>
                                        <SelectItem value="critical">Critical</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>

                            <div>
                                <Label htmlFor="dateFrom">From Date</Label>
                                <Input
                                    id="dateFrom"
                                    type="datetime-local"
                                    onChange={(e) => handleDateFilter('from', e.target.value)}
                                    className="mt-1"
                                />
                            </div>

                            <div>
                                <Label htmlFor="dateTo">To Date</Label>
                                <Input
                                    id="dateTo"
                                    type="datetime-local"
                                    onChange={(e) => handleDateFilter('to', e.target.value)}
                                    className="mt-1"
                                />
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

                {/* Logs Table */}
                <Card>
                    <CardHeader>
                        <CardTitle>System Logs</CardTitle>
                    </CardHeader>
                    <CardContent>
                        {loading ? (
                            <div className="flex items-center justify-center py-8">
                                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
                                <span className="ml-2">Loading logs...</span>
                            </div>
                        ) : (
                            <Table>
                                <TableHeader>
                                    <TableRow>
                                        <TableHead>Timestamp</TableHead>
                                        <TableHead>Action</TableHead>
                                        <TableHead>Severity</TableHead>
                                        <TableHead>Actor</TableHead>
                                        <TableHead>Target</TableHead>
                                        <TableHead>IP Address</TableHead>
                                        <TableHead>Actions</TableHead>
                                    </TableRow>
                                </TableHeader>
                                <TableBody>
                                    {logs.map((log) => (
                                        <TableRow key={log.id}>
                                            <TableCell className="text-sm text-gray-500">
                                                {formatDate(log.timestamp)}
                                            </TableCell>
                                            <TableCell>
                                                <span className="font-medium">
                                                    {formatAction(log.action)}
                                                </span>
                                            </TableCell>
                                            <TableCell>
                                                <div className="flex items-center space-x-2">
                                                    {getSeverityIcon(log.severity)}
                                                    <Badge variant={getSeverityColor(log.severity)}>
                                                        {log.severity}
                                                    </Badge>
                                                </div>
                                            </TableCell>
                                            <TableCell>
                                                <div className="text-sm">
                                                    <div className="font-medium">{log.actorEmail || 'System'}</div>
                                                    {log.actorUid && (
                                                        <div className="text-gray-500 text-xs">{log.actorUid}</div>
                                                    )}
                                                </div>
                                            </TableCell>
                                            <TableCell>
                                                {log.targetEmail ? (
                                                    <div className="text-sm">
                                                        <div className="font-medium">{log.targetEmail}</div>
                                                        {log.targetUid && (
                                                            <div className="text-gray-500 text-xs">{log.targetUid}</div>
                                                        )}
                                                    </div>
                                                ) : (
                                                    <span className="text-gray-400">-</span>
                                                )}
                                            </TableCell>
                                            <TableCell className="text-sm text-gray-500">
                                                {log.ipAddress || '-'}
                                            </TableCell>
                                            <TableCell>
                                                <Button
                                                    variant="outline"
                                                    size="sm"
                                                    onClick={() => {
                                                        setSelectedLog(log);
                                                        setShowLogDetails(true);
                                                    }}
                                                >
                                                    <Eye className="h-4 w-4" />
                                                </Button>
                                            </TableCell>
                                        </TableRow>
                                    ))}
                                </TableBody>
                            </Table>
                        )}

                        {logs.length === 0 && !loading && (
                            <div className="text-center py-8">
                                <Activity className="h-12 w-12 text-gray-400 mx-auto mb-4" />
                                <p className="text-gray-500">No logs found</p>
                            </div>
                        )}
                    </CardContent>
                </Card>
            </div>

            {/* Log Details Dialog */}
            <Dialog open={showLogDetails} onOpenChange={setShowLogDetails}>
                <DialogContent className="max-w-2xl">
                    <DialogHeader>
                        <DialogTitle>Log Details</DialogTitle>
                    </DialogHeader>
                    {selectedLog && (
                        <div className="space-y-4">
                            <div className="grid grid-cols-2 gap-4">
                                <div>
                                    <Label>Action</Label>
                                    <p className="text-sm font-medium">{formatAction(selectedLog.action)}</p>
                                </div>
                                <div>
                                    <Label>Severity</Label>
                                    <div className="flex items-center space-x-2">
                                        {getSeverityIcon(selectedLog.severity)}
                                        <Badge variant={getSeverityColor(selectedLog.severity)}>
                                            {selectedLog.severity}
                                        </Badge>
                                    </div>
                                </div>
                                <div>
                                    <Label>Timestamp</Label>
                                    <p className="text-sm">{formatDate(selectedLog.timestamp)}</p>
                                </div>
                                <div>
                                    <Label>IP Address</Label>
                                    <p className="text-sm">{selectedLog.ipAddress || 'Not available'}</p>
                                </div>
                            </div>

                            {selectedLog.actorEmail && (
                                <div>
                                    <Label>Actor</Label>
                                    <div className="text-sm">
                                        <div className="font-medium">{selectedLog.actorEmail}</div>
                                        {selectedLog.actorUid && (
                                            <div className="text-gray-500">{selectedLog.actorUid}</div>
                                        )}
                                    </div>
                                </div>
                            )}

                            {selectedLog.targetEmail && (
                                <div>
                                    <Label>Target</Label>
                                    <div className="text-sm">
                                        <div className="font-medium">{selectedLog.targetEmail}</div>
                                        {selectedLog.targetUid && (
                                            <div className="text-gray-500">{selectedLog.targetUid}</div>
                                        )}
                                    </div>
                                </div>
                            )}

                            {selectedLog.userAgent && (
                                <div>
                                    <Label>User Agent</Label>
                                    <p className="text-sm text-gray-600">{selectedLog.userAgent}</p>
                                </div>
                            )}

                            {selectedLog.context && Object.keys(selectedLog.context).length > 0 && (
                                <div>
                                    <Label>Context</Label>
                                    <pre className="text-sm bg-gray-50 p-3 rounded border overflow-auto max-h-40">
                                        {JSON.stringify(selectedLog.context, null, 2)}
                                    </pre>
                                </div>
                            )}

                            {selectedLog.metadata && Object.keys(selectedLog.metadata).length > 0 && (
                                <div>
                                    <Label>Metadata</Label>
                                    <pre className="text-sm bg-gray-50 p-3 rounded border overflow-auto max-h-40">
                                        {JSON.stringify(selectedLog.metadata, null, 2)}
                                    </pre>
                                </div>
                            )}
                        </div>
                    )}
                </DialogContent>
            </Dialog>
        </div>
    );
} 
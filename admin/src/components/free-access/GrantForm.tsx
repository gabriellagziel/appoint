'use client';

import { useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { 
  Select, 
  SelectContent, 
  SelectItem, 
  SelectTrigger, 
  SelectValue 
} from '@/components/ui/select';
import { Switch } from '@/components/ui/switch';
import { Calendar } from '@/components/ui/calendar';
import { 
  Popover,
  PopoverContent,
  PopoverTrigger,
} from '@/components/ui/popover';
import { CalendarIcon, Users, Building2, Key, AlertTriangle } from 'lucide-react';
import { format } from 'date-fns';
import { cn } from '@/lib/utils';
import { freeAccessService, GrantRequest } from '@/services/free_access_service';
import { useAuth } from '@/hooks/useAuth';
import { toast } from 'sonner';

interface GrantFormProps {
  targetType?: 'personal' | 'business' | 'enterprise';
  targetId?: string;
  onSuccess?: () => void;
  onCancel?: () => void;
}

export function GrantForm({ targetType, targetId, onSuccess, onCancel }: GrantFormProps) {
  const { user } = useAuth();
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [formData, setFormData] = useState({
    targetType: targetType || 'personal',
    targetId: targetId || '',
    reason: '',
    overrideNote: '',
    duration: '30d' as '7d' | '30d' | '90d' | 'permanent',
    customExpiry: null as Date | null,
    // Personal fields
    planOverride: 'free' as 'free' | 'free_premium',
    premiumForced: false,
    // Business fields
    businessPlanOverride: 'free_studio' as 'free_studio' | 'free_enterprise',
    seatLimitOverride: -1,
    // Enterprise fields
    enterprisePlanOverride: 'free_api' as 'free_api',
    rateLimitOverride: -1,
    featureAccessOverride: ['all'] as string[]
  });

  const isSuperAdmin = user?.claims?.super_admin === true;

  if (!isSuperAdmin) {
    return (
      <div className="text-center py-8">
        <AlertTriangle className="w-12 h-12 text-destructive mx-auto mb-4" />
        <h2 className="text-xl font-semibold mb-2">Access Denied</h2>
        <p className="text-destructive">You need super admin permissions to grant free access.</p>
      </div>
    );
  }

  const validateForm = (): boolean => {
    const newErrors: Record<string, string> = {};

    // Required fields
    if (!formData.targetId.trim()) {
      newErrors.targetId = 'Target ID is required';
    }
    if (!formData.reason.trim()) {
      newErrors.reason = 'Reason is required';
    }

    // Type-specific validation
    if (formData.targetType === 'personal') {
      if (formData.planOverride === 'free_premium' && !formData.premiumForced) {
        newErrors.premiumForced = 'Premium features must be forced for free_premium plan';
      }
    }

    if (formData.targetType === 'business') {
      if (formData.seatLimitOverride !== -1 && formData.seatLimitOverride < 1) {
        newErrors.seatLimitOverride = 'Seat limit must be -1 (unlimited) or >= 1';
      }
    }

    if (formData.targetType === 'enterprise') {
      if (formData.rateLimitOverride !== -1 && formData.rateLimitOverride < 1) {
        newErrors.rateLimitOverride = 'Rate limit must be -1 (unlimited) or >= 1';
      }
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!validateForm()) {
      toast.error('Please fix the errors before submitting');
      return;
    }

    setLoading(true);

    try {
      // Calculate expiry date
      let expiresAt: Date | undefined;
      if (formData.duration !== 'permanent') {
        if (formData.customExpiry) {
          expiresAt = formData.customExpiry;
        } else {
          const days = {
            '7d': 7,
            '30d': 30,
            '90d': 90
          }[formData.duration];
          expiresAt = new Date(Date.now() + days * 24 * 60 * 60 * 1000);
        }
      }

      // Build changes object based on target type
      const changes: Record<string, any> = {
        overrideNote: formData.overrideNote || null
      };

      if (expiresAt) {
        changes.freeUntil = expiresAt;
      }

      switch (formData.targetType) {
        case 'personal':
          changes.planOverride = formData.planOverride;
          changes.premiumForced = formData.premiumForced;
          break;
        case 'business':
          changes.planOverride = formData.businessPlanOverride;
          changes.seatLimitOverride = formData.seatLimitOverride;
          break;
        case 'enterprise':
          changes.planOverride = formData.enterprisePlanOverride;
          changes.rateLimitOverride = formData.rateLimitOverride;
          changes.featureAccessOverride = formData.featureAccessOverride;
          break;
      }

      const request: GrantRequest = {
        targetType: formData.targetType,
        targetId: formData.targetId,
        changes,
        reason: formData.reason,
        expiresAt,
        overrideNote: formData.overrideNote
      };

      await freeAccessService.grantFreeAccess(user!.uid, request);
      
      toast.success('Free access granted successfully');
      onSuccess?.();
    } catch (error) {
      console.error('Failed to grant free access:', error);
      const errorMessage = error instanceof Error ? error.message : 'Failed to grant free access';
      toast.error(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  const getTargetTypeIcon = (type: string) => {
    switch (type) {
      case 'personal': return <Users className="w-4 h-4" />;
      case 'business': return <Building2 className="w-4 h-4" />;
      case 'enterprise': return <Key className="w-4 h-4" />;
      default: return null;
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6" noValidate>
      {/* Target Selection */}
      <Card>
        <CardHeader>
          <CardTitle>Target Selection</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="targetType">Target Type *</Label>
              <Select 
                value={formData.targetType} 
                onValueChange={(value: 'personal' | 'business' | 'enterprise') => 
                  setFormData(prev => ({ ...prev, targetType: value }))
                }
              >
                <SelectTrigger id="targetType" aria-describedby="targetType-error">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="personal">
                    <div className="flex items-center gap-2">
                      <Users className="w-4 h-4" />
                      Personal User
                    </div>
                  </SelectItem>
                  <SelectItem value="business">
                    <div className="flex items-center gap-2">
                      <Building2 className="w-4 h-4" />
                      Business Account
                    </div>
                  </SelectItem>
                  <SelectItem value="enterprise">
                    <div className="flex items-center gap-2">
                      <Key className="w-4 h-4" />
                      Enterprise Client
                    </div>
                  </SelectItem>
                </SelectContent>
              </Select>
              {errors.targetType && (
                <p id="targetType-error" className="text-sm text-destructive">
                  {errors.targetType}
                </p>
              )}
            </div>

            <div className="space-y-2">
              <Label htmlFor="targetId">Target ID *</Label>
              <Input
                id="targetId"
                value={formData.targetId}
                onChange={(e) => setFormData(prev => ({ ...prev, targetId: e.target.value }))}
                placeholder="Enter user UID, business ID, or client ID"
                required
                aria-describedby="targetId-error"
                aria-invalid={!!errors.targetId}
              />
              {errors.targetId && (
                <p id="targetId-error" className="text-sm text-destructive">
                  {errors.targetId}
                </p>
              )}
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Duration & Expiry */}
      <Card>
        <CardHeader>
          <CardTitle>Duration & Expiry</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="duration">Duration Preset</Label>
              <Select 
                value={formData.duration} 
                onValueChange={(value: '7d' | '30d' | '90d' | 'permanent') => 
                  setFormData(prev => ({ ...prev, duration: value }))
                }
              >
                <SelectTrigger id="duration">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="7d">7 Days</SelectItem>
                  <SelectItem value="30d">30 Days</SelectItem>
                  <SelectItem value="90d">90 Days</SelectItem>
                  <SelectItem value="permanent">Permanent</SelectItem>
                </SelectContent>
              </Select>
            </div>

            {formData.duration !== 'permanent' && (
              <div className="space-y-2">
                <Label htmlFor="customExpiry">Custom Expiry Date (Optional)</Label>
                <Popover>
                  <PopoverTrigger asChild>
                    <Button
                      id="customExpiry"
                      variant="outline"
                      className={cn(
                        "w-full justify-start text-left font-normal",
                        !formData.customExpiry && "text-muted-foreground"
                      )}
                    >
                      <CalendarIcon className="mr-2 h-4 w-4" />
                      {formData.customExpiry ? format(formData.customExpiry, "PPP") : "Pick a date"}
                    </Button>
                  </PopoverTrigger>
                  <PopoverContent className="w-auto p-0">
                    <Calendar
                      mode="single"
                      selected={formData.customExpiry}
                      onSelect={(date) => setFormData(prev => ({ ...prev, customExpiry: date }))}
                      initialFocus
                      disabled={(date) => date < new Date()}
                    />
                  </PopoverContent>
                </Popover>
              </div>
            )}
          </div>
        </CardContent>
      </Card>

      {/* Type-Specific Fields */}
      {formData.targetType === 'personal' && (
        <Card>
          <CardHeader>
            <CardTitle>Personal User Settings</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="planOverride">Plan Override</Label>
                <Select 
                  value={formData.planOverride} 
                  onValueChange={(value: 'free' | 'free_premium') => 
                    setFormData(prev => ({ ...prev, planOverride: value }))
                  }
                >
                  <SelectTrigger id="planOverride">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="free">Free Plan</SelectItem>
                    <SelectItem value="free_premium">Free Premium</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="flex items-center space-x-2">
                <Switch
                  id="premiumForced"
                  checked={formData.premiumForced}
                  onCheckedChange={(checked) => 
                    setFormData(prev => ({ ...prev, premiumForced: checked }))
                  }
                />
                <Label htmlFor="premiumForced">Force Premium Features</Label>
              </div>
            </div>
            {errors.premiumForced && (
              <p className="text-sm text-destructive">{errors.premiumForced}</p>
            )}
          </CardContent>
        </Card>
      )}

      {formData.targetType === 'business' && (
        <Card>
          <CardHeader>
            <CardTitle>Business Account Settings</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="businessPlanOverride">Plan Override</Label>
                <Select 
                  value={formData.businessPlanOverride} 
                  onValueChange={(value: 'free_studio' | 'free_enterprise') => 
                    setFormData(prev => ({ ...prev, businessPlanOverride: value }))
                  }
                >
                  <SelectTrigger id="businessPlanOverride">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="free_studio">Free Studio</SelectItem>
                    <SelectItem value="free_enterprise">Free Enterprise</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2">
                <Label htmlFor="seatLimitOverride">Seat Limit Override</Label>
                <Input
                  id="seatLimitOverride"
                  type="number"
                  value={formData.seatLimitOverride === -1 ? '' : formData.seatLimitOverride}
                  onChange={(e) => {
                    const value = e.target.value === '' ? -1 : parseInt(e.target.value);
                    setFormData(prev => ({ ...prev, seatLimitOverride: value }));
                  }}
                  placeholder="-1 for unlimited"
                  aria-describedby="seatLimitOverride-error"
                  aria-invalid={!!errors.seatLimitOverride}
                />
                {errors.seatLimitOverride && (
                  <p id="seatLimitOverride-error" className="text-sm text-destructive">
                    {errors.seatLimitOverride}
                  </p>
                )}
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      {formData.targetType === 'enterprise' && (
        <Card>
          <CardHeader>
            <CardTitle>Enterprise Client Settings</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="enterprisePlanOverride">Plan Override</Label>
                <Select 
                  value={formData.enterprisePlanOverride} 
                  onValueChange={(value: 'free_api') => 
                    setFormData(prev => ({ ...prev, enterprisePlanOverride: value }))
                  }
                >
                  <SelectTrigger id="enterprisePlanOverride">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="free_api">Free API</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2">
                <Label htmlFor="rateLimitOverride">Rate Limit Override</Label>
                <Input
                  id="rateLimitOverride"
                  type="number"
                  value={formData.rateLimitOverride === -1 ? '' : formData.rateLimitOverride}
                  onChange={(e) => {
                    const value = e.target.value === '' ? -1 : parseInt(e.target.value);
                    setFormData(prev => ({ ...prev, rateLimitOverride: value }));
                  }}
                  placeholder="-1 for unlimited"
                  aria-describedby="rateLimitOverride-error"
                  aria-invalid={!!errors.rateLimitOverride}
                />
                {errors.rateLimitOverride && (
                  <p id="rateLimitOverride-error" className="text-sm text-destructive">
                    {errors.rateLimitOverride}
                  </p>
                )}
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Reason & Notes */}
      <Card>
        <CardHeader>
          <CardTitle>Reason & Notes</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="reason">Reason for Grant *</Label>
            <Textarea
              id="reason"
              value={formData.reason}
              onChange={(e) => setFormData(prev => ({ ...prev, reason: e.target.value }))}
              placeholder="Explain why this free access is being granted..."
              required
              rows={3}
              aria-describedby="reason-error"
              aria-invalid={!!errors.reason}
            />
            {errors.reason && (
              <p id="reason-error" className="text-sm text-destructive">
                {errors.reason}
              </p>
            )}
          </div>

          <div className="space-y-2">
            <Label htmlFor="overrideNote">Additional Notes (Optional)</Label>
            <Textarea
              id="overrideNote"
              value={formData.overrideNote}
              onChange={(e) => setFormData(prev => ({ ...prev, overrideNote: e.target.value }))}
              placeholder="Any additional notes or context..."
              rows={2}
            />
          </div>
        </CardContent>
      </Card>

      {/* Actions */}
      <div className="flex justify-end gap-4">
        <Button type="button" variant="outline" onClick={onCancel}>
          Cancel
        </Button>
        <Button type="submit" disabled={loading}>
          {loading ? 'Granting...' : 'Grant Free Access'}
        </Button>
      </div>
    </form>
  );
}

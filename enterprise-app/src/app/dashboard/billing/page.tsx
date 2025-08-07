'use client';

import Button from '@/components/Button';
import Card from '@/components/Card';
import { Download, CreditCard, DollarSign, Calendar, FileText, ArrowRight } from 'lucide-react';
import { useState } from 'react';

export default function BillingPage() {
  const [invoices] = useState([
    {
      id: 'INV-2024-001',
      date: '2024-01-20',
      amount: 245.50,
      status: 'paid',
      meetings: 491,
      description: 'January 2024 - Meeting API Usage',
    },
    {
      id: 'INV-2024-002',
      date: '2024-01-15',
      amount: 198.75,
      status: 'paid',
      meetings: 397,
      description: 'December 2023 - Meeting API Usage',
    },
    {
      id: 'INV-2024-003',
      date: '2024-01-10',
      amount: 156.25,
      status: 'paid',
      meetings: 312,
      description: 'November 2023 - Meeting API Usage',
    },
  ]);

  const [paymentMethods] = useState([
    {
      id: 'pm_1234567890',
      type: 'card',
      last4: '4242',
      brand: 'Visa',
      expMonth: 12,
      expYear: 2025,
      isDefault: true,
    },
    {
      id: 'pm_0987654321',
      type: 'card',
      last4: '5555',
      brand: 'Mastercard',
      expMonth: 8,
      expYear: 2026,
      isDefault: false,
    },
  ]);

  const currentUsage = {
    meetingsThisMonth: 491,
    meetingsLimit: 1000,
    estimatedCost: 245.50,
    nextBillingDate: '2024-02-20',
  };

  const downloadInvoice = (invoiceId: string) => {
    // Mock download functionality
    console.log(`Downloading invoice ${invoiceId}`);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-neutral-900">Billing & Usage</h1>
          <p className="text-neutral-600 mt-1">
            Manage your billing information and view usage analytics
          </p>
        </div>
        <Button className="flex items-center gap-2">
          <CreditCard className="w-4 h-4" />
          Add Payment Method
        </Button>
      </div>

      {/* Current Usage */}
      <Card className="p-6">
        <h2 className="text-lg font-semibold text-neutral-900 mb-4">Current Usage</h2>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          <div>
            <div className="flex items-center gap-2 mb-2">
              <Calendar className="w-5 h-5 text-primary-600" />
              <span className="text-sm font-medium text-neutral-600">Meetings This Month</span>
            </div>
            <div className="text-2xl font-bold text-neutral-900">{currentUsage.meetingsThisMonth}</div>
            <div className="text-sm text-neutral-500">of {currentUsage.meetingsLimit} limit</div>
          </div>
          
          <div>
            <div className="flex items-center gap-2 mb-2">
              <DollarSign className="w-5 h-5 text-success-600" />
              <span className="text-sm font-medium text-neutral-600">Estimated Cost</span>
            </div>
            <div className="text-2xl font-bold text-neutral-900">€{currentUsage.estimatedCost}</div>
            <div className="text-sm text-neutral-500">this month</div>
          </div>
          
          <div>
            <div className="flex items-center gap-2 mb-2">
              <Calendar className="w-5 h-5 text-warning-600" />
              <span className="text-sm font-medium text-neutral-600">Next Billing</span>
            </div>
            <div className="text-2xl font-bold text-neutral-900">
              {new Date(currentUsage.nextBillingDate).toLocaleDateString()}
            </div>
            <div className="text-sm text-neutral-500">automatic charge</div>
          </div>
          
          <div>
            <div className="flex items-center gap-2 mb-2">
              <div className="w-5 h-5 bg-neutral-200 rounded-full flex items-center justify-center">
                <span className="text-xs font-bold text-neutral-600">%</span>
              </div>
              <span className="text-sm font-medium text-neutral-600">Usage Progress</span>
            </div>
            <div className="text-2xl font-bold text-neutral-900">
              {Math.round((currentUsage.meetingsThisMonth / currentUsage.meetingsLimit) * 100)}%
            </div>
            <div className="w-full bg-neutral-200 rounded-full h-2 mt-2">
              <div 
                className="bg-primary-600 h-2 rounded-full" 
                style={{ width: `${(currentUsage.meetingsThisMonth / currentUsage.meetingsLimit) * 100}%` }}
              ></div>
            </div>
          </div>
        </div>
      </Card>

      {/* Payment Methods */}
      <Card className="p-6">
        <h2 className="text-lg font-semibold text-neutral-900 mb-4">Payment Methods</h2>
        <div className="space-y-4">
          {paymentMethods.map((method) => (
            <div key={method.id} className="flex items-center justify-between p-4 border border-neutral-200 rounded-lg">
              <div className="flex items-center gap-3">
                <CreditCard className="w-5 h-5 text-neutral-600" />
                <div>
                  <div className="font-medium text-neutral-900">
                    {method.brand} •••• {method.last4}
                  </div>
                  <div className="text-sm text-neutral-600">
                    Expires {method.expMonth}/{method.expYear}
                  </div>
                </div>
                {method.isDefault && (
                  <span className="px-2 py-1 text-xs bg-primary-100 text-primary-700 rounded-full">
                    Default
                  </span>
                )}
              </div>
              <Button variant="outline" size="sm">
                Edit
              </Button>
            </div>
          ))}
        </div>
        <Button variant="outline" className="mt-4">
          <CreditCard className="w-4 h-4 mr-2" />
          Add New Payment Method
        </Button>
      </Card>

      {/* Invoices */}
      <Card className="p-6">
        <h2 className="text-lg font-semibold text-neutral-900 mb-4">Recent Invoices</h2>
        <div className="space-y-4">
          {invoices.map((invoice) => (
            <div key={invoice.id} className="flex items-center justify-between p-4 border border-neutral-200 rounded-lg">
              <div className="flex items-center gap-4">
                <FileText className="w-5 h-5 text-neutral-600" />
                <div>
                  <div className="font-medium text-neutral-900">{invoice.description}</div>
                  <div className="text-sm text-neutral-600">
                    {invoice.id} • {new Date(invoice.date).toLocaleDateString()} • {invoice.meetings} meetings
                  </div>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="text-right">
                  <div className="font-semibold text-neutral-900">€{invoice.amount}</div>
                  <div className={`text-xs px-2 py-1 rounded-full ${
                    invoice.status === 'paid' 
                      ? 'bg-success-100 text-success-700' 
                      : 'bg-warning-100 text-warning-700'
                  }`}>
                    {invoice.status}
                  </div>
                </div>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => downloadInvoice(invoice.id)}
                  aria-label={`Download invoice ${invoice.id}`}
                >
                  <Download className="w-4 h-4" />
                </Button>
              </div>
            </div>
          ))}
        </div>
        <div className="mt-4 text-center">
          <Button variant="outline">
            View All Invoices
            <ArrowRight className="w-4 h-4 ml-2" />
          </Button>
        </div>
      </Card>

      {/* Billing Information */}
      <Card className="p-6">
        <h2 className="text-lg font-semibold text-neutral-900 mb-4">Billing Information</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <h3 className="font-medium text-neutral-900 mb-3">Company Details</h3>
            <div className="space-y-2 text-sm">
              <div>
                <span className="text-neutral-600">Company:</span>
                <span className="ml-2 text-neutral-900">TechCorp Solutions</span>
              </div>
              <div>
                <span className="text-neutral-600">VAT Number:</span>
                <span className="ml-2 text-neutral-900">DE123456789</span>
              </div>
              <div>
                <span className="text-neutral-600">Address:</span>
                <span className="ml-2 text-neutral-900">123 Business St, Berlin, Germany</span>
              </div>
            </div>
          </div>
          <div>
            <h3 className="font-medium text-neutral-900 mb-3">Contact Information</h3>
            <div className="space-y-2 text-sm">
              <div>
                <span className="text-neutral-600">Email:</span>
                <span className="ml-2 text-neutral-900">billing@techcorp.com</span>
              </div>
              <div>
                <span className="text-neutral-600">Phone:</span>
                <span className="ml-2 text-neutral-900">+49 30 12345678</span>
              </div>
            </div>
            <Button variant="outline" size="sm" className="mt-3">
              Update Information
            </Button>
          </div>
        </div>
      </Card>
    </div>
  );
} 
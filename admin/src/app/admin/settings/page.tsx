"use client"

import { useState } from "react"
import { AdminLayout } from "@/components/AdminLayout"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"

export default function SettingsPage() {
  const [formData, setFormData] = useState({
    siteName: "App-Oint",
    supportEmail: "support@app-oint.com",
    timezone: "UTC",
    maintenanceMode: false,
    debugMode: false,
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    // Handle form submission
    console.log("Settings updated:", formData)
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Settings</h1>
          <p className="text-gray-600">Configure system settings and preferences</p>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <Card>
              <CardHeader>
                <CardTitle>General Settings</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="siteName">Site Name</Label>
                  <Input
                    id="siteName"
                    value={formData.siteName}
                    onChange={(e) => setFormData({ ...formData, siteName: e.target.value })}
                    placeholder="Enter site name"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="supportEmail">Support Email</Label>
                  <Input
                    id="supportEmail"
                    type="email"
                    value={formData.supportEmail}
                    onChange={(e) => setFormData({ ...formData, supportEmail: e.target.value })}
                    placeholder="Enter support email"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="timezone">Timezone</Label>
                  <Select
                    value={formData.timezone}
                    onChange={(e) => setFormData({ ...formData, timezone: e.target.value })}
                  >
                    <SelectItem value="">Select timezone</SelectItem>
                    <SelectItem value="UTC">UTC</SelectItem>
                    <SelectItem value="America/New_York">Eastern Time</SelectItem>
                    <SelectItem value="America/Chicago">Central Time</SelectItem>
                    <SelectItem value="America/Denver">Mountain Time</SelectItem>
                      <SelectItem value="America/Los_Angeles">Pacific Time</SelectItem>
                      <SelectItem value="Europe/London">London</SelectItem>
                      <SelectItem value="Europe/Paris">Paris</SelectItem>
                      <SelectItem value="Asia/Tokyo">Tokyo</SelectItem>
                  </Select>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>System Settings</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="apiKey">API Key</Label>
                  <Input
                    id="apiKey"
                    type="password"
                    placeholder="Enter API key"
                    value="••••••••••••••••"
                    disabled
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="webhookUrl">Webhook URL</Label>
                  <Input
                    id="webhookUrl"
                    placeholder="Enter webhook URL"
                    value="https://api.app-oint.com/webhook"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="maxUsers">Max Users</Label>
                  <Input
                    id="maxUsers"
                    type="number"
                    placeholder="Enter maximum users"
                    value="10000"
                  />
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Security Settings</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="sessionTimeout">Session Timeout (minutes)</Label>
                  <Input
                    id="sessionTimeout"
                    type="number"
                    placeholder="Enter session timeout"
                    value="30"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="passwordPolicy">Password Policy</Label>
                  <Select defaultValue="strong">
                    <SelectItem value="">Select password policy</SelectItem>
                    <SelectItem value="weak">Weak (6+ characters)</SelectItem>
                    <SelectItem value="medium">Medium (8+ characters)</SelectItem>
                    <SelectItem value="strong">Strong (12+ characters)</SelectItem>
                  </Select>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="twoFactor">Two-Factor Authentication</Label>
                  <Select defaultValue="enabled">
                    <SelectItem value="">Select 2FA setting</SelectItem>
                    <SelectItem value="enabled">Enabled</SelectItem>
                    <SelectItem value="disabled">Disabled</SelectItem>
                    <SelectItem value="optional">Optional</SelectItem>
                  </Select>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Advanced Settings</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex items-center space-x-2">
                  <input
                    type="checkbox"
                    id="maintenanceMode"
                    checked={formData.maintenanceMode}
                    onChange={(e) => setFormData({ ...formData, maintenanceMode: e.target.checked })}
                    className="rounded"
                  />
                  <Label htmlFor="maintenanceMode">Maintenance Mode</Label>
                </div>

                <div className="flex items-center space-x-2">
                  <input
                    type="checkbox"
                    id="debugMode"
                    checked={formData.debugMode}
                    onChange={(e) => setFormData({ ...formData, debugMode: e.target.checked })}
                    className="rounded"
                  />
                  <Label htmlFor="debugMode">Debug Mode</Label>
                </div>

                <div className="flex items-center space-x-2">
                  <input
                    type="checkbox"
                    id="autoBackup"
                    defaultChecked
                    className="rounded"
                  />
                  <Label htmlFor="autoBackup">Auto Backup</Label>
                </div>

                <div className="flex items-center space-x-2">
                  <input
                    type="checkbox"
                    id="emailNotifications"
                    defaultChecked
                    className="rounded"
                  />
                  <Label htmlFor="emailNotifications">Email Notifications</Label>
                </div>
              </CardContent>
            </Card>
          </div>

          <div className="flex justify-end space-x-4 mt-6">
            <Button type="button" variant="outline">
              Reset to Defaults
            </Button>
            <Button type="submit">
              Save Changes
            </Button>
          </div>
        </form>
      </div>
    </AdminLayout>
  )
} 
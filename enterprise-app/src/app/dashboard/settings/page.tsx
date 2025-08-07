'use client';

import Button from '@/components/Button';
import Card from '@/components/Card';
import FormInput from '@/components/FormInput';
import { 
  User, 
  Bell, 
  Shield, 
  Globe, 
  Palette, 
  Save,
  Eye,
  EyeOff,
  Key
} from 'lucide-react';
import { useState } from 'react';

export default function SettingsPage() {
  const [activeTab, setActiveTab] = useState('profile');
  const [showPassword, setShowPassword] = useState(false);
  const [showApiKey, setShowApiKey] = useState(false);

  const [profileData, setProfileData] = useState({
    name: 'John Smith',
    email: 'john@techcorp.com',
    company: 'TechCorp Solutions',
    phone: '+49 30 12345678',
    timezone: 'Europe/Berlin',
  });

  const [securityData, setSecurityData] = useState({
    currentPassword: '',
    newPassword: '',
    confirmPassword: '',
    twoFactorEnabled: true,
    sessionTimeout: 30,
  });

  const [notifications, setNotifications] = useState({
    emailNotifications: true,
    billingAlerts: true,
    usageAlerts: true,
    securityAlerts: true,
    marketingEmails: false,
  });

  const [apiSettings, setApiSettings] = useState({
    webhookUrl: 'https://api.techcorp.com/webhooks/appoint',
    webhookSecret: 'whsec_1234567890abcdef',
    rateLimit: 1000,
    timeout: 30,
  });

  const tabs = [
    { id: 'profile', label: 'Profile', icon: User },
    { id: 'security', label: 'Security', icon: Shield },
    { id: 'notifications', label: 'Notifications', icon: Bell },
    { id: 'api', label: 'API Settings', icon: Key },
    { id: 'appearance', label: 'Appearance', icon: Palette },
  ];

  const handleProfileSave = () => {
    console.log('Saving profile data:', profileData);
    // Mock save functionality
  };

  const handleSecuritySave = () => {
    console.log('Saving security settings:', securityData);
    // Mock save functionality
  };

  const handleNotificationToggle = (key: string) => {
    setNotifications(prev => ({
      ...prev,
      [key]: !prev[key as keyof typeof prev]
    }));
  };

  const handleApiSave = () => {
    console.log('Saving API settings:', apiSettings);
    // Mock save functionality
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-neutral-900">Settings</h1>
        <p className="text-neutral-600 mt-1">
          Manage your account settings and preferences
        </p>
      </div>

      {/* Tabs */}
      <div className="border-b border-neutral-200">
        <nav className="flex space-x-8">
          {tabs.map((tab) => {
            const Icon = tab.icon;
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex items-center gap-2 py-4 px-1 border-b-2 font-medium text-sm ${
                  activeTab === tab.id
                    ? 'border-primary-500 text-primary-600'
                    : 'border-transparent text-neutral-500 hover:text-neutral-700 hover:border-neutral-300'
                }`}
              >
                <Icon className="w-4 h-4" />
                {tab.label}
              </button>
            );
          })}
        </nav>
      </div>

      {/* Profile Tab */}
      {activeTab === 'profile' && (
        <Card className="p-6">
          <h2 className="text-lg font-semibold text-neutral-900 mb-6">Profile Information</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <FormInput
              label="Full Name"
              value={profileData.name}
              onChange={(value) => setProfileData(prev => ({ ...prev, name: value }))}
              placeholder="Enter your full name"
            />
            <FormInput
              label="Email Address"
              type="email"
              value={profileData.email}
              onChange={(value) => setProfileData(prev => ({ ...prev, email: value }))}
              placeholder="Enter your email address"
            />
            <FormInput
              label="Company Name"
              value={profileData.company}
              onChange={(value) => setProfileData(prev => ({ ...prev, company: value }))}
              placeholder="Enter your company name"
            />
            <FormInput
              label="Phone Number"
              value={profileData.phone}
              onChange={(value) => setProfileData(prev => ({ ...prev, phone: value }))}
              placeholder="Enter your phone number"
            />
            <FormInput
              label="Timezone"
              value={profileData.timezone}
              onChange={(value) => setProfileData(prev => ({ ...prev, timezone: value }))}
              placeholder="Select your timezone"
            />
          </div>
          <div className="mt-6">
            <Button onClick={handleProfileSave} className="flex items-center gap-2">
              <Save className="w-4 h-4" />
              Save Changes
            </Button>
          </div>
        </Card>
      )}

      {/* Security Tab */}
      {activeTab === 'security' && (
        <Card className="p-6">
          <h2 className="text-lg font-semibold text-neutral-900 mb-6">Security Settings</h2>
          <div className="space-y-6">
            <div>
              <h3 className="font-medium text-neutral-900 mb-4">Change Password</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <FormInput
                  label="Current Password"
                  type={showPassword ? 'text' : 'password'}
                  value={securityData.currentPassword}
                  onChange={(value) => setSecurityData(prev => ({ ...prev, currentPassword: value }))}
                  placeholder="Enter current password"
                />
                <div className="flex items-end">
                  <button
                    onClick={() => setShowPassword(!showPassword)}
                    className="text-neutral-500 hover:text-neutral-700"
                    aria-label={showPassword ? "Hide password" : "Show password"}
                  >
                    {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                  </button>
                </div>
                <FormInput
                  label="New Password"
                  type="password"
                  value={securityData.newPassword}
                  onChange={(value) => setSecurityData(prev => ({ ...prev, newPassword: value }))}
                  placeholder="Enter new password"
                />
                <FormInput
                  label="Confirm New Password"
                  type="password"
                  value={securityData.confirmPassword}
                  onChange={(value) => setSecurityData(prev => ({ ...prev, confirmPassword: value }))}
                  placeholder="Confirm new password"
                />
              </div>
            </div>

            <div>
              <h3 className="font-medium text-neutral-900 mb-4">Two-Factor Authentication</h3>
              <div className="flex items-center justify-between p-4 border border-neutral-200 rounded-lg">
                <div>
                  <div className="font-medium text-neutral-900">Two-Factor Authentication</div>
                  <div className="text-sm text-neutral-600">
                    Add an extra layer of security to your account
                  </div>
                </div>
                <label className="relative inline-flex items-center cursor-pointer">
                  <input
                    type="checkbox"
                    checked={securityData.twoFactorEnabled}
                    onChange={(e) => setSecurityData(prev => ({ ...prev, twoFactorEnabled: e.target.checked }))}
                    className="sr-only peer"
                    aria-label="Enable two-factor authentication"
                  />
                  <div className="w-11 h-6 bg-neutral-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-neutral-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary-600"></div>
                </label>
              </div>
            </div>

            <div>
              <h3 className="font-medium text-neutral-900 mb-4">Session Timeout</h3>
              <div className="flex items-center gap-4">
                <select
                  value={securityData.sessionTimeout}
                  onChange={(e) => setSecurityData(prev => ({ ...prev, sessionTimeout: parseInt(e.target.value) }))}
                  className="border border-neutral-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  aria-label="Select session timeout"
                >
                  <option value={15}>15 minutes</option>
                  <option value={30}>30 minutes</option>
                  <option value={60}>1 hour</option>
                  <option value={120}>2 hours</option>
                </select>
                <span className="text-sm text-neutral-600">
                  Automatically log out after inactivity
                </span>
              </div>
            </div>

            <Button onClick={handleSecuritySave} className="flex items-center gap-2">
              <Save className="w-4 h-4" />
              Save Security Settings
            </Button>
          </div>
        </Card>
      )}

      {/* Notifications Tab */}
      {activeTab === 'notifications' && (
        <Card className="p-6">
          <h2 className="text-lg font-semibold text-neutral-900 mb-6">Notification Preferences</h2>
          <div className="space-y-4">
            {Object.entries(notifications).map(([key, value]) => (
              <div key={key} className="flex items-center justify-between p-4 border border-neutral-200 rounded-lg">
                <div>
                  <div className="font-medium text-neutral-900">
                    {key.replace(/([A-Z])/g, ' $1').replace(/^./, str => str.toUpperCase())}
                  </div>
                  <div className="text-sm text-neutral-600">
                    Receive notifications about {key.toLowerCase().replace(/([A-Z])/g, ' $1')}
                  </div>
                </div>
                <label className="relative inline-flex items-center cursor-pointer">
                  <input
                    type="checkbox"
                    checked={value}
                    onChange={() => handleNotificationToggle(key)}
                    className="sr-only peer"
                    aria-label={`Toggle ${key.replace(/([A-Z])/g, ' $1').toLowerCase()} notifications`}
                  />
                  <div className="w-11 h-6 bg-neutral-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-neutral-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary-600"></div>
                </label>
              </div>
            ))}
          </div>
        </Card>
      )}

      {/* API Settings Tab */}
      {activeTab === 'api' && (
        <Card className="p-6">
          <h2 className="text-lg font-semibold text-neutral-900 mb-6">API Configuration</h2>
          <div className="space-y-6">
            <div>
              <h3 className="font-medium text-neutral-900 mb-4">Webhook Settings</h3>
              <div className="space-y-4">
                <FormInput
                  label="Webhook URL"
                  value={apiSettings.webhookUrl}
                  onChange={(value) => setApiSettings(prev => ({ ...prev, webhookUrl: value }))}
                  placeholder="https://your-domain.com/webhooks/appoint"
                />
                <div>
                  <label className="block text-sm font-medium text-neutral-700 mb-2">
                    Webhook Secret
                  </label>
                  <div className="flex items-center gap-2">
                                         <input
                       type={showApiKey ? 'text' : 'password'}
                       value={apiSettings.webhookSecret}
                       onChange={(e) => setApiSettings(prev => ({ ...prev, webhookSecret: e.target.value }))}
                       className="flex-1 border border-neutral-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                       placeholder="Enter webhook secret"
                       aria-label="Webhook secret"
                     />
                    <button
                      onClick={() => setShowApiKey(!showApiKey)}
                      className="text-neutral-500 hover:text-neutral-700"
                      aria-label={showApiKey ? "Hide webhook secret" : "Show webhook secret"}
                    >
                      {showApiKey ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <div>
              <h3 className="font-medium text-neutral-900 mb-4">Rate Limiting</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label className="block text-sm font-medium text-neutral-700 mb-2">
                    Rate Limit (requests per minute)
                  </label>
                  <input
                    type="number"
                    value={apiSettings.rateLimit}
                    onChange={(e) => setApiSettings(prev => ({ ...prev, rateLimit: parseInt(e.target.value) }))}
                    className="border border-neutral-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-neutral-700 mb-2">
                    Timeout (seconds)
                  </label>
                  <input
                    type="number"
                    value={apiSettings.timeout}
                    onChange={(e) => setApiSettings(prev => ({ ...prev, timeout: parseInt(e.target.value) }))}
                    className="border border-neutral-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  />
                </div>
              </div>
            </div>

            <Button onClick={handleApiSave} className="flex items-center gap-2">
              <Save className="w-4 h-4" />
              Save API Settings
            </Button>
          </div>
        </Card>
      )}

      {/* Appearance Tab */}
      {activeTab === 'appearance' && (
        <Card className="p-6">
          <h2 className="text-lg font-semibold text-neutral-900 mb-6">Appearance Settings</h2>
          <div className="space-y-6">
            <div>
              <h3 className="font-medium text-neutral-900 mb-4">Theme</h3>
              <div className="grid grid-cols-3 gap-4">
                <button className="p-4 border-2 border-primary-500 rounded-lg bg-white">
                  <div className="w-full h-8 bg-neutral-100 rounded mb-2"></div>
                  <div className="text-sm font-medium text-neutral-900">Light</div>
                </button>
                <button className="p-4 border-2 border-transparent rounded-lg bg-neutral-800">
                  <div className="w-full h-8 bg-neutral-700 rounded mb-2"></div>
                  <div className="text-sm font-medium text-white">Dark</div>
                </button>
                <button className="p-4 border-2 border-transparent rounded-lg bg-white">
                  <div className="w-full h-8 bg-gradient-to-r from-primary-100 to-secondary-100 rounded mb-2"></div>
                  <div className="text-sm font-medium text-neutral-900">Auto</div>
                </button>
              </div>
            </div>

            <div>
              <h3 className="font-medium text-neutral-900 mb-4">Language</h3>
              <select className="border border-neutral-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent">
                <option value="en">English</option>
                <option value="de">Deutsch</option>
                <option value="fr">Français</option>
                <option value="es">Español</option>
              </select>
            </div>
          </div>
        </Card>
      )}
    </div>
  );
} 
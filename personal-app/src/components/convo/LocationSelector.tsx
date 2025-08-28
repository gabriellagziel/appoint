'use client';

import { useState } from 'react';
import { MapPin, Globe, Building, Search, ExternalLink } from 'lucide-react';

interface Location {
  type: 'physical' | 'virtual' | 'business';
  value: string;
  details?: {
    address?: string;
    coordinates?: { lat: number; lng: number };
    platform?: string;
    businessInfo?: {
      name: string;
      address: string;
      hours: string;
      phone: string;
    };
  };
}

interface LocationSelectorProps {
  location: Location | null;
  onLocationChange: (location: Location) => void;
  className?: string;
}

export default function LocationSelector({ 
  location, 
  onLocationChange, 
  className = '' 
}: LocationSelectorProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [locationType, setLocationType] = useState<'physical' | 'virtual' | 'business'>('physical');
  const [showMapsPreview, setShowMapsPreview] = useState(false);

  // Mock business data - in real app this would come from Business API
  const mockBusinesses = [
    {
      name: 'Caffè Giusti',
      address: 'Via Emilia, 123, Modena',
      hours: 'Mon-Fri: 7AM-8PM, Sat-Sun: 8AM-9PM',
      phone: '+39 059 123 456'
    },
    {
      name: 'Restaurant Bella Vista',
      address: 'Piazza Grande, 45, Modena',
      hours: 'Tue-Sun: 12PM-11PM, Mon: Closed',
      phone: '+39 059 789 012'
    }
  ];

  const filteredBusinesses = mockBusinesses.filter(business =>
    business.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    business.address.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const virtualPlatforms = [
    { id: 'zoom', name: 'Zoom', icon: '🔵' },
    { id: 'meet', name: 'Google Meet', icon: '🟢' },
    { id: 'teams', name: 'Microsoft Teams', icon: '🔵' },
    { id: 'phone', name: 'Phone Call', icon: '📞' },
    { id: 'custom', name: 'Custom Link', icon: '🔗' }
  ];

  const handleLocationChange = (type: 'physical' | 'virtual' | 'business', value: string, details?: any) => {
    onLocationChange({
      type,
      value,
      details
    });
  };

  const openMapsPreview = (address: string) => {
    const encodedAddress = encodeURIComponent(address);
    window.open(`https://www.google.com/maps/search/?api=1&query=${encodedAddress}`, '_blank');
  };

  return (
    <div className={`space-y-4 ${className}`}>
      {/* Location Type Selection */}
      <div className="grid grid-cols-3 gap-3">
        <button
          onClick={() => setLocationType('physical')}
          className={`p-3 rounded-xl border-2 transition-colors ${
            locationType === 'physical'
              ? 'border-blue-500 bg-blue-50 text-blue-700'
              : 'border-gray-200 hover:border-gray-300'
          }`}
        >
          <MapPin className="w-6 h-6 mx-auto mb-2" />
          <div className="text-sm font-medium">Physical</div>
        </button>
        <button
          onClick={() => setLocationType('virtual')}
          className={`p-3 rounded-xl border-2 transition-colors ${
            locationType === 'virtual'
              ? 'border-blue-500 bg-blue-50 text-blue-700'
              : 'border-gray-200 hover:border-gray-300'
          }`}
        >
          <Globe className="w-6 h-6 mx-auto mb-2" />
          <div className="text-sm font-medium">Virtual</div>
        </button>
        <button
          onClick={() => setLocationType('business')}
          className={`p-3 rounded-xl border-2 transition-colors ${
            locationType === 'business'
              ? 'border-blue-500 bg-blue-50 text-blue-700'
              : 'border-gray-200 hover:border-gray-300'
          }`}
        >
          <Building className="w-6 h-6 mx-auto mb-2" />
          <div className="text-sm font-medium">Business</div>
        </button>
      </div>

      {/* Physical Location */}
      {locationType === 'physical' && (
        <div className="space-y-3">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
            <input
              type="text"
              placeholder="Enter address or location..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-10 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:border-blue-500 focus:outline-none"
            />
          </div>
          
          {searchQuery && (
            <div className="space-y-2">
              <button
                onClick={() => {
                  handleLocationChange('physical', searchQuery, { address: searchQuery });
                  setShowMapsPreview(true);
                }}
                className="w-full text-left p-3 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
              >
                <div className="flex items-center justify-between">
                  <span className="font-medium">{searchQuery}</span>
                  <MapPin className="w-4 h-4 text-blue-500" />
                </div>
              </button>
            </div>
          )}

          {showMapsPreview && (
            <div className="p-4 bg-blue-50 border border-blue-200 rounded-xl">
              <div className="flex items-center justify-between mb-2">
                <span className="font-medium text-blue-800">Location Preview</span>
                <button
                  onClick={() => openMapsPreview(searchQuery)}
                  className="flex items-center gap-2 text-blue-600 hover:text-blue-700 text-sm"
                >
                  <ExternalLink className="w-4 h-4" />
                  Open in Maps
                </button>
              </div>
              <div className="text-sm text-blue-700">
                Address: {searchQuery}
              </div>
            </div>
          )}
        </div>
      )}

      {/* Virtual Platform */}
      {locationType === 'virtual' && (
        <div className="space-y-3">
          <div className="grid grid-cols-2 gap-3">
            {virtualPlatforms.map(platform => (
              <button
                key={platform.id}
                onClick={() => handleLocationChange('virtual', platform.name, { platform: platform.id })}
                className="p-3 border-2 border-gray-200 rounded-xl hover:border-blue-300 hover:bg-blue-50 transition-colors text-center"
              >
                <div className="text-2xl mb-2">{platform.icon}</div>
                <div className="font-medium text-sm">{platform.name}</div>
              </button>
            ))}
          </div>
          
          {location?.type === 'virtual' && (
            <div className="space-y-2">
              <label className="block text-sm font-medium text-gray-700">
                Meeting Link or Details
              </label>
              <input
                type="text"
                placeholder="Enter meeting link, phone number, or details..."
                className="w-full p-3 border-2 border-gray-200 rounded-xl focus:border-blue-500 focus:outline-none"
                onChange={(e) => handleLocationChange('virtual', location.value, { 
                  ...location.details, 
                  link: e.target.value 
                })}
              />
            </div>
          )}
        </div>
      )}

      {/* Business Location */}
      {locationType === 'business' && (
        <div className="space-y-3">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
            <input
              type="text"
              placeholder="Search for businesses..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-10 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:border-blue-500 focus:outline-none"
            />
          </div>

          {searchQuery && filteredBusinesses.length > 0 && (
            <div className="space-y-2">
              {filteredBusinesses.map(business => (
                <button
                  key={business.name}
                  onClick={() => handleLocationChange('business', business.name, { businessInfo: business })}
                  className="w-full text-left p-3 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
                >
                  <div className="font-medium">{business.name}</div>
                  <div className="text-sm text-gray-600">{business.address}</div>
                  <div className="text-xs text-gray-500 mt-1">
                    {business.hours} • {business.phone}
                  </div>
                </button>
              ))}
            </div>
          )}
        </div>
      )}

      {/* Selected Location Display */}
      {location && (
        <div className="p-4 bg-green-50 border border-green-200 rounded-xl">
          <div className="flex items-center justify-between">
            <div>
              <div className="font-medium text-green-800">
                {location.type === 'physical' && <MapPin className="w-4 h-4 inline mr-2" />}
                {location.type === 'virtual' && <Globe className="w-4 h-4 inline mr-2" />}
                {location.type === 'business' && <Building className="w-4 h-4 inline mr-2" />}
                {location.value}
              </div>
              {location.details?.address && (
                <div className="text-sm text-green-600 mt-1">{location.details.address}</div>
              )}
              {location.details?.platform && (
                <div className="text-sm text-green-600 mt-1">Platform: {location.details.platform}</div>
              )}
            </div>
            {location.type === 'physical' && location.details?.address && (
              <button
                onClick={() => location.details?.address && openMapsPreview(location.details.address)}
                className="p-2 text-green-600 hover:bg-green-100 rounded-lg transition-colors"
                aria-label="Open in Maps"
                title="Open in Maps"
              >
                <ExternalLink className="w-4 h-4" />
              </button>
            )}
          </div>
        </div>
      )}
    </div>
  );
}


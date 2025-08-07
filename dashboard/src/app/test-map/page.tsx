'use client';

import { useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import MapWidget from '@/components/MapWidget';

export default function TestMapPage() {
  const [latitude, setLatitude] = useState('37.7749');
  const [longitude, setLongitude] = useState('-122.4194');
  const [address, setAddress] = useState('123 Main Street, San Francisco, CA');

  const handleTestMap = () => {
    // Force re-render with new coordinates
    setLatitude(latitude);
    setLongitude(longitude);
  };

  const openDirections = () => {
    const url = `https://www.google.com/maps/dir/?api=1&destination=${latitude},${longitude}`;
    window.open(url, '_blank');
  };

  return (
    <div className="container mx-auto p-6 max-w-4xl">
      <div className="mb-6">
        <h1 className="text-3xl font-bold mb-2">OpenStreetMap Widget Test</h1>
        <p className="text-gray-600">
          Test the interactive OpenStreetMap widget implementation
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Controls */}
        <Card>
          <CardHeader>
            <CardTitle>Map Configuration</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <Label htmlFor="latitude">Latitude</Label>
              <Input
                id="latitude"
                value={latitude}
                onChange={(e) => setLatitude(e.target.value)}
                placeholder="37.7749"
              />
            </div>
            <div>
              <Label htmlFor="longitude">Longitude</Label>
              <Input
                id="longitude"
                value={longitude}
                onChange={(e) => setLongitude(e.target.value)}
                placeholder="-122.4194"
              />
            </div>
            <div>
              <Label htmlFor="address">Address (Optional)</Label>
              <Input
                id="address"
                value={address}
                onChange={(e) => setAddress(e.target.value)}
                placeholder="123 Main Street, San Francisco, CA"
              />
            </div>
            <div className="flex gap-2">
              <Button onClick={handleTestMap} className="flex-1">
                Update Map
              </Button>
              <Button onClick={openDirections} variant="outline">
                Get Directions
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* Map Display */}
        <Card>
          <CardHeader>
            <CardTitle>Interactive Map</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="h-96">
              <MapWidget
                latitude={parseFloat(latitude) || 37.7749}
                longitude={parseFloat(longitude) || -122.4194}
                address={address}
                height="100%"
              />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Test Locations */}
      <Card className="mt-6">
        <CardHeader>
          <CardTitle>Test Locations</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <Button
              variant="outline"
              onClick={() => {
                setLatitude('40.7128');
                setLongitude('-74.0060');
                setAddress('New York City, NY');
              }}
            >
              New York City
            </Button>
            <Button
              variant="outline"
              onClick={() => {
                setLatitude('51.5074');
                setLongitude('-0.1278');
                setAddress('London, UK');
              }}
            >
              London
            </Button>
            <Button
              variant="outline"
              onClick={() => {
                setLatitude('35.6762');
                setLongitude('139.6503');
                setAddress('Tokyo, Japan');
              }}
            >
              Tokyo
            </Button>
          </div>
        </CardContent>
      </Card>

      {/* Implementation Details */}
      <Card className="mt-6">
        <CardHeader>
          <CardTitle>Implementation Details</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div>
            <h3 className="font-semibold mb-2">✅ Features Implemented</h3>
            <ul className="list-disc list-inside space-y-1 text-sm text-gray-600">
              <li>Interactive OpenStreetMap with Leaflet.js</li>
              <li>Dynamic coordinate updates</li>
              <li>Custom markers with popups</li>
              <li>Google Maps navigation integration</li>
              <li>Responsive design</li>
              <li>Loading states</li>
            </ul>
          </div>
          <div>
            <h3 className="font-semibold mb-2">💰 Cost Benefits</h3>
            <ul className="list-disc list-inside space-y-1 text-sm text-gray-600">
              <li>Zero API costs (OpenStreetMap is free)</li>
              <li>No usage limits</li>
              <li>No API keys required</li>
              <li>Privacy-friendly (no tracking)</li>
            </ul>
          </div>
          <div>
            <h3 className="font-semibold mb-2">🎯 Policy Compliance</h3>
            <ul className="list-disc list-inside space-y-1 text-sm text-gray-600">
              <li>Google Maps for navigation only</li>
              <li>OpenStreetMap for display</li>
              <li>Zero Google Maps API billing</li>
            </ul>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}

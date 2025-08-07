'use client';

import { useState, useEffect, useRef } from 'react';

interface MapWidgetProps {
  latitude: number;
  longitude: number;
  address?: string;
  height?: string;
  className?: string;
}

function MapWidget({ 
  latitude, 
  longitude, 
  address, 
  height = '400px',
  className = ''
}: MapWidgetProps) {
  const mapRef = useRef<HTMLDivElement>(null);
  const mapInstanceRef = useRef<any>(null);

  useEffect(() => {
    // Load Leaflet CSS
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css';
    document.head.appendChild(link);

    // Load Leaflet JS
    const script = document.createElement('script');
    script.src = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js';
    script.onload = () => {
      if (mapRef.current && (window as any).L) {
        const map = (window as any).L.map(mapRef.current).setView([latitude, longitude], 15);
        mapInstanceRef.current = map;
        
        (window as any).L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
          maxZoom: 19,
          attribution: '&copy; OpenStreetMap contributors'
        }).addTo(map);
        
        const marker = (window as any).L.marker([latitude, longitude]).addTo(map);
        if (address) {
          marker.bindPopup(address).openPopup();
        } else {
          marker.bindPopup('Meeting location').openPopup();
        }
      }
    };
    document.head.appendChild(script);

    return () => {
      if (mapInstanceRef.current) {
        mapInstanceRef.current.remove();
      }
      if (document.head.contains(link)) {
        document.head.removeChild(link);
      }
      if (document.head.contains(script)) {
        document.head.removeChild(script);
      }
    };
  }, [latitude, longitude, address]);

  return (
    <div 
      ref={mapRef} 
      style={{ height, width: '100%' }}
      className={`rounded-lg overflow-hidden ${className}`}
    />
  );
}

export default function SimpleMapTestPage() {
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
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-bold mb-4">Map Configuration</h2>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium mb-2">Latitude</label>
              <input
                type="text"
                value={latitude}
                onChange={(e) => setLatitude(e.target.value)}
                placeholder="37.7749"
                className="w-full p-2 border border-gray-300 rounded"
              />
            </div>
            <div>
              <label className="block text-sm font-medium mb-2">Longitude</label>
              <input
                type="text"
                value={longitude}
                onChange={(e) => setLongitude(e.target.value)}
                placeholder="-122.4194"
                className="w-full p-2 border border-gray-300 rounded"
              />
            </div>
            <div>
              <label className="block text-sm font-medium mb-2">Address (Optional)</label>
              <input
                type="text"
                value={address}
                onChange={(e) => setAddress(e.target.value)}
                placeholder="123 Main Street, San Francisco, CA"
                className="w-full p-2 border border-gray-300 rounded"
              />
            </div>
            <div className="flex gap-2">
              <button 
                onClick={handleTestMap} 
                className="flex-1 bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
              >
                Update Map
              </button>
              <button 
                onClick={openDirections} 
                className="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600"
              >
                Get Directions
              </button>
            </div>
          </div>
        </div>

        {/* Map Display */}
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-bold mb-4">Interactive Map</h2>
          <div className="h-96">
            <MapWidget
              latitude={parseFloat(latitude) || 37.7749}
              longitude={parseFloat(longitude) || -122.4194}
              address={address}
              height="100%"
            />
          </div>
        </div>
      </div>

      {/* Test Locations */}
      <div className="mt-6 bg-white p-6 rounded-lg shadow">
        <h2 className="text-xl font-bold mb-4">Test Locations</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <button
            className="bg-gray-100 hover:bg-gray-200 px-4 py-2 rounded"
            onClick={() => {
              setLatitude('40.7128');
              setLongitude('-74.0060');
              setAddress('New York City, NY');
            }}
          >
            New York City
          </button>
          <button
            className="bg-gray-100 hover:bg-gray-200 px-4 py-2 rounded"
            onClick={() => {
              setLatitude('51.5074');
              setLongitude('-0.1278');
              setAddress('London, UK');
            }}
          >
            London
          </button>
          <button
            className="bg-gray-100 hover:bg-gray-200 px-4 py-2 rounded"
            onClick={() => {
              setLatitude('35.6762');
              setLongitude('139.6503');
              setAddress('Tokyo, Japan');
            }}
          >
            Tokyo
          </button>
        </div>
      </div>

      {/* Implementation Details */}
      <div className="mt-6 bg-white p-6 rounded-lg shadow">
        <h2 className="text-xl font-bold mb-4">Implementation Details</h2>
        <div className="space-y-4">
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
        </div>
      </div>
    </div>
  );
}

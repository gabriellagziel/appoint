'use client';

import { useEffect, useRef } from 'react';

interface MapWidgetProps {
  latitude: number;
  longitude: number;
  address?: string;
  height?: string;
  className?: string;
}

declare global {
  interface Window {
    L: any;
  }
}

export default function MapWidget({ 
  latitude, 
  longitude, 
  address, 
  height = '400px',
  className = ''
}: MapWidgetProps) {
  const mapRef = useRef<HTMLDivElement>(null);
  const mapInstanceRef = useRef<any>(null);

  useEffect(() => {
    // Load Leaflet CSS dynamically
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css';
    document.head.appendChild(link);

    // Load Leaflet JS dynamically
    const script = document.createElement('script');
    script.src = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js';
    script.onload = () => {
      if (mapRef.current && window.L) {
        // Initialize map
        const map = window.L.map(mapRef.current).setView([latitude, longitude], 15);
        mapInstanceRef.current = map;

        // Add tile layer
        window.L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
          maxZoom: 19,
          attribution: '&copy; OpenStreetMap contributors'
        }).addTo(map);

        // Add marker
        const marker = window.L.marker([latitude, longitude]).addTo(map);
        
        // Add popup with address if available
        if (address) {
          marker.bindPopup(address).openPopup();
        } else {
          marker.bindPopup('Meeting location').openPopup();
        }
      }
    };
    document.head.appendChild(script);

    // Cleanup function
    return () => {
      if (mapInstanceRef.current) {
        mapInstanceRef.current.remove();
      }
      // Remove dynamically added elements
      document.head.removeChild(link);
      document.head.removeChild(script);
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

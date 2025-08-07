"use client"

import React from "react"

interface LogoProps {
  size?: number
  showText?: boolean
  className?: string
}

export function Logo({ size = 40, showText = true, className = "" }: LogoProps) {
  return (
    <div className={`flex items-center space-x-3 ${className}`}>
      {/* Logo SVG */}
      <div 
        className="relative flex-shrink-0 bg-white rounded-full border-2 border-gray-200 shadow-sm"
        style={{ width: size, height: size }}
      >
        <svg
          width={size}
          height={size}
          viewBox="0 0 512 512"
          xmlns="http://www.w3.org/2000/svg"
          className="rounded-full"
        >
          {/* Background circle */}
          <circle cx="256" cy="256" r="240" fill="white" stroke="#f0f0f0" strokeWidth="2"/>
          
          {/* 8 stylized human figures arranged in a circle */}
          {/* Top figure (Orange) */}
          <path d="M256 80 C256 80, 240 100, 240 120 C240 140, 256 160, 256 160 C256 160, 272 140, 272 120 C272 100, 256 80, 256 80" fill="#FF8C00"/>
          
          {/* Top-right figure (Peach) */}
          <path d="M360 120 C360 120, 340 140, 340 160 C340 180, 360 200, 360 200 C360 200, 380 180, 380 160 C380 140, 360 120, 360 120" fill="#FFB366"/>
          
          {/* Right figure (Teal) */}
          <path d="M432 256 C432 256, 412 240, 412 220 C412 200, 432 180, 432 180 C432 180, 452 200, 452 220 C452 240, 432 256, 432 256" fill="#20B2AA"/>
          
          {/* Bottom-right figure (Purple) */}
          <path d="M360 392 C360 392, 380 372, 380 352 C380 332, 360 312, 360 312 C360 312, 340 332, 340 352 C340 372, 360 392, 360 392" fill="#8A2BE2"/>
          
          {/* Bottom figure (Dark Purple) */}
          <path d="M256 432 C256 432, 272 412, 272 392 C272 372, 256 352, 256 352 C256 352, 240 372, 240 392 C240 412, 256 432, 256 432" fill="#4B0082"/>
          
          {/* Bottom-left figure (Blue) */}
          <path d="M152 392 C152 392, 132 372, 132 352 C132 332, 152 312, 152 312 C152 312, 172 332, 172 352 C172 372, 152 392, 152 392" fill="#4169E1"/>
          
          {/* Left figure (Green) */}
          <path d="M80 256 C80 256, 100 240, 100 220 C100 200, 80 180, 80 180 C80 180, 60 200, 60 220 C60 240, 80 256, 80 256" fill="#32CD32"/>
          
          {/* Top-left figure (Yellow) */}
          <path d="M152 120 C152 120, 172 140, 172 160 C172 180, 152 200, 152 200 C152 200, 132 180, 132 160 C132 140, 152 120, 152 120" fill="#FFD700"/>
          
          {/* Center connection point */}
          <circle cx="256" cy="256" r="8" fill="#333"/>
        </svg>
      </div>
      
      {/* Text */}
      {showText && (
        <div className="flex flex-col">
          <span className="text-xl font-bold text-gray-900">APP-OINT</span>
          <span className="text-xs text-gray-500">Time Organized • Set Send Done</span>
        </div>
      )}
    </div>
  )
}
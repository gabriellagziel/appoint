'use client'

import { useEffect, useRef } from 'react';

interface BarChartProps {
  data: Array<{ label: string; value: number; color?: string }>
  title: string
  height?: number
}

export const BarChart = ({ data, title, height = 300 }: BarChartProps) => {
  const canvasRef = useRef<HTMLCanvasElement>(null)

  useEffect(() => {
    const canvas = canvasRef.current
    if (!canvas || !data.length) return

    const ctx = canvas.getContext('2d')
    if (!ctx) return

    // Clear canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height)

    const maxValue = Math.max(...data.map(d => d.value))
    const barWidth = (canvas.width - 40) / data.length
    const maxBarHeight = canvas.height - 60

    // Draw bars
    data.forEach((item, index) => {
      const barHeight = (item.value / maxValue) * maxBarHeight
      const x = 20 + index * barWidth
      const y = canvas.height - 40 - barHeight

      // Draw bar
      ctx.fillStyle = item.color || '#3B82F6'
      ctx.fillRect(x, y, barWidth - 10, barHeight)

      // Draw label
      ctx.fillStyle = '#374151'
      ctx.font = '12px Inter'
      ctx.textAlign = 'center'
      ctx.fillText(item.label, x + barWidth / 2 - 5, canvas.height - 20)

      // Draw value
      ctx.fillStyle = '#6B7280'
      ctx.font = '10px Inter'
      ctx.fillText(item.value.toString(), x + barWidth / 2 - 5, y - 10)
    })

    // Draw title
    ctx.fillStyle = '#111827'
    ctx.font = 'bold 16px Inter'
    ctx.textAlign = 'center'
    ctx.fillText(title, canvas.width / 2, 20)
  }, [data, title])

  return (
    <div className="bg-white rounded-lg shadow p-6">
      <canvas
        ref={canvasRef}
        width={400}
        height={height}
        className="w-full"
      />
    </div>
  )
} 
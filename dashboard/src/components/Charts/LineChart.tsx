'use client'

import { useEffect, useRef } from 'react';

interface LineChartProps {
  data: Array<{ label: string; value: number }>
  title: string
  height?: number
  color?: string
}

export const LineChart = ({ data, title, height = 300, color = '#3B82F6' }: LineChartProps) => {
  const canvasRef = useRef<HTMLCanvasElement>(null)

  useEffect(() => {
    const canvas = canvasRef.current
    if (!canvas || !data.length) return

    const ctx = canvas.getContext('2d')
    if (!ctx) return

    // Clear canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height)

    const maxValue = Math.max(...data.map(d => d.value))
    const minValue = Math.min(...data.map(d => d.value))
    const valueRange = maxValue - minValue || 1

    const padding = 40
    const chartWidth = canvas.width - 2 * padding
    const chartHeight = canvas.height - 2 * padding
    const pointSpacing = chartWidth / (data.length - 1)

    // Draw grid lines
    ctx.strokeStyle = '#E5E7EB'
    ctx.lineWidth = 1
    for (let i = 0; i <= 4; i++) {
      const y = padding + (i * chartHeight) / 4
      ctx.beginPath()
      ctx.moveTo(padding, y)
      ctx.lineTo(canvas.width - padding, y)
      ctx.stroke()
    }

    // Draw line
    ctx.strokeStyle = color
    ctx.lineWidth = 3
    ctx.beginPath()

    data.forEach((item, index) => {
      const x = padding + index * pointSpacing
      const y = padding + chartHeight - ((item.value - minValue) / valueRange) * chartHeight

      if (index === 0) {
        ctx.moveTo(x, y)
      } else {
        ctx.lineTo(x, y)
      }
    })

    ctx.stroke()

    // Draw points
    ctx.fillStyle = color
    data.forEach((item, index) => {
      const x = padding + index * pointSpacing
      const y = padding + chartHeight - ((item.value - minValue) / valueRange) * chartHeight

      ctx.beginPath()
      ctx.arc(x, y, 4, 0, 2 * Math.PI)
      ctx.fill()
    })

    // Draw labels
    ctx.fillStyle = '#374151'
    ctx.font = '12px Inter'
    ctx.textAlign = 'center'
    data.forEach((item, index) => {
      const x = padding + index * pointSpacing
      ctx.fillText(item.label, x, canvas.height - 10)
    })

    // Draw title
    ctx.fillStyle = '#111827'
    ctx.font = 'bold 16px Inter'
    ctx.textAlign = 'center'
    ctx.fillText(title, canvas.width / 2, 20)
  }, [data, title, color])

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
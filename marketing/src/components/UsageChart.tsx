import { ResponsiveContainer, LineChart, Line, XAxis, YAxis, Tooltip } from 'recharts'
import { useI18n } from '@/lib/i18n'

interface Props {
  data: { date: string; calls: number }[]
}

export const UsageChart: React.FC<Props> = ({ data }) => {
  const { t } = useI18n()
  return (
    <div className="w-full h-64">
      <h3 className="font-semibold mb-2">{t('dashboard.usage')}</h3>
      <ResponsiveContainer width="100%" height="100%">
        <LineChart data={data}>
          <XAxis dataKey="date" />
          <YAxis />
          <Tooltip />
          <Line type="monotone" dataKey="calls" stroke="#8884d8" strokeWidth={2} />
        </LineChart>
      </ResponsiveContainer>
    </div>
  )
}
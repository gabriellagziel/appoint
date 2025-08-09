"use client";

export default function UsageProgressBar({ value }: { value: number }) {
  return (
    <div>
      <div style={{ width: `${value}%`, background: 'green', height: 10 }} />
      <span>{value}%</span>
    </div>
  );
}




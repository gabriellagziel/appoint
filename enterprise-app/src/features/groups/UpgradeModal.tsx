"use client";
import { useState } from 'react';
export default function UpgradeModal({ groupId }: { groupId: string }) {
  const [loading, setLoading] = useState(false);
  const upgrade = async () => {
    try {
      setLoading(true);
      const priceId = process.env.NEXT_PUBLIC_GROUP_PRO_PRICE_ID || '';
      const res = await fetch(`/api/groups/${groupId}/upgrade?priceId=${encodeURIComponent(priceId)}`);
      const data = await res.json();
      if (data?.url) {
        window.location.href = data.url as string;
      }
    } finally {
      setLoading(false);
    }
  };
  return (
    <button onClick={upgrade} disabled={loading}>
      {loading ? '...טוען' : 'שדרג עכשיו'}
    </button>
  );
}




"use client";
import UsageProgressBar from './UsageProgressBar';
import UpsellBanner from './UpsellBanner';

export default function GroupPage({ group }: { group: any }) {
  return (
    <div>
      <h1>{group.name}</h1>
      <UsageProgressBar value={group.usageScore} />
      {group.usageScore >= 70 && group.type === 'community' && (
        <UpsellBanner groupId={group.id} />
      )}
    </div>
  );
}




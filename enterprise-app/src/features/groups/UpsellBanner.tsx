"use client";
import UpgradeModal from './UpgradeModal';
export default function UpsellBanner({ groupId }: { groupId: string }) {
  return (
    <div>
      <p>הקבוצה שלכם פעילה במיוחד. שדרגו לקבוצת Pro!</p>
      <UpgradeModal groupId={groupId} />
    </div>
  );
}




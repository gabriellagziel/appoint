import { Group } from './groupTypes';

export const calculateUsageScore = (group: Group): number => {
  let score = 0;
  if (group.events.length > 10) score += 20;
  if (group.members.length > 30) score += 20;
  if (group.events.length / 4 > 4) score += 15; // 4+ per week
  if (group.members.length > 40) score += 15; // joins spike
  return Math.min(score, 100);
};




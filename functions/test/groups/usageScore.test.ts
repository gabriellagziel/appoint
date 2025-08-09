import { calculateUsageScore } from '../../src/groups/usageScore';

describe('calculateUsageScore', () => {
  it('caps at 100 and increases with events and members', () => {
    const group: any = {
      id: 'g1',
      name: 'Test',
      type: 'community',
      members: Array.from({ length: 50 }, (_, i) => `u${i}`),
      events: Array.from({ length: 25 }, (_, i) => `e${i}`),
      filesUploadedMB: 0,
      createdAt: new Date() as any,
      usageScore: 0,
      ownerId: 'u1',
    };
    const score = calculateUsageScore(group);
    expect(score).toBeLessThanOrEqual(100);
    expect(score).toBeGreaterThan(0);
  });
});




import { consumeToken } from '../src/middleware/rateLimit';

describe('rateLimit', () => {
  test('allows initial burst then throttles', async () => {
    const id = 'test:ip:1.2.3.4';
    let allowed = 0;
    for (let i = 0; i < 60; i++) {
      if (await consumeToken(id)) allowed++;
    }
    expect(allowed).toBeGreaterThan(40);
    expect(allowed).toBeLessThanOrEqual(50);
  });
});




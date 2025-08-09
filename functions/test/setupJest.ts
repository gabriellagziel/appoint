// Stable global fetch mock for legacy tests
global.fetch = (jest.fn(() =>
  Promise.resolve({ ok: true, json: async () => ({ ok: true }) })
)) as any;



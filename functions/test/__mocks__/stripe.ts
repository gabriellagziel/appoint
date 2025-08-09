export default function Stripe() {
  return {
    checkout: {
      sessions: {
        create: jest.fn().mockResolvedValue({ id: 'cs_test', url: 'https://example.com' }),
      },
    },
  } as any;
}



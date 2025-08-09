import Stripe from 'stripe';
import { createProCheckoutSession } from '../../src/groups/proUpgrade';

jest.mock('stripe');

describe('createProCheckoutSession', () => {
  it('creates a checkout session with price and metadata', async () => {
    const mockCreate = jest.fn().mockResolvedValue({ id: 'sess_123', url: 'https://checkout.stripe.com/sess_123' });
    const Ctor = Stripe as unknown as jest.Mock;
    Ctor.mockImplementation(() => ({ checkout: { sessions: { create: mockCreate } } } as any));

    process.env.APP_URL = 'https://app.app-oint.com';
    const session = await createProCheckoutSession('group_1', 'price_123');
    expect(session).toBeDefined();
    expect(mockCreate).toHaveBeenCalledWith(expect.objectContaining({
      line_items: [expect.objectContaining({ price: 'price_123' })],
      metadata: expect.objectContaining({ groupId: 'group_1' }),
    }));
  });
});




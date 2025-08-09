import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY || '', {} as any);

export const createProCheckoutSession = async (groupId: string, priceId: string) => {
  const session = await stripe.checkout.sessions.create({
    mode: 'subscription',
    payment_method_types: ['card'],
    line_items: [{ price: priceId, quantity: 1 }],
    success_url: `${process.env.APP_URL}/groups/${groupId}?upgraded=true`,
    cancel_url: `${process.env.APP_URL}/groups/${groupId}`,
    metadata: { groupId },
  } as any);
  return session;
};




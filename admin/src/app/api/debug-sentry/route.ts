import * as Sentry from '@sentry/nextjs';

export async function GET() {
  try {
    throw new Error('Sentry test error');
  } catch (e) {
    Sentry.captureException(e);
  }
  return new Response(JSON.stringify({ ok: true }), { status: 200 });
}




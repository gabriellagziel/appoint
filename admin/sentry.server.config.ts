import * as Sentry from '@sentry/nextjs';

const dsn = process.env.SENTRY_DSN || '';
if (dsn) {
  Sentry.init({
    dsn,
    environment: process.env.SENTRY_ENV || process.env.NODE_ENV,
    tracesSampleRate: Number(process.env.SENTRY_TRACES_SAMPLE_RATE ?? 0.1),
    beforeSend(event) {
      if (event.request) {
        delete (event as any).request?.headers;
        delete (event as any).request?.cookies;
        delete (event as any).request?.data;
      }
      const type = (event as any)?.exception?.values?.[0]?.type || '';
      const frames = (event as any)?.exception?.values?.[0]?.stacktrace?.frames || [];
      const filename = frames.length ? frames[frames.length - 1]?.filename || '' : '';
      if (/ResizeObserver|Non-Error exception/i.test(String(type))) return null;
      if (/chrome-extension:|moz-extension:/i.test(String(filename))) return null;
      return event;
    },
    release: process.env.SENTRY_RELEASE,
  });
}



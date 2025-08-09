import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 20,
  duration: '30s',
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<500'],
  },
};

export default function () {
  const url = `${__ENV.FUNCTIONS_URL || 'http://localhost:5001/demo-app-oint/us-central1'}/createCheckoutSession`;
  const payload = JSON.stringify({ studioId: 'test', priceId: 'price_test' });
  const params = { headers: { 'Content-Type': 'application/json' } };
  const res = http.post(url, payload, params);
  check(res, { 'status is 200/400': (r) => r.status === 200 || r.status === 400 });
  sleep(1);
}




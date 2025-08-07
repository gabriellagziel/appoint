const https = require('https');

const domains = [
  'storage.googleapis.com',
  'pub.dev',
  'firebase-public.firebaseio.com',
  'metadata.google.internal',
  '169.254.169.254',
  'raw.githubusercontent.com'
];

function checkDomain(domain) {
  return new Promise((resolve, reject) => {
    const req = https.request({ method: 'HEAD', host: domain, path: '/' }, res => {
      res.destroy();
      resolve();
    });
    req.on('error', reject);
    req.end();
  });
}

(async () => {
  for (const domain of domains) {
    try {
      await checkDomain(domain);
      console.log(`✓ ${domain} reachable`);
    } catch (err) {
      console.error(`✗ Cannot reach ${domain}`);
      process.exit(1);
    }
  }
})();

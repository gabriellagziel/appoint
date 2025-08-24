## curl -I results (timestamped)

### <https://app-oint.com>

- Result: SSL cert mismatch (no SAN)
- Output: curl: (60) SSL: no alternative certificate subject name matches target host name 'app-oint.com'

### <http://app-oint.com>

HTTP/1.1 301 Moved Permanently
Location: <https://app-oint.com/>
Server: Varnish
X-Cache: HIT
Date: Tue, 19 Aug 2025 11:21:57 GMT

### <https://business.app-oint.com>

HTTP/2 200
server: cloudflare
content-type: text/html; charset=utf-8
x-do-app-origin: REDACTED_TOKEN
cf-cache-status: MISS
date: Tue, 19 Aug 2025 11:22:01 GMT

### <https://enterprise.app-oint.com>

HTTP/2 200
server: cloudflare
x-powered-by: Express
access-control-allow-origin: *
x-do-app-origin: REDACTED_TOKEN
cf-cache-status: MISS
date: Tue, 19 Aug 2025 11:22:10 GMT

### <https://admin.app-oint.com>

- Result: DNS resolution failed
- Output: curl: (6) Could not resolve host: admin.app-oint.com

### <https://personal.app-oint.com>

- Result: DNS resolution failed
- Output: curl: (6) Could not resolve host: personal.app-oint.com


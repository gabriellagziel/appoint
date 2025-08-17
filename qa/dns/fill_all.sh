#!/usr/bin/env bash
set -euo pipefail

# Fills both DO CSV and BIND zone from env vars

THIS_DIR=$(cd "$(dirname "$0")" && pwd)

"$THIS_DIR/fill_do_dns.sh"

"$THIS_DIR/fill_bind_zone.sh"

echo "Done: qa/dns/dns_records_do.csv and qa/dns/app-oint.com.zone.gen"



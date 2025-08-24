#!/usr/bin/env bash
set -euo pipefail

DOMAIN="app-oint.com"
TTL=300
PERSONAL_TARGET="${PERSONAL_TARGET:-ghs.googlehosted.com}"  # set to cname.vercel-dns.com if hosting Personal on Vercel

req(){ command -v "$1" >/dev/null || { echo "Missing $1"; exit 1; }; }
req doctl; req jq

exists(){ doctl compute domain records list "$DOMAIN" --output json; }

# delete all conflicting records for a name that are not of the desired type
del_conflicts(){ local name="$1" type="$2"
  exists | jq -r --arg n "$name" --arg t "$type" '.[] | select(.name==$n and .type!=$t and .type!="SOA") | .id' \
    | xargs -r -n1 doctl compute domain records delete "$DOMAIN" -f
}

# upsert record (type+name -> data)
upsert(){ local type="$1" name="$2" data="$3"
  del_conflicts "$name" "$type"
  local rec; rec=$(exists | jq -r --arg t "$type" --arg n "$name" '.[] | select(.type==$t and .name==$n) | .id + " " + .data' | head -n1 || true)
  if [[ -z "${rec:-}" ]]; then
    doctl compute domain records create "$DOMAIN" --record-type "$type" --record-name "$name" --record-data "$data" --record-ttl "$TTL"
  else
    local id="${rec%% *}" cur="${rec#* }"
    if [[ "$cur" != "$data" ]]; then
      doctl compute domain records update "$DOMAIN" "$id" --record-data "$data" --record-ttl "$TTL"
    else
      echo "OK: $type $name -> $data"
    fi
  fi
}

# Apex: ensure ONLY this A and no AAAA
exists | jq -r '.[] | select((.name=="@" or .name=="") and .type=="AAAA") | .id' | xargs -r -n1 doctl compute domain records delete "$DOMAIN" -f
exists | jq -r --arg ip "76.76.21.21" '.[] | select((.name=="@" or .name=="") and .type=="A" and .data!=$ip) | .id' | xargs -r -n1 doctl compute domain records delete "$DOMAIN" -f
upsert A @ 76.76.21.21

# Subdomains → Vercel
upsert CNAME www cname.vercel-dns.com
upsert CNAME business cname.vercel-dns.com
upsert CNAME enterprise cname.vercel-dns.com
upsert CNAME admin cname.vercel-dns.com

# Personal (default Firebase; set PERSONAL_TARGET=cname.vercel-dns.com to move to Vercel)
upsert CNAME personal "$PERSONAL_TARGET"

echo "Final DNS:"
exists | jq -r '.[] | "\(.type)\t\(.name)\t->\t\(.data)"'

# App-Oint — Day-2 Ops Cheat Sheet

## Domains → Projects (Vercel)

- marketing → app-oint.com, <www.app-oint.com>
- business → business.app-oint.com
- enterprise-app → enterprise.app-oint.com
- admin → admin.app-oint.com
- appoint (do **not** attach personal.app-oint.com; Firebase hosts Personal)

## DNS (DigitalOcean)

- A  @              → 76.76.21.21
- CNAME www         → cname.vercel-dns.com
- CNAME business    → cname.vercel-dns.com
- CNAME enterprise  → cname.vercel-dns.com
- CNAME admin       → cname.vercel-dns.com
- CNAME personal    → ghs.googlehosted.com  (Firebase)

## Fast checks (Terminal)

- Status lines only:
  for u in <https://app-oint.com> <https://www.app-oint.com> <https://business.app-oint.com> <https://enterprise.app-oint.com> <https://admin.app-oint.com> <https://personal.app-oint.com>; do echo "--- $u ---"; curl -sS -I -L --max-time 15 "$u" | head -1; done
- DNS snapshots:
  dig +short app-oint.com A
  dig +short <www.app-oint.com> CNAME
  dig +short business.app-oint.com CNAME
  dig +short enterprise.app-oint.com CNAME
  dig +short admin.app-oint.com CNAME
  dig +short personal.app-oint.com CNAME

## Vercel tips

- If CLI asks "Set up '~/Desktop/ga'? (Y/n)" → **n**
- Domains status: `npx vercel@latest domains inspect <domain> --scope gabriellagziels-projects`
- Redeploy prod (from project folder): `npx vercel@latest deploy --prod --yes --scope gabriellagziels-projects`

## Firebase (Personal)

- Hosting → site **personal-app-oint** → Custom domains → `personal.app-oint.com`
- If stuck: **Remove domain** → **Add custom domain** again → ensure CNAME exists.
- Optional CAA (only if you already use CAA): add `CAA 0 issue "pki.goog"`

## Safe fallbacks

- Marketing fallback: keep `public/splash.html` + `vercel.json` routing until real page is ready.
- Enterprise fallback: keep `public/index.html` (or `app/page.tsx`) and disable middleware while wiring.

## Security hygiene

- Never paste tokens in chat. Rotate tokens quarterly. Revoke old ones immediately if exposed.

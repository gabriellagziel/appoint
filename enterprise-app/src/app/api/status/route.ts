type ServiceStatus = {
  name: string;
  baseUrl: string;
  health?: any;
  version?: any;
  ok: boolean;
  error?: string;
};

export async function GET() {
  const adminUrl = process.env.STATUS_ADMIN_URL || '';
  const businessUrl = process.env.STATUS_BUSINESS_URL || '';
  const enterpriseUrl = process.env.STATUS_ENTERPRISE_URL || '';

  const targets = [
    { name: 'admin', baseUrl: adminUrl },
    { name: 'business', baseUrl: businessUrl },
    { name: 'enterprise-app', baseUrl: enterpriseUrl },
  ].filter(t => !!t.baseUrl);

  const results: ServiceStatus[] = [];

  await Promise.all(
    targets.map(async (t) => {
      const entry: ServiceStatus = { name: t.name, baseUrl: t.baseUrl, ok: false };
      try {
        const h = await fetch(`${t.baseUrl.replace(/\/$/, '')}/api/healthz`, { cache: 'no-store' });
        entry.health = await h.json().catch(() => ({}));
        const v = await fetch(`${t.baseUrl.replace(/\/$/, '')}/api/version`, { cache: 'no-store' });
        entry.version = await v.json().catch(() => ({}));
        entry.ok = h.ok && v.ok;
      } catch (e: any) {
        entry.error = String(e?.message || e);
      }
      results.push(entry);
    })
  );

  // Shape to UI expectations
  const services = results.map(r => ({
    name: r.name,
    healthz: { ok: r.ok, status: r.ok ? 'OK' : (r.error ? 'ERROR' : 'DOWN') },
    version: {
      sha: (r.version && (r.version as any).commit) || null,
      buildTime: (r.version && (r.version as any).buildTime) || null,
    },
  }));
  const body = { ok: services.every(s => s.healthz.ok), services, timestamp: new Date().toISOString() };
  return new Response(JSON.stringify(body), { status: 200, headers: { 'Content-Type': 'application/json' } });
}



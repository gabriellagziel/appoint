export async function GET() {
  const body = {
    ok: true,
    service: 'admin',
    commit: process.env.SENTRY_RELEASE || process.env.VERCEL_GIT_COMMIT_SHA || process.env.GITHUB_SHA || null,
    buildTime: process.env.BUILD_TIME || null,
  };
  return new Response(JSON.stringify(body), { status: 200, headers: { 'Content-Type': 'application/json' } });
}




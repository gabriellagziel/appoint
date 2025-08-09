import { NextRequest } from 'next/server';

export async function GET(req: NextRequest, { params }: { params: { groupId: string } }) {
  const groupId = params.groupId;
  const priceId = req.nextUrl.searchParams.get('priceId');
  const base = process.env.NEXT_PUBLIC_FUNCTIONS_URL || process.env.FUNCTIONS_URL || '';
  const res = await fetch(`${base}/api/groups/${encodeURIComponent(groupId)}/upgrade?priceId=${encodeURIComponent(priceId || '')}`);
  const data = await res.json();
  return new Response(JSON.stringify(data), { status: res.status, headers: { 'Content-Type': 'application/json' } });
}




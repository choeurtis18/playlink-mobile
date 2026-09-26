import { timingSafeEqual } from "node:crypto";
import { NextResponse } from "next/server";
import { MAX_SYNC_DAYS, syncLandingStats } from "@/lib/landing-stats";

// Appelé chaque nuit par le cron Vercel (vercel.json), qui envoie
// « Authorization: Bearer $CRON_SECRET ». `?days=N` (90 au plus) pour un
// rattrapage manuel ; par défaut, les 3 derniers jours.
export const maxDuration = 60;

export async function GET(req: Request) {
  const expected = process.env.CRON_SECRET;
  if (!expected) return NextResponse.json({ error: "CRON_SECRET absent" }, { status: 503 });
  const given = Buffer.from(req.headers.get("authorization")?.replace(/^Bearer /, "") ?? "");
  const secret = Buffer.from(expected);
  if (given.length !== secret.length || !timingSafeEqual(given, secret)) {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  const days = Math.min(MAX_SYNC_DAYS, Math.max(1, Number(new URL(req.url).searchParams.get("days")) || 3));
  try {
    const r = await syncLandingStats(days);
    return NextResponse.json({ ok: true, from: r.days[0], to: r.days.at(-1), rows: r.rows }, { headers: { "Cache-Control": "no-store" } });
  } catch (e) {
    console.error("[cron landing-stats]", e);
    return NextResponse.json({ ok: false, error: e instanceof Error ? e.message : "Échec" }, { status: 500 });
  }
}

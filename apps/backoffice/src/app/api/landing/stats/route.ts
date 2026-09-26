import { auth } from "@clerk/nextjs/server";
import { NextResponse } from "next/server";
import { breakdown } from "@/lib/landing-stats-core";
import { landingRows, lastDays, lastLandingSync } from "@/lib/landing-stats";

/** Agrégats de la landing sur `?days=` (7 à 90, 30 par défaut), pour un
 * éditeur connecté. Même source que l'écran Stats (DailyStat). */
export async function GET(req: Request) {
  const { userId } = await auth();
  if (!userId) return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const days = Math.min(90, Math.max(7, Number(new URL(req.url).searchParams.get("days")) || 30));
  const window = lastDays(days);
  const rows = await landingRows(window[0]);
  const total = (metric: string) => rows.filter((r) => r.metric === `landing.${metric}`).reduce((s, r) => s + r.value, 0);

  return NextResponse.json(
    {
      from: window[0],
      to: window.at(-1),
      syncedAt: (await lastLandingSync())?.toISOString() ?? null,
      totals: { views: total("views"), visitors: total("visitors"), demoStarted: total("demo_started"), demoCompleted: total("demo_completed") },
      games: breakdown(rows, "game_started"),
      sources: breakdown(rows, "source"),
      referrers: breakdown(rows, "referrer"),
      countries: breakdown(rows, "country"),
      locales: breakdown(rows, "locale"),
    },
    { headers: { "Cache-Control": "no-store" } },
  );
}

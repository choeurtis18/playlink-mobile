import { prisma } from "./prisma";
import { hogql } from "./posthog";
import { buildMetrics, METRIC_PREFIX } from "./landing-stats-core";

// Agrégation quotidienne des événements PostHog de la landing dans
// DailyStat. Le tableau de bord et l'écran Stats ne lisent que ces
// agrégats, jamais PostHog à l'affichage (CLAUDE.md : pas de requête
// lourde à l'affichage).

const TZ = "Europe/Paris";
export const MAX_SYNC_DAYS = 90;
const OWN_DOMAIN = new URL(process.env.SITE_URL ?? "https://playlink-game.fr").hostname;

const dayKey = new Intl.DateTimeFormat("fr-CA", { timeZone: TZ, year: "numeric", month: "2-digit", day: "2-digit" });
/** Jour calendaire à Paris (AAAA-MM-JJ). */
export const parisDay = (d: Date) => dayKey.format(d);
/** AAAA-MM-JJ → Date à minuit UTC (colonne @db.Date). */
export const asDbDay = (day: string) => new Date(`${day}T00:00:00Z`);

/** Les `days` derniers jours (Paris), du plus ancien à aujourd'hui. */
export function lastDays(days: number, now = new Date()): string[] {
  const today = parisDay(now);
  const base = asDbDay(today).getTime();
  return Array.from({ length: days }, (_, i) => new Date(base - (days - 1 - i) * 86_400_000).toISOString().slice(0, 10));
}

/** Recalcule les `days` derniers jours et remplace leurs lignes
 * `landing.*` (idempotent : relancer ne double rien). Recalculer les
 * derniers jours rattrape aussi les événements arrivés en retard. */
export async function syncLandingStats(days = 3): Promise<{ days: string[]; rows: number }> {
  const n = Math.min(MAX_SYNC_DAYS, Math.max(1, Math.floor(days)));
  const window = lastDays(n);
  const from = window[0];
  // Filtre grossier sur l'horodatage (index PostHog), puis jour exact à Paris.
  const where = `timestamp > now() - INTERVAL ${n + 2} DAY AND toDate(toTimeZone(timestamp, '${TZ}')) >= toDate('${from}')`;
  const d = `toDate(toTimeZone(timestamp, '${TZ}'))`;

  const [totals, games, categories, pageviews] = await Promise.all([
    hogql(`SELECT ${d} AS stat_day, event, count(), count(DISTINCT distinct_id) FROM events
      WHERE ${where} AND event IN ('$pageview', 'demo_started', 'demo_completed') GROUP BY stat_day, event`),
    hogql(`SELECT ${d} AS stat_day, event, properties.gameSlug AS game, count() FROM events
      WHERE ${where} AND event IN ('demo_started', 'demo_completed') GROUP BY stat_day, event, game`),
    hogql(`SELECT ${d} AS stat_day, properties.gameSlug AS game, properties.category AS category, count() FROM events
      WHERE ${where} AND event = 'demo_started' GROUP BY stat_day, game, category`),
    hogql(`SELECT ${d} AS stat_day, properties.$referring_domain AS ref, properties.$geoip_country_code AS country, properties.locale AS locale, count() FROM events
      WHERE ${where} AND event = '$pageview' GROUP BY stat_day, ref, country, locale`),
  ]);

  const metrics = buildMetrics({ totals, games, categories, pageviews }, OWN_DOMAIN);
  const data = window.flatMap((day) =>
    [...(metrics.get(day) ?? new Map<string, number>())].map(([metric, value]) => ({ day: asDbDay(day), metric, value })),
  );

  await prisma.$transaction([
    prisma.dailyStat.deleteMany({ where: { day: { gte: asDbDay(from) }, metric: { startsWith: METRIC_PREFIX } } }),
    prisma.dailyStat.createMany({ data }),
    // Trace de la synchro (date affichée sur l'écran Stats). Hors du
    // journal d'activité du tableau de bord (entité « stats »).
    prisma.auditLog.create({ data: { action: "synced_landing_stats", entity: "stats", entityId: "landing", meta: { days: n, rows: data.length } } }),
  ]);
  return { days: window, rows: data.length };
}

/** Dernière synchro réussie, ou null. */
export async function lastLandingSync() {
  const log = await prisma.auditLog.findFirst({
    where: { action: "synced_landing_stats" },
    orderBy: { createdAt: "desc" },
    select: { createdAt: true },
  });
  return log?.createdAt ?? null;
}

/** Lignes `landing.*` des jours donnés. */
export function landingRows(fromDay: string) {
  return prisma.dailyStat.findMany({
    where: { day: { gte: asDbDay(fromDay) }, metric: { startsWith: METRIC_PREFIX } },
    select: { day: true, metric: true, value: true },
  });
}

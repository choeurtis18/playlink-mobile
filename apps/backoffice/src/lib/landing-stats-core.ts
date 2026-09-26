// Transformation pure des résultats PostHog en compteurs quotidiens
// (DailyStat). Sans import : testée par `node --test` (landing-stats-core.test.ts).

export const METRIC_PREFIX = "landing.";

export type SourceKind = "organic" | "social" | "email" | "referral" | "direct";

const SEARCH = ["google.", "bing.", "duckduckgo.", "qwant.", "ecosia.", "yahoo.", "search.brave.", "yandex.", "baidu.", "startpage."];
const SOCIAL = [
  "instagram.", "tiktok.", "facebook.", "fb.me", "fb.com", "t.co", "x.com", "twitter.", "reddit.", "linkedin.", "lnkd.in",
  "youtube.", "youtu.be", "snapchat.", "pinterest.", "whatsapp.", "wa.me", "discord.", "telegram.", "t.me", "threads.",
  "bsky.", "mastodon.", "twitch.",
];
const MAIL = ["mail.", "outlook.", "gmail.", "webmail.", "proton.me", "yahoo.mail"];

const matches = (domain: string, list: string[]) =>
  list.some((p) => domain === p.replace(/\.$/, "") || domain.startsWith(p) || domain.includes(`.${p}`) || domain.endsWith(`.${p.replace(/\.$/, "")}`));

/** Domaine d'origine → type de source. `null` = navigation interne au
 * site (passage FR → EN…), à ne pas compter comme une arrivée. */
export function classifySource(referringDomain: string | null | undefined, ownDomain: string): SourceKind | null {
  const d = (referringDomain ?? "").trim().toLowerCase().replace(/^www\./, "");
  if (!d || d === "$direct") return "direct";
  const own = ownDomain.toLowerCase().replace(/^www\./, "");
  if (d === own || d.endsWith(`.${own}`) || d === "localhost") return null;
  if (matches(d, MAIL)) return "email";
  if (matches(d, SEARCH)) return "organic";
  if (matches(d, SOCIAL)) return "social";
  return "referral";
}

/** Morceau de clé de métrique sûr : minuscules, sans caractère exotique,
 * 60 caractères au plus. Vide → null (ligne ignorée). */
export function metricPart(value: unknown): string | null {
  if (typeof value !== "string" && typeof value !== "number") return null;
  const s = String(value).trim().toLowerCase().replace(/[^a-z0-9._-]+/g, "-").replace(/^-+|-+$/g, "").slice(0, 60);
  return s || null;
}

export type Metrics = Map<string, Map<string, number>>; // jour (AAAA-MM-JJ) → métrique → valeur

export function addMetric(m: Metrics, day: string, metric: string, value: number) {
  if (!Number.isFinite(value) || value <= 0) return;
  const d = m.get(day) ?? new Map<string, number>();
  d.set(metric, (d.get(metric) ?? 0) + Math.round(value));
  m.set(day, d);
}

const EVENT_METRIC: Record<string, string> = {
  $pageview: "views",
  demo_started: "demo_started",
  demo_completed: "demo_completed",
};

/** Résultats des quatre requêtes HogQL → compteurs par jour.
 * - totals : [jour, événement, nombre, visiteurs distincts]
 * - games : [jour, événement, gameSlug, nombre]
 * - categories : [jour, gameSlug, categorySlug, nombre]
 * - pageviews : [jour, domaine d'origine, pays, langue, nombre] */
export function buildMetrics(
  rows: {
    totals: unknown[][];
    games: unknown[][];
    categories: unknown[][];
    pageviews: unknown[][];
  },
  ownDomain: string,
): Metrics {
  const m: Metrics = new Map();
  const day = (v: unknown) => String(v).slice(0, 10);
  const n = (v: unknown) => Number(v) || 0;

  for (const [d, event, count, visitors] of rows.totals) {
    const key = EVENT_METRIC[String(event)];
    if (!key) continue;
    addMetric(m, day(d), `${METRIC_PREFIX}${key}`, n(count));
    if (key === "views") addMetric(m, day(d), `${METRIC_PREFIX}visitors`, n(visitors));
  }
  for (const [d, event, slug, count] of rows.games) {
    const game = metricPart(slug);
    const key = event === "demo_started" ? "game_started" : event === "demo_completed" ? "game_completed" : null;
    if (game && key) addMetric(m, day(d), `${METRIC_PREFIX}${key}.${game}`, n(count));
  }
  for (const [d, gameSlug, categorySlug, count] of rows.categories) {
    const game = metricPart(gameSlug), cat = metricPart(categorySlug);
    if (game && cat) addMetric(m, day(d), `${METRIC_PREFIX}category.${game}/${cat}`, n(count));
  }
  for (const [d, domain, country, locale, count] of rows.pageviews) {
    const source = classifySource(domain as string, ownDomain);
    if (source) addMetric(m, day(d), `${METRIC_PREFIX}source.${source}`, n(count));
    const ref = metricPart(String(domain ?? "").replace(/^www\./, ""));
    if (source && source !== "direct" && ref) addMetric(m, day(d), `${METRIC_PREFIX}referrer.${ref}`, n(count));
    const cc = typeof country === "string" && /^[A-Za-z]{2}$/.test(country) ? country.toUpperCase() : null;
    if (cc) addMetric(m, day(d), `${METRIC_PREFIX}country.${cc}`, n(count));
    const lang = locale === "fr" || locale === "en" ? locale : null;
    if (lang) addMetric(m, day(d), `${METRIC_PREFIX}locale.${lang}`, n(count));
  }
  return m;
}

/** Somme des métriques d'une famille (`landing.source.`) sur une liste
 * de lignes, triée par valeur décroissante. */
export function breakdown(rows: { metric: string; value: number }[], family: string) {
  const prefix = `${METRIC_PREFIX}${family}.`;
  const totals = new Map<string, number>();
  for (const r of rows) {
    if (!r.metric.startsWith(prefix)) continue;
    const key = r.metric.slice(prefix.length);
    totals.set(key, (totals.get(key) ?? 0) + r.value);
  }
  return [...totals].map(([key, value]) => ({ key, value })).sort((a, b) => b.value - a.value || a.key.localeCompare(b.key));
}

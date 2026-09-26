import { cookies } from "next/headers";
import { landingEnGaps } from "@playlink/content-schema/landing-keys.ts";
import { prisma } from "./prisma";
import { missingByKind } from "./content-translations";

/** Cookie « pré-inscriptions vues le … » (date ISO), posé à l'ouverture de
 * l'écran Pré-inscriptions. Par navigateur : pas de migration de base pour
 * un simple indicateur de lecture. */
export const SIGNUPS_SEEN_COOKIE = "bo_inscriptions_vues";
const DAY = 24 * 60 * 60 * 1000;

/** Depuis quand une pré-inscription est « nouvelle » : dernière visite de
 * l'écran, sinon les dernières 24 h. */
export async function signupsSeenSince(): Promise<{ since: Date; visited: boolean }> {
  const raw = (await cookies()).get(SIGNUPS_SEEN_COOKIE)?.value;
  const seen = raw ? new Date(raw) : null;
  return seen && Number.isFinite(seen.getTime())
    ? { since: seen, visited: true }
    : { since: new Date(Date.now() - DAY), visited: false };
}

/** Entités du contenu de l'app : ce que l'app voit après une publication. */
export const APP_ENTITIES = ["card", "category", "game", "slide", "badge"];
/** Actions sur ces entités qui ne concernent que la landing. */
const SITE_ONLY_ACTIONS = ["toggled_preview_eligible"];

/** Lignes du journal que l'app ne voit qu'après publication. */
export function pendingWhere(since: Date | null | undefined) {
  return {
    entity: { in: APP_ENTITIES },
    action: { notIn: SITE_ONLY_ACTIONS },
    ...(since ? { createdAt: { gt: since } } : {}),
  };
}

export type ShellCounts = {
  games: number;
  categories: number;
  cards: number;
  slides: number;
  badges: number;
  /** Éléments sans traduction EN (cartes, jeux, catégories, slides, badges). */
  untranslated: number;
  /** Textes de la landing dont l'anglais n'a pas suivi le FR. */
  siteEnGaps: number;
  /** Modifications du contenu de l'app depuis la dernière publication. */
  pending: number;
  /** Version en ligne dans l'app, null avant la première publication. */
  version: number | null;
  /** Pré-inscriptions arrivées depuis la dernière visite de l'écran (ou
   * les dernières 24 h avant la première visite). */
  newSignups: number;
  signupsVisited: boolean;
};

/** Compteurs de la sidebar, calculés à chaque navigation (le layout est
 * dynamique). Requêtes simples et indexées, sur des volumes faibles. */
export async function getShellCounts(): Promise<ShellCounts> {
  const [release, seen] = await Promise.all([
    prisma.contentRelease.findFirst({ orderBy: { version: "desc" }, select: { version: true, publishedAt: true } }),
    signupsSeenSince(),
  ]);
  const [games, categories, cards, slides, badges, untranslatedCards, missing, texts, pending, newSignups] = await Promise.all([
    prisma.game.count(),
    prisma.category.count(),
    prisma.card.count({ where: { active: true } }),
    prisma.gameRuleSlide.count(),
    prisma.badge.count(),
    prisma.card.count({ where: { translations: { none: { locale: "en" } } } }),
    missingByKind(),
    prisma.landingText.findMany({ select: { locale: true, key: true, value: true, updatedAt: true } }),
    prisma.auditLog.count({ where: pendingWhere(release?.publishedAt) }),
    prisma.landingPreRegistration.count({ where: { createdAt: { gt: seen.since } } }),
  ]);
  return {
    games, categories, cards, slides, badges,
    untranslated: untranslatedCards + Object.values(missing).reduce((a, b) => a + b, 0),
    siteEnGaps: landingEnGaps(texts).length,
    pending, version: release?.version ?? null,
    newSignups, signupsVisited: seen.visited,
  };
}

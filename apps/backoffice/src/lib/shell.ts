import { prisma } from "./prisma";

/** Entités du contenu de l'app : ce que l'app voit après une publication. */
const APP_ENTITIES = ["card", "category", "game", "slide", "badge"];
/** Actions sur ces entités qui ne concernent que la landing. */
const SITE_ONLY_ACTIONS = ["toggled_preview_eligible"];

export type ShellCounts = {
  games: number;
  cards: number;
  /** Modifications du contenu de l'app depuis la dernière publication. */
  pending: number;
  /** Version en ligne dans l'app, null avant la première publication. */
  version: number | null;
  /** Pré-inscriptions des dernières 24 h. */
  newSignups: number;
};

/** Compteurs de la sidebar, calculés à chaque navigation (le layout est
 * dynamique). Quatre requêtes simples et indexées. */
export async function getShellCounts(): Promise<ShellCounts> {
  const release = await prisma.contentRelease.findFirst({ orderBy: { version: "desc" }, select: { version: true, publishedAt: true } });
  const since = new Date(Date.now() - 24 * 60 * 60 * 1000);
  const [games, cards, pending, newSignups] = await Promise.all([
    prisma.game.count(),
    prisma.card.count({ where: { active: true } }),
    prisma.auditLog.count({
      where: {
        entity: { in: APP_ENTITIES },
        action: { notIn: SITE_ONLY_ACTIONS },
        ...(release ? { createdAt: { gt: release.publishedAt } } : {}),
      },
    }),
    prisma.landingPreRegistration.count({ where: { createdAt: { gte: since } } }),
  ]);
  return { games, cards, pending, version: release?.version ?? null, newSignups };
}

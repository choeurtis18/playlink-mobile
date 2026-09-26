import { prisma } from "./prisma";
import type { ContentKind } from "./validation";

// Traductions anglaises des contenus autres que les cartes (jeux,
// catégories, slides de règles, badges) : écran Traductions et « À
// traiter » du tableau de bord.

export type TranslatableField = { key: string; label: string; fr: string; en: string; multiline?: boolean; max: number };
export type TranslatableItem = { id: string; title: string; context?: string; icon?: string | null; gameSlug?: string; fields: TranslatableField[] };

/** Tous les éléments d'un type, avec leur traduction anglaise. Un élément
 * est « à traduire » s'il n'a pas de traduction ou qu'un champ requis y
 * est vide (les descriptions facultatives restent facultatives). */
export async function loadContent(kind: ContentKind): Promise<TranslatableItem[]> {
  const en = { where: { locale: "en" } } as const;
  if (kind === "game") {
    const rows = await prisma.game.findMany({ orderBy: { order: "asc" }, include: { translations: en } });
    return rows.map((g) => ({
      id: g.id, title: g.name, icon: g.icon, gameSlug: g.slug,
      fields: [
        { key: "name", label: "Nom", fr: g.name, en: g.translations[0]?.name ?? "", max: 100 },
        { key: "description", label: "Description", fr: g.description ?? "", en: g.translations[0]?.description ?? "", multiline: true, max: 500 },
      ],
    }));
  }
  if (kind === "category") {
    const rows = await prisma.category.findMany({
      orderBy: [{ game: { order: "asc" } }, { order: "asc" }],
      include: { translations: en, game: { select: { name: true, slug: true } } },
    });
    return rows.map((c) => ({
      id: c.id, title: c.name, context: c.game.name, icon: c.icon, gameSlug: c.game.slug,
      fields: [
        { key: "name", label: "Nom", fr: c.name, en: c.translations[0]?.name ?? "", max: 120 },
        { key: "description", label: "Description", fr: c.description ?? "", en: c.translations[0]?.description ?? "", multiline: true, max: 500 },
      ],
    }));
  }
  if (kind === "slide") {
    const rows = await prisma.gameRuleSlide.findMany({
      orderBy: [{ game: { order: "asc" } }, { order: "asc" }],
      include: { translations: en, game: { select: { name: true, slug: true, icon: true } } },
    });
    return rows.map((s) => ({
      id: s.id, title: s.title, context: s.game.name, icon: s.game.icon, gameSlug: s.game.slug,
      fields: [
        { key: "title", label: "Titre", fr: s.title, en: s.translations[0]?.title ?? "", max: 200 },
        { key: "content", label: "Contenu", fr: s.content, en: s.translations[0]?.content ?? "", multiline: true, max: 2000 },
      ],
    }));
  }
  const rows = await prisma.badge.findMany({ orderBy: { order: "asc" }, include: { translations: en } });
  return rows.map((b) => ({
    id: b.id, title: b.name, context: b.key, icon: b.icon,
    fields: [
      { key: "name", label: "Nom", fr: b.name, en: b.translations[0]?.name ?? "", max: 100 },
      { key: "description", label: "Description", fr: b.description, en: b.translations[0]?.description ?? "", multiline: true, max: 300 },
    ],
  }));
}

/** Champs requis sans valeur anglaise : description facultative pour les
 * jeux et catégories, sauf si le français en a une. */
export function isMissing(item: TranslatableItem) {
  return item.fields.some((f) => f.fr.trim() && !f.en.trim());
}


export const CONTENT_KINDS: ContentKind[] = ["game", "category", "slide", "badge"];

/** Nombre d'éléments à traduire, par type. */
export async function missingByKind(): Promise<Record<ContentKind, number>> {
  const counts = await Promise.all(CONTENT_KINDS.map(async (k) => (await loadContent(k)).filter(isMissing).length));
  return Object.fromEntries(CONTENT_KINDS.map((k, i) => [k, counts[i]])) as Record<ContentKind, number>;
}

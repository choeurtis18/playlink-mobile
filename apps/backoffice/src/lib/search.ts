"use server";

import { prisma } from "./prisma";
import { requireEditor } from "./auth";

export type SearchHit = {
  kind: "game" | "category" | "card";
  id: string;
  label: string;
  /** Contexte affiché sous le libellé (jeu, catégorie, intensité). */
  detail: string;
  icon: string | null;
  href: string;
};

const MIN_QUERY = 2;

/** Recherche globale (⌘K) : jeux, catégories et cartes dont le nom ou le
 * texte contient la saisie, sans tenir compte de la casse. 20 résultats
 * au plus ; chacun mène à l'écran déjà filtré. */
export async function searchContent(query: string): Promise<SearchHit[]> {
  await requireEditor();
  const q = query.trim().slice(0, 100);
  if (q.length < MIN_QUERY) return [];
  const contains = { contains: q, mode: "insensitive" as const };

  const [games, categories, cards] = await Promise.all([
    prisma.game.findMany({
      where: { name: contains },
      select: { id: true, name: true, slug: true, icon: true, _count: { select: { categories: true } } },
      orderBy: { order: "asc" },
      take: 4,
    }),
    prisma.category.findMany({
      where: { name: contains },
      select: { id: true, name: true, slug: true, icon: true, game: { select: { name: true, slug: true } } },
      orderBy: [{ game: { order: "asc" } }, { order: "asc" }],
      take: 6,
    }),
    prisma.card.findMany({
      where: { text: contains },
      select: {
        id: true, text: true, intensity: true,
        category: { select: { name: true, slug: true, game: { select: { name: true, slug: true, icon: true } } } },
      },
      take: 10,
    }),
  ]);

  return [
    ...games.map((g) => ({
      kind: "game" as const,
      id: g.id,
      label: g.name,
      detail: `${g._count.categories} catégorie${g._count.categories > 1 ? "s" : ""}`,
      icon: g.icon,
      href: `/categories?jeu=${encodeURIComponent(g.slug)}`,
    })),
    ...categories.map((c) => ({
      kind: "category" as const,
      id: c.id,
      label: c.name,
      detail: c.game.name,
      icon: c.icon,
      href: `/cartes?jeu=${encodeURIComponent(c.game.slug)}&categorie=${encodeURIComponent(c.slug)}`,
    })),
    ...cards.map((c) => ({
      kind: "card" as const,
      id: c.id,
      label: c.text,
      detail: `${c.category.game.name} · ${c.category.name} · intensité ${c.intensity}`,
      icon: c.category.game.icon,
      // Le texte entier (tronqué) cible cette carte-là dans la liste.
      href: `/cartes?q=${encodeURIComponent(c.text.slice(0, 80))}`,
    })),
  ];
}

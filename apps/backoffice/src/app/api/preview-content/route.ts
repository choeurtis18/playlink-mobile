import { NextResponse } from "next/server";
import { unstable_cache as cache } from "next/cache";
import { prisma } from "@/lib/prisma";

// Échantillon public pour la démo jouable de apps/web (plan landing §03).
// Volontairement plafonné : ce n'est pas un deck complet — la vraie logique
// de jeu (tirage, scores, badges) reste dans l'app, jamais sur le web
// (CLAUDE.md, règle offline-first).
const CARDS_PER_CATEGORY = 15;

const getPreviewContent = cache(
  async () => {
    const categories = await prisma.category.findMany({
      where: { previewEligible: true },
      orderBy: { order: "asc" },
      include: {
        game: { select: { slug: true, name: true, colorMain: true, colorSecondary: true, icon: true } },
        translations: true,
        cards: {
          where: { active: true },
          orderBy: { order: "asc" },
          take: CARDS_PER_CATEGORY,
          include: { translations: true },
        },
      },
    });
    return categories;
  },
  ["preview-content"],
  { tags: ["preview-content"], revalidate: 3600 },
);

export async function GET() {
  const categories = await getPreviewContent();

  return NextResponse.json(
    {
      categories: categories.map((cat) => ({
        slug: cat.slug,
        name: cat.name,
        icon: cat.icon,
        game: cat.game,
        translations: Object.fromEntries(cat.translations.map((t) => [t.locale, { name: t.name }])),
        cards: cat.cards.map((card) => ({
          id: card.id,
          text: card.text,
          intensity: card.intensity,
          translations: Object.fromEntries(card.translations.map((t) => [t.locale, { text: t.text }])),
        })),
      })),
    },
    { headers: { "Cache-Control": "public, s-maxage=3600, stale-while-revalidate=86400" } },
  );
}

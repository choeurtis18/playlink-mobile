import { NextResponse } from "next/server";
import { unstable_cache as cache } from "next/cache";
import { prisma } from "@/lib/prisma";
import { DEFAULT_DEMO_SETTINGS } from "@playlink/content-schema/landing-keys.ts";
import { PUBLIC_API_HEADERS } from "@/lib/landing-api";

// Échantillon public pour la démo jouable de apps/web (plan landing §03).
// Volontairement plafonné : ce n'est pas un catalogue complet. Le site tire
// son deck dans cet échantillon avec le même algorithme que l'app, mais
// rien n'est calculé ni enregistré ici (CLAUDE.md, règle offline-first).
const CARDS_PER_CATEGORY = 15;

const getPreviewContent = cache(
  async () => {
    const site = await prisma.siteContent.findUnique({
      where: { id: "default" },
      select: { demoMaxIntensity: true },
    });
    // Deuxième garde-fou après `previewEligible` : une catégorie cochée
    // n'expose que ses cartes jusqu'à l'intensité réglée au back-office.
    const maxIntensity = site?.demoMaxIntensity ?? DEFAULT_DEMO_SETTINGS.maxIntensity;

    return prisma.category.findMany({
      where: { previewEligible: true, game: { active: true } },
      orderBy: [{ game: { order: "asc" } }, { order: "asc" }],
      include: {
        game: { select: { id: true, slug: true, name: true, colorMain: true, colorSecondary: true, icon: true } },
        translations: true,
        cards: {
          where: { active: true, intensity: { lte: maxIntensity } },
          orderBy: { order: "asc" },
          take: CARDS_PER_CATEGORY,
          include: { translations: true },
        },
      },
    });
  },
  ["preview-content"],
  { tags: ["preview-content"], revalidate: 3600 },
);

export async function GET() {
  const categories = await getPreviewContent();

  return NextResponse.json(
    {
      categories: categories
        // Une catégorie sans carte jouable sous le plafond d'intensité
        // afficherait un deck vide : mieux vaut ne pas la proposer.
        .filter((cat) => cat.cards.length > 0)
        .map((cat) => ({
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
    { headers: PUBLIC_API_HEADERS },
  );
}

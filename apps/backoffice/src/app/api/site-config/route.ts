import { NextResponse } from "next/server";
import { unstable_cache as cache } from "next/cache";
import { prisma } from "@/lib/prisma";
import { DEFAULT_DEMO_SETTINGS } from "@playlink/content-schema/landing-keys.ts";

// Consommé par apps/web (jamais Neon en direct depuis le site — voir plan
// landing §01). Contenu marketing, change rarement : cache long, invalidé
// explicitement par les Server Actions via revalidateTag plutôt qu'un TTL
// court qui réveillerait la base à chaque visite.
const getSiteConfig = cache(
  async () => {
    const [site, texts, games, categories, cards] = await Promise.all([
      prisma.siteContent.findUnique({ where: { id: "default" }, include: { translations: true } }),
      prisma.landingText.findMany({ select: { locale: true, key: true, value: true } }),
      prisma.game.findMany({
        where: { active: true },
        orderBy: { order: "asc" },
        select: {
          id: true, slug: true, name: true, description: true, icon: true, colorMain: true, colorSecondary: true,
          translations: { select: { locale: true, name: true, description: true } },
          _count: { select: { categories: true } },
        },
      }),
      prisma.category.count({ where: { game: { active: true } } }),
      prisma.card.count({ where: { active: true, category: { game: { active: true } } } }),
    ]);
    return { site, texts, games, categories, cards };
  },
  ["site-config"],
  { tags: ["site-config"], revalidate: 3600 },
);

export async function GET() {
  const { site, texts, games, categories, cards } = await getSiteConfig();

  // Ordre de la page Jeux (`games` est trié par `order`) : réordonner
  // les jeux au back-office réordonne aussi la landing.
  const featured = new Set(site?.featuredGameIds ?? []);
  const featuredGames = games
    .filter((g) => featured.has(g.id))
    .map(({ translations, _count, ...g }) => ({
      ...g,
      categoryCount: _count.categories,
      translations: Object.fromEntries(
        translations.map((t) => [t.locale, { name: t.name, description: t.description }]),
      ),
    }));

  const textsByLocale: Record<string, Record<string, string>> = {};
  for (const t of texts) (textsByLocale[t.locale] ??= {})[t.key] = t.value;

  return NextResponse.json(
    {
      releaseDate: site?.releaseDate ?? null,
      heroImageUrl: site?.heroImageUrl ?? null,
      heroImageAlt: site?.heroImageAlt ?? null,
      social: {
        instagram: site?.instagramUrl ?? null,
        tiktok: site?.tiktokUrl ?? null,
        reddit: site?.redditUrl ?? null,
      },
      // Textes partiels : le site complète lui-même (langue → FR → défaut),
      // pour que la règle de repli vive à un seul endroit.
      texts: textsByLocale,
      demo: {
        deckSize: site?.demoDeckSize ?? DEFAULT_DEMO_SETTINGS.deckSize,
        maxIntensity: site?.demoMaxIntensity ?? DEFAULT_DEMO_SETTINGS.maxIntensity,
      },
      stats: { games: games.length, categories, cards },
      featuredGames,
      // Ancien format, lu par la landing déjà déployée. À retirer une fois
      // la nouvelle landing en ligne (plan, risques : « changement de format »).
      translations: Object.fromEntries(
        (site?.translations ?? []).map((t) => [
          t.locale,
          { heroTitle: t.heroTitle, heroLede: t.heroLede, ctaLabel: t.ctaLabel },
        ]),
      ),
    },
    { headers: { "Cache-Control": "public, s-maxage=3600, stale-while-revalidate=86400" } },
  );
}

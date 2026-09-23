import { NextResponse } from "next/server";
import { unstable_cache as cache } from "next/cache";
import { prisma } from "@/lib/prisma";

// Consommé par apps/web (jamais Neon en direct depuis le site — voir plan
// landing §01). Contenu marketing, change rarement : cache long, invalidé
// explicitement par saveSiteContent() via revalidateTag plutôt qu'un TTL
// court qui réveillerait la base à chaque visite.
const getSiteConfig = cache(
  async () => {
    const [site, games] = await Promise.all([
      prisma.siteContent.findUnique({ where: { id: "default" }, include: { translations: true } }),
      prisma.game.findMany({
        where: { active: true },
        orderBy: { order: "asc" },
        select: { id: true, slug: true, name: true, description: true, icon: true, colorMain: true, colorSecondary: true },
      }),
    ]);
    return { site, games };
  },
  ["site-config"],
  { tags: ["site-config"], revalidate: 3600 },
);

export async function GET() {
  const { site, games } = await getSiteConfig();

  const featuredGames = (site?.featuredGameIds ?? [])
    .map((id) => games.find((g) => g.id === id))
    .filter((g): g is NonNullable<typeof g> => Boolean(g));

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
      translations: Object.fromEntries(
        (site?.translations ?? []).map((t) => [
          t.locale,
          { heroTitle: t.heroTitle, heroLede: t.heroLede, ctaLabel: t.ctaLabel },
        ]),
      ),
      featuredGames,
    },
    { headers: { "Cache-Control": "public, s-maxage=3600, stale-while-revalidate=86400" } },
  );
}

import type { FeaturedGame, PreviewCategory, PreviewContent } from "./backoffice";
import type { FanCard } from "@/components/hero/HeroFan";
import type { MarqueeItem } from "@/components/hero/Marquee";
import { frenchSpacing } from "./typography";

// Vitrine du héros : uniquement de vraies cartes, tirées de l'échantillon
// public (/api/preview-content), donc déjà filtrées par le back-office
// (catégories « jouables », intensité max). Les plus douces d'abord : ce
// sont les premières que voit un visiteur, avant tout choix d'intensité.
const SOFT_MAX = 2;
const MARQUEE_PER_GAME = 3;

const gradient = (g: { colorMain: string; colorSecondary: string }) =>
  `linear-gradient(135deg, ${g.colorMain}, ${g.colorSecondary})`;

function cardsOf(slug: string, preview: PreviewContent, locale: string) {
  return preview.categories
    .filter((c: PreviewCategory) => c.game.slug === slug)
    .flatMap((c) => c.cards)
    .sort((a, b) => a.intensity - b.intensity)
    .map((c) => ({ text: frenchSpacing(c.translations[locale]?.text ?? c.text), intensity: c.intensity }));
}

export function heroFanCards(games: FeaturedGame[], preview: PreviewContent, locale: string): FanCard[] {
  return games.map((g) => {
    const name = g.translations[locale]?.name ?? g.name;
    const raw = g.translations[locale]?.description ?? g.description;
    const description = raw ? frenchSpacing(raw) : null;
    return {
      slug: g.slug,
      name,
      icon: g.icon,
      colorMain: g.colorMain,
      colorSecondary: g.colorSecondary,
      // Un jeu sans catégorie jouable garde sa carte dans l'éventail, avec
      // sa description : l'éventail présente les jeux, pas seulement la démo.
      sample: cardsOf(g.slug, preview, locale)[0]?.text ?? description ?? name,
      description,
    };
  });
}

/** Cartes douces de chaque jeu, alternées d'un jeu à l'autre pour que deux
 * voisines du bandeau ne viennent pas du même jeu. */
export function marqueeItems(games: FeaturedGame[], preview: PreviewContent, locale: string): MarqueeItem[] {
  const perGame = games.map((g) =>
    cardsOf(g.slug, preview, locale)
      .filter((c) => c.intensity <= SOFT_MAX)
      .slice(0, MARQUEE_PER_GAME)
      .map((c) => ({ text: c.text, gradient: gradient(g) })),
  );
  const out: MarqueeItem[] = [];
  for (let i = 0; i < MARQUEE_PER_GAME; i++) {
    for (const list of perGame) if (list[i]) out.push(list[i]);
  }
  return out;
}

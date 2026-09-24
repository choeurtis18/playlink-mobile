import type { LandingTexts } from "@playlink/content-schema/landing-keys.ts";
import type { FeaturedGame } from "@/lib/backoffice";
import { frenchSpacing } from "@/lib/typography";
import { GamesTrack } from "./GamesTrack";

/** « 01 — Les jeux » : en-tête éditorial (sur-titre, titre, texte) et
 * tuiles des jeux mis en avant, dans l'ordre choisi au back-office. */
export function GamesSection({ texts, games, locale }: { texts: LandingTexts; games: FeaturedGame[]; locale: string }) {
  const tiles = games.map((g) => {
    const description = g.translations[locale]?.description ?? g.description;
    return {
      slug: g.slug,
      name: g.translations[locale]?.name ?? g.name,
      icon: g.icon,
      colorMain: g.colorMain,
      colorSecondary: g.colorSecondary,
      description: description ? frenchSpacing(description) : null,
      categoryCount: g.categoryCount,
    };
  });

  return (
    <section id="jeux" className="px-[clamp(20px,4vw,24px)] py-[clamp(72px,11vw,120px)]">
      <div className="mx-auto flex max-w-[1200px] flex-col gap-14">
        <div className="grid grid-cols-[repeat(auto-fit,minmax(min(100%,420px),1fr))] items-end gap-x-16 gap-y-6">
          <div className="flex flex-col gap-[18px]">
            <p data-reveal className="m-0 font-mono text-xs uppercase tracking-[0.18em] text-accent">
              {texts["games.kicker"]}
            </p>
            <h2
              data-reveal
              data-delay="60"
              className="m-0 text-balance font-display text-[clamp(36px,4.8vw,60px)] font-semibold leading-[1.02] tracking-[-0.03em]"
            >
              {frenchSpacing(texts["games.title"])}
            </h2>
          </div>
          <p data-reveal data-delay="120" className="m-0 max-w-[46ch] text-pretty text-lg leading-[1.55] text-ink-soft">
            {frenchSpacing(texts["games.lede"])}
          </p>
        </div>
        <GamesTrack games={tiles} />
      </div>
    </section>
  );
}

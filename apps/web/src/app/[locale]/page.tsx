import { setRequestLocale, getTranslations } from "next-intl/server";
import { getSiteConfig, getPreviewContent, landingTexts, landingSections } from "@/lib/backoffice";
import { GameTile } from "@/components/GameTile";
import { PreviewDemo } from "@/components/PreviewDemo";
import { Hero } from "@/components/hero/Hero";
import { Marquee } from "@/components/hero/Marquee";
import { heroFanCards, marqueeItems } from "@/lib/hero-content";

export default async function HomePage({
  params,
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  setRequestLocale(locale);

  const [site, preview, tHero, tSocial] = await Promise.all([
    getSiteConfig(),
    getPreviewContent(),
    getTranslations("hero"),
    getTranslations("social"),
  ]);

  // Repli langue → FR (langue d'origine, CLAUDE.md) → texte par défaut :
  // un héros sans titre ne doit jamais s'afficher.
  const t = landingTexts(site, locale);
  const isReleased = site.releaseDate ? new Date(site.releaseDate) <= new Date() : false;
  const sections = landingSections(site);

  return (
    <div className="flex flex-col">
      <Hero
        texts={t}
        locale={locale}
        released={isReleased}
        stats={site.stats}
        cards={heroFanCards(site.featuredGames, preview, locale)}
        primaryHref={`#${sections.includes("jeux") ? "jeux" : "demo"}`}
        secondaryHref={sections.includes("notif") ? "#notif" : null}
      />
      <Marquee items={marqueeItems(site.featuredGames, preview, locale)} label={tHero("marqueeLabel")} />

      {/* ── Jeux ──────────────────────────────────────────────────── */}
      {sections.includes("jeux") && (
        <section id="jeux" className="border-t border-hairline px-6 py-20">
          <div className="mx-auto max-w-5xl">
            <div data-reveal className="mb-10 text-center">
              <h2 className="font-[family-name:var(--font-display)] text-3xl font-semibold">{t["games.title"]}</h2>
              <p className="mx-auto mt-2 max-w-[50ch] text-ink-soft">{t["games.lede"]}</p>
            </div>
            <ul className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
              {site.featuredGames.map((game, i) => (
                <GameTile key={game.id} game={game} index={i} locale={locale} />
              ))}
            </ul>
          </div>
        </section>
      )}

      {/* ── Démo jouable ──────────────────────────────────────────── */}
      <section id="demo" className="border-t border-hairline px-6 py-20">
        <div className="mx-auto max-w-3xl">
          <div data-reveal className="mb-10 text-center">
            <h2 className="font-[family-name:var(--font-display)] text-3xl font-semibold">{t["demo.title"]}</h2>
            <p className="mx-auto mt-2 max-w-[50ch] text-ink-soft">{t["demo.lede"]}</p>
          </div>
          <PreviewDemo categories={preview.categories} locale={locale} />
        </div>
      </section>

      {/* ── Réseaux sociaux ───────────────────────────────────────── */}
      {sections.includes("reseaux") && (
        <section id="reseaux" className="border-t border-hairline px-6 py-16 text-center">
          <h2 className="mb-5 font-[family-name:var(--font-display)] text-xl font-semibold">{t["social.title"]}</h2>
          <div className="flex justify-center gap-4 font-mono text-sm">
            {site.social.instagram && (
              <a href={site.social.instagram} target="_blank" rel="noreferrer" className="text-ink-soft hover:text-accent">
                {tSocial("instagram")}
              </a>
            )}
            {site.social.tiktok && (
              <a href={site.social.tiktok} target="_blank" rel="noreferrer" className="text-ink-soft hover:text-accent">
                {tSocial("tiktok")}
              </a>
            )}
            {site.social.reddit && (
              <a href={site.social.reddit} target="_blank" rel="noreferrer" className="text-ink-soft hover:text-accent">
                {tSocial("reddit")}
              </a>
            )}
          </div>
        </section>
      )}

    </div>
  );
}

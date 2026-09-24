import { setRequestLocale, getTranslations } from "next-intl/server";
import { getSiteConfig, getPreviewContent, landingTexts, landingSections } from "@/lib/backoffice";
import { DemoSection } from "@/components/demo/DemoSection";
import { Hero } from "@/components/hero/Hero";
import { GamesSection } from "@/components/games/GamesSection";
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

      {sections.includes("jeux") && <GamesSection texts={t} games={site.featuredGames} locale={locale} />}

      <DemoSection texts={t} categories={preview.categories} locale={locale} settings={site.demo} />

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

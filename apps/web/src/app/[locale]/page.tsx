import { setRequestLocale, getTranslations } from "next-intl/server";
import { getSiteConfig, getPreviewContent, landingTexts, landingSections } from "@/lib/backoffice";
import { DemoSection } from "@/components/demo/DemoSection";
import { HowItWorks } from "@/components/sections/HowItWorks";
import { NotifSection } from "@/components/sections/NotifSection";
import { SocialSection } from "@/components/sections/SocialSection";
import { Hero } from "@/components/hero/Hero";
import { StructuredData } from "@/components/StructuredData";
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

  const [site, preview, tHero] = await Promise.all([
    getSiteConfig(),
    getPreviewContent(),
    getTranslations("hero"),
  ]);

  // Repli langue → FR (langue d'origine, CLAUDE.md) → texte par défaut :
  // un héros sans titre ne doit jamais s'afficher.
  const t = landingTexts(site, locale);
  const isReleased = site.releaseDate ? new Date(site.releaseDate) <= new Date() : false;
  const sections = landingSections(site);

  return (
    <div className="flex flex-col">
      <StructuredData locale={locale} description={t["meta.description"]} />
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

      <HowItWorks texts={t} stats={site.stats} locale={locale} />
      <NotifSection texts={t} locale={locale} />
      {sections.includes("reseaux") && <SocialSection texts={t} social={site.social} />}
    </div>
  );
}

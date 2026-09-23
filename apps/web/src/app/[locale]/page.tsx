import { setRequestLocale, getTranslations } from "next-intl/server";
import { getSiteConfig, getPreviewContent, FALLBACK_HERO } from "@/lib/backoffice";
import { GameTile } from "@/components/GameTile";
import { PreviewDemo } from "@/components/PreviewDemo";

export default async function HomePage({
  params,
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  setRequestLocale(locale);

  const [site, preview, tHero, tGames, tDemo, tSocial, tFooter] = await Promise.all([
    getSiteConfig(),
    getPreviewContent(),
    getTranslations("hero"),
    getTranslations("games"),
    getTranslations("demo"),
    getTranslations("social"),
    getTranslations("footer"),
  ]);

  // FR est la langue d'origine du contenu (CLAUDE.md), d'où ce fallback.
  // Le dernier niveau couvre le cas d'un SiteContent existant mais encore
  // vide de traductions : un héros sans titre ne doit jamais s'afficher.
  const t =
    site.translations[locale] ?? site.translations.fr ?? FALLBACK_HERO[locale] ?? FALLBACK_HERO.fr;
  const isReleased = site.releaseDate ? new Date(site.releaseDate) <= new Date() : false;
  const hasSocial = site.social.instagram || site.social.tiktok || site.social.reddit;

  return (
    <main className="flex flex-col">
      {/* ── Héros ─────────────────────────────────────────────────── */}
      <section className="relative overflow-hidden px-6 py-24 sm:py-32">
        <div
          aria-hidden
          className="pointer-events-none absolute -top-24 left-1/2 h-[420px] w-[640px] -translate-x-1/2 opacity-70 blur-3xl"
          style={{ background: "radial-gradient(circle, var(--color-accent-wash) 0%, transparent 70%)" }}
        />
        <div className="relative mx-auto flex max-w-2xl flex-col gap-6 text-center">
          <p className="motion-safe:animate-[fade-up_0.6s_ease-out_backwards] font-mono text-xs uppercase tracking-[0.18em] text-accent">
            {isReleased ? tHero("eyebrowReleased") : tHero("eyebrow")}
          </p>
          <h1 className="text-balance font-[family-name:var(--font-display)] text-4xl font-semibold leading-tight tracking-tight motion-safe:animate-[fade-up_0.6s_ease-out_0.08s_backwards] sm:text-5xl">
            {t.heroTitle}
          </h1>
          <p className="mx-auto max-w-[60ch] text-lg text-ink-soft motion-safe:animate-[fade-up_0.6s_ease-out_0.16s_backwards]">
            {t.heroLede}
          </p>
          <p className="mx-auto inline-flex w-fit items-center gap-2 rounded-full border border-hairline-firm px-4 py-2 font-mono text-xs text-neutral-faint motion-safe:animate-[fade-up_0.6s_ease-out_0.24s_backwards]">
            {t.ctaLabel} — {isReleased ? tHero("eyebrowReleased") : tHero("eyebrow")}
          </p>
        </div>
      </section>

      {/* ── Jeux ──────────────────────────────────────────────────── */}
      {site.featuredGames.length > 0 && (
        <section className="border-t border-hairline px-6 py-20">
          <div className="mx-auto max-w-5xl">
            <div className="mb-10 text-center">
              <h2 className="font-[family-name:var(--font-display)] text-3xl font-semibold">{tGames("title")}</h2>
              <p className="mx-auto mt-2 max-w-[50ch] text-ink-soft">{tGames("lede")}</p>
            </div>
            <ul className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
              {site.featuredGames.map((game, i) => (
                <GameTile key={game.id} game={game} index={i} />
              ))}
            </ul>
          </div>
        </section>
      )}

      {/* ── Démo jouable ──────────────────────────────────────────── */}
      <section className="border-t border-hairline px-6 py-20">
        <div className="mx-auto max-w-3xl">
          <div className="mb-10 text-center">
            <h2 className="font-[family-name:var(--font-display)] text-3xl font-semibold">{tDemo("title")}</h2>
            <p className="mx-auto mt-2 max-w-[50ch] text-ink-soft">{tDemo("lede")}</p>
          </div>
          <PreviewDemo categories={preview.categories} locale={locale} />
        </div>
      </section>

      {/* ── Réseaux sociaux ───────────────────────────────────────── */}
      {hasSocial && (
        <section className="border-t border-hairline px-6 py-16 text-center">
          <h2 className="mb-5 font-[family-name:var(--font-display)] text-xl font-semibold">{tSocial("title")}</h2>
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

      {/* ── Footer ────────────────────────────────────────────────── */}
      <footer className="mx-auto flex w-full max-w-5xl flex-wrap gap-6 border-t border-hairline px-6 py-8 font-mono text-xs text-neutral-faint">
        <a href={`/${locale}/mentions-legales`} className="hover:text-ink">{tFooter("legal")}</a>
        <a href={`/${locale}/confidentialite`} className="hover:text-ink">{tFooter("privacy")}</a>
        <a href={`/${locale}/cgu`} className="hover:text-ink">{tFooter("terms")}</a>
        <a href={`/${locale}/cookies`} className="hover:text-ink">{tFooter("cookies")}</a>
      </footer>
    </main>
  );
}

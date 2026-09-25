import { getTranslations } from "next-intl/server";
import type { LandingTexts } from "@playlink/content-schema/landing-keys.ts";
import type { SiteStats } from "@/lib/backoffice";
import { HeroFan, type FanCard } from "./HeroFan";
import { HeroGlow } from "./HeroGlow";
import { frenchSpacing } from "@/lib/typography";
import { Emphasis } from "../Emphasis";

/** Entrée du héros en CSS (et non via RevealRoot) : il est visible dès le
 * chargement, une animation déclenchée après hydratation le ferait
 * clignoter. `backwards` garde l'état de départ pendant le délai. */
const ENTER = "motion-safe:animate-[pl-reveal_0.8s_cubic-bezier(.2,.8,.2,1)_backwards]";
/** Titre et accroche : glissement sans fondu. Chrome ne compte un texte
 * comme affiché qu'une fois visible ; un fondu retardait l'affichage
 * principal mesuré (LCP) de près de 3 s sur mobile. */
const RISE = "motion-safe:animate-[pl-rise_0.8s_cubic-bezier(.2,.8,.2,1)_backwards]";
const delay = (ms: number) => ({ animationDelay: `${ms}ms` });

export async function Hero({
  texts,
  locale,
  released,
  stats,
  cards,
  primaryHref,
  secondaryHref,
}: {
  texts: LandingTexts;
  locale: string;
  released: boolean;
  stats: SiteStats | null;
  cards: FanCard[];
  /** Cible du bouton principal (section jeux, ou démo à défaut). */
  primaryHref: string;
  /** Cible du bouton « me prévenir » ; absent tant que la section n'existe pas. */
  secondaryHref: string | null;
}) {
  const t = await getTranslations("hero");
  const nf = new Intl.NumberFormat(locale === "en" ? "en-US" : "fr-FR");
  // « 1 500+ » plutôt que « 1 521 » : un chiffre rond reste juste plus
  // longtemps, le catalogue change à chaque publication.
  const cardsRounded = stats && stats.cards >= 100 ? Math.floor(stats.cards / 100) * 100 : stats?.cards;

  return (
    <section className="relative overflow-clip px-[clamp(20px,4vw,24px)] pb-[clamp(64px,10vw,104px)] pt-[clamp(48px,9vw,88px)]">
      <HeroGlow />
      <div
        aria-hidden
        className="pointer-events-none absolute inset-0 opacity-90"
        style={{ background: "radial-gradient(ellipse 60% 50% at 80% 30%, #2b121c 0%, transparent 70%)" }}
      />
      <div
        aria-hidden
        className="pointer-events-none absolute inset-0 opacity-55"
        style={{
          backgroundImage: "radial-gradient(#2a2733 1px, transparent 1px)",
          backgroundSize: "28px 28px",
          maskImage: "radial-gradient(ellipse 70% 60% at 50% 40%, #000 0%, transparent 75%)",
          WebkitMaskImage: "radial-gradient(ellipse 70% 60% at 50% 40%, #000 0%, transparent 75%)",
        }}
      />

      <div className="relative mx-auto grid max-w-[1200px] grid-cols-[repeat(auto-fit,minmax(min(100%,460px),1fr))] items-center gap-[clamp(40px,6vw,56px)]">
        <div className="flex flex-col items-start gap-7">
          <p
            style={delay(0)}
            className={`${ENTER} m-0 flex items-center gap-2.5 rounded-full border border-hairline-firm bg-surface/60 py-[7px] pl-2.5 pr-3.5 font-mono text-xs uppercase tracking-[0.16em] text-ink-soft`}
          >
            <span className="h-2 w-2 rounded-full bg-accent motion-safe:animate-[pl-pulse_2.2s_infinite]" />
            {released ? t("eyebrowReleased") : texts["hero.eyebrow"]}
          </p>
          <h1
            style={delay(80)}
            className={`${RISE} m-0 text-balance font-display text-[clamp(44px,6.6vw,88px)] font-semibold leading-[0.98] tracking-[-0.035em]`}
          >
            <Emphasis text={frenchSpacing(texts["hero.title"])} variant="shine" />
          </h1>
          <p
            style={delay(160)}
            className={`${RISE} m-0 max-w-[52ch] text-pretty text-[clamp(17px,1.6vw,20px)] leading-[1.55] text-ink-soft`}
          >
            {frenchSpacing(texts["hero.lede"])}
          </p>
          <div style={delay(240)} className={`${ENTER} flex flex-wrap gap-3`}>
            <a
              href={primaryHref}
              data-analytics="cta_clicked"
              data-analytics-cta="hero_primary"
              className="flex items-center gap-2.5 rounded-full px-6 py-4 text-base font-bold text-ground-deep shadow-[0_10px_30px_-10px_rgb(242_58_107/0.7)] transition-[transform,box-shadow] duration-200 hover:-translate-y-0.5 hover:text-ground-deep hover:shadow-[0_16px_40px_-12px_rgb(242_58_107/0.9)] active:translate-y-0"
              style={{ background: "var(--gradient-accent)" }}
            >
              {texts["hero.ctaPrimary"]}
              <span aria-hidden>↓</span>
            </a>
            {secondaryHref && (
              <a
                href={secondaryHref}
                data-analytics="cta_clicked"
                data-analytics-cta="hero_notify"
                className="rounded-full border border-hairline-firm bg-surface/50 px-6 py-4 text-base font-semibold text-ink transition-colors hover:border-neutral hover:bg-surface hover:text-ink"
              >
                {texts["hero.ctaSecondary"]}
              </a>
            )}
          </div>
          {stats && (
            <p
              style={delay(320)}
              className={`${ENTER} m-0 flex flex-wrap gap-[22px] font-mono text-xs uppercase tracking-[0.12em] text-neutral-faint`}
            >
              <span>{t("statGames", { n: stats.games })}</span>
              <span aria-hidden className="text-hairline-firm">/</span>
              <span>{t("statCards", { n: nf.format(cardsRounded ?? 0), plus: stats.cards >= 100 ? "+" : "" })}</span>
              <span aria-hidden className="text-hairline-firm">/</span>
              <span>{t("statOffline")}</span>
            </p>
          )}
        </div>

        {cards.length > 0 && (
          <div style={delay(200)} className={ENTER}>
            <HeroFan cards={cards} />
          </div>
        )}
      </div>
    </section>
  );
}

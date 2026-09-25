import { getTranslations } from "next-intl/server";
import type { LandingTexts } from "@playlink/content-schema/landing-keys.ts";
import type { SiteStats } from "@/lib/backoffice";
import { frenchSpacing } from "@/lib/typography";
import { Emphasis } from "../Emphasis";

const KICKER = "font-mono text-xs uppercase tracking-[0.18em] text-accent";

/** « 03 — Comment ça marche » : trois étapes, puis les chiffres du
 * catalogue, qui comptent depuis zéro à leur apparition (RevealRoot). */
export async function HowItWorks({ texts, stats, locale }: { texts: LandingTexts; stats: SiteStats | null; locale: string }) {
  const t = await getTranslations("about");
  const nf = new Intl.NumberFormat(locale === "en" ? "en-US" : "fr-FR");
  const steps = ([1, 2, 3] as const).map((n) => ({
    n: `0${n}`,
    title: texts[`about.step${n}`],
    body: texts[`about.step${n}Body`],
  }));
  // Cartes arrondies à la centaine inférieure, comme dans le héros.
  const cards = stats && stats.cards >= 100 ? Math.floor(stats.cards / 100) * 100 : stats?.cards ?? 0;
  const figures = stats
    ? [
        { value: stats.games, suffix: "", label: t("games", { n: stats.games }) },
        { value: stats.categories, suffix: "", label: t("categories", { n: stats.categories }) },
        { value: cards, suffix: stats.cards >= 100 ? "+" : "", label: t("cards", { n: cards }) },
      ]
    : [];

  return (
    <section id="apropos" className="px-[clamp(20px,4vw,24px)] py-[clamp(72px,11vw,120px)]">
      <div className="mx-auto flex max-w-[1200px] flex-col gap-16">
        <div className="flex max-w-[760px] flex-col gap-[18px]">
          <p data-reveal className={`m-0 ${KICKER}`}>{t("kicker")}</p>
          <h2 data-reveal data-delay="60" className="m-0 text-balance font-display text-[clamp(36px,4.8vw,60px)] font-semibold leading-[1.02] tracking-[-0.03em]">
            <Emphasis text={frenchSpacing(texts["about.title"])} variant="soft" />
          </h2>
        </div>

        <ol className="m-0 grid list-none grid-cols-[repeat(auto-fit,minmax(min(100%,240px),1fr))] gap-x-10 p-0">
          {steps.map((s, i) => (
            <li key={s.n} data-reveal data-delay={String(i * 100)} className="flex flex-col gap-3.5 border-t border-hairline py-8">
              <span aria-hidden className="font-display text-[56px] font-medium leading-none text-hairline-firm">{s.n}</span>
              <h3 className="m-0 text-xl font-semibold">{frenchSpacing(s.title)}</h3>
              <p className="m-0 text-base leading-[1.55] text-ink-soft">{frenchSpacing(s.body)}</p>
            </li>
          ))}
        </ol>

        <div className="grid grid-cols-[repeat(auto-fit,minmax(min(100%,220px),1fr))] gap-4">
          {figures.map((f, i) => (
            <Figure key={i} delay={i * 80} label={f.label}>
              <span data-count={f.value} data-suffix={f.suffix}>
                {nf.format(f.value)}
                {f.suffix}
              </span>
            </Figure>
          ))}
          {/* « 100 % » : une promesse du produit, pas une donnée du catalogue. */}
          <div data-reveal data-delay={String(figures.length * 80)} className="flex flex-col gap-1.5 rounded-[22px] border border-accent bg-accent-wash p-7">
            <span className="font-display text-[64px] font-semibold leading-none tracking-[-0.03em] text-accent-deep">
              <span data-count="100" data-suffix={t("percentSuffix")}>100{t("percentSuffix")}</span>
            </span>
            <span className="text-[15px] text-ink">{t("offline")}</span>
          </div>
        </div>
      </div>
    </section>
  );
}

function Figure({ delay, label, children }: { delay: number; label: string; children: React.ReactNode }) {
  return (
    <div data-reveal data-delay={String(delay)} className="flex flex-col gap-1.5 rounded-[22px] border border-hairline bg-surface p-7">
      <span className="font-display text-[64px] font-semibold leading-none tracking-[-0.03em]">{children}</span>
      <span className="text-[15px] text-ink-soft">{label}</span>
    </div>
  );
}

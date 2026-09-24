import { getTranslations } from "next-intl/server";
import type { DemoSettings, LandingTexts } from "@playlink/content-schema/landing-keys.ts";
import type { PreviewCategory } from "@/lib/backoffice";
import { frenchSpacing } from "@/lib/typography";
import { Demo } from "./Demo";

/** « 02 — Démo jouable » : en-tête éditorial + démo (îlot client). */
export async function DemoSection({ texts, categories, locale, settings }: {
  texts: LandingTexts;
  categories: PreviewCategory[];
  locale: string;
  settings: DemoSettings;
}) {
  const t = await getTranslations("demo");
  return (
    <section
      id="demo"
      className="relative overflow-hidden border-y border-hairline bg-ground-deep px-[clamp(20px,4vw,24px)] py-[clamp(72px,11vw,120px)]"
    >
      <div className="mx-auto flex max-w-[1200px] flex-col gap-12">
        <div className="relative flex max-w-[720px] flex-col gap-[18px]">
          <p data-reveal className="m-0 font-mono text-xs uppercase tracking-[0.18em] text-accent">{t("kicker")}</p>
          <h2 data-reveal data-delay="60" className="m-0 text-balance font-display text-[clamp(36px,4.8vw,60px)] font-semibold leading-[1.02] tracking-[-0.03em]">
            {frenchSpacing(texts["demo.title"])}
          </h2>
          <p data-reveal data-delay="120" className="m-0 max-w-[52ch] text-lg leading-[1.55] text-ink-soft">
            {frenchSpacing(texts["demo.lede"])}
          </p>
        </div>
        <Demo categories={categories} locale={locale} settings={settings} />
      </div>
    </section>
  );
}

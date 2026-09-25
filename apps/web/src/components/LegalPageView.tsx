import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import type { LegalKey } from "@/content/legal";
import { getLegalPage } from "@/lib/legal";
import { Markdown } from "./Markdown";

export const LEGAL_PATHS: Record<LegalKey, string> = {
  legal: "mentions-legales",
  privacy: "confidentialite",
  terms: "cgu",
  cookies: "cookies",
};

export async function legalMetadata(key: LegalKey, params: Promise<{ locale: string }>): Promise<Metadata> {
  const { locale } = await params;
  const page = await getLegalPage(key, locale);
  const path = LEGAL_PATHS[key];
  return {
    title: `${page.title} — Playlink`,
    alternates: { canonical: `/${locale}/${path}`, languages: { fr: `/fr/${path}`, en: `/en/${path}` } },
  };
}

/** Gabarit commun des quatre pages légales. */
export async function LegalPageView({ legalKey, params }: { legalKey: LegalKey; params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  setRequestLocale(locale);
  const [page, t] = await Promise.all([getLegalPage(legalKey, locale), getTranslations("legal")]);
  return (
    <section className="px-[clamp(20px,4vw,24px)] py-[clamp(56px,9vw,104px)]">
      <article className="mx-auto flex max-w-[760px] flex-col gap-6">
        <p className="m-0 font-mono text-xs uppercase tracking-[0.18em] text-accent">{t("kicker")}</p>
        <h1 className="m-0 text-balance font-display text-[clamp(34px,4.6vw,56px)] font-semibold leading-[1.04] tracking-[-0.03em]">{page.title}</h1>
        <div className="flex flex-col gap-4 text-[17px] leading-[1.65] text-ink-soft [&_p]:m-0">
          <Markdown source={page.content} />
        </div>
        <a href={`/${locale}`} className="mt-6 w-fit font-mono text-xs uppercase tracking-[0.14em] text-neutral-faint hover:text-ink">
          ← {t("back")}
        </a>
      </article>
    </section>
  );
}

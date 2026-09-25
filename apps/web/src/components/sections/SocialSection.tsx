import { getTranslations } from "next-intl/server";
import type { LandingTexts } from "@playlink/content-schema/landing-keys.ts";
import type { SiteConfig } from "@/lib/backoffice";
import { frenchSpacing } from "@/lib/typography";

const HASHTAGS = ["#Playlink", "#PartieEntreAmis"];

/** « 05 — En attendant » : un réseau sans lien au back-office n'apparaît
 * pas (et la section entière disparaît s'il n'y en a aucun, voir
 * landingSections). */
export async function SocialSection({ texts, social }: { texts: LandingTexts; social: SiteConfig["social"] }) {
  const t = await getTranslations("social");
  const links = (["instagram", "tiktok", "reddit"] as const)
    .filter((k) => social[k])
    .map((k) => ({ key: k, href: social[k]!, name: t(k), note: t(`notes.${k}`) }));

  return (
    <section id="reseaux" className="px-[clamp(20px,4vw,24px)] pb-[clamp(72px,11vw,120px)]">
      <div className="mx-auto grid max-w-[1200px] grid-cols-[repeat(auto-fit,minmax(min(100%,420px),1fr))] items-start gap-10">
        <div className="flex flex-col gap-[18px]">
          <p data-reveal className="m-0 font-mono text-xs uppercase tracking-[0.18em] text-accent">{t("kicker")}</p>
          <h2 data-reveal data-delay="60" className="m-0 text-balance font-display text-[clamp(34px,4.2vw,54px)] font-semibold leading-[1.02] tracking-[-0.03em]">
            {frenchSpacing(texts["social.title"])}
          </h2>
          <div data-reveal data-delay="120" className="flex flex-wrap gap-2">
            {HASHTAGS.map((h) => (
              <span key={h} className="rounded-full border border-hairline-firm px-3 py-[7px] font-mono text-[13px] text-accent-deep">{h}</span>
            ))}
          </div>
        </div>
        <ul className="m-0 flex list-none flex-col border-t border-hairline p-0">
          {links.map((l, i) => (
            <li key={l.key} data-reveal data-delay={String(i * 80)}>
              <a
                href={l.href}
                target="_blank"
                rel="noreferrer"
                data-analytics="social_link_clicked"
                data-analytics-platform={l.key}
                className="flex items-center justify-between gap-4 border-b border-hairline px-1 py-[26px] text-ink transition-[padding,color] duration-300 ease-[cubic-bezier(.2,.8,.2,1)] hover:pl-4 hover:text-accent-deep"
              >
                <span className="font-display text-[clamp(28px,3vw,40px)] font-medium tracking-[-0.02em]">{l.name}</span>
                <span className="flex items-center gap-3.5 font-mono text-[13px] text-neutral-faint">
                  {l.note}
                  <span aria-hidden className="text-xl text-ink">↗</span>
                  <span className="sr-only">{t("newTab")}</span>
                </span>
              </a>
            </li>
          ))}
        </ul>
      </div>
    </section>
  );
}

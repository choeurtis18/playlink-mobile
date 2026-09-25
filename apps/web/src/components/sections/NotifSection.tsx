import { getTranslations } from "next-intl/server";
import type { LandingTexts } from "@playlink/content-schema/landing-keys.ts";
import { frenchSpacing } from "@/lib/typography";
import { PreRegisterForm } from "./PreRegisterForm";

/** « 04 — Pré-inscription » : bloc encadré d'un dégradé qui ondule. */
export async function NotifSection({ texts, locale }: { texts: LandingTexts; locale: string }) {
  const t = await getTranslations("notif");
  return (
    <section id="notif" className="px-[clamp(20px,4vw,24px)] pb-[clamp(72px,11vw,120px)]">
      <div
        data-reveal
        className="relative mx-auto max-w-[1200px] rounded-[32px] bg-[length:200%_200%] p-0.5 motion-safe:animate-[pl-shine_10s_linear_infinite]"
        style={{ backgroundImage: "linear-gradient(135deg, #7C3AED, #f23a6b 45%, #ff6b93 70%, #0EA5E9)" }}
      >
        <div className="relative grid grid-cols-[repeat(auto-fit,minmax(min(100%,380px),1fr))] items-center gap-10 overflow-clip rounded-[30px] bg-sunk p-[clamp(28px,5vw,64px)]">
          <div aria-hidden className="pointer-events-none absolute -right-[120px] -top-[120px] h-[420px] w-[420px] rounded-full bg-[radial-gradient(circle,#2b121c,transparent_70%)]" />
          <div className="relative flex flex-col gap-4">
            <p className="m-0 font-mono text-xs uppercase tracking-[0.18em] text-accent">{t("kicker")}</p>
            <h2 className="m-0 text-balance font-display text-[clamp(34px,4.2vw,54px)] font-semibold leading-[1.02] tracking-[-0.03em]">
              {frenchSpacing(texts["notif.title"])}
            </h2>
            <p className="m-0 max-w-[44ch] text-[17px] leading-[1.55] text-ink-soft">{frenchSpacing(texts["notif.lede"])}</p>
          </div>
          <PreRegisterForm
            locale={locale}
            privacyHref={`/${locale}/confidentialite`}
            texts={{
              button: texts["notif.button"],
              consent: frenchSpacing(texts["notif.consent"]),
              success: frenchSpacing(texts["notif.success"]),
            }}
          />
        </div>
      </div>
    </section>
  );
}

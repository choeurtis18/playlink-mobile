"use client";

import { useState } from "react";
import { CheckCircleIcon, DesktopIcon, DeviceMobileIcon, WarningIcon } from "@phosphor-icons/react/dist/ssr";
import { LANDING_SECTIONS, resolveLandingTexts, type LandingKey, type LandingTexts } from "@playlink/content-schema/landing-keys.ts";
import { Segmented } from "@/components/ui";
import type { SectionId } from "./draft";
import type { EditorGame, SiteDraft } from "./types";

type Lang = "fr" | "en";

// Libellés fixes de la landing (apps/web/src/messages) : ils changent avec
// le code, pas au back-office. Repris ici pour que l'aperçu ressemble à la
// page.
const FIXED: Record<Lang, Record<string, string>> = {
  fr: {
    demoKicker: "02 — Démo jouable", aboutKicker: "03 — Comment ça marche", notifKicker: "04 — Pré-inscription",
    socialKicker: "05 — En attendant", email: "toi@exemple.fr", released: "Disponible sur iOS & Android",
    instagram: "Défis de la semaine", tiktok: "Parties filmées", reddit: "Proposer des cartes", hidden: "masqué — pas de lien",
  },
  en: {
    demoKicker: "02 — Playable demo", aboutKicker: "03 — How it works", notifKicker: "04 — Early sign-up",
    socialKicker: "05 — Meanwhile", email: "you@example.com", released: "Available on iOS & Android",
    instagram: "Weekly challenges", tiktok: "Games on camera", reddit: "Suggest cards", hidden: "hidden — no link",
  },
};

const DOMAIN = "playlink-game.fr";
const KICKER = "font-mono text-[9.5px] uppercase tracking-[0.16em] text-accent";
const TITLE = "m-0 font-display text-2xl font-semibold leading-[1.05] tracking-[-0.025em]";
const LEDE = "m-0 text-xs leading-normal text-ink-soft";

/** `*mot*` mis en valeur, comme sur la landing (dégradé pour le héros,
 * texte en retrait pour « Comment ça marche »). */
function Emphasis({ text, variant }: { text: string; variant: "shine" | "soft" }) {
  return (
    <>
      {text.split(/\*([^*]+)\*/).map((part, i) =>
        i % 2 === 1 ? (
          <span
            key={i}
            className={variant === "shine" ? "bg-gradient-to-r from-accent via-accent-deep to-[#7c3aed] bg-clip-text italic text-transparent" : "text-neutral-faint"}
          >
            {part}
          </span>
        ) : (
          part
        ),
      )}
    </>
  );
}

const gradient = (g: { colorMain: string; colorSecondary: string }) => `linear-gradient(135deg, ${g.colorMain}, ${g.colorSecondary})`;

/** Aperçu en direct de la section ouverte : reproduction légère de la
 * landing (pas une iframe du vrai site, pour ne pas dépendre de son
 * déploiement). Textes résolus comme sur le site : langue → FR → défaut. */
export function SitePreview({ section, draft, games }: { section: SectionId; draft: SiteDraft; games: EditorGame[] }) {
  const [lang, setLang] = useState<Lang>("fr");
  const [device, setDevice] = useState<"desktop" | "mobile">("desktop");

  const raw = (locale: Lang) => Object.fromEntries(Object.entries(draft.texts).map(([k, v]) => [k, v[locale]]));
  const t = resolveLandingTexts({ fr: raw("fr"), en: raw("en") }, lang);
  const fixed = FIXED[lang];
  const meta = LANDING_SECTIONS.find((s) => s.id === section)!;
  const fallback = lang === "en" && meta.fields.some((f) => !draft.texts[f.key as LandingKey].en.trim());
  const mobile = device === "mobile";

  const featured = games.filter((g) => g.active && draft.settings.featuredGameIds.includes(g.id));
  const gameName = (g: EditorGame) => (lang === "en" && g.nameEn) || g.name;

  return (
    <aside aria-label="Aperçu en direct" className="flex min-w-0 flex-col gap-2.5 min-[1280px]:sticky min-[1280px]:top-[76px]">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <span className="flex items-center gap-2 text-xs text-neutral-faint">
          <span aria-hidden className="h-1.5 w-1.5 rounded-full bg-success motion-safe:animate-[bo-pulse_2s_infinite]" />
          Aperçu en direct
        </span>
        <div className="flex gap-1.5">
          <Segmented
            size="sm"
            label="Largeur de l’aperçu"
            value={device}
            onChange={setDevice}
            options={[
              { value: "desktop", label: <DesktopIcon aria-label="Bureau" />, title: "Bureau" },
              { value: "mobile", label: <DeviceMobileIcon aria-label="Mobile" />, title: "Mobile" },
            ]}
          />
          <Segmented size="sm" label="Langue de l’aperçu" value={lang} onChange={setLang} options={[{ value: "fr", label: "FR" }, { value: "en", label: "EN" }]} />
        </div>
      </div>

      <div className={`mx-auto w-full overflow-hidden rounded-[14px] border border-hairline bg-ground-deep transition-[max-width] duration-300 ${mobile ? "max-w-[260px]" : "max-w-full"}`}>
        <div className="flex items-center gap-1.5 border-b border-hairline bg-sunk px-3 py-2">
          {[0, 1, 2].map((i) => <span key={i} aria-hidden className="h-[7px] w-[7px] rounded-full bg-hairline" />)}
          <span className="ml-1.5 truncate font-mono text-[10.5px] text-neutral-faint">{DOMAIN}/{lang}{meta.anchor}</span>
        </div>

        <div lang={lang} className="flex min-h-[320px] flex-col gap-3 p-[18px]">
          {fallback && (
            <span className="flex items-center gap-1.5 self-start rounded-full bg-warning/12 px-2.5 py-1 text-[11px] text-warning">
              <WarningIcon aria-hidden /> Textes EN manquants — repli sur le FR
            </span>
          )}

          {section === "hero" && (
            <>
              <span className="self-start rounded-full border border-hairline-firm px-2.5 py-1 font-mono text-[9px] uppercase tracking-[0.16em] text-ink-soft">
                {draft.settings.releaseDate && new Date(draft.settings.releaseDate) <= new Date() ? fixed.released : t["hero.eyebrow"]}
              </span>
              <p className={`${TITLE} ${mobile ? "text-[26px]" : "text-[30px]"}`}><Emphasis text={t["hero.title"]} variant="shine" /></p>
              <p className="m-0 text-[12.5px] leading-normal text-ink-soft">{t["hero.lede"]}</p>
              <div className="flex flex-wrap gap-1.5">
                <span className="rounded-full bg-accent px-3 py-2 text-[11px] font-bold text-ground-deep">{t["hero.ctaPrimary"]} ↓</span>
                <span className="rounded-full border border-hairline-firm px-3 py-2 text-[11px] font-semibold">{t["hero.ctaSecondary"]}</span>
              </div>
            </>
          )}

          {section === "games" && (
            <>
              <span className={KICKER}>{t["games.kicker"]}</span>
              <p className={TITLE}>{t["games.title"]}</p>
              <p className={LEDE}>{t["games.lede"]}</p>
              {featured.length === 0 ? (
                <p className="m-0 text-xs text-warning">Aucun jeu actif sélectionné : la section est masquée sur la landing.</p>
              ) : (
                <div className={`grid gap-1.5 ${mobile ? "grid-cols-2" : "grid-cols-4"}`}>
                  {featured.map((g) => (
                    <div key={g.id} className="flex flex-col gap-1.5 rounded-lg border border-hairline bg-surface p-2">
                      <span aria-hidden className="flex h-6 w-6 items-center justify-center rounded-md text-xs" style={{ background: gradient(g) }}>{g.icon}</span>
                      <span className="font-display text-[11px] font-semibold leading-tight">{gameName(g)}</span>
                    </div>
                  ))}
                </div>
              )}
            </>
          )}

          {section === "demo" && <DemoPreview t={t} fixed={fixed} draft={draft} games={games} />}

          {section === "about" && (
            <>
              <span className={KICKER}>{fixed.aboutKicker}</span>
              <p className={TITLE}><Emphasis text={t["about.title"]} variant="soft" /></p>
              {([1, 2, 3] as const).map((n) => (
                <div key={n} className="flex gap-2.5 border-t border-hairline py-2">
                  <span aria-hidden className="font-display text-xl leading-none text-neutral-faint">0{n}</span>
                  <span className="flex flex-col gap-0.5">
                    <span className="text-[12.5px] font-semibold">{t[`about.step${n}`]}</span>
                    <span className="text-[11px] leading-normal text-ink-soft">{t[`about.step${n}Body`]}</span>
                  </span>
                </div>
              ))}
            </>
          )}

          {section === "notif" && (
            <>
              <span className={KICKER}>{fixed.notifKicker}</span>
              <p className={TITLE}>{t["notif.title"]}</p>
              <p className={LEDE}>{t["notif.lede"]}</p>
              <div className="flex gap-1.5">
                <span className="flex-1 rounded-lg border border-hairline-firm bg-surface p-2 text-[11px] text-neutral-faint">{fixed.email}</span>
                <span className="rounded-lg bg-accent px-3 py-2 text-[11px] font-bold text-ground-deep">{t["notif.button"]}</span>
              </div>
              <span className="text-[10.5px] leading-snug text-neutral-faint">☐ {t["notif.consent"]}</span>
              <div className="flex items-center gap-2 rounded-lg border border-success/30 bg-success/10 p-2.5 text-[11.5px]">
                <CheckCircleIcon aria-hidden weight="fill" className="shrink-0 text-[15px] text-success" />
                {t["notif.success"]}
              </div>
              {draft.settings.doubleOptIn && (
                <span className="text-[10.5px] text-neutral-faint">Double opt-in actif : un e-mail de confirmation part après l’inscription.</span>
              )}
            </>
          )}

          {section === "social" && (
            <>
              <span className={KICKER}>{fixed.socialKicker}</span>
              <p className={TITLE}>{t["social.title"]}</p>
              {([["Instagram", draft.settings.instagramUrl, fixed.instagram], ["TikTok", draft.settings.tiktokUrl, fixed.tiktok], ["Reddit", draft.settings.redditUrl, fixed.reddit]] as const).map(
                ([name, url, note]) => (
                  <div key={name} className={`flex items-center justify-between gap-2 border-t border-hairline py-2 text-[13px] ${url.trim() ? "" : "opacity-40"}`}>
                    {name}
                    <span className="font-mono text-[9.5px] text-neutral-faint">{url.trim() ? note : fixed.hidden}</span>
                  </div>
                ),
              )}
            </>
          )}

          {section === "seo" && <SeoPreview t={t} lang={lang} featured={featured} />}
        </div>
      </div>
    </aside>
  );
}

function DemoPreview({ t, fixed, draft, games }: { t: LandingTexts; fixed: Record<string, string>; draft: SiteDraft; games: EditorGame[] }) {
  // Première catégorie jouable (jeu actif, carte dans la limite
  // d'intensité) : c'est elle que la démo propose d'abord.
  const pick = games
    .filter((g) => g.active)
    .flatMap((g) => g.categories.map((c) => ({ g, c })))
    .find(({ c }) => draft.eligible[c.id] && c.sample && c.sample.intensity <= draft.settings.demoMaxIntensity);
  return (
    <>
      <span className={KICKER}>{fixed.demoKicker}</span>
      <p className={TITLE}>{t["demo.title"]}</p>
      <p className={LEDE}>{t["demo.lede"]}</p>
      {pick ? (
        <div className="relative mx-auto mt-1.5 aspect-[3/4] w-[150px]">
          <div aria-hidden className="absolute inset-0 translate-x-2 rotate-6 rounded-xl border border-hairline bg-surface" />
          <div className="absolute inset-0 flex flex-col justify-between rounded-xl p-3 text-white" style={{ background: gradient(pick.g) }}>
            <span className="font-mono text-[8px] uppercase tracking-[0.14em]">{pick.g.icon} {pick.c.name}</span>
            <span className="font-display text-[13px] font-semibold leading-tight">{pick.c.sample!.text}</span>
            <span className="font-mono text-[8px] opacity-80">1 / {draft.settings.demoDeckSize}</span>
          </div>
        </div>
      ) : (
        <p className="m-0 text-xs text-warning">Aucune catégorie jouable : la démo n’a rien à proposer.</p>
      )}
    </>
  );
}

const cut = (s: string, max: number) => (s.length > max ? `${s.slice(0, max - 1).trimEnd()}…` : s);

function SeoPreview({ t, lang, featured }: { t: LandingTexts; lang: Lang; featured: EditorGame[] }) {
  const fan = featured.slice(0, 4);
  return (
    <>
      <span className="text-[11px] text-neutral-faint">Aperçu du résultat Google</span>
      <div className="flex flex-col gap-1 rounded-[10px] border border-hairline bg-surface p-3">
        <span className="text-[11px] text-ink-soft">{DOMAIN} › {lang}</span>
        <span className="text-[15px] leading-snug text-[#8ab4f8]">{cut(t["meta.title"], 60)}</span>
        <span className="text-xs leading-normal text-ink-soft">{cut(t["meta.description"], 160)}</span>
      </div>
      <span className="mt-1.5 text-[11px] text-neutral-faint">Carte de partage (réseaux sociaux, messageries)</span>
      <div className="overflow-hidden rounded-[10px] border border-hairline">
        <div aria-hidden className="flex h-[110px] items-center justify-center gap-1 bg-ground">
          {fan.map((g, i) => (
            <span
              key={g.id}
              className="h-10 w-7 rounded-md"
              style={{ background: gradient(g), transform: `rotate(${(i - (fan.length - 1) / 2) * 12}deg)` }}
            />
          ))}
        </div>
        <div className="bg-surface px-2.5 py-2 text-[11.5px] font-semibold">{t["meta.title"]}</div>
      </div>
    </>
  );
}

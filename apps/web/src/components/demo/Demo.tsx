"use client";

import { useEffect, useMemo, useReducer, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import type { DemoSettings } from "@playlink/content-schema/landing-keys.ts";
import type { PreviewCategory } from "@/lib/backoffice";
import { OPEN_DEMO_EVENT, type OpenDemoDetail } from "@/lib/demo-events";
import { buildDeck, INTENSITY_DEFAULT } from "@/lib/demo/deck";
import { reduce, startGame, type Action, type DemoPlayer, type GameState } from "@/lib/demo/game";
import { frenchSpacing } from "@/lib/typography";
import { DemoStage, type DemoGame } from "./DemoStage";

/** Trois joueurs par défaut, non modifiables (décision produit du 24/09) :
 * assez pour montrer le tour de rôle et le podium, sans formulaire. */
const PLAYERS: DemoPlayer[] = [
  { id: "alex", name: "Alex", avatar: "🦊" },
  { id: "sam", name: "Sam", avatar: "🐙" },
  { id: "lea", name: "Léa", avatar: "🦄" },
];

/** Même règle que l'app (content_repository.dart) : 3 indices par carte
 * pour Devine le mot, aucun ailleurs. */
const hintsPerCard = (slug: string) => (slug === "devine-mot" ? 3 : 0);

type Selection = { gameSlug: string; categorySlug: string; intensity: number };

function gameReducer(s: GameState | null, a: Action | { type: "start"; state: GameState } | { type: "stop" }) {
  if (a.type === "start") return a.state;
  if (a.type === "stop") return null;
  return s && reduce(s, a);
}

/** Démo jouable : le vrai déroulé d'une partie de l'app, à trois joueurs,
 * sur l'échantillon de cartes publié par le back-office. */
export function Demo({ categories, locale, settings }: { categories: PreviewCategory[]; locale: string; settings: DemoSettings }) {
  const t = useTranslations("demo");

  // Jeux jouables = ceux qui ont au moins une catégorie dans l'échantillon,
  // dans l'ordre des catégories (déjà trié par ordre de jeu côté API).
  const games = useMemo(() => {
    const bySlug = new Map<string, DemoGame>();
    for (const c of categories) {
      const g = bySlug.get(c.game.slug) ?? { ...c.game, categories: [] };
      g.categories.push(c);
      bySlug.set(c.game.slug, g);
    }
    return [...bySlug.values()];
  }, [categories]);

  const defaultIntensity = Math.min(INTENSITY_DEFAULT, settings.maxIntensity);
  const [sel, setSel] = useState<Selection>(() => ({
    gameSlug: games[0]?.slug ?? "",
    categorySlug: games[0]?.categories[0]?.slug ?? "",
    intensity: defaultIntensity,
  }));
  const [game, dispatch] = useReducer(gameReducer, null);
  const stageRef = useRef<HTMLDivElement>(null);

  const current = games.find((g) => g.slug === sel.gameSlug) ?? games[0];
  const category = current?.categories.find((c) => c.slug === sel.categorySlug) ?? current?.categories[0];

  // Carte du héros ou tuile « Jouer » : on présélectionne ce jeu.
  useEffect(() => {
    const onOpen = (e: Event) => {
      const { gameSlug } = (e as CustomEvent<OpenDemoDetail>).detail;
      const g = games.find((x) => x.slug === gameSlug);
      if (!g) return;
      setSel((s) => ({ ...s, gameSlug: g.slug, categorySlug: g.categories[0].slug }));
      dispatch({ type: "stop" });
    };
    window.addEventListener(OPEN_DEMO_EVENT, onOpen);
    return () => window.removeEventListener(OPEN_DEMO_EVENT, onOpen);
  }, [games]);

  if (!current || !category) {
    return (
      <div className="rounded-3xl border border-dashed border-hairline-firm bg-surface/50 px-6 py-16 text-center text-sm text-neutral-faint">
        {t("comingSoon")}
      </div>
    );
  }

  // Changer un réglage en cours de partie la termine : la partie affichée
  // doit toujours correspondre à ce qui est sélectionné.
  function select(next: Partial<Selection>) {
    setSel((s) => ({ ...s, ...next }));
    dispatch({ type: "stop" });
  }

  function play() {
    const cards = category!.cards.map((c) => ({
      id: c.id,
      text: frenchSpacing(c.translations[locale]?.text ?? c.text),
      intensity: c.intensity,
    }));
    const deck = buildDeck(cards, sel.intensity, settings.deckSize, (c) => c.intensity);
    dispatch({ type: "start", state: startGame(PLAYERS, deck, hintsPerCard(current!.slug)) });
    // Sous 900 px, la scène est sous les réglages : on l'amène à l'écran.
    if (!window.matchMedia("(min-width: 900px)").matches) {
      const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
      stageRef.current?.scrollIntoView({ behavior: reduceMotion ? "auto" : "smooth", block: "start" });
    }
  }

  const gradient = `linear-gradient(135deg, ${current.colorMain}, ${current.colorSecondary})`;
  const levelLabel = (n: number) => t(`levels.${n}`);

  return (
    <>
      {/* Halo à la couleur du jeu choisi, derrière toute la section. */}
      <div
        aria-hidden
        className="pointer-events-none absolute inset-0 transition-[background] duration-[800ms]"
        style={{ background: `radial-gradient(ellipse 55% 60% at 75% 55%, color-mix(in srgb, ${current.colorMain} 20%, transparent), transparent 70%)` }}
      />
      <div className="relative grid grid-cols-[repeat(auto-fit,minmax(min(100%,400px),1fr))] items-stretch gap-5">
        {/* ── Réglages ─────────────────────────────────────────────── */}
        <div data-reveal className="flex flex-col gap-[30px] rounded-[26px] border border-hairline bg-sunk p-[clamp(20px,4vw,28px)]">
          <Step n="01" label={t("pickGame")}>
            <ChipRow label={t("gameLabel")}>
              {games.map((g) => (
                <Chip
                  key={g.slug}
                  on={g.slug === current.slug}
                  color={g.colorMain}
                  rounded="full"
                  onClick={() => select({ gameSlug: g.slug, categorySlug: g.categories[0].slug })}
                >
                  <span aria-hidden>{g.icon}</span>
                  {g.name}
                </Chip>
              ))}
            </ChipRow>
          </Step>

          <Step n="02" label={t("pickCategory")}>
            <ChipRow label={t("categoryLabel")}>
              {current.categories.map((c) => (
                <Chip key={c.slug} on={c.slug === category.slug} color={current.colorMain} rounded="md" onClick={() => select({ categorySlug: c.slug })}>
                  {c.translations[locale]?.name ?? c.name}
                </Chip>
              ))}
            </ChipRow>
          </Step>

          <Step n="03" label={t("pickIntensity")} aside={`${sel.intensity} · ${levelLabel(sel.intensity)}`}>
            <div role="radiogroup" aria-label={t("intensityLabel")} className="grid grid-cols-5 gap-1.5">
              {[1, 2, 3, 4, 5].map((n) => {
                const locked = n > settings.maxIntensity;
                const on = n <= sel.intensity;
                return (
                  <button
                    key={n}
                    type="button"
                    role="radio"
                    aria-checked={n === sel.intensity}
                    aria-disabled={locked || undefined}
                    aria-label={locked ? t("levelLocked", { n, label: levelLabel(n) }) : `${n} — ${levelLabel(n)}`}
                    title={locked ? t("levelLockedHint") : undefined}
                    onClick={() => !locked && select({ intensity: n })}
                    className={`flex h-11 items-end justify-center rounded-[10px] border border-hairline pb-[7px] transition-[background,transform] duration-300 ${
                      locked ? "cursor-not-allowed" : "hover:-translate-y-0.5"
                    }`}
                    style={{ background: on ? `linear-gradient(180deg, ${current.colorSecondary}, ${current.colorMain})` : "var(--color-surface)" }}
                  >
                    <span className={`font-mono text-[11px] font-semibold ${on ? "text-white" : "text-neutral-faint"}`}>
                      {locked ? "🔒" : n}
                    </span>
                  </button>
                );
              })}
            </div>
            {settings.maxIntensity < 5 && <p className="m-0 text-[13px] text-neutral-faint">{t("levelLockedHint")}</p>}
          </Step>

          <div className="mt-auto flex flex-col gap-3">
            <button
              type="button"
              onClick={play}
              className="flex items-center justify-center gap-2.5 rounded-[14px] px-[22px] py-4 text-base font-bold text-ground-deep shadow-[0_10px_30px_-12px_rgb(242_58_107/0.8)] transition-transform duration-200 hover:-translate-y-0.5 active:translate-y-0"
              style={{ background: "var(--gradient-accent)" }}
            >
              {game ? t("restart") : t("start")}
            </button>
            <p className="m-0 text-center text-[13px] text-neutral-faint">
              {t.rich("keyboard", { kbd: (chunk) => <Kbd>{chunk}</Kbd> })}
            </p>
          </div>
        </div>

        {/* ── Scène ────────────────────────────────────────────────── */}
        <DemoStage
          ref={stageRef}
          game={current}
          gradient={gradient}
          categoryName={category.translations[locale]?.name ?? category.name}
          intensity={sel.intensity}
          intensityLabel={levelLabel(sel.intensity)}
          deckSize={Math.min(settings.deckSize, category.cards.length)}
          state={game}
          dispatch={dispatch}
          onReplay={play}
          onChangeGame={() => dispatch({ type: "stop" })}
        />
      </div>
    </>
  );
}

function Step({ n, label, aside, children }: { n: string; label: string; aside?: string; children: React.ReactNode }) {
  return (
    <div className="flex min-w-0 flex-col gap-3.5">
      <div className="flex items-baseline justify-between gap-3">
        <p className="m-0 flex gap-2.5 font-mono text-xs uppercase tracking-[0.14em] text-neutral-faint">
          <span className="text-accent">{n}</span>
          {label}
        </p>
        {aside && <span className="text-sm font-semibold text-ink">{aside}</span>}
      </div>
      {children}
    </div>
  );
}

/** Rangée de choix : sur plusieurs lignes au-delà de 900 px ; en dessous,
 * une seule ligne qui défile horizontalement jusqu'aux bords du panneau,
 * avec un fondu à droite pour signaler la suite. */
function ChipRow({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div
      data-track
      data-chiprow
      role="radiogroup"
      aria-label={label}
      className="-mx-[clamp(20px,4vw,28px)] flex snap-x snap-proximity gap-2 overflow-x-auto overscroll-x-contain px-[clamp(20px,4vw,28px)] py-0.5 [mask-image:linear-gradient(90deg,#000_82%,transparent)] [scroll-padding-inline:clamp(20px,4vw,28px)] min-[900px]:mx-0 min-[900px]:flex-wrap min-[900px]:overflow-visible min-[900px]:px-0 min-[900px]:[mask-image:none]"
    >
      {children}
    </div>
  );
}

function Chip({ on, color, rounded, onClick, children }: {
  on: boolean; color: string; rounded: "full" | "md"; onClick: () => void; children: React.ReactNode;
}) {
  return (
    <button
      type="button"
      role="radio"
      aria-checked={on}
      onClick={(e) => {
        onClick();
        revealChip(e.currentTarget);
      }}
      className={`flex shrink-0 snap-start items-center gap-2 whitespace-nowrap border text-sm font-medium transition-[border-color,background,color] duration-[250ms] hover:border-neutral hover:text-ink ${
        rounded === "full" ? "rounded-full px-3.5 py-[9px]" : "rounded-[10px] px-[13px] py-2"
      } ${on ? "text-ink" : "border-hairline text-ink-soft"}`}
      style={on ? { borderColor: color, background: `color-mix(in srgb, ${color} 20%, var(--color-surface))` } : undefined}
    >
      {children}
    </button>
  );
}

/** Recentre l'option choisie quand la rangée défile (sous 900 px). */
function revealChip(btn: HTMLElement) {
  const row = btn.closest<HTMLElement>("[data-chiprow]");
  if (!row || row.scrollWidth <= row.clientWidth) return;
  const left = btn.offsetLeft - row.offsetLeft - (row.clientWidth - btn.offsetWidth) / 2;
  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  row.scrollTo({ left: Math.max(0, left), behavior: reduceMotion ? "auto" : "smooth" });
}

function Kbd({ children }: { children: React.ReactNode }) {
  return <kbd className="rounded-[5px] border border-hairline-firm px-1.5 py-0.5 font-mono">{children}</kbd>;
}

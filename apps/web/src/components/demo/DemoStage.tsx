"use client";

import { useEffect, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import type { PreviewCategory } from "@/lib/backoffice";
import { ranking, stageOf, type Action, type GameState } from "@/lib/demo/game";
import { LogoMark } from "../Logo";

export type DemoGame = PreviewCategory["game"] & { categories: PreviewCategory[] };

const SWIPE_PX = 90;
const MEDALS = ["🥇", "🥈", "🥉"];

type Props = {
  ref: React.Ref<HTMLDivElement>;
  game: DemoGame;
  gradient: string;
  categoryName: string;
  intensity: number;
  intensityLabel: string;
  deckSize: number;
  state: GameState | null;
  dispatch: (a: Action) => void;
  onReplay: () => void;
  onChangeGame: () => void;
};

/** Scène de la démo. Chaque étape reprend l'écran correspondant de l'app
 * (play_screen.dart) : tour → carte → vote → … → résultats. */
export function DemoStage(props: Props) {
  const { ref, game, gradient, categoryName, intensity, intensityLabel, deckSize, state, dispatch } = props;
  const t = useTranslations("demo");
  const stage = state ? stageOf(state) : "setup";
  const player = state?.players[state.currentPlayer];
  // « d'Alex », « qu'Alex » : le français élide devant une voyelle.
  const who = player && { name: player.name, elide: /^[aeiouyhàâéèêëîïôöûü]/i.test(player.name) ? "yes" : "no" };
  const primaryRef = useRef<HTMLButtonElement>(null);

  // Nouvelle étape : le focus va à son bouton principal, pour enchaîner au
  // clavier et pour que le lecteur d'écran lise la nouvelle étape. Jamais
  // au premier affichage (la page défilerait toute seule jusqu'ici).
  useEffect(() => {
    if (state) primaryRef.current?.focus({ preventScroll: true });
  }, [stage, state]);

  // Raccourcis : P / → = point, N / ← = pas de point ; sur la carte, ← →
  // valent le swipe de l'app (ouvrir le vote).
  function onKeyDown(e: React.KeyboardEvent) {
    if (!state) return;
    const k = e.key.toLowerCase();
    if (stage === "vote" && (k === "p" || k === "arrowright")) dispatch({ type: "vote", point: true });
    else if (stage === "vote" && (k === "n" || k === "arrowleft")) dispatch({ type: "vote", point: false });
    else if (stage === "card" && (k === "arrowleft" || k === "arrowright")) dispatch({ type: "openVote" });
    else return;
    e.preventDefault();
  }

  return (
    <div
      ref={ref}
      data-reveal
      data-delay="120"
      onKeyDown={onKeyDown}
      aria-label={t("stageLabel")}
      role="region"
      className="relative flex min-h-[600px] flex-col overflow-clip rounded-[26px] border border-hairline bg-sunk/70 p-[clamp(16px,3vw,24px)]"
    >
      {/* En-tête : jeu, catégorie · intensité, avancement du deck. */}
      <div className="flex items-center justify-between gap-3">
        <div className="flex min-w-0 items-center gap-2.5">
          <span aria-hidden className="flex h-[34px] w-[34px] shrink-0 items-center justify-center rounded-[10px] text-lg" style={{ background: gradient }}>
            {game.icon}
          </span>
          <span className="flex min-w-0 flex-col">
            <span className="text-[15px] font-semibold text-ink">{game.name}</span>
            <span className="truncate text-[13px] text-neutral-faint">
              {categoryName} · {intensity} · {intensityLabel}
            </span>
          </span>
        </div>
        {state && stage !== "results" && (
          <div className="flex items-center gap-2.5">
            <div aria-hidden className="flex gap-1">
              {state.deck.map((c, k) => (
                <span
                  key={c.id}
                  className="h-1 rounded-sm transition-all duration-[400ms]"
                  style={{
                    width: k === state.index ? 18 : 8,
                    background: k < state.index ? game.colorSecondary : k === state.index ? "var(--color-ink)" : "var(--color-hairline-firm)",
                  }}
                />
              ))}
            </div>
            <span className="font-mono text-xs text-ink-soft">
              {t("cardOf", { n: state.index + 1, total: state.deck.length })}
            </span>
          </div>
        )}
      </div>

      {/* Annonce vocale de chaque changement d'étape. */}
      <p aria-live="polite" className="sr-only">
        {stage === "turn" && player && t("turnOf", who!)}
        {stage === "vote" && player && t("deservesPoint", who!)}
        {stage === "results" && t("gameOver")}
      </p>

      {stage === "setup" && <Setup gradient={gradient} icon={game.icon} deckSize={deckSize} />}

      {state && player && (stage === "turn" || stage === "card" || stage === "vote") && (
        <div className="flex flex-1 flex-col items-center justify-center gap-5 pb-1 pt-5">
          <p className="m-0 text-center text-[15px] text-ink-soft">
            {t.rich("turnOfRich", {
              ...who!,
              b: (chunk) => <strong className="font-semibold" style={{ color: game.colorSecondary }}>{chunk}</strong>,
            })}
          </p>

          <FlipCard
            key={state.index}
            revealed={stage !== "turn"}
            dimmed={stage === "vote"}
            gradient={gradient}
            categoryName={categoryName}
            card={state.deck[state.index]}
            position={t("cardOf", { n: state.index + 1, total: state.deck.length })}
            intensityLabel={t(`levels.${state.deck[state.index].intensity}`)}
            onReveal={() => dispatch({ type: "reveal" })}
            onSwipe={() => dispatch({ type: "openVote" })}
            backLabel={t("tapToReveal")}
          />

          {stage === "turn" && (
            <div className="flex flex-col items-center gap-2.5">
              <PrimaryButton ref={primaryRef} gradient={gradient} onClick={() => dispatch({ type: "reveal" })}>
                {t("seeCard")}
              </PrimaryButton>
              <span className="text-center text-[13px] text-neutral-faint">
                {state.index === 0 ? t("dontPeek") : t("passPhoneTo", { name: player.name })}
              </span>
            </div>
          )}

          {stage === "card" && (
            <div className="flex w-full flex-col items-center gap-3">
              {state.hintsPerCard > 0 && (
                <div className="flex items-center gap-3 text-sm text-ink-soft">
                  <span aria-hidden className="flex gap-1">
                    {Array.from({ length: state.hintsPerCard }, (_, i) => (
                      <span key={i} className="h-2 w-2 rounded-full" style={{ background: i < state.hintsLeft ? game.colorSecondary : "var(--color-hairline-firm)" }} />
                    ))}
                  </span>
                  {t("hintsLeft", { n: state.hintsLeft })}
                  <button
                    type="button"
                    disabled={state.hintsLeft === 0}
                    onClick={() => dispatch({ type: "useHint" })}
                    className="rounded-full border border-hairline-firm px-3 py-1.5 text-[13px] font-semibold text-ink transition-colors hover:border-neutral disabled:opacity-40"
                  >
                    {t("useHint")}
                  </button>
                </div>
              )}
              <PrimaryButton ref={primaryRef} gradient={gradient} onClick={() => dispatch({ type: "openVote" })}>
                {t("vote")}
              </PrimaryButton>
              <span className="text-[13px] text-neutral-faint">{t("swipeHint")}</span>
            </div>
          )}

          {stage === "vote" && (
            <div className="flex w-full max-w-[360px] flex-col gap-3.5">
              <p className="m-0 text-center font-display text-2xl font-semibold leading-tight tracking-[-0.01em]">
                {t("deservesPoint", who!)}
              </p>
              <div className="grid grid-cols-2 gap-2.5">
                <button
                  type="button"
                  onClick={() => dispatch({ type: "vote", point: false })}
                  className="flex h-[76px] flex-col items-center justify-center gap-1 rounded-2xl border border-hairline bg-surface text-base font-bold text-ink transition-colors hover:border-neutral"
                >
                  <span aria-hidden className="text-xl">👎</span>
                  {t("no")}
                </button>
                <button
                  ref={primaryRef}
                  type="button"
                  onClick={() => dispatch({ type: "vote", point: true })}
                  className="flex h-[76px] flex-col items-center justify-center gap-1 rounded-2xl text-base font-bold text-white transition-transform hover:-translate-y-0.5"
                  style={{ background: gradient }}
                >
                  <span aria-hidden className="text-xl">👍</span>
                  {t("yes")}
                </button>
              </div>
              <span className="text-center text-[13px] text-neutral-faint">{t("voteIsMandatory")}</span>
            </div>
          )}
        </div>
      )}

      {state && stage === "results" && (
        <Results
          state={state}
          gradient={gradient}
          meta={`${categoryName} · ${t("cardsCount", { n: state.deck.length })} · ${intensity} · ${intensityLabel}`}
          replayRef={primaryRef}
          onReplay={props.onReplay}
          onChangeGame={props.onChangeGame}
        />
      )}
    </div>
  );
}

function Setup({ gradient, icon, deckSize }: { gradient: string; icon: string | null; deckSize: number }) {
  const t = useTranslations("demo");
  const outlined = { background: `linear-gradient(var(--color-surface), var(--color-surface)) padding-box, ${gradient} border-box` };
  return (
    <div className="flex flex-1 flex-col items-center justify-center gap-8 py-6">
      <div aria-hidden className="relative h-[300px] w-[220px]">
        <div className="absolute inset-0 -translate-x-[22px] -rotate-[8deg] rounded-[22px] border-2 border-transparent opacity-50" style={outlined} />
        <div className="absolute inset-0 translate-x-[18px] rotate-[6deg] rounded-[22px] border-2 border-transparent opacity-75" style={outlined} />
        <div
          className="absolute inset-0 flex flex-col items-center justify-center gap-3.5 rounded-[22px] border-2 border-transparent motion-safe:animate-[pl-float_5s_ease-in-out_infinite]"
          style={outlined}
        >
          <span className="text-[54px]">{icon}</span>
          <span className="font-mono text-[11px] uppercase tracking-[0.16em] text-neutral-faint">{t("cardsCount", { n: deckSize })}</span>
        </div>
      </div>
      <p className="m-0 max-w-[32ch] text-center text-base leading-normal text-ink-soft">{t("setupHint")}</p>
    </div>
  );
}

/** Carte retournable : dos Playlink au tour du joueur, face au clic. Au
 * recto, glisser la carte à gauche ou à droite ouvre le vote, comme le
 * swipe de l'app. `key` = index de la carte : chaque carte arrive neuve. */
function FlipCard(p: {
  revealed: boolean;
  dimmed: boolean;
  gradient: string;
  categoryName: string;
  card: { text: string; intensity: number };
  position: string;
  intensityLabel: string;
  backLabel: string;
  onReveal: () => void;
  onSwipe: () => void;
}) {
  const [dragX, setDragX] = useState(0);
  const drag = useRef<{ x: number; moved: boolean } | null>(null);

  return (
    <div className={`relative aspect-[3/4] select-none transition-[width] duration-500 ease-[cubic-bezier(.2,.8,.2,1)] [perspective:1200px] motion-safe:animate-[card-enter_0.35s_ease-out] ${p.dimmed ? "w-[min(190px,50vw)]" : "w-[min(280px,72vw)]"}`}>
      <div
        onPointerDown={(e) => {
          drag.current = { x: e.clientX, moved: false };
          e.currentTarget.setPointerCapture(e.pointerId);
        }}
        onPointerMove={(e) => {
          if (!drag.current) return;
          const dx = e.clientX - drag.current.x;
          if (Math.abs(dx) > 5) drag.current.moved = true;
          // Face cachée : la carte résiste (on ne vote pas sans avoir lu).
          setDragX(p.revealed && !p.dimmed ? dx : dx * 0.12);
        }}
        onPointerUp={() => {
          const d = drag.current;
          drag.current = null;
          if (d && !d.moved && !p.revealed) p.onReveal();
          else if (d?.moved && p.revealed && !p.dimmed && Math.abs(dragX) > SWIPE_PX) p.onSwipe();
          setDragX(0);
        }}
        onPointerCancel={() => {
          drag.current = null;
          setDragX(0);
        }}
        className={`absolute inset-0 touch-pan-y ${p.revealed ? "" : "cursor-pointer"}`}
        style={{
          transform: `translateX(${dragX}px) rotate(${dragX / 18}deg)`,
          transition: drag.current ? "none" : "transform .3s cubic-bezier(.2,.8,.2,1)",
        }}
      >
        <div
          className="absolute inset-0 transition-transform duration-[600ms] ease-[cubic-bezier(.2,.8,.2,1)] [transform-style:preserve-3d]"
          style={{ transform: `rotateY(${p.revealed ? 0 : 180}deg)` }}
        >
          {/* Recto */}
          <div
            className={`absolute inset-0 overflow-hidden rounded-[24px] border border-white/15 shadow-[0_40px_70px_-30px_rgb(6_5_9/0.9)] transition-opacity duration-300 [backface-visibility:hidden] ${p.dimmed ? "opacity-60" : ""}`}
            style={{ background: p.gradient }}
            aria-hidden={!p.revealed}
          >
            <div aria-hidden className="absolute inset-0 bg-gradient-to-b from-ground-deep/30 to-ground-deep/60" />
            <div className="relative flex h-full flex-col justify-between p-6 text-white">
              <span className="font-mono text-[11px] uppercase tracking-[0.16em] opacity-90">{p.categoryName}</span>
              <p className={`m-0 text-pretty font-display font-semibold leading-[1.22] ${p.dimmed ? "line-clamp-5 text-base" : "text-[clamp(20px,5vw,24px)]"}`}>{p.card.text}</p>
              <span className="flex justify-between font-mono text-xs opacity-90">
                <span>{p.intensityLabel}</span>
                <span>{p.position}</span>
              </span>
            </div>
          </div>
          {/* Verso (dos Playlink) */}
          <div
            aria-hidden={p.revealed}
            className="absolute inset-0 flex flex-col items-center justify-center gap-3.5 rounded-[24px] border-2 border-transparent [backface-visibility:hidden] [transform:rotateY(180deg)]"
            style={{ background: `linear-gradient(#17151d, #17151d) padding-box, ${p.gradient} border-box` }}
          >
            <LogoMark size={64} />
            <span className="font-display text-2xl font-semibold text-ink">Playlink</span>
            <span className="font-mono text-[11px] uppercase tracking-[0.16em] text-neutral-faint">{p.backLabel}</span>
          </div>
        </div>
      </div>
    </div>
  );
}

function PrimaryButton({ ref, gradient, onClick, children }: {
  ref: React.Ref<HTMLButtonElement>; gradient: string; onClick: () => void; children: React.ReactNode;
}) {
  return (
    <button
      ref={ref}
      type="button"
      onClick={onClick}
      className="min-w-[200px] rounded-full px-6 py-3.5 text-base font-bold text-white shadow-[0_10px_30px_-12px_rgb(6_5_9/0.9)] transition-transform duration-200 hover:-translate-y-0.5"
      style={{ background: gradient }}
    >
      {children}
    </button>
  );
}

function Results({ state, gradient, meta, replayRef, onReplay, onChangeGame }: {
  state: GameState;
  gradient: string;
  meta: string;
  replayRef: React.Ref<HTMLButtonElement>;
  onReplay: () => void;
  onChangeGame: () => void;
}) {
  const t = useTranslations("demo");
  const { ranked, tie } = ranking(state);

  return (
    <div className="flex flex-1 flex-col justify-center gap-6 px-2 py-6">
      <div className="flex flex-col gap-2">
        <p className="m-0 font-mono text-xs uppercase tracking-[0.16em] text-accent">{t("gameOver")}</p>
        <h3 className="m-0 font-display text-[clamp(28px,4vw,36px)] font-semibold leading-[1.1] tracking-[-0.02em]">
          {tie ? t("tie") : t("winnerAnnounce", { name: ranked[0].name })}
        </h3>
        <p className="m-0 text-[13px] text-neutral-faint">{meta}</p>
      </div>

      <ol className="m-0 flex list-none flex-col gap-2 p-0">
        {ranked.map((p, i) => (
          <li
            key={p.id}
            className="flex items-center gap-3 rounded-2xl border px-4 py-3"
            style={i === 0 && !tie ? { borderColor: "transparent", background: `linear-gradient(var(--color-surface), var(--color-surface)) padding-box, ${gradient} border-box` } : { borderColor: "var(--color-hairline)", background: "var(--color-surface)" }}
          >
            <span aria-hidden className="w-7 text-xl">{MEDALS[i]}</span>
            <span aria-hidden className="text-2xl">{p.avatar}</span>
            <span className="flex-1 font-semibold text-ink">{p.name}</span>
            <span className="font-mono text-sm text-ink-soft">{t("points", { n: p.score })}</span>
          </li>
        ))}
      </ol>

      <p className="m-0 text-[15px] leading-normal text-ink-soft">{t("appPitch")}</p>

      <div className="grid grid-cols-[repeat(auto-fit,minmax(150px,1fr))] gap-2.5">
        {["App Store", "Google Play"].map((store) => (
          <div key={store} className="flex flex-col gap-0.5 rounded-2xl border border-hairline bg-surface px-4 py-3">
            <span className="font-mono text-[10px] uppercase tracking-[0.16em] text-neutral-faint">{t("soonOn")}</span>
            <span className="text-[17px] font-semibold">{store}</span>
          </div>
        ))}
      </div>

      <div className="flex flex-wrap gap-2.5">
        <button
          ref={replayRef}
          type="button"
          onClick={onReplay}
          className="rounded-full border border-accent px-5 py-3 text-[15px] font-semibold text-ink transition-colors hover:bg-accent-wash"
        >
          {t("replay")}
        </button>
        <button
          type="button"
          onClick={onChangeGame}
          className="rounded-full border border-hairline-firm px-5 py-3 text-[15px] font-semibold text-ink-soft transition-colors hover:border-neutral hover:text-ink"
        >
          {t("changeGame")}
        </button>
      </div>
    </div>
  );
}

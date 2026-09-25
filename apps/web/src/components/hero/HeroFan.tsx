"use client";

import { useEffect, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import { openDemo } from "@/lib/demo-events";

export type FanCard = {
  slug: string;
  name: string;
  icon: string | null;
  colorMain: string;
  colorSecondary: string;
  /** Une vraie carte du jeu, ou sa description à défaut. */
  sample: string;
  description: string | null;
};

/** Position selon l'écart au jeu affiché : [x, y, rotation, échelle,
 * opacité]. 0 = au centre, 1/3 à droite, 2/4 à gauche ; au-delà, la carte
 * attend cachée derrière. Valeurs du design. */
const POS: [number, number, number, number, number][] = [
  [0, 0, 0, 1, 1],
  [96, 16, 9, 0.9, 0.96],
  [-96, 16, -9, 0.9, 0.96],
  [172, 44, 17, 0.8, 0.7],
  [-172, 44, -17, 0.8, 0.7],
];
const HIDDEN: [number, number, number, number, number] = [0, 50, 0, 0.72, 0];
const ROTATION_MS = 2500;

/** Éventail des jeux du héros : tourne toutes les 2,5 s, se met en pause au
 * survol, au focus clavier et quand l'onglet est caché ; jamais en
 * mouvement réduit. Clic sur la carte du dessus = démo de ce jeu. */
export function HeroFan({ cards }: { cards: FanCard[] }) {
  const t = useTranslations("hero");
  const [active, setActive] = useState(0);
  const paused = useRef(false);

  useEffect(() => {
    if (cards.length < 2) return;
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
    const id = window.setInterval(() => {
      if (!paused.current && !document.hidden) setActive((i) => (i + 1) % cards.length);
    }, ROTATION_MS);
    return () => window.clearInterval(id);
  }, [cards.length]);

  const current = cards[active];
  const pad = (n: number) => String(n).padStart(2, "0");

  return (
    <div className="flex flex-col items-center gap-[22px]">
      <div
        role="region"
        aria-label={t("fanLabel")}
        onPointerEnter={() => (paused.current = true)}
        onPointerLeave={() => (paused.current = false)}
        onFocus={() => (paused.current = true)}
        onBlur={() => (paused.current = false)}
        // Sous 640 px, l'éventail se resserre (écarts × 0,58, cartes × 0,84)
        // via ces variables : aucun calcul JS de largeur, donc aucun écart
        // entre le rendu serveur et le navigateur.
        className="relative h-[clamp(360px,95vw,440px)] w-full [--k:0.58] [--ks:0.84] [perspective:1200px] motion-safe:animate-[pl-float_7s_ease-in-out_infinite] min-[640px]:[--k:1] min-[640px]:[--ks:1]"
      >
        {cards.map((c, i) => {
          const p = (i - active + cards.length) % cards.length;
          const [x, y, r, s, o] = POS[p] ?? HIDDEN;
          const gradient = `linear-gradient(135deg, ${c.colorMain}, ${c.colorSecondary})`;
          return (
            <button
              key={c.slug}
              type="button"
              onClick={() => openDemo(c.slug)}
              aria-label={t("tryGame", { name: c.name })}
              // Seule la carte du dessus est atteignable au clavier ; les
              // autres le deviennent en tournant (ou via les points).
              tabIndex={p === 0 ? 0 : -1}
              aria-hidden={p === 0 ? undefined : true}
              className="absolute left-1/2 top-1/2 h-[340px] w-[250px] cursor-pointer overflow-hidden rounded-3xl border border-white/15 p-0 text-left shadow-[0_40px_70px_-30px_rgb(6_5_9/0.9),0_0_0_1px_rgb(6_5_9/0.2)] transition-[transform,opacity] duration-[900ms,700ms] ease-[cubic-bezier(.2,.8,.2,1)]"
              style={{
                background: gradient,
                zIndex: 10 - p,
                opacity: o,
                transform: `translate(-50%,-50%) translate(calc(${x}px * var(--k)), calc(${y}px * var(--k))) rotate(${r}deg) scale(calc(${s} * var(--ks)))`,
              }}
            >
              {/* Voile : garde le texte blanc lisible (≥ 4,5:1) même sur les
                  dégradés clairs (Icebreaker, Mime). */}
              <span aria-hidden className="absolute inset-0 bg-gradient-to-b from-ground-deep/10 to-ground-deep/60" />
              <span className="relative flex h-full flex-col justify-between p-[22px] text-white">
                <span className="flex items-center justify-between">
                  <span className="flex h-[52px] w-[52px] items-center justify-center rounded-2xl bg-white/15 text-[28px]">{c.icon}</span>
                  <span className="font-mono text-[11px] tracking-[0.14em] opacity-85">
                    {pad(i + 1)} / {pad(cards.length)}
                  </span>
                </span>
                <span className="flex flex-col gap-2.5">
                  <span className="font-mono text-[11px] uppercase tracking-[0.16em] opacity-90">{c.name}</span>
                  <span className="line-clamp-4 font-display text-[22px] font-semibold leading-[1.18] tracking-[-0.01em]">{c.sample}</span>
                  <span className="text-[13px] font-semibold opacity-90">{t("playDemo")}</span>
                </span>
              </span>
            </button>
          );
        })}
      </div>

      {current && (
        <div className="flex min-h-14 flex-col items-center gap-3">
          <p aria-live="polite" className="m-0 text-center text-[15px] text-ink-soft">
            <strong className="font-semibold text-ink">{current.name}</strong>
            {current.description && <> — {current.description}</>}
          </p>
          {/* Zone de clic de 24 px (cible tactile minimale), trait visible
              centré dedans : le design reste fin, le doigt ne rate pas. */}
          <div className="flex">
            {cards.map((c, i) => (
              <button
                key={c.slug}
                type="button"
                onClick={() => setActive(i)}
                aria-label={t("showGame", { name: c.name })}
                aria-current={i === active ? "true" : undefined}
                className="flex h-6 min-w-6 items-center justify-center px-[3px]"
              >
                <span
                  aria-hidden
                  className="h-1.5 rounded-[3px] transition-[width,background] duration-[400ms] ease-[cubic-bezier(.2,.8,.2,1)]"
                  style={{
                    width: i === active ? 26 : 6,
                    background: i === active ? `linear-gradient(135deg, ${c.colorMain}, ${c.colorSecondary})` : "var(--color-hairline-firm)",
                  }}
                />
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

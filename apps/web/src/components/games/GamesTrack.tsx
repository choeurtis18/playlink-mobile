"use client";

import { useEffect, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import { openDemo } from "@/lib/demo-events";

export type GameTileData = {
  slug: string;
  name: string;
  icon: string | null;
  colorMain: string;
  colorSecondary: string;
  description: string | null;
  categoryCount: number;
};

const TILT_MAX_DEG = 16;
const GAP_PX = 16;

/** Tuiles des jeux. Au-delà de 900 px : grille, avec inclinaison 3D et
 * lueur à la couleur du jeu qui suivent la souris. En dessous : slider
 * horizontal aimanté, avec compteur, points et flèches. La bascule est
 * entièrement en CSS (media queries) ; le JS ne fait que suivre la
 * position du slider. */
export function GamesTrack({ games }: { games: GameTileData[] }) {
  const t = useTranslations("games");
  const trackRef = useRef<HTMLUListElement>(null);
  const [index, setIndex] = useState(0);
  const last = games.length - 1;

  // Carte affichée = défilement / largeur d'un pas. En butée droite, la
  // dernière carte peut ne jamais atteindre le bord gauche : on la
  // considère alors comme affichée, sinon « 08 / 08 » serait inatteignable.
  useEffect(() => {
    const el = trackRef.current;
    if (!el) return;
    let frame = 0;
    const update = () => {
      frame = 0;
      const first = el.firstElementChild as HTMLElement | null;
      if (!first || el.scrollWidth <= el.clientWidth) return;
      const step = first.getBoundingClientRect().width + GAP_PX;
      const atEnd = el.scrollLeft + el.clientWidth >= el.scrollWidth - 4;
      setIndex(atEnd ? last : Math.max(0, Math.min(last, Math.round(el.scrollLeft / step))));
    };
    const onScroll = () => {
      if (!frame) frame = requestAnimationFrame(update);
    };
    el.addEventListener("scroll", onScroll, { passive: true });
    return () => {
      cancelAnimationFrame(frame);
      el.removeEventListener("scroll", onScroll);
    };
  }, [last]);

  function scroll(to: (step: number, el: HTMLElement) => number) {
    const el = trackRef.current;
    const first = el?.firstElementChild as HTMLElement | null;
    if (!el || !first) return;
    const step = first.getBoundingClientRect().width + GAP_PX;
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    el.scrollTo({ left: to(step, el), behavior: reduce ? "auto" : "smooth" });
  }
  const slideTo = (i: number) => scroll((step) => Math.max(0, Math.min(last, i)) * step);
  // Flèches : une tuile de plus ou de moins depuis la position RÉELLE, pas
  // depuis l'index. Sur tablette (2,3 tuiles visibles), les dernières
  // tuiles partagent la même butée : viser « la 7e » depuis la 8e ne
  // bougerait pas. L'aimantation recale ensuite sur une tuile.
  const step = (dir: 1 | -1) => scroll((w, el) => el.scrollLeft + dir * w);

  const pad = (n: number) => String(n).padStart(2, "0");

  return (
    <div className="flex flex-col gap-5 min-[900px]:gap-0">
      <ul
        ref={trackRef}
        data-track
        data-reveal
        aria-label={t("listLabel")}
        className="-mx-[clamp(20px,4vw,24px)] flex snap-x snap-mandatory gap-4 overflow-x-auto overscroll-x-contain px-[clamp(20px,4vw,24px)] pb-2 pt-1.5 [scroll-padding-inline:clamp(20px,4vw,24px)] min-[900px]:mx-0 min-[900px]:grid min-[900px]:snap-none min-[900px]:grid-cols-[repeat(auto-fill,minmax(min(100%,262px),1fr))] min-[900px]:overflow-visible min-[900px]:p-0 my-0 list-none"
      >
        {games.map((g, i) => (
          <GameTile key={g.slug} game={g} num={pad(i + 1)} />
        ))}
      </ul>

      {games.length > 1 && (
        <div className="flex items-center justify-between gap-4 min-[900px]:hidden">
          <div className="flex items-center gap-3.5">
            <span aria-live="polite" className="font-mono text-xs tracking-[0.12em] text-ink-soft">
              {pad(index + 1)} / {pad(games.length)}
            </span>
            {/* Sous 400 px, les points (24 px chacun, cible tactile) ne tiennent
                plus à côté du compteur et des flèches : on garde ces deux-là. */}
            <div className="hidden min-[400px]:flex">
              {games.map((g, i) => (
                <button
                  key={g.slug}
                  type="button"
                  onClick={() => slideTo(i)}
                  aria-label={t("goTo", { name: g.name })}
                  aria-current={i === index ? "true" : undefined}
                  className="flex h-6 min-w-6 items-center justify-center px-[3px]"
                >
                  <span
                    aria-hidden
                    className="h-1.5 rounded-[3px] transition-[width,background] duration-[350ms] ease-[cubic-bezier(.2,.8,.2,1)]"
                    style={{
                      width: i === index ? 22 : 6,
                      background: i === index ? `linear-gradient(135deg, ${g.colorMain}, ${g.colorSecondary})` : "var(--color-hairline-firm)",
                    }}
                  />
                </button>
              ))}
            </div>
          </div>
          <div className="flex gap-2">
            <ArrowButton label={t("prev")} disabled={index === 0} onClick={() => step(-1)}>←</ArrowButton>
            <ArrowButton label={t("next")} disabled={index === last} onClick={() => step(1)}>→</ArrowButton>
          </div>
        </div>
      )}
    </div>
  );
}

function ArrowButton({ label, disabled, onClick, children }: { label: string; disabled: boolean; onClick: () => void; children: string }) {
  return (
    <button
      type="button"
      aria-label={label}
      disabled={disabled}
      onClick={onClick}
      className="h-11 w-11 rounded-full border border-hairline-firm bg-surface text-lg text-ink transition-opacity disabled:cursor-default disabled:opacity-35"
    >
      {children}
    </button>
  );
}

function GameTile({ game, num }: { game: GameTileData; num: string }) {
  const t = useTranslations("games");
  const gradient = `linear-gradient(135deg, ${game.colorMain}, ${game.colorSecondary})`;

  // Inclinaison + lueur : souris seulement, grille seulement (dans le
  // slider, la tuile défile sous le doigt), jamais en mouvement réduit.
  // Écrit directement dans le style : suivre la souris par setState
  // re-rendrait la tuile à chaque pixel.
  function onMove(e: React.PointerEvent<HTMLElement>) {
    if (e.pointerType !== "mouse") return;
    if (!window.matchMedia("(min-width: 900px) and (prefers-reduced-motion: no-preference)").matches) return;
    const el = e.currentTarget;
    const r = el.getBoundingClientRect();
    const x = (e.clientX - r.left) / r.width;
    const y = (e.clientY - r.top) / r.height;
    el.style.transform = `perspective(900px) rotateX(${(0.5 - y) * TILT_MAX_DEG}deg) rotateY(${(x - 0.5) * TILT_MAX_DEG}deg) translateY(-4px)`;
    el.style.borderColor = "var(--color-hairline-firm)";
    el.style.setProperty("--gx", `${x * 100}%`);
    el.style.setProperty("--gy", `${y * 100}%`);
    el.style.setProperty("--glow", "0.55");
  }

  function onLeave(e: React.PointerEvent<HTMLElement>) {
    const el = e.currentTarget;
    el.style.transform = "";
    el.style.borderColor = "";
    el.style.setProperty("--glow", "0");
  }

  return (
    <li
      onPointerMove={onMove}
      onPointerLeave={onLeave}
      className="relative isolate flex min-h-[290px] shrink-0 grow-0 basis-[78%] snap-start flex-col gap-3.5 overflow-clip rounded-[22px] border border-hairline bg-surface p-6 transition-[transform,border-color] duration-[350ms] ease-[cubic-bezier(.2,.8,.2,1)] [transform-style:preserve-3d] min-[640px]:basis-[calc((100%-32px)/2.3)] min-[900px]:basis-auto"
    >
      <div
        aria-hidden
        className="absolute inset-0 -z-10 opacity-[var(--glow,0)] blur-[24px] transition-opacity duration-[350ms]"
        style={{ background: `radial-gradient(circle at var(--gx,30%) var(--gy,20%), ${game.colorMain} 0%, transparent 62%)` }}
      />
      <div className="flex items-start justify-between">
        <div
          aria-hidden
          className="flex h-[54px] w-[54px] items-center justify-center rounded-2xl text-[27px]"
          style={{ background: gradient, boxShadow: `0 10px 24px -10px ${game.colorMain}` }}
        >
          {game.icon}
        </div>
        <span className="font-mono text-xs tracking-[0.12em] text-neutral-faint">{num}</span>
      </div>
      <h3 className="mt-2 font-display text-2xl font-semibold tracking-[-0.015em] text-ink">{game.name}</h3>
      <p className="m-0 flex-1 text-pretty text-[15px] leading-normal text-ink-soft">{game.description}</p>
      <div className="flex items-center justify-between gap-2.5">
        <span className="font-mono text-[11px] uppercase tracking-[0.12em] text-neutral-faint">
          {t("categoryCount", { n: game.categoryCount })}
        </span>
        <button
          type="button"
          onClick={() => openDemo(game.slug)}
          aria-label={t("playAria", { name: game.name })}
          className="flex items-center gap-2 rounded-full border bg-ground/40 px-4 py-[9px] text-sm font-semibold text-ink transition-[background,transform] duration-200 hover:translate-x-0.5 hover:bg-raised"
          style={{ borderColor: game.colorMain }}
        >
          {t("play")} <span aria-hidden>→</span>
        </button>
      </div>
    </li>
  );
}

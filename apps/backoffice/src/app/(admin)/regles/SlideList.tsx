"use client";

import { useState } from "react";
import { CaretLeftIcon, CaretRightIcon } from "@phosphor-icons/react/dist/ssr";
import { DragHandle, DragList } from "@/components/DragList";
import { renderMarkdownLite } from "@/components/RulesSlidePreview";
import { reorderSlides } from "@/lib/actions";
import { DeleteSlideButton, EditSlideButton } from "./SlideEditor";

type Slide = { id: string; gameId: string; title: string; content: string; order: number; imageRef: string | null };
type GameColors = { colorMain: string; colorSecondary: string };

const plain = (s: string) => s.replace(/\*\*(.+?)\*\*/g, "$1");

/** Liste des slides d'un jeu + aperçu téléphone. Cliquer une slide
 * l'affiche dans l'aperçu ; ‹ › y naviguent comme dans l'app. */
export function SlideList({ slides, gameColors }: { slides: Slide[]; gameColors: GameColors }) {
  const [selectedId, setSelectedId] = useState(slides[0]?.id ?? null);
  const index = Math.max(0, slides.findIndex((s) => s.id === selectedId));
  const current = slides[index];
  const grad = `linear-gradient(180deg, ${gameColors.colorMain}, ${gameColors.colorSecondary})`;

  return (
    <div className="grid grid-cols-[repeat(auto-fit,minmax(min(100%,360px),1fr))] items-start gap-5">
      <DragList
        items={slides}
        reorder={reorderSlides}
        label={(s) => s.title}
        className="flex flex-col gap-2.5"
        renderItem={(s, onDragStart, onMove) => {
          const on = s.id === current?.id;
          return (
            <div className={`flex items-start gap-3 rounded-[14px] border bg-surface p-3.5 transition-colors ${on ? "border-accent" : "border-hairline hover:border-hairline-firm"}`}>
              <DragHandle id={s.id} label={s.title} onDragStart={onDragStart} onMove={onMove} className="mt-0.5 h-7 w-6" />
              <span aria-hidden className="flex h-7 w-7 flex-none items-center justify-center rounded-lg font-mono text-xs font-semibold text-white" style={{ background: grad }}>
                {slides.findIndex((x) => x.id === s.id) + 1}
              </span>
              <button
                type="button"
                onClick={() => setSelectedId(s.id)}
                aria-pressed={on}
                aria-label={`Afficher « ${s.title} » dans l’aperçu`}
                className="flex min-w-0 flex-1 flex-col gap-1 text-left"
              >
                <span className="text-sm font-semibold text-ink">{s.title}</span>
                <span className="line-clamp-3 text-[13px] leading-normal text-ink-soft">{plain(s.content)}</span>
                {s.imageRef && <code className="font-mono text-[11px] text-neutral-faint">{s.imageRef}</code>}
              </button>
              <div className="flex flex-none items-center gap-1">
                <EditSlideButton slide={{ id: s.id, gameId: s.gameId, title: s.title, content: s.content, order: s.order }} gameColors={gameColors} />
                <DeleteSlideButton id={s.id} title={s.title} />
              </div>
            </div>
          );
        }}
      />

      {current && (
        <aside aria-label="Aperçu dans l’app" className="flex flex-col items-center gap-3.5 min-[1100px]:sticky min-[1100px]:top-[76px]">
          <span className="text-xs text-neutral-faint">Aperçu dans l’app</span>
          <div className="w-[300px] max-w-full rounded-[40px] border border-hairline-firm bg-sunk p-2.5">
            <div className="flex min-h-[420px] flex-col justify-center rounded-[30px] bg-ground-deep p-3">
              <div className="overflow-hidden rounded-[18px] bg-white shadow-[0_20px_40px_rgb(0_0_0/0.4)]">
                <div className="flex items-center gap-2 p-4 text-white" style={{ background: grad }}>
                  <span aria-hidden>📖</span>
                  <span className="flex-1 text-base font-extrabold">Règle du jeu</span>
                  <span aria-hidden className="flex h-6 w-6 items-center justify-center rounded-full bg-white/20 text-xs">✕</span>
                </div>
                <div aria-live="polite" className="flex min-h-[170px] flex-col gap-2 p-4">
                  <p className="m-0 break-words text-lg font-bold text-neutral-900">{current.title}</p>
                  <p className="m-0 whitespace-pre-wrap break-words text-sm leading-relaxed text-neutral-600">{renderMarkdownLite(current.content)}</p>
                </div>
                <div className="flex items-center justify-between px-4 pb-4">
                  <button type="button" aria-label="Slide précédente" disabled={index === 0}
                    onClick={() => setSelectedId(slides[index - 1].id)}
                    className="flex h-8 w-8 items-center justify-center rounded-full border border-neutral-200 bg-white text-neutral-900 disabled:opacity-30">
                    <CaretLeftIcon aria-hidden />
                  </button>
                  <div aria-hidden className="flex gap-[5px]">
                    {slides.map((s, i) => (
                      <span key={s.id} className="h-1.5 rounded-[3px] transition-[width] duration-300"
                        style={{ width: i === index ? 18 : 6, background: i === index ? gameColors.colorMain : "#e5e5e5" }} />
                    ))}
                  </div>
                  <button type="button" aria-label="Slide suivante" disabled={index === slides.length - 1}
                    onClick={() => setSelectedId(slides[index + 1].id)}
                    className="flex h-8 w-8 items-center justify-center rounded-full text-white disabled:opacity-30" style={{ background: grad }}>
                    <CaretRightIcon aria-hidden />
                  </button>
                </div>
              </div>
            </div>
          </div>
          <span className="text-xs text-neutral-faint">Slide {index + 1} sur {slides.length}</span>
        </aside>
      )}
    </div>
  );
}

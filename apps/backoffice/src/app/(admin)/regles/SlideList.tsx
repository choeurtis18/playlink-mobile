"use client";

import { DragHandle, DragList } from "@/components/DragList";
import { reorderSlides } from "@/lib/actions";
import { DeleteSlideButton, EditSlideButton } from "./SlideEditor";

type Slide = { id: string; gameId: string; title: string; content: string; order: number; imageRef: string | null };
type GameColors = { colorMain: string; colorSecondary: string };

export function SlideList({ slides, gameColors }: { slides: Slide[]; gameColors: GameColors }) {
  return (
    <DragList
      items={slides}
      reorder={reorderSlides}
      className="flex flex-col gap-3"
      renderItem={(s, onDragStart) => (
        <div className="rounded-lg border border-hairline bg-surface p-4">
          <div className="flex items-start gap-3">
            <DragHandle onDragStart={onDragStart} className="mt-1 text-lg" />
            <div className="min-w-0 flex-1">
              <div className="font-medium">{s.title}</div>
              <p className="mt-1 whitespace-pre-wrap text-sm text-ink-soft">{s.content}</p>
              {s.imageRef && <code className="mt-2 block text-xs text-neutral-faint">{s.imageRef}</code>}
            </div>
            <div className="flex shrink-0 gap-1">
              <EditSlideButton
                slide={{ id: s.id, gameId: s.gameId, title: s.title, content: s.content, order: s.order }}
                gameColors={gameColors} />
              <DeleteSlideButton id={s.id} />
            </div>
          </div>
        </div>
      )}
    />
  );
}

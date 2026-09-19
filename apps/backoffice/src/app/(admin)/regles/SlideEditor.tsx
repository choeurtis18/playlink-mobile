"use client";

import { useState } from "react";
import { Button, ConfirmButton, Field, Input, Modal, Textarea } from "@/components/ui";
import { RulesSlidePreview } from "@/components/RulesSlidePreview";
import { deleteSlide, saveSlide } from "@/lib/actions";

type Slide = { id: string; gameId: string; title: string; content: string; order: number };
type Game = { colorMain: string; colorSecondary: string };

function SlideFields({ slide, defaultOrder, gameColors }: { slide?: Slide; defaultOrder: number; gameColors: Game }) {
  const [title, setTitle] = useState(slide?.title ?? "");
  const [content, setContent] = useState(slide?.content ?? "");

  return (
    <div className="grid grid-cols-1 gap-5 md:grid-cols-[1fr_auto]">
      <div className="flex flex-col gap-3">
        <Field label="Titre">
          <Input name="title" value={title} onChange={(e) => setTitle(e.target.value)} required maxLength={200} />
        </Field>
        <Field label="Contenu" hint="Markdown accepté (**gras**).">
          <Textarea name="content" rows={7} value={content} onChange={(e) => setContent(e.target.value)} required maxLength={2000} />
        </Field>
        <Field label="Ordre"><Input type="number" name="order" defaultValue={defaultOrder} min={0} /></Field>
      </div>
      <div className="flex min-w-0 flex-col items-center gap-2">
        <span className="text-xs text-neutral-faint">Aperçu dans l&apos;app</span>
        <RulesSlidePreview title={title} content={content} colorMain={gameColors.colorMain} colorSecondary={gameColors.colorSecondary} />
      </div>
    </div>
  );
}

export function NewSlideButton({ gameId, gameName, gameColors, nextOrder }: {
  gameId: string; gameName: string; gameColors: Game; nextOrder: number;
}) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button onClick={() => setOpen(true)}>Nouvelle slide</Button>
      <Modal title={`Nouvelle slide — ${gameName}`} open={open} onClose={() => setOpen(false)} wide
        action={(fd) => saveSlide(null, fd)}>
        <input type="hidden" name="gameId" value={gameId} />
        <SlideFields defaultOrder={nextOrder} gameColors={gameColors} />
      </Modal>
    </>
  );
}

export function EditSlideButton({ slide, gameColors }: { slide: Slide; gameColors: Game }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button variant="ghost" onClick={() => setOpen(true)}>Éditer</Button>
      <Modal title="Modifier la slide" open={open} onClose={() => setOpen(false)} wide
        action={(fd) => saveSlide(slide.id, fd)}>
        <input type="hidden" name="gameId" value={slide.gameId} />
        <SlideFields slide={slide} defaultOrder={slide.order} gameColors={gameColors} />
      </Modal>
    </>
  );
}

export function DeleteSlideButton({ id }: { id: string }) {
  return <ConfirmButton label="Supprimer" confirm="Supprimer cette slide ?" action={() => deleteSlide(id)} />;
}

"use client";

import { useState } from "react";
import { PencilSimpleIcon, PlusIcon, TrashIcon } from "@phosphor-icons/react/dist/ssr";
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
          <Input name="title" value={title} onChange={(e) => setTitle(e.target.value)} required maxLength={200} counter />
        </Field>
        <Field label="Contenu" hint="Markdown accepté (**gras**).">
          <Textarea name="content" rows={7} value={content} onChange={(e) => setContent(e.target.value)} required maxLength={2000} counter />
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
      <Button icon={<PlusIcon aria-hidden />} onClick={() => setOpen(true)}>Nouvelle slide</Button>
      <Modal title={`Nouvelle slide — ${gameName}`} open={open} onClose={() => setOpen(false)} wide successMessage="Slide ajoutée"
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
      <button type="button" onClick={() => setOpen(true)} aria-label={`Éditer la slide « ${slide.title} »`}
        className="flex h-[30px] w-[30px] items-center justify-center rounded-[7px] border border-hairline text-ink-soft transition-colors hover:bg-ground hover:text-ink">
        <PencilSimpleIcon aria-hidden />
      </button>
      <Modal title="Modifier la slide" open={open} onClose={() => setOpen(false)} wide successMessage="Slide mise à jour"
        action={(fd) => saveSlide(slide.id, fd)}>
        <input type="hidden" name="gameId" value={slide.gameId} />
        <SlideFields slide={slide} defaultOrder={slide.order} gameColors={gameColors} />
      </Modal>
    </>
  );
}

export function DeleteSlideButton({ id, title }: { id: string; title: string }) {
  return (
    <ConfirmButton size="xs" label={`Supprimer la slide « ${title} »`} confirm={`Supprimer la slide « ${title} » ?`}
      action={() => deleteSlide(id)} doneMessage="Slide supprimée">
      <TrashIcon aria-hidden className="text-sm" />
    </ConfirmButton>
  );
}

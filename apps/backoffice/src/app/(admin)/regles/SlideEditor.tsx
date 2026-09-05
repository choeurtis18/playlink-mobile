"use client";

import { useState } from "react";
import { Button, ConfirmButton, Field, Input, Modal, Textarea } from "@/components/ui";
import { deleteSlide, saveSlide } from "@/lib/actions";

type Slide = { id: string; gameId: string; title: string; content: string; order: number };

export function NewSlideButton({ gameId, gameName, nextOrder }: { gameId: string; gameName: string; nextOrder: number }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button onClick={() => setOpen(true)}>Nouvelle slide</Button>
      <Modal title={`Nouvelle slide — ${gameName}`} open={open} onClose={() => setOpen(false)}
        action={(fd) => saveSlide(null, fd)}>
        <input type="hidden" name="gameId" value={gameId} />
        <Field label="Titre"><Input name="title" required maxLength={200} /></Field>
        <Field label="Contenu" hint="Markdown accepté.">
          <Textarea name="content" rows={5} required maxLength={2000} />
        </Field>
        <Field label="Ordre"><Input type="number" name="order" defaultValue={nextOrder} min={0} /></Field>
      </Modal>
    </>
  );
}

export function EditSlideButton({ slide }: { slide: Slide }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button variant="ghost" onClick={() => setOpen(true)}>Éditer</Button>
      <Modal title="Modifier la slide" open={open} onClose={() => setOpen(false)}
        action={(fd) => saveSlide(slide.id, fd)}>
        <input type="hidden" name="gameId" value={slide.gameId} />
        <Field label="Titre"><Input name="title" defaultValue={slide.title} required maxLength={200} /></Field>
        <Field label="Contenu"><Textarea name="content" rows={5} defaultValue={slide.content} required maxLength={2000} /></Field>
        <Field label="Ordre"><Input type="number" name="order" defaultValue={slide.order} min={0} /></Field>
      </Modal>
    </>
  );
}

export function DeleteSlideButton({ id }: { id: string }) {
  return <ConfirmButton label="Supprimer" confirm="Supprimer cette slide ?" action={() => deleteSlide(id)} />;
}

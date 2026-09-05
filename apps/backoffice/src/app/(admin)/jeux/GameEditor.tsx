"use client";

import { useState } from "react";
import { Button, ConfirmButton, Field, Input, Modal, Textarea } from "@/components/ui";
import { deleteCategory, saveCategory, saveGame } from "@/lib/actions";

type Game = {
  id: string; name: string; slug: string; description: string | null;
  icon: string | null; colorMain: string; colorSecondary: string; active: boolean; order: number;
};
type Cat = { id: string; name: string; slug: string; description: string | null; icon: string | null; order: number; gameId: string };

export function EditGameButton({ game }: { game: Game }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button variant="ghost" onClick={() => setOpen(true)}>Éditer</Button>
      <Modal title={`Modifier « ${game.name} »`} open={open} onClose={() => setOpen(false)}
        action={(fd) => saveGame(game.id, fd)}>
        <Field label="Nom"><Input name="name" defaultValue={game.name} required /></Field>
        <Field label="Slug"><Input name="slug" defaultValue={game.slug} required pattern="[a-z0-9-]+" /></Field>
        <Field label="Description"><Textarea name="description" rows={3} defaultValue={game.description ?? ""} /></Field>
        <div className="grid grid-cols-3 gap-3">
          <Field label="Icône"><Input name="icon" defaultValue={game.icon ?? ""} maxLength={4} /></Field>
          <Field label="Couleur 1"><Input type="color" name="colorMain" defaultValue={game.colorMain} className="h-9 p-1" /></Field>
          <Field label="Couleur 2"><Input type="color" name="colorSecondary" defaultValue={game.colorSecondary} className="h-9 p-1" /></Field>
        </div>
        <Field label="Ordre"><Input type="number" name="order" defaultValue={game.order} min={0} /></Field>
        <label className="flex items-center gap-2 text-sm">
          <input type="checkbox" name="active" defaultChecked={game.active} /> Jeu actif
        </label>
      </Modal>
    </>
  );
}

export function CategoryButtons({ cat }: { cat: Cat }) {
  const [open, setOpen] = useState(false);
  return (
    <span className="inline-flex items-center gap-1">
      <button onClick={() => setOpen(true)} className="text-neutral-faint hover:text-ink" title="Éditer">✎</button>
      <Modal title={`Modifier « ${cat.name} »`} open={open} onClose={() => setOpen(false)}
        action={(fd) => saveCategory(cat.id, fd)}>
        <input type="hidden" name="gameId" value={cat.gameId} />
        <Field label="Nom"><Input name="name" defaultValue={cat.name} required /></Field>
        <Field label="Slug"><Input name="slug" defaultValue={cat.slug} required pattern="[a-z0-9-]+" /></Field>
        <Field label="Description"><Textarea name="description" rows={2} defaultValue={cat.description ?? ""} /></Field>
        <div className="grid grid-cols-2 gap-3">
          <Field label="Icône"><Input name="icon" defaultValue={cat.icon ?? ""} maxLength={4} /></Field>
          <Field label="Ordre"><Input type="number" name="order" defaultValue={cat.order} min={0} /></Field>
        </div>
      </Modal>
    </span>
  );
}

export function NewCategoryButton({ gameId, gameName }: { gameId: string; gameName: string }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <button onClick={() => setOpen(true)}
        className="rounded border border-dashed border-hairline px-2 py-1 text-xs text-neutral-faint hover:text-ink">
        + catégorie
      </button>
      <Modal title={`Nouvelle catégorie — ${gameName}`} open={open} onClose={() => setOpen(false)}
        action={(fd) => saveCategory(null, fd)}>
        <input type="hidden" name="gameId" value={gameId} />
        <Field label="Nom"><Input name="name" required /></Field>
        <Field label="Slug"><Input name="slug" required pattern="[a-z0-9-]+" placeholder="ma-categorie" /></Field>
        <Field label="Description"><Textarea name="description" rows={2} /></Field>
        <div className="grid grid-cols-2 gap-3">
          <Field label="Icône"><Input name="icon" maxLength={4} /></Field>
          <Field label="Ordre"><Input type="number" name="order" defaultValue={0} min={0} /></Field>
        </div>
      </Modal>
    </>
  );
}

export function DeleteCategoryButton({ id, name }: { id: string; name: string }) {
  return <ConfirmButton label="×" confirm={`Supprimer la catégorie « ${name} » ?`} action={() => deleteCategory(id)}>
    <span className="px-1">×</span>
  </ConfirmButton>;
}

export function NewGameButton() {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button onClick={() => setOpen(true)}>Nouveau jeu</Button>
      <Modal title="Nouveau jeu" open={open} onClose={() => setOpen(false)} action={(fd) => saveGame(null, fd)}>
        <Field label="Nom"><Input name="name" required /></Field>
        <Field label="Slug"><Input name="slug" required pattern="[a-z0-9-]+" placeholder="mon-jeu" /></Field>
        <Field label="Description"><Textarea name="description" rows={3} /></Field>
        <div className="grid grid-cols-3 gap-3">
          <Field label="Icône"><Input name="icon" maxLength={4} placeholder="🎲" /></Field>
          <Field label="Couleur 1"><Input type="color" name="colorMain" defaultValue="#7C3AED" className="h-9 p-1" /></Field>
          <Field label="Couleur 2"><Input type="color" name="colorSecondary" defaultValue="#EC4899" className="h-9 p-1" /></Field>
        </div>
        <Field label="Ordre"><Input type="number" name="order" defaultValue={0} min={0} /></Field>
        <label className="flex items-center gap-2 text-sm">
          <input type="checkbox" name="active" defaultChecked /> Jeu actif
        </label>
      </Modal>
    </>
  );
}

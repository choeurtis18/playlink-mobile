"use client";

import { useState } from "react";
import { Button, ConfirmButton, Field, Input, Modal, Select, Textarea } from "@/components/ui";
import { deleteCategory, saveCategory } from "@/lib/actions";

type Game = { id: string; name: string; icon: string | null };
export type Cat = {
  id: string; name: string; slug: string; description: string | null;
  icon: string | null; order: number; gameId: string;
};

function Fields({ cat, games }: { cat?: Cat; games: Game[] }) {
  return (
    <>
      <Field label="Jeu">
        <Select name="gameId" defaultValue={cat?.gameId} required>
          {games.map((g) => <option key={g.id} value={g.id}>{g.icon} {g.name}</option>)}
        </Select>
      </Field>
      <Field label="Nom"><Input name="name" defaultValue={cat?.name} required maxLength={120} /></Field>
      <Field label="Slug" hint="Minuscules, chiffres et tirets. Unique au sein du jeu.">
        <Input name="slug" defaultValue={cat?.slug} required pattern="[a-z0-9-]+" placeholder="ma-categorie" />
      </Field>
      <Field label="Description"><Textarea name="description" rows={2} defaultValue={cat?.description ?? ""} /></Field>
      <div className="grid grid-cols-2 gap-3">
        <Field label="Icône"><Input name="icon" defaultValue={cat?.icon ?? ""} maxLength={4} placeholder="🎲" /></Field>
        <Field label="Ordre"><Input type="number" name="order" defaultValue={cat?.order ?? 0} min={0} /></Field>
      </div>
    </>
  );
}

export function NewCategoryButton({ games }: { games: Game[] }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button onClick={() => setOpen(true)}>Nouvelle catégorie</Button>
      <Modal title="Nouvelle catégorie" open={open} onClose={() => setOpen(false)}
        action={(fd) => saveCategory(null, fd)}>
        <Fields games={games} />
      </Modal>
    </>
  );
}

export function EditCategoryButton({ cat, games }: { cat: Cat; games: Game[] }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button variant="ghost" onClick={() => setOpen(true)}>Éditer</Button>
      <Modal title={`Modifier « ${cat.name} »`} open={open} onClose={() => setOpen(false)}
        action={(fd) => saveCategory(cat.id, fd)}>
        <Fields cat={cat} games={games} />
      </Modal>
    </>
  );
}

export function DeleteCategoryButton({ id, name, cards }: { id: string; name: string; cards: number }) {
  // Une catégorie non vide n'est pas supprimable : la cascade effacerait ses
  // cartes sans que l'éditeur le voie. On le dit plutôt que de le laisser
  // découvrir au clic.
  if (cards > 0) {
    return (
      <span className="cursor-not-allowed rounded border border-hairline px-3 py-1.5 text-sm text-neutral-faint"
        title={`${cards} cartes rattachées — vide la catégorie d'abord`}>
        Supprimer
      </span>
    );
  }
  return <ConfirmButton label="Supprimer" confirm={`Supprimer la catégorie « ${name} » ?`} action={() => deleteCategory(id)} />;
}

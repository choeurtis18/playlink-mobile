"use client";

import { useEffect, useState } from "react";
import { LockSimpleIcon, PencilSimpleIcon, PlusIcon, TrashIcon } from "@phosphor-icons/react/dist/ssr";
import { Button, ConfirmButton, Field, IconPicker, Input, Modal, Select, Textarea } from "@/components/ui";
import { NameSlugFields } from "@/components/NameSlugFields";
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
      <NameSlugFields name={cat?.name} slug={cat?.slug} placeholder="ma-categorie" hint="Minuscules, chiffres et tirets. Unique au sein du jeu." />
      <Field label="Description"><Textarea name="description" rows={2} defaultValue={cat?.description ?? ""} /></Field>
      <Field label="Icône"><IconPicker name="icon" defaultValue={cat?.icon} /></Field>
      <Field label="Ordre"><Input type="number" name="order" defaultValue={cat?.order ?? 0} min={0} /></Field>
    </>
  );
}

export function NewCategoryButton({ games }: { games: Game[] }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button icon={<PlusIcon aria-hidden />} onClick={() => setOpen(true)}>Nouvelle catégorie</Button>
      <Modal title="Nouvelle catégorie" open={open} onClose={() => setOpen(false)} successMessage="Catégorie créée"
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
      <button type="button" onClick={() => setOpen(true)} aria-label={`Éditer la catégorie ${cat.name}`}
        className="flex h-[30px] w-[30px] items-center justify-center rounded-[7px] border border-hairline text-ink-soft transition-colors hover:bg-ground hover:text-ink">
        <PencilSimpleIcon aria-hidden />
      </button>
      <Modal title={`Modifier « ${cat.name} »`} open={open} onClose={() => setOpen(false)} successMessage="Catégorie mise à jour"
        action={(fd) => saveCategory(cat.id, fd)}>
        <Fields cat={cat} games={games} />
      </Modal>
    </>
  );
}

export function DeleteCategoryButton({ id, name, cards }: { id: string; name: string; cards: number }) {
  // Une catégorie non vide n'est pas supprimable : la cascade effacerait ses
  // cartes sans que l'éditeur le voie. Le serveur refuse aussi (deleteCategory).
  if (cards > 0) {
    const why = `${cards} carte${cards > 1 ? "s" : ""} rattachée${cards > 1 ? "s" : ""} — vide la catégorie d’abord`;
    return (
      <span title={why} className="flex h-[30px] w-[30px] items-center justify-center rounded-[7px] border border-hairline text-neutral-faint">
        <LockSimpleIcon aria-hidden />
        <span className="sr-only">Suppression impossible : {why}</span>
      </span>
    );
  }
  return (
    <ConfirmButton size="xs" label={`Supprimer la catégorie ${name}`} confirm={`Supprimer la catégorie « ${name} » ?`}
      action={() => deleteCategory(id)} doneMessage="Catégorie supprimée">
      <TrashIcon aria-hidden className="text-sm" />
    </ConfirmButton>
  );
}

/** Répartition des cartes actives par intensité. Les barres partent de
 * zéro et se remplissent après le premier affichage (animer la hauteur
 * dès le rendu serveur ne montrerait aucune transition). */
export function DistBars({ dist }: { dist: number[] }) {
  const [shown, setShown] = useState(false);
  useEffect(() => { const id = requestAnimationFrame(() => setShown(true)); return () => cancelAnimationFrame(id); }, []);
  const max = Math.max(...dist, 1);
  const summary = dist.map((n, i) => `intensité ${i + 1} : ${n}`).join(", ");
  return (
    <div className="flex h-6 items-end gap-[3px]" title={dist.map((n, i) => `${i + 1} : ${n}`).join(" · ")}>
      {dist.map((n, i) => (
        <span
          key={i}
          aria-hidden
          className="w-2.5 rounded-sm bg-accent transition-[height] duration-[600ms] ease-[cubic-bezier(.2,.8,.2,1)]"
          style={{ height: shown ? `${Math.max(2, (n / max) * 24)}px` : "2px", opacity: n ? 0.4 + (n / max) * 0.6 : 0.15 }}
        />
      ))}
      <span className="sr-only">{summary}</span>
    </div>
  );
}

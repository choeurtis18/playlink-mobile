"use client";

import { useState } from "react";
import { PencilSimpleIcon, PlusIcon, XIcon } from "@phosphor-icons/react/dist/ssr";
import { Button, ConfirmButton, Field, IconPicker, Input, Modal, Switch, Textarea } from "@/components/ui";
import { GameTilePreview } from "@/components/GameTilePreview";
import { NameSlugFields } from "@/components/NameSlugFields";
import { deleteCategory, saveCategory, saveGame } from "@/lib/actions";

type Game = {
  id: string; name: string; slug: string; description: string | null;
  icon: string | null; colorMain: string; colorSecondary: string; active: boolean; order: number;
};
type Cat = { id: string; name: string; slug: string; description: string | null; icon: string | null; order: number; gameId: string };

/** Champs du formulaire jeu + aperçu de tuile en direct (nom/icône/
 * couleurs), partagés par création et édition. */
function GameFields({ game, categoryCount = 0 }: { game?: Game; categoryCount?: number }) {
  const [name, setName] = useState(game?.name ?? "");
  const [icon, setIcon] = useState(game?.icon ?? "");
  const [colorMain, setColorMain] = useState(game?.colorMain ?? "#7C3AED");
  const [colorSecondary, setColorSecondary] = useState(game?.colorSecondary ?? "#EC4899");

  return (
    <div className="grid grid-cols-1 gap-5 md:grid-cols-[1fr_auto]">
      <div className="flex flex-col gap-3">
        <NameSlugFields name={game?.name} slug={game?.slug} onNameChange={setName} placeholder="mon-jeu" />
        <Field label="Description"><Textarea name="description" rows={3} defaultValue={game?.description ?? ""} /></Field>
        <Field label="Icône"><IconPicker name="icon" defaultValue={game?.icon} onChange={setIcon} /></Field>
        <div className="grid grid-cols-2 gap-3">
          <Field label="Couleur 1">
            <Input type="color" name="colorMain" value={colorMain} onChange={(e) => setColorMain(e.target.value)} className="h-9 p-1" />
          </Field>
          <Field label="Couleur 2">
            <Input type="color" name="colorSecondary" value={colorSecondary} onChange={(e) => setColorSecondary(e.target.value)} className="h-9 p-1" />
          </Field>
        </div>
        <Field label="Ordre"><Input type="number" name="order" defaultValue={game?.order ?? 0} min={0} /></Field>
        <div className="flex items-center gap-2.5 text-sm">
          <Switch name="active" label="Jeu actif" defaultChecked={game?.active ?? true} size="sm" />
          Jeu actif <span className="text-xs text-neutral-faint">(inactif = masqué dans l’app et sur la landing)</span>
        </div>
      </div>
      <div className="flex min-w-0 flex-col items-center gap-2">
        <span className="text-xs text-neutral-faint">Aperçu dans l&apos;app</span>
        <GameTilePreview
          name={name} icon={icon} colorMain={colorMain} colorSecondary={colorSecondary}
          categoryCount={categoryCount}
        />
      </div>
    </div>
  );
}

export function EditGameButton({ game, categoryCount }: { game: Game; categoryCount: number }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <button type="button" onClick={() => setOpen(true)} aria-label={`Éditer ${game.name}`}
        className="flex h-[34px] w-[34px] items-center justify-center rounded-lg border border-hairline text-ink-soft transition-colors hover:bg-raised hover:text-ink">
        <PencilSimpleIcon aria-hidden className="text-base" />
      </button>
      <Modal title={`Modifier « ${game.name} »`} open={open} onClose={() => setOpen(false)} wide
        action={(fd) => saveGame(game.id, fd)}>
        <GameFields game={game} categoryCount={categoryCount} />
      </Modal>
    </>
  );
}

export function CategoryButtons({ cat }: { cat: Cat }) {
  const [open, setOpen] = useState(false);
  return (
    <span className="inline-flex items-center gap-1">
      <button type="button" onClick={() => setOpen(true)} aria-label={`Éditer la catégorie ${cat.name}`}
        className="flex h-6 w-6 items-center justify-center rounded-full text-neutral-faint hover:bg-hairline hover:text-ink">
        <PencilSimpleIcon aria-hidden className="text-xs" />
      </button>
      <Modal title={`Modifier « ${cat.name} »`} open={open} onClose={() => setOpen(false)}
        action={(fd) => saveCategory(cat.id, fd)}>
        <input type="hidden" name="gameId" value={cat.gameId} />
        <NameSlugFields name={cat.name} slug={cat.slug} hint="Minuscules, chiffres et tirets. Unique au sein du jeu." />
        <Field label="Description"><Textarea name="description" rows={2} defaultValue={cat.description ?? ""} /></Field>
        <Field label="Icône"><IconPicker name="icon" defaultValue={cat.icon} /></Field>
        <Field label="Ordre"><Input type="number" name="order" defaultValue={cat.order} min={0} /></Field>
      </Modal>
    </span>
  );
}

export function NewCategoryButton({ gameId, gameName }: { gameId: string; gameName: string }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <button type="button" onClick={() => setOpen(true)} aria-label={`Ajouter une catégorie à ${gameName}`}
        className="inline-flex items-center gap-1 rounded-full border border-dashed border-hairline-firm px-2.5 py-1 text-xs text-neutral-faint transition-colors hover:text-ink">
        <PlusIcon aria-hidden /> catégorie
      </button>
      <Modal title={`Nouvelle catégorie — ${gameName}`} open={open} onClose={() => setOpen(false)}
        action={(fd) => saveCategory(null, fd)}>
        <input type="hidden" name="gameId" value={gameId} />
        <NameSlugFields placeholder="ma-categorie" hint="Minuscules, chiffres et tirets. Unique au sein du jeu." />
        <Field label="Description"><Textarea name="description" rows={2} /></Field>
        <Field label="Icône"><IconPicker name="icon" /></Field>
        <Field label="Ordre"><Input type="number" name="order" defaultValue={0} min={0} /></Field>
      </Modal>
    </>
  );
}

export function DeleteCategoryButton({ id, name }: { id: string; name: string }) {
  return (
    <ConfirmButton size="xs" label={`Supprimer la catégorie ${name}`} confirm={`Supprimer la catégorie « ${name} » ?`}
      action={() => deleteCategory(id)} doneMessage="Catégorie supprimée">
      <XIcon aria-hidden />
    </ConfirmButton>
  );
}

export function NewGameButton({ icon }: { icon?: React.ReactNode }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button icon={icon} onClick={() => setOpen(true)}>Nouveau jeu</Button>
      <Modal title="Nouveau jeu" open={open} onClose={() => setOpen(false)} wide action={(fd) => saveGame(null, fd)}>
        <GameFields />
      </Modal>
    </>
  );
}

"use client";

import { useState } from "react";
import { Button, ConfirmButton, Field, Input, Modal, Select, Textarea } from "@/components/ui";
import { deleteCard, saveCard, toggleCardActive } from "@/lib/actions";

type Cat = { id: string; name: string; game: { name: string } };
export type EditableCard = {
  id: string; text: string; intensity: number; tags: string[];
  active: boolean; order: number; categoryId: string;
};

export function NewCardButton({ categories }: { categories: Cat[] }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button onClick={() => setOpen(true)}>Nouvelle carte</Button>
      <Modal title="Nouvelle carte" open={open} onClose={() => setOpen(false)}
        action={(fd) => saveCard(null, fd)}>
        <CardFields categories={categories} />
      </Modal>
    </>
  );
}

export function EditCardButton({ card, categories }: { card: EditableCard; categories: Cat[] }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button variant="ghost" onClick={() => setOpen(true)}>Éditer</Button>
      <Modal title="Modifier la carte" open={open} onClose={() => setOpen(false)}
        action={(fd) => saveCard(card.id, fd)}>
        <CardFields card={card} categories={categories} />
      </Modal>
    </>
  );
}

export function DeleteCardButton({ id }: { id: string }) {
  return <ConfirmButton label="Supprimer" confirm="Supprimer définitivement cette carte ?" action={() => deleteCard(id)} />;
}

export function ToggleActive({ id, active }: { id: string; active: boolean }) {
  return (
    <Button variant="ghost" onClick={() => toggleCardActive(id, !active)}>
      {active ? "Désactiver" : "Activer"}
    </Button>
  );
}

function CardFields({ card, categories }: { card?: EditableCard; categories: Cat[] }) {
  return (
    <>
      <Field label="Texte">
        <Textarea name="text" rows={3} defaultValue={card?.text} required maxLength={500} />
      </Field>
      <Field label="Catégorie">
        <Select name="categoryId" defaultValue={card?.categoryId} required>
          {categories.map((c) => (
            <option key={c.id} value={c.id}>{c.game.name} — {c.name}</option>
          ))}
        </Select>
      </Field>
      <div className="grid grid-cols-2 gap-3">
        <Field label="Intensité (1–5)">
          <Select name="intensity" defaultValue={String(card?.intensity ?? 3)}>
            {[1, 2, 3, 4, 5].map((i) => <option key={i} value={i}>{i}</option>)}
          </Select>
        </Field>
        <Field label="Ordre">
          <Input type="number" name="order" defaultValue={card?.order ?? 0} min={0} />
        </Field>
      </div>
      <Field label="Tags" hint="Séparés par des virgules. Les tags canoniques sont recalculés automatiquement.">
        <Input name="tags" defaultValue={card?.tags.join(", ")} placeholder="humour, vérité" />
      </Field>
      <label className="flex items-center gap-2 text-sm">
        <input type="checkbox" name="active" defaultChecked={card?.active ?? true} />
        Carte active (entre dans le tirage)
      </label>
    </>
  );
}

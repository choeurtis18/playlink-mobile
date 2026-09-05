"use client";

import { useState } from "react";
import { Button, ConfirmButton, Field, Input, Modal, Textarea } from "@/components/ui";
import { deleteBadge, saveBadge } from "@/lib/actions";

type Badge = { id: string; key: string; name: string; description: string; icon: string; order: number };

function Fields({ badge, presetKey }: { badge?: Badge; presetKey?: string }) {
  return (
    <>
      <Field label="Clé" hint="Identifiant de la règle Dart correspondante. Ne pas changer après coup.">
        <Input name="key" defaultValue={badge?.key ?? presetKey} required pattern="[a-z0-9_]+" />
      </Field>
      <Field label="Nom"><Input name="name" defaultValue={badge?.name} required /></Field>
      <Field label="Description"><Textarea name="description" rows={2} defaultValue={badge?.description} required /></Field>
      <div className="grid grid-cols-2 gap-3">
        <Field label="Icône"><Input name="icon" defaultValue={badge?.icon} required maxLength={4} placeholder="🏆" /></Field>
        <Field label="Ordre"><Input type="number" name="order" defaultValue={badge?.order ?? 0} min={0} /></Field>
      </div>
    </>
  );
}

export function NewBadgeButton({ presetKey, label }: { presetKey?: string; label?: string }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      {label
        ? <button onClick={() => setOpen(true)} className="rounded border border-dashed border-hairline px-2 py-1 text-xs text-neutral-faint hover:text-ink">{label}</button>
        : <Button onClick={() => setOpen(true)}>Nouveau badge</Button>}
      <Modal title="Nouveau badge" open={open} onClose={() => setOpen(false)} action={(fd) => saveBadge(null, fd)}>
        <Fields presetKey={presetKey} />
      </Modal>
    </>
  );
}

export function EditBadgeButton({ badge }: { badge: Badge }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button variant="ghost" onClick={() => setOpen(true)}>Éditer</Button>
      <Modal title="Modifier le badge" open={open} onClose={() => setOpen(false)} action={(fd) => saveBadge(badge.id, fd)}>
        <Fields badge={badge} />
      </Modal>
    </>
  );
}

export function DeleteBadgeButton({ id, name }: { id: string; name: string }) {
  return <ConfirmButton label="Supprimer" confirm={`Supprimer le badge « ${name} » ?`} action={() => deleteBadge(id)} />;
}

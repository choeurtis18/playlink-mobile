"use client";

import { useState, useTransition } from "react";
import { PencilSimpleIcon, PlusIcon, TrashIcon } from "@phosphor-icons/react/dist/ssr";
import { BADGE_ICON_CHOICES, Button, ConfirmButton, Field, IconPicker, Input, Modal, Textarea, useToast } from "@/components/ui";
import { createPlannedBadge, deleteBadge, saveBadge } from "@/lib/actions";

type Badge = { id: string; key: string; name: string; description: string; icon: string; order: number };

function Fields({ badge, known }: { badge?: Badge; known: string[] }) {
  const [key, setKey] = useState(badge?.key ?? "");
  const unknown = key && !known.includes(key);
  return (
    <>
      <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
        <Field
          label="Clé"
          error={unknown ? "Aucune règle dans l’app pour cette clé : ce badge ne se débloquera jamais." : null}
          hint="Identifiant de la règle codée dans l’app. Ne pas changer après coup."
        >
          <Input name="key" value={key} onChange={(e) => setKey(e.target.value)} required pattern="[a-z0-9_]+" className="font-mono text-[12.5px]" list="badge-keys" />
        </Field>
        <Field label="Nom"><Input name="name" defaultValue={badge?.name} required /></Field>
      </div>
      <datalist id="badge-keys">{known.map((k) => <option key={k} value={k} />)}</datalist>
      <Field label="Description" hint="Affichée aux joueurs dans l’app."><Textarea name="description" rows={2} defaultValue={badge?.description} required /></Field>
      <Field label="Icône"><IconPicker name="icon" defaultValue={badge?.icon} choices={BADGE_ICON_CHOICES} /></Field>
      <Field label="Ordre"><Input type="number" name="order" defaultValue={badge?.order ?? 0} min={0} /></Field>
    </>
  );
}

export function NewBadgeButton({ known }: { known: string[] }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button icon={<PlusIcon aria-hidden />} onClick={() => setOpen(true)}>Nouveau badge</Button>
      <Modal title="Nouveau badge" open={open} onClose={() => setOpen(false)} successMessage="Badge créé" action={(fd) => saveBadge(null, fd)}>
        <Fields known={known} />
      </Modal>
    </>
  );
}

export function EditBadgeButton({ badge, known }: { badge: Badge; known: string[] }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <button type="button" onClick={() => setOpen(true)} aria-label={`Éditer le badge ${badge.name}`}
        className="flex h-[30px] w-[30px] items-center justify-center rounded-[7px] border border-hairline text-ink-soft transition-colors hover:bg-ground hover:text-ink">
        <PencilSimpleIcon aria-hidden />
      </button>
      <Modal title="Modifier le badge" open={open} onClose={() => setOpen(false)} successMessage="Badge mis à jour" action={(fd) => saveBadge(badge.id, fd)}>
        <Fields badge={badge} known={known} />
      </Modal>
    </>
  );
}

export function DeleteBadgeButton({ id, name }: { id: string; name: string }) {
  return (
    <ConfirmButton size="xs" label={`Supprimer le badge ${name}`} confirm={`Supprimer le badge « ${name} » ?`}
      action={() => deleteBadge(id)} doneMessage="Badge supprimé">
      <TrashIcon aria-hidden className="text-sm" />
    </ConfirmButton>
  );
}

/** Création en un clic d'un badge prévu, avec ses valeurs par défaut. */
export function CreatePlannedBadge({ badgeKey, name }: { badgeKey: string; name: string }) {
  const toast = useToast();
  const [pending, start] = useTransition();
  return (
    <button
      type="button"
      disabled={pending}
      onClick={() => start(async () => {
        const r = await createPlannedBadge(badgeKey);
        toast(r.ok ? `Badge « ${name} » créé` : r.error, r.ok ? "success" : "error");
      })}
      aria-label={`Créer le badge ${name}`}
      className="inline-flex items-center gap-1 rounded-md border border-dashed border-hairline-firm px-2 py-1 text-xs text-ink-soft transition-colors hover:text-ink disabled:opacity-50"
    >
      <PlusIcon aria-hidden /> {pending ? "Création…" : "Créer"}
    </button>
  );
}

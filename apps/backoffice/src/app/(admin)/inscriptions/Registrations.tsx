"use client";

import { useState } from "react";
import { MagnifyingGlassIcon, TrashIcon, XIcon } from "@phosphor-icons/react/dist/ssr";
import { Badge, ConfirmButton, Segmented } from "@/components/ui";
import { deletePreRegistration } from "@/lib/actions";
import { useUrlFilters } from "@/lib/use-url-filters";
import type { RegistrationFilters } from "@/lib/registrations";

export const TABLE_ID = "inscriptions-liste";
const LEAVE_MS = 220;

export function RegistrationFiltersBar({ sp }: { sp: RegistrationFilters & { page?: string } }) {
  const { apply, applyLater, reset, pending } = useUrlFilters(sp);
  const [q, setQ] = useState(sp.q ?? "");
  const active = !!(sp.q || sp.langue || sp.statut);

  return (
    <div role="search" aria-label="Filtrer les pré-inscriptions" aria-busy={pending} className="mb-3 flex flex-wrap items-center gap-2">
      <label className="flex min-w-[240px] items-center gap-2 rounded-lg border border-hairline bg-surface px-2.5 py-[7px] text-neutral-faint focus-within:border-accent">
        <MagnifyingGlassIcon aria-hidden />
        <input
          type="search"
          value={q}
          aria-label="Rechercher une adresse e-mail"
          placeholder="Rechercher un e-mail…"
          onChange={(e) => { setQ(e.target.value); applyLater({ q: e.target.value.trim() || undefined }); }}
          className="min-w-0 flex-1 bg-transparent text-[13px] text-ink outline-none placeholder:text-neutral-faint focus-visible:outline-none"
        />
      </label>
      <Segmented
        size="sm"
        label="Langue"
        value={sp.langue ?? ""}
        onChange={(v) => apply({ langue: v || undefined })}
        options={[{ value: "", label: "Toutes" }, { value: "fr", label: "FR", title: "Français" }, { value: "en", label: "EN", title: "Anglais" }]}
      />
      <Segmented
        size="sm"
        label="Statut"
        value={sp.statut ?? ""}
        onChange={(v) => apply({ statut: v || undefined })}
        options={[{ value: "", label: "Tous" }, { value: "confirmee", label: "Confirmées" }, { value: "attente", label: "En attente" }]}
      />
      {active && (
        <button type="button" onClick={() => { setQ(""); reset(); }}
          className="flex items-center gap-1 px-1 text-[13px] text-neutral-faint hover:text-ink">
          <XIcon aria-hidden /> Réinitialiser
        </button>
      )}
    </div>
  );
}

export type RegistrationRowData = {
  id: string; email: string; locale: string; newsletter: boolean; confirmed: boolean;
  created: string; createdFull: string;
};

/** Ligne de la liste. À la suppression, la ligne s'efface (fondu) pendant
 * l'appel ; en cas d'erreur, elle réapparaît et l'erreur s'affiche. */
export function RegistrationRow({ r }: { r: RegistrationRowData }) {
  const [leaving, setLeaving] = useState(false);

  return (
    <tr className={`border-t border-hairline transition-[opacity,background-color] duration-200 hover:bg-raised ${leaving ? "pointer-events-none opacity-0" : ""}`}>
      <td className="max-w-[360px] truncate px-3.5 py-[11px] font-mono text-[12.5px]">{r.email}</td>
      <td className="px-3.5 py-[11px]"><Badge tone={r.locale === "en" ? "blue" : "neutral"}>{r.locale.toUpperCase()}</Badge></td>
      <td className="whitespace-nowrap px-3.5 py-[11px]">
        {r.confirmed ? <Badge tone="success">Confirmée</Badge> : <Badge tone="warning">En attente</Badge>}
      </td>
      <td className="whitespace-nowrap px-3.5 py-[11px] text-ink-soft">{r.newsletter ? "Oui" : "Non"}</td>
      <td className="whitespace-nowrap px-3.5 py-[11px] text-ink-soft"><time dateTime={r.createdFull} title={r.createdFull}>{r.created}</time></td>
      <td className="whitespace-nowrap px-3.5 py-[11px] text-right">
        <ConfirmButton
          size="xs"
          label={`Supprimer ${r.email}`}
          confirm={`Supprimer définitivement ${r.email} ? Cette action est irréversible.`}
          doneMessage="Pré-inscription supprimée"
          onConfirm={() => setLeaving(true)}
          action={async () => {
            const [res] = await Promise.all([deletePreRegistration(r.id), new Promise((ok) => setTimeout(ok, LEAVE_MS))]);
            if (!res.ok) setLeaving(false);
            // La ligne disparaît : le focus revient sur la liste plutôt que
            // de retomber au début de la page.
            else document.getElementById(TABLE_ID)?.focus();
            return res;
          }}
        >
          <TrashIcon aria-hidden />
        </ConfirmButton>
      </td>
    </tr>
  );
}
